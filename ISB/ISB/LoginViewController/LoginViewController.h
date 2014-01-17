//
//  ViewController.h
//  ISB
//
//  Created by AppRoutes on 25/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkService.h"
@class SHBaseRequest;
@interface LoginViewController : UIViewController<UITextFieldDelegate,RequestDeligate>
{
    AppDelegate *app;
    NSManagedObjectContext *context;
//    NSArray *arrProfileData;
    NSDictionary *dicProfileData;
}

@property (retain, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (retain, nonatomic) IBOutlet UIButton *signInBtn;
@property (retain, nonatomic) IBOutlet UILabel *forgotPasswordLbl;
@property (retain, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (retain, nonatomic) IBOutlet UIButton *registrationBtn;
@property (strong, nonatomic) IBOutlet UIView *loginviewController;
-(void)willKeyBoardHide;

@end
