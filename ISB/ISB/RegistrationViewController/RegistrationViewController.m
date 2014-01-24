//
//  RegistrationViewController.m
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "RegistrationViewController.h"
#import "Utils.h"
#import "NetworkService.h"
#import "Defines.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSData+Base64.h"
#import "JSON.h"
#import "LoginViewController.h"
#import "TermsAndConditionViewController.h"

@interface RegistrationViewController ()

@end

@implementation RegistrationViewController

@synthesize countryArray,stateArray,picker,imgBackCamera,imgCamera,imgUserDefaultImage,stringCountry_id;

@synthesize scrollView,firstNameTxtField,lastNameTxtField,userNameTxtField,passwordTxtField,confirmpasswordTxtField,addressTxtField,checkBoxBtn,cityTxtPassword,confirmEmailTxtField,countryTxtField,zipCodeTxtField,phoneNoPrefixTxtField,phoneNoTxtField,emailAddressTxtField,signUpBtn,stateTxtField,termAndConditionBtn,toolBar,stateBtn,countryBtn,pickerContainer,pickerView;

//int textFieldTouched = 0;

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
    imgCamera.layer.cornerRadius = 2.5;
    imgCamera.layer.masksToBounds = YES;
    picker = [[UIImagePickerController alloc]init];
    picker.allowsEditing = NO;
    picker.delegate=self;
    [scrollView setScrollEnabled:YES];
     pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
   signUpBtn.enabled=NO;
//    self.countryArray=[[NSMutableArray alloc]initWithObjects:@"United Kingdom",nil];

    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.scrollView.frame = CGRectMake(0, 106, 320, self.view.frame.size.height-60);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 106, 320, self.view.frame.size.height-44);
    }
    
    scrollView.contentSize = CGSizeMake(0, 860);
}

- (void)displayActionSheet
{
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
//    [actionSheet addButtonWithTitle:@""]; //Blue color
//    [actionSheet addButtonWithTitle:@""];
//    [actionSheet addButtonWithTitle:@""];
//    [actionSheet setCancelButtonIndex:2];
//    [actionSheet setDestructiveButtonIndex:1];
//    [actionSheet showInView:self.view];
//    UIButton *button = [[actionSheet subviews] objectAtIndex:1];
//    UIImage *img =[UIImage imageNamed:@"btnTakePicture.png"];
//    [button setBackgroundImage:img forState:UIControlStateNormal];
//    UIButton *button1 = [[actionSheet subviews] objectAtIndex:2];
//    UIImage *img1 =[UIImage imageNamed:@"btnChooseLibrary.png"];
//    [button1 setBackgroundImage:img1 forState:UIControlStateNormal];
//    UIButton *button2 = [[actionSheet subviews] objectAtIndex:3];
//    UIImage *img2 =[UIImage imageNamed:@"btnCancel.png"];
//    [button2 setBackgroundImage:img2 forState:UIControlStateNormal];
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                                    cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"", @"", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
      [actionSheet showInView:self.view];
    
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"btnTakePicture.png"] forState:UIControlStateNormal];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"btnChooseLibrary.png"] forState:UIControlStateNormal];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"btnTakePicture.png"] forState:UIControlStateHighlighted];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"btnChooseLibrary.png"] forState:UIControlStateHighlighted];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateHighlighted];
    
    
}

#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imgBackCamera.hidden = NO;
    self.imgCamera.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        self.imgUserDefaultImage.hidden = YES;
    //    if (!self.imgCamera)
    //    {
    //        return;
    //    }
    //
    //    // Adjusting Image Orientation
    //    NSData *data = UIImagePNGRepresentation(imgCamera);
    //    UIImage *tmp = [UIImage imageWithData:data];
    //    UIImage *fixed = [UIImage imageWithCGImage:tmp.CGImage
    //                                         scale:imgCamera.scale orientation:self.imgCamera.imageOrientation];
    //    self.imgCamera = fixed;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:@"This device has no camera" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }
            
        }
            break;
        case 1:
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
        }
        default:
            // Do Nothing.........
            break;
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [stateTxtField resignFirstResponder];
    [countryTxtField resignFirstResponder];
