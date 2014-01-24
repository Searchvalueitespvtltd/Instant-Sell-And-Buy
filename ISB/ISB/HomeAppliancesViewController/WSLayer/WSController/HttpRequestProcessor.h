//
//  HttpRequestProcessor.h
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSHeaders.h"

@interface HttpRequestProcessor : NSObject
{
    NSString *userState;
    NSURLConnection *mConnection;
}

+(HttpRequestProcessor*)shareHttpRequest;
-(void)ProcessEditionList : (SHRequestSampleList *)inRequest;
-(void)ProcessImage : (SHRequestSampleImage *)inRequest;

@property (nonatomic, retain) NSString *userState;
@property (nonatomic, retain) NSURLConnection *Connection;

@end
extern HttpRequestProcessor * gHttpRequestProcessor;