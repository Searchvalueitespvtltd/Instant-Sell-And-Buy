//
//  EditViewController.m
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "EditViewController.h"
#import "Utils.h"
#import "NetworkService.h"
#import "Defines.h"
#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSData+Base64.h"
#import "JSON.h"
#import "ChangePasswordViewController.h"
#import "Users.h"
@interface EditViewController ()

@end

@implementation EditViewController
@synthesize countryArray,stateArray,picker,imgBackCamera,imgCamera,imgUserDefaultImage,Country_id;

@synthesize scrollView,firstNameTxtField,lastNameTxtField,userNameLbl,addressTxtField,cityTxtPassword,countryTxtField,zipCodeTxtField,phoneNoPrefixTxtField,phoneNoTxtField,emailAddressTxtField,signUpBtn,stateTxtField,toolBar,stateBtn,countryBtn,pickerContainer,pickerView,created_Date,year,stringCountry_id,txtPayPalaccountId;

//int textFieldTouche = 0;

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
     context=[App managedObjectContext];
    userData=[[NSMutableArray alloc]init];
    [self fetchData:@"Users"];
    
    Users *ev=(Users*)[userData objectAtIndex:0];
    self.firstNameTxtField.text=ev.fname;
    self.lastNameTxtField.text=ev.lname;
    self.zipCodeTxtField.text=ev.zipcode;
    self.stateTxtField.text=ev.state;
    self.emailAddressTxtField.text=ev.email;
    self.countryTxtField.text=ev.country;
    self.cityTxtPassword.text=ev.city;
    self.phoneNoTxtField.text=ev.phoneno;
    self.phoneNoPrefixTxtField.text=ev.isdcode;
    self.imgCamera.image = [UIImage imageWithData:ev.image];
    self.userNameLbl.text=ev.username;
    self.addressTxtField.text=ev.address;
    self.year=ev.created_dt;
    self.Country_id=ev.country_id;
    self.txtPayPalaccountId.text=ev.paypal_account;
}


//- (void)addUsers:(NSDictionary *)dictionary
//{
//    
//    
//    Users *user = [self userWithID:[dictionary objectForKey:SID]];
//    NSManagedObjectContext *context=App.managedObjectContext;
//    
//    if  (user == nil) {
//        user = [NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
//    }
//    else
//    {
////        if(loggedin==NO)
////        {
////            if(![[Database database]compareDate:[dictionary objectForKey:SPORTLASTUPDATE] withLocalDate:[[NSUserDefaults standardUserDefaults]valueForKey:SPORTSLASTUPDATE]])
////            {
////                return;
////            }
////        }
//    }
////    
////    Users  *event = (Users *)[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
//    [user setEmail:emailAddressTxtField.text];
//    [user setFname:firstNameTxtField.text];
//    [user setLname:lastNameTxtField.text];
//    [user setId:[NSNumber numberWithInt:1]];
//    [user setZipcode:zipCodeTxtField.text];
//    [user setUsername:[[NSString stringWithFormat:@"%@ ",firstNameTxtField.text] stringByAppendingString:lastNameTxtField.text]];
//    [user setAddress:addressTxtField.text];
//    [user setCity:cityTxtPassword.text];
//    [user setCountry:countryTxtField.text];
//    [user setIsdcode:phoneNoPrefixTxtField.text];
//    [user setPhoneno:phoneNoTxtField.text];
//    NSError *error;
//    if (![context save:&error])
//    {
//        //NSLog(@"ERROR--%@",error);
//        abort();
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    
//    if (![imgCamera.image isEqual:[NSNull null]]) {
//        self.imgUserDefaultImage.hidden = YES;
//    }
    [ItemDetails sharedInstance].isSelected =0;
   
    

    imgCamera.layer.cornerRadius = 2.5;
    imgCamera.layer.masksToBounds = YES;
    picker = [[UIImagePickerController alloc]init];
    picker.allowsEditing = NO;
    picker.delegate=self;
    [scrollView setScrollEnabled:YES];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    // self.countryArray=[[NSMutableArray alloc]initWithObjects:@"United Kingdom",nil];
    
    if (!self.imgCamera.image)
    {
        self.imgUserDefaultImage.image=[UIImage imageNamed:@"userIcon.png"];
    }
    else
    {
        self.imgUserDefaultImage.hidden = YES;
    }
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.scrollView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 44, 320, self.view.frame.size.height-44);
    }
    
    scrollView.contentSize = CGSizeMake(0, 670);

}

