//
//  MessageViewController.m
//  ISB
//
//  Created by AppRoutes on 28/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MessageViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

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
- (IBAction)editClick:(id)sender {
}
- (IBAction)backClick:(id)sender {
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    //  appointmentSchedulerTbl=tableView;
    if (cell == nil) {
        
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CellMessageView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        //    UIImageView *Image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 42)];
        //    Image.contentMode=UIViewContentModeScaleToFill;
        //    cell.selectedBackgroundView=Image;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    CreateEventViewController *eventViewController=[[CreateEventViewController alloc] initWithNibName:@"CreateEventViewController" bundle:nil];
//    
//    [self.view addSubview:eventViewController.view];
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_searchBar release];
    [_cancelBtn release];
    [_editBtn release];
    [_cancelBtn release];
    [_messageTableView release];
    [super dealloc];
}
@end
