//
//  Users.h
//  ISB
//
//  Created by chetan shishodia on 01/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Users : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * created_dt;
@property (nonatomic, retain) NSString * display_name;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * fname;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSData * image;
@property (nonatomic, retain) NSString * isdcode;
@property (nonatomic, retain) NSString * lname;
@property (nonatomic, retain) NSString * phoneno;
@property (nonatomic, retain) NSString * profile_pic_path;
@property (nonatomic, retain) NSString * pwd;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * userid;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * country_id;
@property (nonatomic, retain) NSString * paypal_account;

@end
