//
//  UserDetailViewController.h
//  ISB
//
//  Created by AppRoutes on 13/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailViewController : UIViewController
@property (retain, nonatomic) IBOutlet UILabel *lblCustName;
@property (retain, nonatomic) IBOutlet UILabel *lblCustAdd;
@property (retain, nonatomic) IBOutlet UILabel *lblEmailId;
@property (retain, nonatomic) IBOutlet UILabel *lblContectNumber;
@property (retain, nonatomic) IBOutlet UILabel *lblDealAmount;
@property (retain,nonatomic) IBOutlet UIView *viewReview;
@property(retain,nonatomic) IBOutlet UILabel *lblViewTitle;

@property (retain,nonatomic) NSString * strUserId;
@property (retain,nonatomic) NSString * strItemId;
@property (retain,nonatomic) NSString * strService;
@property (retain,nonatomic) NSString * strPostage;
@property (retain,nonatomic) NSString * strItem_as_described;
@property (retain,nonatomic) NSString *strViewTitle;

@property (retain, nonatomic) IBOutlet UIImageView *profilePicImg;
@property(retain,nonatomic)IBOutlet UIImageView *imgUserDefaultImage;


-(IBAction)btnReviewClicked:(id)sender;
-(IBAction)btnSendReview:(id)sender;
-(IBAction)btnBack:(id)sender;

@end