//    switch(textFieldTouched)
//    {
//        case 1:
//            //    [btnPostageType setTitle:[NSString stringWithString:[[arrPostageType objectAtIndex:row]valueForKey:@"name"]] forState:UIControlStateNormal];
//            
//            
//            // [self.stateBtn setTitle:[[self.stateArray objectAtIndex:row] valueForKey:@"name"] forState:UIControlStateNormal];
//            
//            
//            
//            stateTxtField.text = [[self.stateArray objectAtIndex:row] objectForKey:@"name"];
//            
//            state_id = [[[self.stateArray objectAtIndex:row] objectForKey:@"id"]intValue];
//            break;
//        case 2:
//            
//            //            [self.countryBtn setTitle:[self.countryArray objectAtIndex:row] forState:UIControlStateNormal];
//            
//            countryTxtField.text = [[self.countryArray objectAtIndex:row] objectForKey:@"short_name"];
//            country_id = [[[self.countryArray objectAtIndex:row] objectForKey:@"id"]intValue];
//            //            country_id = [[[self.countryArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"id"]intValue];
//            break;
//    }
//    [self.countryBtn setTitle:[[self.countryArray objectAtIndex:row] valueForKey:@"short_name"] forState:UIControlStateNormal];
    
    isSelected = YES;
    countryTxtField.text = [[self.countryArray objectAtIndex:row] objectForKey:@"short_name"];
    country_id = [[[self.countryArray objectAtIndex:row] objectForKey:@"id"]intValue];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
//    switch(textFieldTouched)
//    {
//        case 1:
//            return [self.stateArray count];
//            break;
//        case 2:
//            return [self.countryArray count];
//            break;
//        default:
//            return 0;
//    }
    return [self.countryArray count];
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
//    switch(textFieldTouched)
//    {
//        case 1:
//            return [[self.stateArray objectAtIndex:row] objectForKey:@"name"];
//            break;
//        case 2:
//            return [[self.countryArray objectAtIndex:row] objectForKey:@"short_name"];
//            break;
//        default:
//            return @"nothing";
//    }
    return [[self.countryArray objectAtIndex:row] objectForKey:@"short_name"];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-30) animated:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
   
}

