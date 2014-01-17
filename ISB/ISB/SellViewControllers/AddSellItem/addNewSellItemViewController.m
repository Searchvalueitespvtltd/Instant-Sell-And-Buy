//
//  addNewSellItemViewController.m
//  ISB
//
//  Created by chetan shishodia on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "addNewSellItemViewController.h"
#import "AddSellItemViewController.h"

@interface addNewSellItemViewController ()

@end

@implementation addNewSellItemViewController

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

    // Do any additional setup after loading the view from its nib.
}

#pragma - mark Button Method

-(IBAction)btnProfileViewClicked:(id)sender
{
    
}

-(IBAction)btnAddItemClicked:(id)sender
{
    AddSellItemViewController *addSellItem;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        addSellItem = [[AddSellItemViewController alloc]initWithNibName:@"AddSellItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        addSellItem = [[AddSellItemViewController alloc]initWithNibName:@"AddSellItemViewController" bundle:nil];
    }
    [self.navigationController pushViewController:addSellItem animated:YES];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
