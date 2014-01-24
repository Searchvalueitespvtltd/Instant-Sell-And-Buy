//
//  AppDelegate.m
//  ISB
//
//  Created by AppRoutes on 25/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"

#import "HomeViewController.h"
#import "Defines.h"
#import "CXMPPController.h"
#import "PayPal.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


@implementation AppDelegate
@synthesize navigationController,tabBarController,tabbarView;
@synthesize locationManager;
@synthesize userCurrentLocation;
@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;
@synthesize dictEditItemDetail;
@synthesize isEdit;

@synthesize strchatBadgeValue;

#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif
- (void)dealloc
{
    [_window release];
    [_loginviewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//    strchatBadgeValue = nil;
    [[[[[self tabBarController]tabBar]items]objectAtIndex:0]setBadgeValue:strchatBadgeValue];
        
        [PayPal initializeWithAppID:@"APP-6BT56084883032942" forEnvironment:ENV_LIVE];
    //    [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone Simulator"])
    {
        
        self.currentDeviceToken=@"3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0";
        [[NSUserDefaults standardUserDefaults] setValue:@"3304645e047e061df52d0635ac8171941826e6dc467aff1d5e12d4c8d4da6be0" forKey:kDevicetoken];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//        NSLog(@"registerForRemoteNotificationTypes");
    }

    LoginViewController *LoginScreenView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        LoginScreenView =[[LoginViewController alloc]initWithNibName:@"LoginViewController_iPhone5" bundle:nil];

    }
    else
    {
        LoginScreenView =[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];

    }
    [CXMPPController sharedXMPPController];
    self.navigationController=[[UINavigationController alloc] initWithRootViewController:LoginScreenView];
    self.navigationController.navigationBarHidden=YES;
    
    self.window.rootViewController = self.navigationController;

    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    if (LoginScreenView)
    {
        [LoginScreenView release];
    }
    
//    [LoginViewController release];
    
    
    /////////////// 
//    objTabBar=[[tabbarViewController alloc]initWithNibName:@"tabbarViewController" bundle:nil];
//    if (objTabBar.view)
//    {
//        [self.window addSubview:[objTabBar.tabBarController view]];
//    }
    //////////////
    
    return YES;
}

#pragma mark Application_deligate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *deviceTokenStr = [[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""] stringByReplacingOccurrencesOfString: @">" withString: @""] stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    [[NSUserDefaults standardUserDefaults] setValue:deviceTokenStr forKey:kDevicetoken];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSLog(@"Registered");

//    NSLog(@"Device Token: %@ ", deviceTokenStr);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    //    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
        NSLog(@"Fail");
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    ///For testing Purpose///
    
