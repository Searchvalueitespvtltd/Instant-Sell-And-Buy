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
#import "Utils.h"
#import "HomeViewController.h"
#import "Defines.h"
#import "CXMPPController.h"
#import "Users.h"

#import "ItemDetailsViewController.h" // for test ..

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize forgotPasswordLbl,forgotPasswordBtn,signInBtn,userNameTxtField,passwordTxtField,loginviewController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isKeepMeLoginEnabled"]) {
        AppDelegate *delegate = APP_DELEGATE;
        [delegate removeHomeScreen:@"0"];
        return;
    }
    
        context=[App managedObjectContext];
    
//    userNameTxtField.text =@"shiv" ;
//  passwordTxtField.text = @"qwerty" ;
    
    self.navigationController.navigationBarHidden=YES;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appHasGoneInBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    

	NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"Forgot password?"];
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    forgotPasswordLbl.attributedText = [attributeString copy];
    
   }


-(void)viewWillAppear:(BOOL)animated
{
//    [self willKeyBoardHide];
    [ItemDetails sharedInstance].isSelected =0;

    [userNameTxtField resignFirstResponder];
    [passwordTxtField resignFirstResponder];
    [super viewWillAppear:animated];
}

-(void)appHasGoneInBackground
{
    [userNameTxtField resignFirstResponder];
    [passwordTxtField resignFirstResponder];
}

