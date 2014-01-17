//
//  SellItems.h
//  ISB
//
//  Created by chetan shishodia on 22/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SellItems : NSManagedObject

@property (nonatomic, retain) NSString * sellCount;
@property (nonatomic, retain) NSString * userId;

@end
