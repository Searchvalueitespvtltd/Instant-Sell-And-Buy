//
//  NotificationsViewController.m
//  ISB
//
//  Created by AppRoutes on 12/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "NotificationsViewController.h"

@interface NotificationsViewController ()

@end

@implementation NotificationsViewController
@synthesize arrayNotifications,tblNotificationList;
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

-(void)viewWillAppear:(BOOL)animated
{
    if (!arrayNotifications || !arrayNotifications.count){
        btnEdit.hidden=YES;
    }
    else
        btnEdit.hidden=NO;
    tblNotificationList.editing=NO;
    [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    
}

-(void)callWebServiceForDelete:(NSString *)remID
{
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    NetworkService *objService = [[NetworkService alloc]init];
    //    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/delete?msg_id=%@",msgID ]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    [objService sendRequestToServer:[NSString stringWithFormat:@"reminders/delete?rem_id=%@",remID]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    
}

-(IBAction)btnAddORDeleteRowsClicked:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [tblNotificationList setEditing:NO animated:NO];
        [tblNotificationList reloadData];
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [tblNotificationList setEditing:YES animated:YES];
        [tblNotificationList reloadData];
        [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
}
- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - TableView Delegates

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
//    /* Create custom view to display section header... */
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 250, 20)];
//    label.font = [UIFont fontWithName:@"Avenir Next Condensed" size:13.0];
//    NSString *string;
//    if (strViewHeading)
//    {
//        string = [NSString stringWithFormat:@"%d Items found in %@",[self.arrSearchItem count],strViewHeading];
//    }
//    else
//    {
//        string = [NSString stringWithFormat:@"%d Items found in %@",[self.arrSearchItem count],strViewTitle];
//    }
//    
//    //    NSString *string = [NSString stringWithFormat:@"%d Items found in %@",[self.arrSearchItem count],strViewTitle];
//    
//    label.backgroundColor = [UIColor clearColor];
//    label.textColor = [UIColor blackColor];
//    //    UIImageView *imgholder = [[UIImageView alloc] initWithFrame:CGRectMake(294, 2, 17, 17)];
//    //    UIImage *img = [UIImage imageNamed:@"iconImageView.png"];
//    //    imgholder.image=img;
//    //    [view addSubview:imgholder];
//    //
//    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //3
//    //    [button setFrame:CGRectMake(294, 2, 17, 17 )];
//    //    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];//2
//    //    [view addSubview:button];
//    
//    /* Section header is in 0th index... */
//    [label setText:string];
//    [view addSubview:label];
//    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
//    
//    return view;
    
//}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellText = @"Go get some text for your cell.";
    UIFont *cellFont = [UIFont fontWithName:@"Avenir Next Condensed Bold" size:15.0];
    CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
   // return 55;
    return labelSize.height + 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (![arrayNotifications count] == 0)
    {
        return [arrayNotifications count];
    }
    else
        return 1;

}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
               if ([cell.textLabel.text isEqualToString:@"There are currently no recent notification"]) {
                return NO;
            }
           return YES;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    cell.textLabel.numberOfLines=3;
            if (![arrayNotifications count] == 0)
            {
                cell.textLabel.text =  [[arrayNotifications objectAtIndex:indexPath.row]valueForKey:@"msg"];
            }
            else
                cell.textLabel.text = @"There are currently no recent notification";
          cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.textColor = [UIColor grayColor];
    
    return cell;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //    [Utils stopActivityIndicatorInView:self.view];
            [self callWebServiceForDelete:[[arrayNotifications objectAtIndex:indexPath.row]valueForKey:@"id"]];
            
//            dispatch_async(dispatch_get_main_queue(), ^{
                [arrayNotifications removeObjectAtIndex:indexPath.row];
                if (!arrayNotifications || !arrayNotifications.count){
                    btnEdit.hidden=YES;
                }
                else
                    btnEdit.hidden=NO;
                [tblNotificationList reloadData];
                
//            });
//        });
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [searchBar resignFirstResponder];
//    
//    [self fetchData:[arrSaveItem objectAtIndex:indexPath.row]];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self performSelector:@selector(saveToDatabase:) withObject:[arrSaveItem objectAtIndex:indexPath.row]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
//    });
//    
//    
//    ItemViewController *itemDetailView;
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController_iPhone5" bundle:nil];
//    }
//    else
//    {
//        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
//    }
//    
//    itemDetailView.dicItemDetails = [arrSearchItem objectAtIndex:indexPath.row];
//    itemDetailView.isWatching=[[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"is_watch"] integerValue];
//    
//    [self.navigationController pushViewController:itemDetailView animated:YES ];
//    
//    [itemDetailView release];
    
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
   [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"responce:%@",inResponseDic);
    
    //    if([[inResponseDic valueForKey:@"id"]isEqualToString:@"0"])
    //    {
    //        //       [Utils showAlertView:kAlertTitle message:@"Wrong email or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [Utils showAlertView:kAlertTitle message:[inResponseDic valueForKey:@"error"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //    }
    //    else{
    //        [self setField:self.passwordTxtField forKey:kXMPPmyPassword1];
    //        [self setField:self.userNameTxtField forKey:kXMPPmyJID1];
    //        if([gCXMPPController connect])
    //        {
    //            NSLog(@"connected");
    //        }
    //        else
    //        {
    //            NSLog(@"not connected");
    //        }
    //        [[NSUserDefaults standardUserDefaults]setValue:[inResponseDic objectForKey:@"id"] forKey:@"USERID"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //        [[NSUserDefaults standardUserDefaults]setValue:[inResponseDic objectForKey:@"username"] forKey:@"USER_NAME"];
    //        [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //        dicProfileData = [NSDictionary dictionaryWithDictionary:inResponseDic];
    //
    //
    //        //        if (![[dicProfileData objectForKey:@"profile_pic_path"]isEqual:@""])
    //        //        {
    //        //
    //        //        }
    //
    //        [self saveToDatabase];
    //
    //        HomeViewController *homeViewController;
    //        if([[UIScreen mainScreen] bounds].size.height>480)
    //        {
    //            homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController_iPhone5" bundle:nil];
    //
    //        }
    //        else
    //        {
    //            homeViewController=[[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    //        }
    //
    //        //        [self.navigationController pushViewController:homeViewController animated:YES ];
    //        AppDelegate *delegate = APP_DELEGATE;
    //        [delegate removeHomeScreen:@"0"];
    //        //        [homeViewController release];
    //
    //    }
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    NSLog(@"%@",inError);
    
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //    [Utils showAlertView:kAlertTitle message:[inError debugDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    //    NSLog(@"*** requestErrorHandler *** and Error : %@",[inError debugDescription]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [tblNotificationList release];
    [super dealloc];
}

@end
