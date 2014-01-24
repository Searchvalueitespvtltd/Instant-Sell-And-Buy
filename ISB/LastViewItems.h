//
//  LastViewItems.h
//  ISB
//
//  Created by AppRoutes on 07/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface LastViewItems : NSManagedObject

@property (nonatomic, retain) NSString * category_id;
@property (nonatomic, retain) NSString * category_name;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country_id;
@property (nonatomic, retain) NSString * country_name;
@property (nonatomic, retain) NSString * created_by;
@property (nonatomic, retain) NSString * created_dt;
@property (nonatomic, retain) NSString * desc;
@property (nonatomic, retain) NSString * home_addr;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSString * is_watch;
@property (nonatomic, retain) NSString * item_code;
@property (nonatomic, retain) NSData * itemImage;
@property (nonatomic, retain) NSData * itemImage2;
@property (nonatomic, retain) NSData * itemImage3;
@property (nonatomic, retain) NSString * last_modified_by;
@property (nonatomic, retain) NSString * last_modified_dt;
@property (nonatomic, retain) NSString * location_latlong;
@property (nonatomic, retain) NSString * paymenttype_id;
@property (nonatomic, retain) NSString * paymenttype_name;
@property (nonatomic, retain) NSString * pic_path;
@property (nonatomic, retain) NSString * pic_path2;
@property (nonatomic, retain) NSString * pic_path3;
@property (nonatomic, retain) NSString * postage;
@property (nonatomic, retain) NSString * postagetype_id;
@property (nonatomic, retain) NSString * postagetype_name;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * sender_email;
@property (nonatomic, retain) NSString * state_id;
@property (nonatomic, retain) NSString * state_name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * user_name;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * zipcode;
@property (nonatomic, retain) NSString * default_pic;

@property (nonatomic,strong) NSString *rating_all;
@property (nonatomic,strong) NSString *seller_pic;
@property (nonatomic,strong) NSString *availability;



@property (nonatomic,strong) NSString *rating_postage;
@property (nonatomic,strong) NSString *rating_service;
@property (nonatomic,strong) NSString *rating_item_as_described;
@property (nonatomic,strong) NSString *rating_count;


@end
