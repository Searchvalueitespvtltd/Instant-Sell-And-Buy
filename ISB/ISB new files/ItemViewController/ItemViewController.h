//
//  ItemViewController.h
//  ISB
//
//  Created by AppRoutes on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *overlay;
@property (retain, nonatomic) IBOutlet UIButton *searchBtn;
@property (retain, nonatomic) IBOutlet UIButton *watchBtn;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UITextView *productDiscriptionTxtView;
@property (retain, nonatomic) IBOutlet UILabel *itemLocationValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *PostageValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *itemCodeValueLbl;
@property (retain, nonatomic) IBOutlet UIButton *buyItemBtn;
@property (retain, nonatomic) IBOutlet UIButton *contectSellerBtn;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@end
