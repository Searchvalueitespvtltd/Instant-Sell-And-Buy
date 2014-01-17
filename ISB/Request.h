//
//  Request.h
//  ISB
//
//  Created by Neha Saxena on 15/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Request : NSManagedObject

@property (nonatomic, retain) NSString * jid;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * userid;
@end
