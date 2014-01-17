//
//  Category.m
//  ISB
//
//  Created by AppRoutes on 15/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "Category.h"

@implementation Category
@synthesize id,name;
-(id)init
{
    self = [super init];
    if (self)
    {
//        id = 0;
        name = nil;
    }
    return self;
}
@end
