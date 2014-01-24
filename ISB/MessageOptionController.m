//
//  MessageOptionController.m
//  ISB
//
//  Created by Pankaj on 9/13/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MessageOptionController.h"
#import "MessageViewController.h"

@interface MessageOptionController ()

@end

@implementation MessageOptionController

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
//    Option=[[NSMutableArray alloc]initWithObjects:@"Inbox",@"Sent",@"Deleted", nil];
    Option=[[NSMutableArray alloc]initWithObjects:@"Inbox",@"Deleted", nil];

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnInbox{
        MessageViewController *messageView ;
    
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController_iPhone5" bundle:nil];
        }
        else
        {
            messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
        }
    messageView.messageType=4;
        [self.navigationController pushViewController:messageView animated:YES ];
        [messageView release];
    
}

- (void)btnSent{
    MessageViewController *messageView ;
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController_iPhone5" bundle:nil];
        
    }
    else
    {
        messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    }
    messageView.messageType=2;
    [self.navigationController pushViewController:messageView animated:YES ];
    [messageView release];
    
}

- (void)btnDeleted {
    MessageViewController *messageView ;
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController_iPhone5" bundle:nil];
    }
    else
    {
        messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
    }
    messageView.messageType=3;
    [self.navigationController pushViewController:messageView animated:YES ];
    [messageView release];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [Option count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   // static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"messageOptionCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    UILabel *cellLabel=(UILabel*)[cell.contentView viewWithTag:400];
    cellLabel.text=[Option objectAtIndex:indexPath.row];
    
    UIImageView *image=(UIImageView *)[cell.contentView viewWithTag:100];
    
    switch (indexPath.row) {
        case 0:
            image.image=[UIImage imageNamed:@"InboxBtn@2x.png"];
            break;
//        case 1:
//            image.image=[UIImage imageNamed:@"OutboxBtn@2x.png"];
//
//            break;
        case 1:
            image.image=[UIImage imageNamed:@"DeletedBtn@2x.png"];

            break;
            
        default:
            break;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            [self btnInbox];
            break;
//        case 1:
//            [self btnSent];
//            break;
        case 1:
            [self btnDeleted];
            break;
            
        default:
            break;
    }
}
- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
@end
