//
//  Category.h
//  ISB
//
//  Created by AppRoutes on 17/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Category : NSManagedObject

@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;

@end
