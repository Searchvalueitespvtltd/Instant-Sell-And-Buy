//
//  Product.h
//  ISB
//
//  Created by AppRoutes on 11/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Product : NSObject
@property (nonatomic,strong) NSString *created_dt;
@property (nonatomic,strong) NSString *category_name;
@property (nonatomic,strong) NSString *desc;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *country_name;
@property (nonatomic,strong) NSString *state_name;
@property (nonatomic,strong) NSString *home_addr;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSArray *location_latlong;
@property (nonatomic,strong) NSString *paymenttype_name;
@property (nonatomic,strong) NSString *postage;
@property (nonatomic,strong) NSString *postagetype_name;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *user_name;
@property (nonatomic,strong) NSString *zipcode;
@property (nonatomic,strong) NSString *last_modified_dt;
@property (nonatomic,strong) NSString *pic_path;
@property (nonatomic,strong) NSString *pic_path2;
@property (nonatomic,strong) NSString *pic_path3;

@property (nonatomic,strong) NSString *item_code;
@property (nonatomic,strong) NSString *paymenttype_id;
@property (nonatomic,strong) NSString *sender_email;
@property (nonatomic,strong) NSString *postagetype_id;

@property (nonatomic,strong) NSString *default_pic;

@property (nonatomic,strong) NSString *rating_all;
@property (nonatomic,strong) NSString *rating_postage;
@property (nonatomic,strong) NSString *rating_service;
@property (nonatomic,strong) NSString *rating_item_as_described;

@property (nonatomic,strong) NSString *availability;
@property (nonatomic,strong) NSString *rating_count;

//new
@property (nonatomic,strong) NSString *is_watch;

@property (nonatomic,strong) NSString *item_status;

@property (nonatomic,strong) NSString *seller_pic;


@property (nonatomic) int created_by;
@property (nonatomic) int id;
@property (nonatomic) int country_id;
@property (nonatomic) int category_id;
@property (nonatomic,strong) UIImage *image;
@end
