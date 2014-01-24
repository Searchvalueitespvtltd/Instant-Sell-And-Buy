//
//  SHBaseRequest.m
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SHBaseRequest.h"

@implementation SHBaseRequest


-(id)initWithURL:(NSURL *)URL
{
    self = [super initWithURL:URL];
    if (self)
    {
        mResponseClassDelegate = nil;
        mRequestIdentifier = nil;
        mResponseData = nil;

    }
    return self;
}
-(void)
SetResponseData:(NSData *)inData
{
    if (!mResponseData)
    {
        mResponseData = [[NSMutableData alloc] init];
    }
    [mResponseData appendData: inData];
}

-(NSData *)
GetResponseData
{
    return  mResponseData;
}


@end
