//
//  ItemDetails.h
//  ISB
//
//  Created by Pankaj on 02/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemDetails : NSObject
//@property(retain,nonatomic) NSMutableDictionary *dicItemDetail;
@property(retain,nonatomic) NSMutableDictionary *dicCategoryDetail;
@property(retain,nonatomic) NSMutableDictionary *dicPriceDetail;
@property(retain,nonatomic) NSMutableDictionary *dicLocDetail;
@property(retain,nonatomic) NSMutableDictionary *dicOtherdetails;
@property (retain , nonatomic) NSMutableDictionary *dicToShare;
@property( nonatomic) int isSelected;
@property( assign) BOOL isEditing;
+ (ItemDetails *)sharedInstance;
@end
