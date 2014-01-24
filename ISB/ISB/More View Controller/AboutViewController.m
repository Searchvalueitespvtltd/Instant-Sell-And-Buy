//
//  AboutViewController.m
//  ISB
//
//  Created by AppRoutes on 19/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "AboutViewController.h"


@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:@"www.eitcl.co.uk"];
    
    [attributeString addAttribute:NSUnderlineStyleAttributeName
                            value:[NSNumber numberWithInt:1]
                            range:(NSRange){0,[attributeString length]}];
    lblGoToLink.attributedText = [attributeString copy];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    txtViewAbout.userInteractionEnabled = NO;
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnGOTOClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.eitcl.co.uk"]];
}

@end
