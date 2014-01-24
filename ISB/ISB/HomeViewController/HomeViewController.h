//
//  HomeViewController.h
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface HomeViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate>
{
    AppDelegate *app;
    IBOutlet UIImageView *imgReminderValue;
    IBOutlet UIImageView *imgMessageValue;
    IBOutlet UIImageView *imgSavedValue;
    IBOutlet UIImageView *imgChatValue;
    
    NSManagedObjectContext *context;
    NSMutableArray *arrSavedData;
    NSMutableArray *arrLastViewedItems;
//    NSMutableArray *arrUserData;
    
    IBOutlet UILabel *lblLastViewedItems;
    IBOutlet UIButton *btnUserProfile;

}
- (IBAction)goToChatScreen:(id)sender;

@property(retain,nonatomic)IBOutlet UITextField *txtSearch;
@property(retain,nonatomic)IBOutlet UILabel *lblSellValue, *lblBuyValue,*lblWatchValue,*lblReminderValue,*lblMessagesValue,*lblSavedValue,*lblChatValue;
@property(retain,nonatomic) IBOutlet UIScrollView *scrllView;

-(IBAction)btnUserProfileClicked:(id)sender;
-(IBAction)btnSettingClicked:(id)sender;
-(IBAction)btnReminderClicked:(id)sender;
-(IBAction)btnMessagesClicked:(id)sender;
-(IBAction)btnSavedClicked:(id)sender;
-(IBAction)btnSearchCancelClicked:(id)sender;

-(IBAction)btnBuyingClicked:(id)sender;
-(IBAction)btnSellingClicked:(id)sender;
-(IBAction)btnWatchClicked:(id)sender;



@end
