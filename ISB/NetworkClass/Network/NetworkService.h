//
//  NetworkService.h
//  Thrones
//
//  Created by Pradeep on 01/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHBaseRequest.h"
@class RequestDeligate;
@interface NetworkService : NSObject
{
    //NSMutableData *receivedData;
}

//@property(nonatomic,assign)id delegateObj;

-(void)sendRequestToServer:(NSString*)inApi  dataToSend:(id)inData delegate:(id)inDelegate requestMethod :(NSString *)inMethod requestType:(NSString *)inType;

-(id)sendSynchronusRequest:(NSString*)inApi  dataToSend:(id)inData delegate:(id<RequestDeligate>)inDelegate requestMethod :(NSString*)inReqMethod requestType:(NSString *)inType;

+ (NetworkService *)sharedInstance;

@end
