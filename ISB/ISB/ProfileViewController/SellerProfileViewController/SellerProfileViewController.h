//
//  ProfileViewController.h
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerProfileViewController : UIViewController
{
    NSMutableDictionary*    userDetailDictionary;
}


@property (retain, nonatomic) IBOutlet UILabel *profileNameLbl;
@property (retain, nonatomic) IBOutlet UILabel *locationlbl;
@property (retain, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (retain, nonatomic) IBOutlet UILabel *yearLbl;
@property (retain, nonatomic) IBOutlet UIImageView *profilePicImg;
@property(retain,nonatomic)IBOutlet UIImageView *imgUserDefaultImage;
@property (retain, nonatomic) IBOutlet UILabel *ContactNoLbl;
@property(retain,nonatomic) NSString *strUserId;
@property(retain,nonatomic) NSString *strItemId;

@property (assign,nonatomic) float service;
@property (assign,nonatomic) float postage;
@property (assign,nonatomic) float itemDescribed;

- (IBAction)backButton:(id)sender;
- (IBAction)saveRatingBtn:(id)sender;

@end
