//
//  ChangePasswordViewController.h
//  ISB
//
//  Created by AppRoutes on 08/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePasswordViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *oldPasswordTxtField;
@property (retain, nonatomic) IBOutlet UITextField *nwPasswordTxtFiled;
@property (retain, nonatomic) IBOutlet UITextField *confirmPasswordTxtField;
@property (strong, nonatomic) IBOutlet UIView *changePasswordViewController;
@end
