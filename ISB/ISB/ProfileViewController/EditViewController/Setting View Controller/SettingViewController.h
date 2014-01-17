//
//  SignOutViewController.h
//  ISB
//
//  Created by chetan shishodia on 11/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
{
    NSManagedObjectContext *context;
    NSString *strIsNotifyme;
}
- (IBAction)keepmeLogIn:(id)sender;
- (IBAction)notifyMe:(id)sender;


@property (retain, nonatomic) IBOutlet UILabel *lblProfileName;
@property (retain, nonatomic) IBOutlet UISwitch *switchKeepMeLogged;
@property (retain, nonatomic) IBOutlet UISwitch *switchRecentItem;
@property (retain, nonatomic) IBOutlet UISwitch *switchNotifyme;
- (IBAction)addPayPalClick:(id)sender;


-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnSignOutClicked:(id)sender;

@end
