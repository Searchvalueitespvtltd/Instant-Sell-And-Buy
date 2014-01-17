//
//  MySavedSearch.h
//  ISB
//
//  Created by chetan shishodia on 18/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MySavedSearch : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * category_name;
@property (nonatomic, retain) NSString * isNotify;
@property (nonatomic, retain) NSString * searchName;
@property (nonatomic, retain) NSString * userId;

@end
