//
//  searchItem.h
//  ISB
//
//  Created by chetan shishodia on 05/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface searchItem : NSObject
{
    NSString *category;
    NSString *name;
}

@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *name;

+ (id)searchOfCategory:(NSString*)category name:(NSString*)name;

@end
