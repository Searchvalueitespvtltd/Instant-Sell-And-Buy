//
//  HttpRequestProcessor.m
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "HttpRequestProcessor.h"

HttpRequestProcessor *gHttpRequestProcessor = nil;
@interface HttpRequestProcessor()
-(BOOL)validateUrl:(NSString *)inUrlStr;
@end

@implementation HttpRequestProcessor

@synthesize userState;
@synthesize Connection = mConnection;


+(HttpRequestProcessor *)shareHttpRequest
{
    if (gHttpRequestProcessor == nil)
    {
        gHttpRequestProcessor = [[HttpRequestProcessor alloc] init];
    }
    return gHttpRequestProcessor;
}

-(BOOL)validateUrl:(NSString *)inUrlStr
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx]; 
    
    return [urlTest evaluateWithObject: inUrlStr];
}


-(void)ProcessEditionList : (SHRequestSampleList *)inRequest
{
    if(inRequest)
    {

        NSString * urlStr = [NSString stringWithFormat:@"http://gpsdatagateway.autogear.no/RawdataUploader/"];
        NSString * urlParams = nil;
        if ([urlStr length] > 5)
            urlParams = [NSString stringWithFormat: @"Login/stefan@soko.no/Thompson1"];
        
        urlStr = [urlStr stringByAppendingString: [urlParams stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
        NSURL *theURL = [NSURL URLWithString: urlStr];
       
        [inRequest setHTTPMethod:@"GET"];
              
        [inRequest setURL:theURL];
        NSLog(@"ulr inRequest = %@",inRequest.URL);
         mConnection = [[NSURLConnection alloc] initWithRequest:inRequest delegate:self startImmediately:YES];
    }
}

-(void)ProcessImage : (SHRequestSampleImage *)inRequest
{
    if(inRequest)
    {
        NSString * urlStr;// = [NSString stringWithString:kBaseURL];
        //NSString * urlStr = [NSString stringWithFormat:@""];

//        NSString * urlParams = nil;
//        if ([urlStr length] > 5)
//            urlParams = [NSString stringWithFormat:@"%@", inRequest.ImageId];
//        
        urlStr = [kImageURL stringByAppendingString: [inRequest.ImageId stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
        
        NSURL *theURL = [NSURL URLWithString: urlStr];
        
        [inRequest setURL:theURL];
        NSLog(@"ulr inRequest = %@",inRequest.URL);
        mConnection = [[NSURLConnection alloc] initWithRequest:inRequest delegate:self startImmediately:YES];
    }

}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"didReceiveResponse");
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"didFinishLoading");
    // Store incoming data into a string
    SHBaseRequestImage *currRequest =   (SHBaseRequestImage *)connection.currentRequest;
    
    
    id callerClass = [currRequest GetResponseHandlerObj];
    SEL selector = [currRequest GetResponseHandler];
    
    [currRequest SetResponseData:[currRequest GetResponseData]];
    
    if ([callerClass respondsToSelector: selector])
    {
        [callerClass performSelector: selector withObject: currRequest];
    }
    else
    {
        NSLog(@"***CLAS %@ AND METHOD = %@ ***",[callerClass class] , NSStringFromSelector(selector));
    }
    
    // Yes, this is incomplete, but I was waiting for the method to fire before going
    // any further. This will at least show me the JSON data being returned from yahoo
    // in string format so I can output it to the console via NSLog
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError = %@",[error description]);
    SHBaseRequestImage *currRequest =   (SHBaseRequestImage *)connection.currentRequest;
    
    id callerClass = [currRequest GetResponseHandlerObj];
    SEL selector = [currRequest GetErrorHandler];
    
    if ([callerClass respondsToSelector: selector])
    {
        [callerClass performSelector: selector withObject: currRequest];
    }
    else
    {
        NSLog(@"*** CLAS %@ AND METHOD = %@ *** ",[callerClass class] , NSStringFromSelector(selector));
    }
     
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    
    SHBaseRequestImage *curReq = (SHBaseRequestImage *)connection.currentRequest;
    [curReq SetResponseData: data];
    
}

- (void)dealloc 
{
    [userState release];
    [mConnection release];
    [super dealloc];
}


@end
