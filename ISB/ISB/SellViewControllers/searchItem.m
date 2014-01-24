//
//  searchItem.m
//  ISB
//
//  Created by chetan shishodia on 05/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "searchItem.h"

@implementation searchItem
@synthesize category;
@synthesize name;

+ (id)searchOfCategory:(NSString *)category name:(NSString *)name
{
    searchItem *search = [[self alloc] init];
    [search setCategory:category];
    [search setName:name];
    return search;
}

@end
