//
//  WatchItemTable.h
//  ISB
//
//  Created by chetan shishodia on 22/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WatchItemTable : NSManagedObject

@property (nonatomic, retain) NSString * product_id;
@property (nonatomic, retain) NSString * user_id;

@end