//- (Users *)UsersWithID:(NSString *)string
//{
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSManagedObjectContext *context=App.managedObjectContext;
//    
//    //         Edit the entity name as appropriate.
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
//    
//    [fetchRequest setEntity:entity];
//    
//    // Set the batch size to a suitable number.
//    [fetchRequest setFetchBatchSize:20];
//    
//    //    // Set example predicate and sort orderings...
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id LIKE[c] %@",string];
//    [fetchRequest setPredicate:predicate];
//    predicate=nil;
//    NSError *error = nil;
//    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
//    context=nil;
//    if ([array count] != 0) {
//        return [array objectAtIndex:0];
//    }
//    return nil;
//}


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
//    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;    //
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                                    cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"", @"", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
   // [actionSheet showInView:self.view];
    
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"btnTakePicture.png"] forState:UIControlStateNormal];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"btnChooseLibrary.png"] forState:UIControlStateNormal];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"btnTakePicture.png"] forState:UIControlStateHighlighted];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"btnChooseLibrary.png"] forState:UIControlStateHighlighted];
    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateHighlighted];
    [actionSheet showInView:self.tabBarController.tabBar];
}

#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [self.picker dismissViewControllerAnimated:YES completion:nil];
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
            break;

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
//    switch(textFieldTouche)
//    {
//        case 1:
//            stateTxtField.text = [[self.stateArray objectAtIndex:row] objectForKey:@"name"];
//            state_id = [[[self.stateArray objectAtIndex:row] objectForKey:@"id"]intValue];
//            break;
//        case 2:
//            countryTxtField.text = [self.countryArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
//            country_id = 235;
//            //            country_id = [[[self.countryArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"id"]intValue];
//            break;
//    }
//    switch(textFieldTouche)
//    {
//        case 1:
//            //    [btnPostageType setTitle:[NSString stringWithString:[[arrPostageType objectAtIndex:row]valueForKey:@"name"]] forState:UIControlStateNormal];
//            
//            
//            stateTxtField.text = [[self.stateArray objectAtIndex:row] valueForKey:@"name"];
//            
//            
//            
//            //            = [[self.stateArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"name"];
//            
//            state_id = [[[self.stateArray objectAtIndex:row] objectForKey:@"id"]intValue];
//            break;
//        case 2:
//            
////            [self.countryBtn setTitle:[self.countryArray objectAtIndex:row] forState:UIControlStateNormal];
//            
//                     countryTxtField.text = [self.countryArray objectAtIndex:row];
//            country_id = 235;
//            //            country_id = [[[self.countryArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"id"]intValue];
//            break;
  //  }
    
      isSelected = YES;
    countryTxtField.text = [[self.countryArray objectAtIndex:row] objectForKey:@"short_name"];
    stringCountry_id = [[self.countryArray objectAtIndex:row] objectForKey:@"id"];
   Country_id = [[self.countryArray objectAtIndex:row] objectForKey:@"id"];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
//    switch(textFieldTouche)
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
    
    [self.picker dismissViewControllerAnimated:YES completion:NULL];
    
}
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
//    switch(textFieldTouche)
//    {
//        case 1:
//            return [[self.stateArray objectAtIndex:row] objectForKey:@"name"];
//            break;
//        case 2:
//            return [self.countryArray objectAtIndex:row];
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
            [addressTxtField becomeFirstResponder];
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
//            [self showStatePicker:@"101"];
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
            [txtPayPalaccountId becomeFirstResponder];
            break;
        case 113:
            if (![self.emailAddressTxtField text].length>0)
            {
                [Utils showAlertView:kAlertTitle message:@"Email address can't be left blank." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return NO;
            }
             [txtPayPalaccountId resignFirstResponder];
            [emailAddressTxtField resignFirstResponder];
            
            break;
        case 114:
            [txtPayPalaccountId resignFirstResponder];
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                [self.scrollView setContentOffset:CGPointMake(0, 180) animated:YES];
            }
            else
            {
                [self.scrollView setContentOffset:CGPointMake(0, 280) animated:YES];
            }
            break;

               default:
