//
//  ChangePasswordViewController.m
//  ISB
//
//  Created by AppRoutes on 08/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ChangePasswordViewController.h"

@interface ChangePasswordViewController ()

@end

@implementation ChangePasswordViewController
@synthesize oldPasswordTxtField,confirmPasswordTxtField,nwPasswordTxtFiled,changePasswordViewController;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

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
}
-(void)willKeyBoardShow
{
    CGRect selfFrame = changePasswordViewController.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [changePasswordViewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 110, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
}
-(void)willKeyBoardHide
{
    CGRect selfFrame = changePasswordViewController.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [changePasswordViewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 110, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [nwPasswordTxtFiled resignFirstResponder];
    [oldPasswordTxtField resignFirstResponder];
    [confirmPasswordTxtField resignFirstResponder];
}
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)changePasswordClick:(id)sender {
    self.nwPasswordTxtFiled.text = [self.nwPasswordTxtFiled.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.oldPasswordTxtField.text = [self.oldPasswordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.confirmPasswordTxtField.text = [self.confirmPasswordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([self.nwPasswordTxtFiled text].length<5)
    {[Utils showAlertView:kAlertTitle message:@"New password length must be of minimum 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //        signInBtn.enabled = NO;
    }
    else if (![self.nwPasswordTxtFiled.text isEqualToString:self.confirmPasswordTxtField.text])
    {
        [Utils showAlertView:kAlertTitle message:@"New password and confirm password are not matched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self.nwPasswordTxtFiled.text=@"";
        self.confirmPasswordTxtField.text=@"";
        return;
    }
    else
    {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self performSelector:@selector(callWebService) withObject:nil afterDelay:1.0];
    }
    
}
-(void)callWebService
{
    
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/change_pwd?username=%@&oldpwd=%@&newpwd=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"],oldPasswordTxtField.text,nwPasswordTxtFiled.text]  dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"Response -- %@",inResponseDic);
    if([[inResponseDic objectAtIndex:0]isEqualToString:@"success"])
          {
        [Utils showAlertView:kAlertTitle message:@"Password change successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter correct Password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    //    }
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

-(void)viewWillAppear:(BOOL)animated
{
    [ItemDetails sharedInstance].isSelected =0;

    [super viewWillAppear:YES];
    //    submitBtn.enabled=NO;
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    switch (textField.tag) {
        case 101:
            
            if (![self.oldPasswordTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Old password can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
            [oldPasswordTxtField resignFirstResponder];
//            [nwPasswordTxtFiled becomeFirstResponder];
            break;
        case 102:
            
            if (![self.nwPasswordTxtFiled text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"New password can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
            [nwPasswordTxtFiled resignFirstResponder];
//            [confirmPasswordTxtField becomeFirstResponder];
            break;
            
           case 103:
            
            [confirmPasswordTxtField resignFirstResponder];
    }
    return YES;
}

@end
