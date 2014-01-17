//
//  Product.m
//  ISB
//
//  Created by AppRoutes on 11/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "Product.h"

@implementation Product
@synthesize category_id,category_name,desc,city,country_name,home_addr,status,location_latlong,paymenttype_name,postage,postagetype_name,price,title,pic_path,pic_path2,pic_path3,user_name,zipcode,last_modified_dt,created_by,country_id,created_dt,id,image,item_status,is_watch,paymenttype_id,sender_email,default_pic,postagetype_id,state_name,rating_all,rating_item_as_described,rating_postage,rating_service,seller_pic,availability,rating_count;
-(id)init
{
    self = [super init];
    if (self)
    {
        rating_all=nil;
        rating_item_as_described=nil;
        rating_postage=nil;
        rating_service=nil;
        rating_count=nil;
       category_name=nil;
        item_status = nil;
       desc=nil;
        availability=nil;
        seller_pic=nil;
        city=nil;
        country_name=nil;
        home_addr=nil;
       status=nil;
        default_pic=nil;
        location_latlong=nil;
       paymenttype_name=nil;
        paymenttype_id = nil;
        postage=nil;
        postagetype_name=nil;
        price=nil;
       title=nil;
        postagetype_id=nil;
        user_name=nil;
        zipcode=nil;
        last_modified_dt=nil;
        image=nil;
        is_watch=nil;
        sender_email = nil;
        state_name=nil;
        
        }
    return self;
}

@end
