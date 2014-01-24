//
//  SHBaseRequest.m
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SHBaseRequestImage.h"

@implementation SHBaseRequestImage
@synthesize index;


-(id)initWithURL:(NSURL *)URL
{
    self = [super initWithURL:URL];
    if (self)
    {
        mResponseHandler = nil;
        mErrorHandler = nil;
        mResponseHandlerClass = nil;
        mReqType = -1;
        mResponseData = nil;
        index =-1;

    }
    return self;
}

-(void)						
SetRequestType	:(eRequestType)			inReqType
{
    mReqType = inReqType;

}

-(eRequestType)
GetRequestType
{
	return mReqType;
}


-(void)						
SetResponseData:(NSData *)inData
{
    if (!mResponseData)
    {
        mResponseData = [[NSMutableData alloc] init];
    }
    [mResponseData appendData: inData];}

-(NSData *)                
GetResponseData
{
    return  mResponseData;
}

-(SEL)
GetResponseHandler
{
	return mResponseHandler;
}

-(void)
SetResponseHandler	:(SEL)					inHandler
{
	mResponseHandler = inHandler;
}

-(SEL)
GetErrorHandler
{
	return mErrorHandler;
}

-(void)
SetErrorHandler	:(SEL)					inErrorHandler
{
	mErrorHandler = inErrorHandler;
}

-(id)
GetResponseHandlerObj
{
	return mResponseHandlerClass;
}

-(void)
SetResponseHandlerObj	:(id)				inHandlerClass
{
	[mResponseHandlerClass autorelease];
	mResponseHandlerClass = [inHandlerClass retain];
}

@end
