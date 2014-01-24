//
//  ProfileViewController.h
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController
{
    NSString *mystring;
    NSManagedObjectContext *context;
    NSMutableArray *userData;
//    IBOutlet UIImageView *imgRating;
}
@property (retain, nonatomic) IBOutlet UILabel *profileNameLbl;
@property (retain, nonatomic) IBOutlet UILabel *locationlbl;
@property (retain, nonatomic) IBOutlet UILabel *emailAddressLbl;
@property (retain, nonatomic) IBOutlet UILabel *yearLbl;
@property (retain, nonatomic) IBOutlet UIImageView *profilePicImg;
@property(retain,nonatomic)IBOutlet UIImageView *imgUserDefaultImage;
//@property (retain, nonatomic) IBOutlet NSString *displayName;


-(IBAction)btnSignOutClicked:(id)sender;

@end
