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
        NSLog(@"working");
        [self delete];
        
            }
}
//#pragma mark - Delete Data In Core Data
-(void)delete{
    //EMPTY GROUP TABLE
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentSearch" inManagedObjectContext:context];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [fetchRequest setEntity:entity];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error=nil;
    for (RecentSearch *objectToDelete in myObjectsToDelete) {
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

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSignOutClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
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
@end