- (IBAction)signInClick:(id)sender
{
//    ItemDetailsViewController * sell = [[ItemDetailsViewController alloc]init];
//    [self.navigationController pushViewController:sell animated:YES];
   
//    /*
    [self.passwordTxtField resignFirstResponder];
    [self.userNameTxtField resignFirstResponder];
    
    self.userNameTxtField.text = [self.userNameTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.passwordTxtField.text = [self.passwordTxtField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[NSUserDefaults standardUserDefaults] setValue:userNameTxtField.text forKey:@"email"];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    self.userNameTxtField.text = [userNameTxtField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
   
   if([self.userNameTxtField.text length]==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter username." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
  else if ([self.passwordTxtField text].length<5)
        {[Utils showAlertView:kAlertTitle message:@"Password length must be of minimum 6 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        signInBtn.enabled = NO;
        }
else
    {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self performSelector:@selector(callWebService) withObject:nil afterDelay:1.0];
    }
//    */
}
-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/auth?username=%@&pwd=%@",userNameTxtField.text,passwordTxtField.text]  dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];

}
- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        if([key isEqualToString:kXMPPmyJID1])
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@@%@",field.text,STRChatServerURL] forKey:key];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults]setObject:field.text forKey:key];
        }
        
//        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:key]);
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];

    if([[inResponseDic valueForKey:@"id"]isEqualToString:@"0"])
    {
//       [Utils showAlertView:kAlertTitle message:@"Wrong email or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Utils showAlertView:kAlertTitle message:[inResponseDic valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    else{
        [self setField:self.passwordTxtField forKey:kXMPPmyPassword1];
        [self setField:self.userNameTxtField forKey:kXMPPmyJID1];
        if([gCXMPPController connect])
        {
            NSLog(@"connected");
        }
        else
        {
            NSLog(@"not connected");
        }
        [[NSUserDefaults standardUserDefaults]setValue:[inResponseDic objectForKey:@"id"] forKey:@"USERID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
//        [[NSUserDefaults standardUserDefaults]setValue:[inResponseDic objectForKey:@"username"] forKey:@"USER_NAME"];
        [[NSUserDefaults standardUserDefaults]setValue:[inResponseDic objectForKey:@"display_name"] forKey:@"USER_NAME"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        dicProfileData = [NSDictionary dictionaryWithDictionary:inResponseDic];
        
        
        if (![[inResponseDic valueForKey:@"paypal_account"]isEqual:[NSNull null]])
        {
            [[NSUserDefaults standardUserDefaults] setValue:[inResponseDic valueForKey:@"paypal_account"] forKey:@"paypal_account"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
        [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:@"paypal_account"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        [self saveToDatabase];
        
        HomeViewController *homeViewController;
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone5" bundle:nil];
            
        }
        else
        {
            homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
        }
        
//        [self.navigationController pushViewController:homeViewController animated:YES ];
        AppDelegate *delegate = APP_DELEGATE;
        [delegate removeHomeScreen:@"0"];
//        [homeViewController release];
  
    }
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    NSLog(@"requestErrorHandler -----%@",inError);

    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
//    [Utils showAlertView:kAlertTitle message:[inError debugDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //    NSLog(@"*** requestErrorHandler *** and Error : %@",[inError debugDescription]);
    
}

#pragma mark - Save to database

-(void)saveToDatabase
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(username LIKE[c] %@)",[dicProfileData valueForKey:@"username"]];
//     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
//    NSPredicate *pred2 =
//    [NSPredicate predicateWithFormat:@"(profile_pic_path LIKE[c] %@)",[dicProfileData objectForKey:@"profile_pic_path"]];
    
//    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred,pred2, nil];
    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    // Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count]==0)
    {
         Users *user = (Users *)[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
        
        if (![[dicProfileData valueForKey:@"profile_pic_path"] isEqual:@""])
        {
            NSURL *url = [NSURL URLWithString:[kImageURL stringByAppendingString:[dicProfileData valueForKey:@"profile_pic_path"]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image =  [Utils scaleImage:[UIImage imageWithData:data] maxWidth:77 maxHeight:77];
            [user setImage:UIImagePNGRepresentation(image)];
        }
        
        [user setUserid:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
        [user setAddress:[dicProfileData valueForKey:@"home_addr"]];
        [user setCity:[dicProfileData valueForKey:@"city"]];
        [user setCountry:[dicProfileData valueForKey:@"country_name"]];
        [user setCountry_id:[dicProfileData valueForKey:@"country_id"]];
        [user setCreated_dt:[dicProfileData valueForKey:@"created_dt"]];
        [user setDisplay_name:[dicProfileData valueForKey:@"display_name"]];
        [user setEmail:[dicProfileData valueForKey:@"email"]];
        
        [user setFname:[dicProfileData valueForKey:@"fname"]];
        
        //    [user setId:[]]
        //    [user setImage:[]];
        
        [user setIsdcode:[dicProfileData valueForKey:@"isd_code"]];
        [user setLname:[dicProfileData valueForKey:@"lname"]];
        [user setPhoneno:[dicProfileData valueForKey:@"primary_phone"]];
        
        [user setProfile_pic_path:[dicProfileData objectForKey:@"profile_pic_path"]];
        [user setState:[dicProfileData objectForKey:@"state_name"]];
        [user setUsername:[dicProfileData valueForKey:@"username"]];
        
        [user setZipcode:[dicProfileData valueForKey:@"zipcode"]];
        if (![[dicProfileData valueForKey:@"paypal_account"] isEqual:[NSNull null]]) {
            [user setPaypal_account:[dicProfileData valueForKey:@"paypal_account"]];
        }else
            [user setPaypal_account:@""];


        
        NSError *error;
        if (![context save:&error])
        {
            //NSLog(@"ERROR--%@",error);
            abort();
        }
    }else{
        Users* user = [mutableFetchResults objectAtIndex:0];
        if (![[dicProfileData valueForKey:@"profile_pic_path"] isEqual:@""])
        {
            NSURL *url = [NSURL URLWithString:[kImageURL stringByAppendingString:[dicProfileData valueForKey:@"profile_pic_path"]]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *image =  [Utils scaleImage:[UIImage imageWithData:data] maxWidth:77 maxHeight:77];
            [user setImage:UIImagePNGRepresentation(image)];
        }
        
        [user setUserid:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
        [user setAddress:[dicProfileData valueForKey:@"home_addr"]];
        [user setCity:[dicProfileData valueForKey:@"city"]];
        [user setCountry:[dicProfileData valueForKey:@"country_name"]];
        [user setCountry_id:[dicProfileData valueForKey:@"country_id"]];
        [user setCreated_dt:[dicProfileData valueForKey:@"created_dt"]];
        [user setDisplay_name:[dicProfileData valueForKey:@"display_name"]];
        [user setEmail:[dicProfileData valueForKey:@"email"]];
        
        [user setFname:[dicProfileData valueForKey:@"fname"]];
        
        //    [user setId:[]]
        //    [user setImage:[]];
        
        [user setIsdcode:[dicProfileData valueForKey:@"isd_code"]];
        [user setLname:[dicProfileData valueForKey:@"lname"]];
        [user setPhoneno:[dicProfileData valueForKey:@"primary_phone"]];
        
        [user setProfile_pic_path:[dicProfileData objectForKey:@"profile_pic_path"]];
        [user setState:[dicProfileData objectForKey:@"state_name"]];
        [user setUsername:[dicProfileData valueForKey:@"username"]];
        
        [user setZipcode:[dicProfileData valueForKey:@"zipcode"]];
        if (![[dicProfileData valueForKey:@"paypal_account"] isEqual:[NSNull null]]) {
            [user setPaypal_account:[dicProfileData valueForKey:@"paypal_account"]];
        }else
            [user setPaypal_account:@""];
        
        
        if (![context save:&error])
        {
            //NSLog(@"ERROR--%@",error);
            abort();
        }
    }
}




///////////////////////////////////////////////////////////////////////////////////////////

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
//    NSString *specialCharacters = @"!#€%&/()[]=?$§*'";
//    if ([[userNameTxtField.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:specialCharacters]] count] < 5)
//     
//    {
//        [Utils showAlertView:kAlertTitle message:@"Use letters or number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        //        return YES;
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [userNameTxtField resignFirstResponder];
    [passwordTxtField resignFirstResponder];
}

-(void)willKeyBoardShow
{
    CGRect selfFrame = loginviewController.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [loginviewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 108, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
}
-(void)willKeyBoardHide
{
    CGRect selfFrame = loginviewController.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [loginviewController setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 108, selfFrame.size.width, selfFrame.size.height)];
    
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
