//
//  ForgotPasswordViewController.m
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "NetworkService.h"
#import "Utils.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController
@synthesize emailAddress,submitBtn,forgotViewController;

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
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
-(void)viewWillAppear:(BOOL)animated{
    [ItemDetails sharedInstance].isSelected =0;

}
-(void)willKeyBoardShow
{
    CGRect selfFrame = forgotViewController.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [forgotViewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 110, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
}
-(void)willKeyBoardHide
{
    CGRect selfFrame = forgotViewController.frame;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [forgotViewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 110, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [emailAddress resignFirstResponder];
    
}
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submitClick:(id)sender {
    
    
    if([emailAddress.text length]>0)
    {
       [Utils startActivityIndicatorInView:self.view withMessage:nil];
       [self performSelector:@selector(callWebService) withObject:nil afterDelay:1.0];
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
}
-(void)callWebService
{
    
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/send_pwd?username=%@",emailAddress.text] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"Response -- %@",inResponseDic);
  if([[inResponseDic objectAtIndex:0]isEqualToString:@"success"])
//    {
//        NSString *message=[NSString stringWithFormat:@"Details of your accout has beens sent to %@",emailAddress.text] ;
//        [Utils showAlertView:nil message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//    else
//    {
  {
        [Utils showAlertView:kAlertTitle message:[inResponseDic objectAtIndex:1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [self.navigationController popViewControllerAnimated:YES];

  }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter correct username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
//    }
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [emailAddress resignFirstResponder];
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [emailAddress release];
    [submitBtn release];
    [super dealloc];
}
@end
