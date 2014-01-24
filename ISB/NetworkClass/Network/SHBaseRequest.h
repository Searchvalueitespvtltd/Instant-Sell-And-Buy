//
//  SHBaseRequest.h
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol RequestDeligate <NSObject>

@required
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier;
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier;

@end

@interface SHBaseRequest : NSMutableURLRequest
{
	id <RequestDeligate>        mResponseClassDelegate;
    NSMutableData *                    mResponseData;
    NSString *                  mRequestIdentifier;
}
@property(nonatomic,retain) id <RequestDeligate> ResponseClassDelegate;
@property(nonatomic,retain)  NSData *  ResponseData;
@property(nonatomic,retain)  NSString * RequestIdentifier;

-(void) SetResponseData:(NSData *)inData;
-(NSData *) GetResponseData;


@end
