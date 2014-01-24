//
//  SignOutViewController.m
//  ISB
//
//  Created by chetan shishodia on 11/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SettingViewController.h"
#import "LoginViewController.h"
#import "ProfileViewController.h"
#import "RecentSearch.h"
#import "SearchViewController.h"
#import "LastViewItems.h"
#import "CXMPPController.h"
#import "AddPayPalViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize lblProfileName,switchKeepMeLogged,switchRecentItem;
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
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [ItemDetails sharedInstance].isSelected =0;

    context=[App managedObjectContext];
    lblProfileName.text =[[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:@"isKeepMeLoginEnabled"]) {
        [switchKeepMeLogged setOn:NO];
    }else{
        [switchKeepMeLogged setOn:YES];

    }
}


- (IBAction)btnProfileClick:(id)sender {
    ProfileViewController *profileViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iPhone5" bundle:nil];
        
    }
    else{
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil]; }
    
    [self.navigationController pushViewController:profileViewController animated:YES ];
    [profileViewController release];
}

- (IBAction)btnKeepMeLoggedClick:(id)sender {
  
//    [[NSUserDefaults standardUserDefaults]setValue:[inResponseDic objectForKey:@"id"] forKey:@"USERID"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)btnRecentClick:(id)sender {
    
    
}

- (IBAction)btnClearRecentActivityClick:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISB" message:@"Tap Continue to clear Recent Searches" delegate:self
                                         cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [alert show];
    [alert release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // SearchViewController *search = [[SearchViewController alloc]init];
    if (buttonIndex == 1) {
//        NSLog(@"working");
        [self deleteLastViewdItems];
        [self deleteRecentSearch];
            }
}
//#pragma mark - Delete Data In Core Data
-(void)deleteRecentSearch{
    //EMPTY GROUP TABLE
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentSearch" inManagedObjectContext:context];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [fetchRequest setEntity:entity];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error=nil;
    for (RecentSearch *objectToDelete in myObjectsToDelete)
    {
        [context deleteObject:objectToDelete];
        
        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISB" message:@"All recent activity cleared" delegate:self
                                         cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];
//    SearchViewController *search = [[SearchViewController alloc]init];
//    search.arrSearchItem=nil;
//    [self.navigationController pushViewController:search animated:YES];
    // arrSearchItem=[[NSMutableArray alloc]init];
    
}

-(void)deleteLastViewdItems{
    //EMPTY GROUP TABLE
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LastViewItems" inManagedObjectContext:context];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [fetchRequest setEntity:entity];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error=nil;
    for (LastViewItems *objectToDelete in myObjectsToDelete) {
        [context deleteObject:objectToDelete];
        
        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    // arrSearchItem=nil;
    // arrSearchItem=[[NSMutableArray alloc]init];
    
}

#pragma  - mark Button Methods

- (IBAction)addPayPalClick:(id)sender {
    AddPayPalViewController *paypal=[[AddPayPalViewController alloc]initWithNibName:@"AddPayPalViewController" bundle:nil];
    [self.navigationController pushViewController:paypal animated:YES];
    
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSignOutClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isKeepMeLoginEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [gCXMPPController disconnect];
    
    AppDelegate *delegate = APP_DELEGATE;
    [delegate showHomeScreen];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [lblProfileName release];
//    [_switch release];
    [switchRecentItem release];
    [super dealloc];
}
- (IBAction)keepmeLogIn:(id)sender {
    
    if ([sender isOn]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isKeepMeLoginEnabled"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isKeepMeLoginEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)notifyMe:(id)sender
{
    if ([sender isOn])
    {
        strIsNotifyme = @"1";
        [self callWebService:strIsNotifyme];
    }
    else
    {
        strIsNotifyme = @"0";
        [self callWebService:strIsNotifyme];
    }
}

#pragma  - mark Call Webservice

-(void)callWebService:(NSString *)strIsNotify
{
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    NetworkService *objService = [[NetworkService alloc]init];
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"userSearches/modify?user_id=%@&is_notify=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],strIsNotify] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
//http://chat.eitcl.co.uk/devchat/index.php/userSearches/modify?user_id=1&is_notify=1
    
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            [Utils showAlertView:kAlertTitle message:@"Modified successfully." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];   
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
}



@end