//             [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
            break;
            
    }
    return YES;
    
}
- (IBAction)changePasswordClick:(id)sender {
    ChangePasswordViewController *changePasswordViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        changePasswordViewController=[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController_iPhone5" bundle:nil];
        
    }
    else{
        changePasswordViewController=[[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil]; }
    
    [self.navigationController pushViewController:changePasswordViewController animated:YES ];
    [changePasswordViewController release];

    
}


- (IBAction)saveClick:(id)sender
{
    [emailAddressTxtField resignFirstResponder];
    
    self.emailAddressTxtField.text = [self.emailAddressTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if(([self.firstNameTxtField text].length>0)&&([self.lastNameTxtField text].length>0)&&([self.emailAddressTxtField text].length>0)&&([self.addressTxtField text].length>0)&&([self.cityTxtPassword text].length>0)&&([self.countryTxtField text].length>0)&&([self.stateTxtField text].length>0)&&([self.zipCodeTxtField text].length>0)&&([self.phoneNoPrefixTxtField text].length>0)&&([self.phoneNoTxtField text].length>0))
    {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self performSelector:@selector(callWebService) withObject:nil afterDelay:1.0];
    }
    else{
        [Utils showAlertView:kAlertTitle message:@"Fields can't be left blank." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    /////////////////////////
}

-(void)callCounties
{
    
    
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
//  [pickerView reloadAllComponents];
    
    [Utils startActivityIndicatorInView:self.view withMessage:nil];

    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"countries/get"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    
}
-(void)callStates
{
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"states/get?country_id=235"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
//    [self.scrollView setContentOffset:CGPointMake(0, stateTxtField.frame.origin.y-30) animated:YES];
    //            [UIView beginAnimations:nil context:NULL];
    //            [UIView setAnimationDuration:0.3];
    //            if([[UIScreen mainScreen] bounds].size.height>480)
    //            {
    //                pickerContainer.frame = CGRectMake(0, 290, 320, 261);
    //
    //            }
    //            else{
    //                pickerContainer.frame = CGRectMake(0, 200, 320, 261);
    //            }
    //
    //            [UIView commitAnimations];
       //         [pickerView reloadAllComponents];
}

-(void)callUserDetailService
{
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"/users/get?username=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];

}

#pragma mark - Fetch Data From Core Data
-(void)fetchData:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
//    NSPredicate *pred =
//    [NSPredicate predicateWithFormat:@"(username LIKE[c] %@)",
//     [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
//    [request setPredicate:pred];
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(username LIKE [c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    [request setPredicate:pred];

    
    // Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
	if (!mutableFetchResults)
	{
		//NSLog(@"Cant Fetch");
	}
    if([tableName isEqualToString:@"Users"])
    {
        for(Users *ev in mutableFetchResults)
        {
            userData = mutableFetchResults;
        }
    }
    
}

#pragma mark - Save Data From Core Data
-(void)saveToDatabase
{
    Users  *event = (Users *)[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
    [event setDisplay_name:[[NSString stringWithFormat:@"%@ ",firstNameTxtField.text] stringByAppendingString:lastNameTxtField.text]];
    [event setEmail:emailAddressTxtField.text];
    [event setFname:firstNameTxtField.text];
    [event setLname:lastNameTxtField.text];
    [event setId:[NSNumber numberWithInt:1]];
    [event setZipcode:zipCodeTxtField.text];
    [event setUsername:userNameLbl.text];
    [event setAddress:addressTxtField.text];
    [event setCity:cityTxtPassword.text];
    [event setCountry:countryTxtField.text];
    [event setIsdcode:phoneNoPrefixTxtField.text];
    [event setPhoneno:phoneNoTxtField.text];
    [event setState:stateTxtField.text];
    [event setUserid:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [event setCreated_dt:year];
    [event setCountry_id:Country_id];
    if (imgCamera.image) {
//        NSData *imageData=
        [event setImage:UIImagePNGRepresentation(imgCamera.image)];
    }
    NSError *error;
    if (![context save:&error])
    {
        //NSLog(@"ERROR--%@",error);
        abort();
    }
    
}

#pragma mark - Delete Data In Core Data
-(void)delete{
    //EMPTY GROUP TABLE
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [fetchRequest setEntity:entity];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error=nil;
    for (Users *objectToDelete in myObjectsToDelete) {
        [context deleteObject:objectToDelete];
        
        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    userData=[myObjectsToDelete mutableCopy];
}


-(void)callWebService
{
    
//    NSString *imgString = [UIImagePNGRepresentation(self.imgCamera.image) base64Encoding];
//    NSString *string=[@"img=" stringByAppendingString:imgString];
//    NSData *postData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //    users/save?email=%@&pwd=Welcome@123&fname=ojal&lname=suthar&zip=122&device_token=213ab3c33c4c4d55e5f5f&username=oja3l15&home_addr=343,trgvrtyvrt%20street&city=udaipur&state_id=4&country_id=1&isd_code=23&primary_phone=98898998999
    NSString *urlString = [NSString stringWithFormat:@"users/edit?username=%@&fname=%@&lname=%@&zip=%@&device_token=%@&home_addr=%@&city=%@&state_name=%@&country_id=%@&primary_phone=%@&isd_code=%@&email=%@&paypal_account=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"],firstNameTxtField.text,lastNameTxtField.text,zipCodeTxtField.text,[[NSUserDefaults standardUserDefaults]valueForKey:kDevicetoken],addressTxtField.text,cityTxtPassword.text,stateTxtField.text,Country_id,phoneNoTxtField.text,phoneNoPrefixTxtField.text,emailAddressTxtField.text,self.txtPayPalaccountId.text];
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
//    NSLog(@"result: %@",result);
  
    if([[result objectAtIndex:0]isEqualToString:@"success"])
    {
        [Utils showAlertView:nil message:@"We have updated your details !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [self delete];
       [self saveToDatabase];
    }
    else
    {
        [Utils showAlertView:nil message:@"Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
    
    // NSLog(@"Response is = %@",inResponseDic);
    
    if ([inReqIdentifier rangeOfString:@"users/get?username"].length>0)
    {//////////////////////////////////
        //////////////////////////////////
       // [self callCounties];//////////////////////////////////
        ////////////////////////////////////////////////////////////////////
        //////////////////////////////////
        if([inResponseDic isKindOfClass:[NSArray class]])
        {
            cityTxtPassword.text = [[inResponseDic objectAtIndex:0]valueForKey:@"city"];
            emailAddressTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"email"];
            firstNameTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"fname"];
            
            lastNameTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"lname"];
            
            zipCodeTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"zipcode"];
            
            userNameLbl.text= [[inResponseDic objectAtIndex:0]valueForKey:@"username"];
            
            addressTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"home_addr"];
            
            stringCountry_id= [[inResponseDic objectAtIndex:0]valueForKey:@"id"];
            NSString *imagepath = [[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"];
            NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
            if (![imageData isEqual:[NSNull null]]) {
                imgCamera.image = [UIImage imageWithData:imageData];
            }
            
            created_Date = [[inResponseDic objectAtIndex:0]valueForKey:@"created_dt"];
            NSArray *stringWithoutChar = [created_Date componentsSeparatedByString:@" "];
            created_Date = [stringWithoutChar objectAtIndex:0];
            stringWithoutChar = [created_Date componentsSeparatedByString:@"-"];
            self.year = [stringWithoutChar objectAtIndex:0];
            
          countryTxtField.text=[[inResponseDic objectAtIndex:0]valueForKey:@"country_name"];
            stateTxtField.text = [[inResponseDic objectAtIndex:0]valueForKey:@"state_name"];
            phoneNoPrefixTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"isd_code"];
            
            phoneNoTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"primary_phone"];
            
        }
  //      NSLog(@"Response is = %@",inResponseDic);
    }
    else if([inReqIdentifier rangeOfString:@"countries/get"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
//            for (int i=0; i<[inResponseDic count]; i++)
//            {
//                
//                if ([[[inResponseDic objectAtIndex:i]valueForKey:@"id"]intValue]==[Country_id intValue])
//                {
//                    countryTxtField.text = [[self.countryArray objectAtIndex:i]valueForKey:@"short_name"];
//                    break;
//                }
//                
//            }
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
            //            stateTxtField.text= [[inResponseDic objectAtIndex:0]valueForKey:@"name"];
            //
        }
//        [self delete];
//         [self saveToDatabase];
    }
    else
    {
//        [self.countryArray removeAllObjects];
//        //        self.countryArray = inResponseDic;
//        [self.countryArray addObject:@"United Kingdom"];
//        NSLog(@"Response is = %@",self.countryArray);
    }
//    if ([userData count]!=0) {
//        [self delete];
//    }
   
    [Utils stopActivityIndicatorInView:self.view];
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"*** requestErrorHandler *** and Error : %@",[inError debugDescription]);
    
}

- (IBAction)uploadPictureClick:(id)sender {
    [self  displayActionSheet];
}
- (IBAction)stopEditing:(id)sender {
    if ([cityTxtPassword isFirstResponder] ||[stateTxtField isFirstResponder] ||[emailAddressTxtField isFirstResponder] || [zipCodeTxtField isFirstResponder]|| [phoneNoPrefixTxtField isFirstResponder]||[phoneNoTxtField isFirstResponder]||[txtPayPalaccountId isFirstResponder]) {
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            [self.scrollView setContentOffset:CGPointMake(0, 180) animated:YES];
        }
        else
        {
            [self.scrollView setContentOffset:CGPointMake(0, 280) animated:YES];
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
//    textFieldTouche = 1;
    [pickerView reloadAllComponents];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    [self performSelector:@selector(callStates) withObject:nil afterDelay:1.0];
//    textFieldTouche = 1;
    [self.scrollView setContentOffset:CGPointMake(0, stateTxtField.frame.origin.y-30) animated:YES];
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
 
}

- (IBAction)showCountryPicker:(id)sender
{
    [self.view endEditing:YES];
   // textFieldTouche = 2;
//    if (self.countryArray==nil)
//    {
//        [self performSelector:@selector(callCounties) withObject:nil afterDelay:1.0];
//    }
    
        [self performSelector:@selector(callCounties) withObject:nil afterDelay:1.0];
    //[self callCounties];
    
    
}

- (IBAction)hidePicker:(id)sender
{
//    [self.view endEditing:YES];
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
//    [UIView commitAnimations];
//    if (textFieldTouche == 2) {
//        countryTxtField.text=@"United Kingdom";
//        [zipCodeTxtField becomeFirstResponder];
//    }
//    else
//        [phoneNoPrefixTxtField becomeFirstResponder];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
    if(isSelected==NO)
    {
  
    if([countryArray count]>0)
    {
       // self.stringCountry_id = [[countryArray objectAtIndex:0]valueForKey:@"id"];
        Country_id =[[self.countryArray objectAtIndex:0] objectForKey:@"id"];
        countryTxtField.text = [[self.countryArray objectAtIndex:0] objectForKey:@"short_name"];
    }

    }
    
    
    //     [self.countryBtn setTitle:[[self.countryArray objectAtIndex:0] valueForKey:@"short_name"] forState:UIControlStateNormal];
  //  countryTxtField.text = [[self.countryArray objectAtIndex:0] objectForKey:@"short_name"];
    //     if (textFieldTouched == 2) {
    //         countryTxtField.text=@"United Kingdom";
    //        [zipCodeTxtField becomeFirstResponder];
    //    }
    //    else
    //        [phoneNoPrefixTxtField becomeFirstResponder];
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
    [self setTxtPayPalaccountId:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [firstNameTxtField release];
    [lastNameTxtField release];
    [userNameLbl release];
    [addressTxtField release];
    [cityTxtPassword release];
    [stateTxtField release];
    [zipCodeTxtField release];
    [emailAddressTxtField release];
    [countryTxtField release];
    [phoneNoPrefixTxtField release];
    [phoneNoTxtField release];
    [signUpBtn release];
    [txtPayPalaccountId release];
    [super dealloc];
}
@end