//-(void)textFieldDidEndEditing:(UITextField *)textField{
//    
////    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
////    NSString *username = [self.emailAddressTxtField.text stringByTrimmingCharactersInSet:set];
////    NSString *regix = @"\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
////    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regix];
////    
////    if (![predicate evaluateWithObject:username])
////    {
////        [Utils showAlertView:kAlertTitle message:@"Email is not in correct format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
////        self.emailAddressTxtField.text=@"";
////        self.confirmEmailTxtField.text=@"";
////        return;
////    }
//
//    if (![self.firstNameTxtField text].length>0)
//    {
//        [Utils showAlertView:kAlertTitle message:@"First Name can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.lastNameTxtField text].length>0)
//    {
//        [Utils showAlertView:kAlertTitle message:@"Last Name can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    
//    else if ([self.passwordTxtField text].length<5)
//    {
//        [Utils showAlertView:kAlertTitle message:@"Password length must be of minimum 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        //        signInBtn.enabled = NO;
//    }
//   else if (![self.userNameTxtField text].length>0)
//    {
//        [Utils showAlertView:kAlertTitle message:@"UserName can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.passwordTxtField text].length>0)
//    {
//        [Utils showAlertView:kAlertTitle message:@"Password can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.confirmpasswordTxtField text].length>0)
//    {
//        [Utils showAlertView:kAlertTitle message:@"Confirm Password can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.cityTxtPassword text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"City can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.stateTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"State can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.zipCodeTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"Zip Code can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.countryTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"Country can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.phoneNoPrefixTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"ISD Code can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.phoneNoTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"Phone Number can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.emailAddressTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"Email address can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.confirmEmailTxtField text].length>0)
//    {
//        [Utils showAlertView:@"ISB" message:@"Confirm Email address can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
//    else if (![self.passwordTxtField.text isEqualToString:self.confirmpasswordTxtField.text])
//    {
//        [Utils showAlertView:@"ISB" message:@"Password and confirm password are not matched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        self.passwordTxtField.text=@"";
//        self.confirmpasswordTxtField.text=@"";
//        return;
//    }
//    else if (![self.emailAddressTxtField.text isEqualToString:self.confirmEmailTxtField.text])
//    {
//        [Utils showAlertView:@"ISB" message:@"Email address and Confirm email address are not matched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        self.emailAddressTxtField.text=@"";
//        self.confirmEmailTxtField.text=@"";
//        return;
//        
//        
//    }
//
//}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
        switch (textField.tag) {
        case 101:
           
            if (![self.firstNameTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"First Name can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
                [firstNameTxtField resignFirstResponder];
                [lastNameTxtField becomeFirstResponder];
            break;
        case 102:
            
            if (![self.lastNameTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Last Name can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
                [lastNameTxtField resignFirstResponder];
                [userNameTxtField becomeFirstResponder];
            break;
        case 103:
            if (![self.userNameTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"UserName can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
               
            [userNameTxtField resignFirstResponder];
            [passwordTxtField becomeFirstResponder];
            break;
        case 104:
            if (![self.passwordTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Password can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }

            [passwordTxtField resignFirstResponder];
            [confirmpasswordTxtField becomeFirstResponder];
            break;
        case 105:
            [confirmpasswordTxtField resignFirstResponder];
            [addressTxtField becomeFirstResponder];
            break;
        case 106:
            if (![self.addressTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Home Address can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }

            [addressTxtField resignFirstResponder];
            [cityTxtPassword becomeFirstResponder];
            break;
        case 107:
            if (![self.cityTxtPassword text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"City can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
            [cityTxtPassword resignFirstResponder];
            [countryTxtField becomeFirstResponder];
            [self showCountryPicker:@"102"];
            break;
        case 108:
            if (![self.countryTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Country can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
            [countryTxtField resignFirstResponder];
            [zipCodeTxtField becomeFirstResponder];
            break;
        case 109:
            if (![self.zipCodeTxtField text].length>0)
        {
            [Utils showAlertView:kAlertTitle message:@"Zip Code can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            return NO;
        }
            [zipCodeTxtField resignFirstResponder];
            [stateTxtField becomeFirstResponder];
            //[self showStatePicker:@"101"];
            break;
        case 110:
            if (![self.stateTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"State can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
            [stateTxtField resignFirstResponder];
            [phoneNoPrefixTxtField becomeFirstResponder];
            break;
        case 111:
            if (![self.phoneNoPrefixTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"ISD Code can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
            [phoneNoPrefixTxtField resignFirstResponder];
            [phoneNoTxtField becomeFirstResponder];
            break;
        case 112:
            if (![self.phoneNoTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Phone Number can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }

            [phoneNoTxtField resignFirstResponder];
            [emailAddressTxtField becomeFirstResponder];
            break;
        case 113:
            if (![self.emailAddressTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Email address can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }

            [emailAddressTxtField resignFirstResponder];
            [confirmEmailTxtField becomeFirstResponder];
            break;
        case 114:
            [confirmEmailTxtField resignFirstResponder];
                if([[UIScreen mainScreen] bounds].size.height>480)
                {
                    [self.scrollView setContentOffset:CGPointMake(0, 340) animated:YES];
                }
                else
                {
                    [self.scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
                }
                break;
            
        default:
            
            break;
            
    }
    return YES;
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == zipCodeTxtField) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }else if (textField == phoneNoTxtField)
        
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 10) ? NO : YES;
    }else if(textField == phoneNoPrefixTxtField)
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 4) ? NO : YES;
    }
    else
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 30) ? NO : YES;
        
    }
}

- (IBAction)termAndConditionClick:(id)sender
{
        TermsAndConditionViewController *terms;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            terms = [[TermsAndConditionViewController alloc] initWithNibName:@"TermsAndConditionViewController_iPhone5" bundle:nil];
        }
        else
        {
            terms = [[TermsAndConditionViewController alloc] initWithNibName:@"TermsAndConditionViewController" bundle:nil];
        }
        
        [self.navigationController pushViewController:terms animated:YES ];
        
        [terms release];

}

- (IBAction)checkBoxClick:(id)sender {
    [self.view endEditing:YES];
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 340) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
    }

    if([checkBoxBtn isSelected])
    {
        [checkBoxBtn setSelected:NO];
        signUpBtn.enabled=NO;
    }
    else
    {
        [checkBoxBtn setSelected:YES];
        signUpBtn.enabled=YES;
    }
}

- (IBAction)signUpClick:(id)sender {
    self.emailAddressTxtField.text = [self.emailAddressTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.confirmEmailTxtField.text = [self.confirmEmailTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
     self.passwordTxtField.text = [self.passwordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.confirmpasswordTxtField.text = [self.confirmpasswordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.userNameTxtField.text = [userNameTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     if(([self.firstNameTxtField text].length>0)&&([self.lastNameTxtField text].length>0)&&([self.userNameTxtField text].length>0)&&([self.passwordTxtField text].length>0)&&([self.confirmpasswordTxtField text].length>0)&&([self.emailAddressTxtField text].length>0)&&([self.confirmEmailTxtField text].length>0)&&([self.addressTxtField text].length>0)&&([self.cityTxtPassword text].length>0)&&([self.countryTxtField text].length>0)&&([self.stateTxtField text].length>0)&&([self.zipCodeTxtField text].length>0)&&([self.phoneNoPrefixTxtField text].length>0)&&([self.phoneNoTxtField text].length>0))
     {
         
         
            NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
         NSString *email = [self.emailAddressTxtField.text stringByTrimmingCharactersInSet:set];
         NSString *regix = @"\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
         NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regix];
         
         if (![predicate evaluateWithObject:email])
         {
             [Utils showAlertView:kAlertTitle message:@"Email is not in correct format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
             self.emailAddressTxtField.text=@"";
             self.confirmEmailTxtField.text=@"";
             return;
         }
          else if ([self.passwordTxtField text].length<5)
         {[Utils showAlertView:kAlertTitle message:@"Password length must be of minimum 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //        signInBtn.enabled = NO;
         }
         
         else if (![self.passwordTxtField.text isEqualToString:self.confirmpasswordTxtField.text])
            {
                [Utils showAlertView:kAlertTitle message:@"Password and confirm password are not matched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                self.passwordTxtField.text=@"";
                self.confirmpasswordTxtField.text=@"";
                return;
            }
    else if (![self.emailAddressTxtField.text isEqualToString:self.confirmEmailTxtField.text])
            {
                [Utils showAlertView:kAlertTitle message:@"Email address and Confirm email address are not matched." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                self.emailAddressTxtField.text=@"";
                self.confirmEmailTxtField.text=@"";
                return;
            }

         else
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callWebService) withObject:nil afterDelay:1.0];
     }
     else{
         [Utils showAlertView:kAlertTitle message:@"Fields can't be left blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
     }
        /////////////////////////
}

-(void)callCountries
{
    
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"countries/get"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
//    [self.scrollView setContentOffset:CGPointMake(0, countryTxtField.frame.origin.y-30) animated:YES];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        pickerContainer.frame = CGRectMake(0, 290, 320, 261);
//        
//    }
//    else{
//        pickerContainer.frame = CGRectMake(0, 200, 320, 261);
//    }
//    
//    [UIView commitAnimations];
//    [pickerView reloadAllComponents];
//    NetworkService *objService = [NetworkService sharedInstance];
//    [objService sendRequestToServer:[NSString stringWithFormat:@"countries/get"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    

}
-(void)callStates
{
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"states/get?country_id=235"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)callWebService
{
    
    
//    users/save?email=%@&pwd=Welcome@123&fname=ojal&lname=suthar&zip=122&device_token=213ab3c33c4c4d55e5f5f&username=oja3l15&home_addr=343,trgvrtyvrt%20street&city=udaipur&state_id=4&country_id=1&isd_code=23&primary_phone=98898998999
    NSString *urlString = [NSString stringWithFormat:@"users/save?email=%@&pwd=%@&fname=%@&lname=%@&zip=%@&device_token=%@&username=%@&home_addr=%@&city=%@&state_name=%@&country_id=%d&isd_code=%@&primary_phone=%@&paypal_account=%@",emailAddressTxtField.text,passwordTxtField.text,firstNameTxtField.text,lastNameTxtField.text,zipCodeTxtField.text,[[NSUserDefaults standardUserDefaults]valueForKey:kDevicetoken],userNameTxtField.text,addressTxtField.text,cityTxtPassword.text,stateTxtField.text,country_id,phoneNoPrefixTxtField.text,phoneNoTxtField.text,self.txtPayPalAccountId.text];
    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:urlString]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    if(self.imgCamera.image != NULL)
    {
        NSString *imgString = [UIImagePNGRepresentation(self.imgCamera.image) base64Encoding];
        NSString *str=[@"img=" stringByAppendingString:imgString];
        NSData *postData = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        [request setHTTPBody:postData];
    }
    
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@",s);
    NSArray *result = [s JSONValue];
//    NSLog(@"%@",result);
    if([[result objectAtIndex:0]isKindOfClass:[NSDictionary class]])
    {
        [Utils showAlertView:kAlertTitle message:@"Registration successful.\nA verification email has been sent to your email account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [[NSUserDefaults standardUserDefaults]setValue:[[result objectAtIndex:0] objectForKey:@"user_id"] forKey:@"USERID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        LoginViewController *loginView;
        if([[UIScreen mainScreen]bounds].size.height>480)
        {
            loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController_iPhone5" bundle:nil];
        }
        else
        {
            loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        }
        [self.navigationController pushViewController:loginView animated:YES];
        [loginView release];
        
        
//        HomeViewController *homeViewController;
//        if([[UIScreen mainScreen] bounds].size.height>480)
//        {
//            homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone5" bundle:nil]; 
//        }
//        else
//        {
//            homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];   
//        }
//        
//        //        [self.navigationController pushViewController:homeViewController animated:YES ];
        //        [homeViewController release];
        
//        AppDelegate *delegate = APP_DELEGATE;
//        [delegate removeHomeScreen:@"0"];
        

    }
    else
    {
        [Utils showAlertView:kAlertTitle message:[result objectAtIndex:1] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    [Utils stopActivityIndicatorInView:self.view];
}

//-(void)receiveURLResponse:(id)responseDic
//{
//    [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"Response is = %@",responseDic);
//    if([[responseDic objectAtIndex:0]isEqualToString:@"success"])
//    {
//
//        [Utils showAlertView:nil message:@"Registration successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
//}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
      // NSLog(@"Response is = %@",inResponseDic);
      
//    if ([inReqIdentifier rangeOfString:@"short_name"].length>0) {
//        [pickerView reloadAllComponents];
//    }
    if([inReqIdentifier rangeOfString:@"users/save?email"].length>0)
    {
        
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [Utils showAlertView:kAlertTitle message:@"Registration successful.\nA verification email has been sent to your email account." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
//            LoginViewController *loginView;
//            if([[UIScreen mainScreen]bounds].size.height>480)
//            {
//                loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController_iPhone5" bundle:nil];
//            }
//            else
//            {
//                loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
//            }
//            [self.navigationController pushViewController:loginView animated:YES];
//            [loginView release];
            
//            HomeViewController *homeViewController;
//            if([[UIScreen mainScreen] bounds].size.height>480)
//            {
//                homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone5" bundle:nil];
//                
//            }
//            else{
//                homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil]; }
//            
//            [self.navigationController pushViewController:homeViewController animated:YES ];
//            [homeViewController release];

        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Specified username already registered" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
//        [self.navigationController popToRootViewControllerAnimated:YES];
//
    }
    else if([inReqIdentifier rangeOfString:@"countries/get"].length>0){
                   [self.countryArray removeAllObjects];
            self.countryArray = inResponseDic;
//            NSLog(@"Response is = %@",self.countryArray);
            [self.scrollView setContentOffset:CGPointMake(0, countryTxtField.frame.origin.y-30) animated:YES];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                pickerContainer.frame = CGRectMake(0, 290, 320, 261);
                
            }
            else{
                pickerContainer.frame = CGRectMake(0, 200, 320, 261);
            }
            
            [UIView commitAnimations];
            [pickerView reloadAllComponents];
    }
  
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

- (IBAction)uploadPictureClick:(id)sender {
    [self  displayActionSheet];
}
- (IBAction)stopEditing:(id)sender {
    if ([emailAddressTxtField isFirstResponder] || [confirmEmailTxtField isFirstResponder]|| [phoneNoPrefixTxtField isFirstResponder]||[phoneNoTxtField isFirstResponder]) {
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 300) animated:YES];
        }
        else
        {
            [self.scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
    }
      
    }

    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
}
- (IBAction)showStatePicker:(id)sender
{
    [self.view endEditing:YES];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callStates) withObject:nil afterDelay:1.0];
   // textFieldTouched = 1;
}
- (IBAction)backButton:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showCountryPicker:(id)sender
{
    [self.view endEditing:YES];
     [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callCountries) withObject:nil afterDelay:1.0];
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    [self performSelector:@selector(callCounties) withObject:nil afterDelay:1.0];
   // [self callCountries];
    
   
}

- (IBAction)hidePicker:(id)sender
{
     [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
//     [self.countryBtn setTitle:[[self.countryArray objectAtIndex:0] valueForKey:@"short_name"] forState:UIControlStateNormal];
//    countryTxtField.text = [[self.countryArray objectAtIndex:0] objectForKey:@"short_name"];
//     if (textFieldTouched == 2) {
//         countryTxtField.text=@"United Kingdom";
//        [zipCodeTxtField becomeFirstResponder];
//    }
//    else
//        [phoneNoPrefixTxtField becomeFirstResponder];
    
    if(isSelected==NO)
    {
        
        if([countryArray count]>0)
        {
            self.stringCountry_id = [[countryArray objectAtIndex:0]valueForKey:@"id"];
            countryTxtField.text = [[self.countryArray objectAtIndex:0] objectForKey:@"short_name"];
        }
        
    }

    
    
   [zipCodeTxtField becomeFirstResponder];
     
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    [self setPickerContainer:nil];
    [self setTxtPayPalAccountId:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [firstNameTxtField release];
    [lastNameTxtField release];
    [userNameTxtField release];
    [passwordTxtField release];
    [confirmpasswordTxtField release];
    [addressTxtField release];
    [cityTxtPassword release];
    [stateTxtField release];
    [zipCodeTxtField release];
    [emailAddressTxtField release];
    [confirmEmailTxtField release];
    [countryTxtField release];
    [phoneNoPrefixTxtField release];
    [phoneNoTxtField release];
    [signUpBtn release];
    [checkBoxBtn release];
    [_txtPayPalAccountId release];
    [super dealloc];
}
@end
