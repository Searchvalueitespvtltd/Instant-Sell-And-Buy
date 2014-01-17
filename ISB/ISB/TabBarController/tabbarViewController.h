//
//  tabbarViewController.h
//  ISB
//
//  Created by chetan shishodia on 29/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tabbarViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITabBarController *tabBarController;
@property (retain, nonatomic) IBOutlet UITabBarItem *HomeTabBarItem;
@property (retain, nonatomic) IBOutlet UITabBarItem *searchTabBarItem;
@property (retain, nonatomic) IBOutlet UITabBarItem *myISBTabBarItem;
@property (retain, nonatomic) IBOutlet UITabBarItem *sellTabBarItem;
@property (retain, nonatomic) IBOutlet UITabBarItem *moreTabBarItem;

@property (nonatomic, retain) NSString *index;

@end
