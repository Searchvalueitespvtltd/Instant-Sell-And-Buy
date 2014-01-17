//
//  ViewController.h
//  ISB
//
//  Created by AppRoutes on 25/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (retain, nonatomic) IBOutlet UIButton *signInBtn;
@property (retain, nonatomic) IBOutlet UILabel *forgotPasswordLbl;
@property (retain, nonatomic) IBOutlet UIButton *forgotPasswordBtn;
@property (retain, nonatomic) IBOutlet UIButton *registrationBtn;
@property (strong, nonatomic) IBOutlet UIView *loginviewController;
@end
