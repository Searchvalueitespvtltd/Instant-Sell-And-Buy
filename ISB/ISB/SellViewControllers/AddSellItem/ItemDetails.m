//
//  ItemDetails.m
//  ISB
//
//  Created by Neha Saxena on 02/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ItemDetails.h"

@implementation ItemDetails
@synthesize dicLocDetail,dicCategoryDetail,dicPriceDetail;
+ (ItemDetails *)sharedInstance {
    
    /*
     if (sharedInstance == nil) {
     sharedInstance = [[super allocWithZone:NULL] init];
     }
     
     return sharedInstance;
     */
    
    static ItemDetails *_sharedInstance;
    
    
	if(!_sharedInstance)
    {
		static dispatch_once_t oncePredicate;
		dispatch_once(&oncePredicate, ^{
			_sharedInstance = [[super allocWithZone:nil] init];
        });
    }
    
    return _sharedInstance;
    
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self sharedInstance] retain];
}

@end
