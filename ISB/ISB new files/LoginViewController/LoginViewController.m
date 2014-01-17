//
//  ViewController.m
//  ISB
//
//  Created by AppRoutes on 25/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "LoginViewController.h"
#import "ForgotPasswordViewController.h"
#import "RegistrationViewController.h"



@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize forgotPasswordLbl,forgotPasswordBtn,signInBtn,userNameTxtField,passwordTxtField,loginviewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

	NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Forgot username or password?"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    forgotPasswordLbl.attributedText = [attributeString copy];
    [userNameTxtField resignFirstResponder];
    [passwordTxtField resignFirstResponder];

}
- (IBAction)signInClick:(id)sender {
    
}
- (IBAction)forgotPasswordClick:(id)sender {
    ForgotPasswordViewController *forgotPassViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        forgotPassViewController=[[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController_iPhone5" bundle:nil];
        
    }
    else{
        forgotPassViewController=[[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil]; }
    
    [self.navigationController pushViewController:forgotPassViewController animated:YES ];
    [forgotPassViewController release];

}
- (IBAction)registrationClick:(id)sender {
    RegistrationViewController *registrationViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        registrationViewController=[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController_iPhone5" bundle:nil];
        
    }
    else{
        registrationViewController=[[RegistrationViewController alloc] initWithNibName:@"RegistrationViewController" bundle:nil]; }

    [self.navigationController pushViewController:registrationViewController animated:YES ];
    [registrationViewController release];

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
//    NSString *trimmedString = [emailTxtField.text stringByTrimmingCharactersInSet:
//                               [NSCharacterSet whitespaceCharacterSet]];
//    
//    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
//    if (([emailTest evaluateWithObject:trimmedString]) && ([self.passwordTxtField text].length>5))
//    {
//        signInBtn.enabled=YES;
//    }
//    else
//    {
//        signInBtn.enabled=NO;
//    }
    


}




- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    switch (textField.tag)
    {
        case 100:
            [userNameTxtField resignFirstResponder];
//            [passwordTxtField becomeFirstResponder];
                    break;
            
        case 101:
            [self.passwordTxtField resignFirstResponder];
            break;
            
        default:
            break;
    }
return YES;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [userNameTxtField resignFirstResponder];
    [passwordTxtField resignFirstResponder];
    
    
}

-(void)willKeyBoardShow
{
    CGRect selfFrame = loginviewController.frame;
    NSLog(@"willKeyBoardShow");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [loginviewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 110, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
}
-(void)willKeyBoardHide
{
    CGRect selfFrame = loginviewController.frame;
    
    NSLog(@"willKeyBoardHide");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [loginviewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 110, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [userNameTxtField release];
    [passwordTxtField release];
    [signInBtn release];
    [forgotPasswordLbl release];
    [forgotPasswordBtn release];
    [_registrationBtn release];
    [super dealloc];
}
@end
