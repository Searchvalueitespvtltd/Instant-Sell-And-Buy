//
//  SaveSearchViewController.m
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SaveSearchViewController.h"

@interface SaveSearchViewController ()

@end

@implementation SaveSearchViewController

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
- (IBAction)cancelClick:(id)sender {
}
- (IBAction)saveClick:(id)sender {
}

- (void)dealloc {
    [_cancelBtn release];
    [_saveBtn release];
    [_searchTxtField release];
    [super dealloc];
}
@end
