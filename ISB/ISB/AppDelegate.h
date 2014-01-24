//
//  AppDelegate.h
//  ISB
//
//  Created by AppRoutes on 25/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tabbarViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreData/CoreData.h>

@class LoginViewController;

@class tabbarViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    tabbarViewController *objTabBar;
    UITabBarController *tabBarController;
        //    NSString *strChatBadgeValue;
}
@property (nonatomic, assign)BOOL isEdit;

@property (nonatomic, retain) NSMutableDictionary *dictEditItemDetail;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation* userCurrentLocation;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign)BOOL isShared;

@property (nonatomic, assign) int chatMessageCount;

@property (nonatomic,retain) NSString *currentDeviceToken;

@property (strong, nonatomic) LoginViewController *loginviewController;

@property (strong, nonatomic) UINavigationController *navigationController;

@property(retain,nonatomic) UITabBarController *tabBarController;

@property(retain,nonatomic) tabbarViewController *tabbarView;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property(retain,nonatomic) NSString *strchatBadgeValue;

- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;

- (void)showHomeScreen;
- (void)removeHomeScreen:(NSString *)index;

@end
