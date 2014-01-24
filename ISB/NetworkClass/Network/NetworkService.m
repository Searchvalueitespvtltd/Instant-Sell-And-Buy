//
//  NetworkService.m
//  Thrones
//
//  Created by Pradeep on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NetworkService.h"
#import "JSON.h"
#import "Defines.h"
#import "Reachability.h"
#import "Utils.h"
#import "SHBaseRequest.h"

#define thisFileA eLAWS
static NetworkService *sharedInstance = nil;

@implementation NetworkService

// Get the shared instance and create it if necessary.
+ (NetworkService *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)retain {
    return self;
}
- (NSUInteger)retainCount {
    return NSUIntegerMax;
}
- (oneway void)release {
    
}
- (id)autorelease {
    return self;
}

-(void)sendRequestToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate requestMethod :(NSString *)inMethod requestType:(NSString *)inType
{
    
//    Reachability *aReachability = [Reachability reachabilityForInternetConnection];
//	NetworkStatus internetStatus = [aReachability currentReachabilityStatus];
//    
//    if (internetStatus == NotReachable)
//    {
//        UIAlertView *aMsg = [[[UIAlertView alloc] initWithTitle:@"Error Message !" message: @"Network is not available." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] autorelease];
//            [aMsg show];
//        SHBaseRequest *request = [SHBaseRequest requestWithURL:[NSURL URLWithString:inApi]];
//        [request.ResponseClassDelegate requestErrorHandler:nil andRequestIdentifier:<#(NSString *)#>];
//        return;
//
//    }
    
    SHBaseRequest *aRequest = nil;
    NSString *aRequestURL;
    if ([inType isEqualToString:@"Normal"])
    {
        inApi = [NSString stringWithFormat:@"%@",inApi];
        aRequestURL = [kBaseURL stringByAppendingString:inApi];
        NSLog(@"URL: %@",aRequestURL);
//        aRequestURL = [aRequestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        aRequestURL = [aRequestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
        //NSString * urlStr = [NSString stringWithFormat:@"http://gpsdatagateway.autogear.no/RawdataUploader/"];
        //@"https://api.semantics3.com/v1/"
        // NSString * urlStr = [NSString stringWithFormat:@"http://red5reader.area5.nl/applications/c1rbm4jk3k"];
        NSString * urlParams = nil;
        //urlParams = [NSString stringWithFormat:@"%@",[(NSDictionary *)inData objectForKey:kRequestParameters]];
        
        //aRequestURL = [aRequestURL stringByAppendingString: [urlParams stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
        
        aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:360];
        //aRequest = [[SHBaseRequest alloc]initWithURL:[NSURL URLWithString:aRequestURL]];
        
        [aRequest setHTTPMethod:inMethod];
        aRequest.ResponseClassDelegate = inDelegate;
        aRequest.RequestIdentifier = inApi;

        NSLog(@"url inRequest = %@",aRequest.URL);
    }
    else if([inType isEqualToString:@"Json"])
    {
       
        //
//        NSString *strEncoded = [Base64 encode:imageData];
        NSString *str=[@"img=" stringByAppendingString:[inData objectForKey:@"img"]];
        NSData *postData = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        aRequestURL = [kBaseURL stringByAppendingString:inApi];
        aRequestURL = [aRequestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSLog(@"%@",aRequestURL);
        
        aRequest=[SHBaseRequest requestWithURL:[NSURL URLWithString:aRequestURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:360];
        [aRequest setHTTPMethod:inMethod];
        aRequest.ResponseClassDelegate = inDelegate;
        [aRequest setHTTPMethod:@"POST"];
        
//        [aRequest setHTTPBody:postData];
        
//        NSURLResponse *response;
//        NSError *err;
//        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//        
//        NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",s);
//        NSArray *result = [s JSONValue];

        //
        
//        NSString *jsonToSend = [inData JSONRepresentation];
//        NSLog(@"%@",jsonToSend);
//        NSData *aRequestData = [NSData dataWithBytes:[jsonToSend UTF8String] length:[jsonToSend length]];
        [aRequest addValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
        [aRequest setHTTPBody:postData];

    }
        
   // [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self] autorelease];
     [[[NSURLConnection alloc] initWithRequest:aRequest delegate:self startImmediately:YES] autorelease];

    
}

-(id)sendSynchronusRequest:(NSString*)inApi  dataToSend:(id)inData delegate:(id<RequestDeligate>)inDelegate requestMethod :(NSString*)inReqMethod requestType:(NSString *)inType;

{
    NSLog(@"SYNCHRONUS METHOD CALLED");
    NSString *aRequestURL = [kBaseURL stringByAppendingString:inApi];
    aRequestURL = [aRequestURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"SYNC -URL == %@",aRequestURL);
    SHBaseRequest *aRequest = [[[SHBaseRequest alloc] init] autorelease];
    [aRequest setTimeoutInterval:360];
    [aRequest setURL:[NSURL URLWithString:aRequestURL]];
    [aRequest setHTTPMethod:inReqMethod];
     [aRequest addValue:@"application/JSON" forHTTPHeaderField:@"Content-Type"];
     NSData *aRequestData = [NSData dataWithBytes:[inData UTF8String] length:[inData length]];
    [aRequest setHTTPBody:aRequestData];
    NSURLResponse* response = nil;
    NSError* error = nil;
    NSMutableDictionary *tempDic = nil;
    NSString *responseString = nil;
    NSData *result = [NSURLConnection sendSynchronousRequest:aRequest  returningResponse:&response error:&error];
    if (error)
    {
        NSLog(@"%@",error.description);
       // [Utils showAlertView:VENIRE message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
        
    }else
    {
        responseString  = [[NSString alloc]initWithData:result encoding:NSASCIIStringEncoding];
        id dicResult  = [[responseString JSONValue] retain];
        return dicResult;
        if (responseString.length)
        {
            NSMutableArray *arrayResult  = [responseString JSONValue];
            NSLog(@"reponse start14");
            if (arrayResult != nil)
            {
                if ([arrayResult count]>0)
                {
                    NSLog(@"reponse start15");
                    tempDic =[NSMutableDictionary  dictionaryWithObjectsAndKeys:@"TRUE",SUCCESS,arrayResult,DATA,nil];
                }else
                {
                    NSLog(@"empty arrayResult");
                    tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
                    
                }
            }else
            {
                NSLog(@"empty arrayResult");
                tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
            }
        }else
        {
            NSLog(@"nil response string");    
            tempDic = [NSDictionary dictionaryWithObject:@"FALSE" forKey:SUCCESS];
        }
        
        NSLog(@"reponse start16");
        
    }
    [responseString release];
    NSLog(@"SYNCHRONUS METHOD END CALLED");
//
    return tempDic;
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
   // if(receivedData.length!=0)
//    if (receivedData) 
//    {
//        [receivedData release];
//        receivedData = nil;
//    }
//        receivedData = [[NSMutableData alloc]init];
//    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    SHBaseRequest *curReq = (SHBaseRequest *)connection.currentRequest;
    [curReq SetResponseData: data];
    
    
    NSString *responseString = [[NSString alloc]initWithData:data encoding:NSASCIIStringEncoding];  //NSASCIIStringEncoding
    
//    SHLogs(eLLDebugInfo, thisFileA, @"Response string = %@",responseString);

}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)connection.currentRequest;
    // inform the user
    NSLog(@"Connection failed! Error - %@ %@", [error localizedDescription],          [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    NSLog(@"%d",[error code]);
   // [Utils showAlertView:VENIRE message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [aCurrRequest.ResponseClassDelegate requestErrorHandler:error andRequestIdentifier:aCurrRequest.RequestIdentifier];
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//  //  NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
    
    SHBaseRequest *aCurrRequest = (SHBaseRequest *)connection.currentRequest;
    
    NSString *responseString = [[NSString alloc]initWithData:[aCurrRequest GetResponseData] encoding:NSASCIIStringEncoding];  //NSASCIIStringEncoding

//    SHLogs(eLLDebugInfo, thisFileA, @"Response string = %@",responseString);
    id dicResult  = [[responseString JSONValue] retain];
    if (dicResult)
    {
        [aCurrRequest.ResponseClassDelegate responseHandler: dicResult andRequestIdentifier:aCurrRequest.RequestIdentifier];
    }else
    {
        [aCurrRequest.ResponseClassDelegate requestErrorHandler:nil andRequestIdentifier:aCurrRequest.RequestIdentifier];
        //SHLogs(eLLErrors, thisFileA, @"*** Json Format is not correct ***");
    }
    [responseString release];
    
}


@end
