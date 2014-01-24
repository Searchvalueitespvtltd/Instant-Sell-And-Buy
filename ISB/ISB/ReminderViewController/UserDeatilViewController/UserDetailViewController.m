//
//  UserDetailViewController.m
//  ISB
//
//  Created by AppRoutes on 13/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "UserDetailViewController.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_lblCustName release];
    [_lblCustAdd release];
    [_lblCustMail release];
    [_lblEmailId release];
    [_lblContectNumber release];
    [super dealloc];
}
@end
