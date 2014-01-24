//
//  RecentSearch.h
//  ISB
//
//  Created by chetan shishodia on 18/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecentSearch : NSManagedObject

@property (nonatomic, retain) NSString * item_name;
@property (nonatomic, retain) NSString * userId;

@end