//    UIAlertView* notificationAlert = [[UIAlertView alloc]initWithTitle:nil message:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Accept",@"Reject", @"Block", nil];
//    [notificationAlert show];
//    [notificationAlert release];
//    
    ////////////////////////
    
    
    
   [Utils showAlertView:kAlertTitle message:[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    
    //[[objTabBar.tabBar.tabBar.items objectAtIndex:4]setBadgeValue:@"4"];
    
    
    
    //    NSLog(@"%@ : %@", NSStringFromSelector(_cmd),userInfo);
    /*
     if ([userInfo isKindOfClass:[NSDictionary class]])
     {
     if ([[userInfo objectForKey:@"screen_type"] isEqualToString:@"order_paid"])
     [self performSelector:@selector(addNativeEventWithOrderId:) withObject:[userInfo objectForKey:@"orderId"] afterDelay:10];
     else {
     if ([[userInfo objectForKey:@"screen_type"] isEqualToString:@"salon_bookings"])
     {
     BOOL isLoginSalon = ([[[NSUserDefaults standardUserDefaults] stringForKey:kSalonLoginCurrentSession] length] > 0);
     if (isLoginSalon)
     {
     //                    [self loadSalonUI];
     [[SpaDataSource shared] showSpaAlertWithMessage:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]];
     }
     } else if ([[userInfo objectForKey:@"screen_type"] isEqualToString:@"bookings_rebook"])
     {
     BOOL isLoginCustomer = ([[[NSUserDefaults standardUserDefaults] stringForKey:kUserToken] length] > 0 && [[[NSUserDefaults standardUserDefaults] stringForKey:kUserLogin] length] > 0 && [[[NSUserDefaults standardUserDefaults] stringForKey:kUserPsw] length] > 0);
     if (isLoginCustomer)
     {
     //                     [self loadCustomerWithActiveTab:2];
     [[SpaDataSource shared] showSpaAlertWithMessage:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]];
     }
     } else if ([[userInfo objectForKey:@"screen_type"] isEqualToString:@"avatar"])
     {
     BOOL isLoginCustomer = ([[[NSUserDefaults standardUserDefaults] stringForKey:kUserToken] length] > 0 && [[[NSUserDefaults standardUserDefaults] stringForKey:kUserLogin] length] > 0 && [[[NSUserDefaults standardUserDefaults] stringForKey:kUserPsw] length] > 0);
     if (isLoginCustomer)
     {
     //                    [self loadCustomerWithActiveTab:0];
     [[SpaDataSource shared] showSpaAlertWithMessage:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]];
     }
     } else [[SpaDataSource shared] showSpaAlertWithMessage:[[userInfo objectForKey:@"aps"]objectForKey:@"alert"]];
     }
     }
     */
}

- (void)showHomeScreen
{
    [[self.tabbarView.tabBarController view] removeFromSuperview];
    
    LoginViewController *loginView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController_iPhone5" bundle:nil];
    }
    else
    {
        loginView = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    }
    
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:loginView];
    self.navigationController.navigationBarHidden=YES;

    self.window.rootViewController=self.navigationController;
    
    if (loginView)
    {
        [loginView release];
    }
}

- (void)removeHomeScreen:(NSString *)index
{
    [self.navigationController.view removeFromSuperview];
    self.navigationController = nil;
    // ReleaseObject(self.tabBarController);
    
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.tabbarView = [[tabbarViewController alloc] initWithNibName:@"tabbarViewController_iPhone5" bundle:nil];
    }
    else
    {
        self.tabbarView = [[tabbarViewController alloc] initWithNibName:@"tabbarViewController" bundle:nil];
    }
//    self.tabbarView = [[tabbarViewController alloc] initWithNibName:@"tabbarViewController" bundle:nil];
    self.tabbarView.index = index;
    if (self.tabbarView.view)
    {
      [self.window addSubview:[self.tabbarView.tabBarController view]];
    }
}

#pragma mark - Get current location of user

-(void)startUpdateLocation
{
    [locationManager startUpdatingLocation];
}

-(void)initLocationManager
{
    if (locationManager) {
        [locationManager release];
        locationManager=nil;
    }
    
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
	locationManager.distanceFilter = 100.0f;
	if(![CLLocationManager locationServicesEnabled])
	{
		[Utils showAlertView:@"Location Services Disabled" message:@"ISB requires your location." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	}
	[locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if(self.userCurrentLocation == nil)
        self.userCurrentLocation = newLocation;
    
    CLLocation* aloc = self.userCurrentLocation ;
    [StoredData sharedData].latitude= [NSString stringWithFormat:@"%f",aloc.coordinate.latitude];
    [StoredData sharedData].longitude = [NSString stringWithFormat:@"%f",aloc.coordinate.longitude];
//    NSLog(@"%@,%@",[[StoredData sharedData]latitude],[[StoredData sharedData]longitude]);
    [locationManager stopUpdatingLocation];
    CLLocationCoordinate2D location;
    location.latitude=  [[StoredData sharedData].latitude floatValue];
    location.longitude= [[StoredData sharedData].longitude floatValue];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	NSString* errorType = (error.code == kCLErrorDenied) ? @"Access Denied" : @"Unknown Error";
    if (errorType)
        [errorType release];
    [self initLocationManager];
    //[locationManager startUpdatingLocation];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    
#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif
    
	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{
			
			DDLogVerbose(@"KeepAliveHandler");
			
			// Do other keep alive stuff here.
		}];
	}

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self initLocationManager];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (managedObjectContext != nil)
    {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    
    if (persistentStoreCoordinator != nil)
    {
        return persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ISB.sqlite"];
    NSLog(@"database:%@",storeURL);
    
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return persistentStoreCoordinator;
}
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
