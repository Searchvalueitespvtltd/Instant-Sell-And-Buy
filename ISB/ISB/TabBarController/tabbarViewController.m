//
//  tabbarViewController.m
//  ISB
//
//  Created by chetan shishodia on 29/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "tabbarViewController.h"

@interface tabbarViewController ()

@end

@implementation tabbarViewController
@synthesize tabBarController,HomeTabBarItem,searchTabBarItem,index,myISBTabBarItem,sellTabBarItem,moreTabBarItem;

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
    self.navigationController.navigationBarHidden=YES;

    UIImage *selectedImage0,*selectedImage4,*unselectedImage4;
    UIImage *unselectedImage0,*selectedImage1,*unselectedImage1,*selectedImage2,*unselectedImage2,*selectedImage3,*unselectedImage3;

        selectedImage0 = [UIImage imageNamed:@"homeSelected.png"];
        unselectedImage0 = [UIImage imageNamed:@"home.png"];
        
        selectedImage1 = [UIImage imageNamed:@"searchSelected.png"];
        unselectedImage1 = [UIImage imageNamed:@"search.png"];
        
        selectedImage2 = [UIImage imageNamed:@"myISBSelected.png"];
        unselectedImage2 = [UIImage imageNamed:@"myISB.png"];
        
        selectedImage3 = [UIImage imageNamed:@"sellSelected.png"];
        unselectedImage3 = [UIImage imageNamed:@"sell.png"];
        
        selectedImage4 = [UIImage imageNamed:@"moreSelected.png"];
        unselectedImage4 = [UIImage imageNamed:@"more.png"];
        

    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = [tabBar.items objectAtIndex:0];
    
    UITabBarItem *item1 = [tabBar.items objectAtIndex:1];
    UITabBarItem *item2 = [tabBar.items objectAtIndex:2];
    UITabBarItem *item3 = [tabBar.items objectAtIndex:3];
    UITabBarItem *item4 = [tabBar.items objectAtIndex:4];
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    [item4 setFinishedSelectedImage:selectedImage4 withFinishedUnselectedImage:unselectedImage4];
    [self.tabBarController setSelectedIndex:[index intValue]];

    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
