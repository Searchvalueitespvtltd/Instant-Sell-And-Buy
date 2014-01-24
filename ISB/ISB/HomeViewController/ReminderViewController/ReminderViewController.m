//
//  ReminderViewController.m
//  ISB
//
//  Created by AppRoutes on 12/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ReminderViewController.h"
#import "NotificationsViewController.h"
#import "UserDetailViewController.h"
@interface ReminderViewController ()

@end

@implementation ReminderViewController
@synthesize tblReminderList;

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
    section0Array = [[NSMutableArray alloc]init];
    section1Array = [[NSMutableArray alloc]init];
    section2Array = [[NSMutableArray alloc]init];

    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.tblReminderList.frame = CGRectMake(tblReminderList.frame.origin.x, tblReminderList.frame.origin.y, 320, self.view.frame.size.height- 140);
    }
    else
    {
        self.tblReminderList.frame = CGRectMake(tblReminderList.frame.origin.x, tblReminderList.frame.origin.y, 320, self.view.frame.size.height- 140);
    }


}

-(void)viewWillAppear:(BOOL)animated
{
    [self callWebService];
    if ((!section0Array || !section0Array.count) && (!section1Array || !section1Array.count) && (!section2Array || !section2Array.count)){
        btnEdit.hidden=YES;
    }
   else
        btnEdit.hidden=NO;
    tblReminderList.editing=NO;
    [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
}

-(IBAction)btnAddORDeleteRowsClicked:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [tblReminderList setEditing:NO animated:NO];
        [tblReminderList reloadData];
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [tblReminderList setEditing:YES animated:YES];
        [tblReminderList reloadData];
        [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
}


-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"reminders/get?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    //    [objService sendRequestToServer:@"msgs/get_all?user_id=18" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)callWebServiceForDelete:(NSString *)remID
{
    NetworkService *objService = [[NetworkService alloc]init];
    //    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/delete?msg_id=%@",msgID ]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    [objService sendRequestToServer:[NSString stringWithFormat:@"reminders/delete?rem_id=%@",remID]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"responce:%@",inResponseDic);
    
    if([inResponseDic isKindOfClass:[NSDictionary class]])
    {
        btnEdit.hidden=NO;
        notificationArray = [[NSMutableArray alloc]initWithArray:[inResponseDic valueForKey:@"Notification"]];
        
        // for removing the rejected by or blocked by list from local active list.
        for (NSDictionary* str in notificationArray)
        {
            NSMutableString* name = [[ (NSString*)[str objectForKey:@"msg" ] componentsSeparatedByString:@" "] objectAtIndex:4];
           name = [name substringFromIndex:1];
            name = [name substringToIndex:[name length] - 2];
            [Utils arrayFromUserDefaultForKey:kBlockedRejectedBy update:name];
            NSArray* arr = [Utils arrayFromUserDefaultForKey:kActiveList];
            
            for (NSString* str2 in arr)
            {
                NSString* str3 = [[ str2 componentsSeparatedByString:@"@"] objectAtIndex:0];
                if ([str3 caseInsensitiveCompare:name])
                {
                    [Utils removeObject:str2 fromList:kActiveList];
                }
                
            }
            
        }
        
        section0Array = [inResponseDic valueForKey:@"WatchList"];
        section1Array = [inResponseDic valueForKey:@"Buy"];
        section2Array = [inResponseDic valueForKey:@"Sell"];
        if ((!section0Array || !section0Array.count) && (!section1Array || !section1Array.count) && (!section2Array || !section2Array.count)){
            btnEdit.hidden=YES;
        }
        else
            btnEdit.hidden=NO;

        [tblReminderList reloadData];
    }
    
        
    
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



#pragma mark - TableView Delegates

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    switch (indexPath.section) {
        case 0:
            if ([cell.textLabel.text isEqualToString:@"There are currently no recent activity"]||!section0Array || !section0Array.count) {
                return NO;
            }
            break;
        case 1:
            if ([cell.textLabel.text isEqualToString:@"There are currently no buying reminders"]||!section1Array || !section1Array.count) {
                return NO;
            }
            break;
        case 2:
            if ([cell.textLabel.text isEqualToString:@"There are currently no selling reminders"]||!section2Array || !section2Array.count) {
                return NO;
            }
            
        default:
            break;
    }
    return YES;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    /* Create custom view to display section header... */
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 320, 20)];
    label.font = [UIFont fontWithName:@"AvenirNextCondensed-Bold" size:15.0];

    switch (section) {
        case 0:
            label.text=@"Recent activity";
            break;
        case 1:
            label.text=@"Buying reminders";
            break;
        case 2:
            label.text=@"Selling reminders";
            break;
            
        default:
            break;
    }

    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
       [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:198/255.0 green:198/255.0 blue:198/255.0 alpha:1.0]]; //your background color...
    
    return view;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

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
    
    switch (section) {
        case 0:
            if (![section0Array count] == 0)
            {
            return [section0Array count];
            }
            else
                return 1;
            break;
        case 1:
            if (![section1Array count] == 0)
            {
            return [section1Array count];
            }
            else
                return 1;
            break;
        case 2:
                if (![section2Array count] == 0)
                {
            return [section2Array count];
                }
                else
                    return 1;
            break;
            
        default:
            break;
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
    
    switch (indexPath.section) {
        case 0:
            if (![section0Array count] == 0)
            {
                cell.textLabel.text =  [[section0Array objectAtIndex:indexPath.row]valueForKey:@"msg"];
            }
            else
                cell.textLabel.text = @"There are currently no recent activity";
            break;
        case 1:
            if (![section1Array count] == 0)
            {
                cell.textLabel.text =  [[section1Array objectAtIndex:indexPath.row]valueForKey:@"msg"];
            }
            else
                cell.textLabel.text = @"There are currently no buying reminders";
            break;
        case 2:
            if (![section2Array count] == 0)
            {
                cell.textLabel.text =  [[section2Array objectAtIndex:indexPath.row]valueForKey:@"msg"];
            }
            else
                cell.textLabel.text = @"There are currently no selling reminders";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.highlightedTextColor = [UIColor grayColor];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
//    
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    switch (indexPath.section) {
        case 0:
            if ([cell.textLabel.text isEqualToString:@"There are currently no recent activity"]) {
                return ;
            }
            break;
        case 1:
            if ([cell.textLabel.text isEqualToString:@"There are currently no buying reminders"]) {
                return ;
            }
            break;
        case 2:
            if ([cell.textLabel.text isEqualToString:@"There are currently no selling reminders"]) {
                return ;
            }
            break;
            
        default:
            break;
    }
    UserDetailViewController *userDetailView ;
    switch (indexPath.section) {
        case 0:
            if ([cell.textLabel.text isEqualToString:@"There are currently no recent activity"]) {
                return ;
            }
            break;
        case 1:
            
            
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController_iPhone5" bundle:nil];
                
            }
            else
            {
                userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
            }
            
            userDetailView.strViewTitle = @"Seller Details";
            userDetailView.strUserId = [[section1Array objectAtIndex:indexPath.row]valueForKey:@"seller_id"];
            userDetailView.strItemId = [[section1Array objectAtIndex:indexPath.row]valueForKey:@"item_id"];
            
            [self.navigationController pushViewController:userDetailView animated:YES ];
            [userDetailView release];
            break;

        case 2:
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController_iPhone5" bundle:nil];
                
            }
            else
            {
                userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
            }
            
            userDetailView.strViewTitle = @"Buyer Details";
            userDetailView.strUserId = [[section2Array objectAtIndex:indexPath.row]valueForKey:@"buyer_id"];
            userDetailView.strItemId = [[section2Array objectAtIndex:indexPath.row]valueForKey:@"item_id"];
            
            
            [self.navigationController pushViewController:userDetailView animated:YES ];
            [userDetailView release];
            break;
            
        default:
            break;
    }

    
//    if (![section0Array count] == 0)
//    {
//      
//    }
//    else if (![section1Array count] == 0)
//    {
//        UserDetailViewController *userDetailView ;
//        
//        if([[UIScreen mainScreen] bounds].size.height>480)
//        {
//            userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController_iPhone5" bundle:nil];
//            
//        }
//        else
//        {
//            userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
//        }
//        
//        userDetailView.strViewTitle = @"Seller Details";
//        userDetailView.strUserId = [[section1Array objectAtIndex:indexPath.row]valueForKey:@"seller_id"];
//        userDetailView.strItemId = [[section1Array objectAtIndex:indexPath.row]valueForKey:@"item_id"];
//        
//        [self.navigationController pushViewController:userDetailView animated:YES ];
//        [userDetailView release];
//
//    }
//    else if (![section2Array count] == 0)
//    {
//        UserDetailViewController *userDetailView ;
//        
//        if([[UIScreen mainScreen] bounds].size.height>480)
//        {
//            userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController_iPhone5" bundle:nil];
//            
//        }
//        else
//        {
//            userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
//        }
//        
//        userDetailView.strViewTitle = @"Buyer Details";
//        userDetailView.strUserId = [[section2Array objectAtIndex:indexPath.row]valueForKey:@"buyer_id"];
//        userDetailView.strItemId = [[section2Array objectAtIndex:indexPath.row]valueForKey:@"item_id"];
//
//        
//        [self.navigationController pushViewController:userDetailView animated:YES ];
//        [userDetailView release];
//
//    }
    
//    UserDetailViewController *userDetailView ;
//    
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController_iPhone5" bundle:nil];
//        
//    }
//    else
//    {
//        userDetailView=[[UserDetailViewController alloc] initWithNibName:@"UserDetailViewController" bundle:nil];
//    }
//    
//    [self.navigationController pushViewController:userDetailView animated:YES ];
//    [userDetailView release];
    
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (section0Array.count>0)
            {
                [self callWebServiceForDelete:[[section0Array objectAtIndex:indexPath.row]valueForKey:@"id"]];
            }
            else if (section1Array.count>0)
            {
                [self callWebServiceForDelete:[[section1Array objectAtIndex:indexPath.row]valueForKey:@"id"]];
            }
            else if (section2Array.count>0)
            {
                [self callWebServiceForDelete:[[section2Array objectAtIndex:indexPath.row]valueForKey:@"id"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (section0Array.count>0)
                {
                    [section0Array removeObjectAtIndex:indexPath.row];
                    [tblReminderList reloadData];
                }
                else if(section1Array.count>0)
                {
                    [section1Array removeObjectAtIndex:indexPath.row];
                    [tblReminderList reloadData];
                }
                else if(section2Array.count>0)
                {
                    [section2Array removeObjectAtIndex:indexPath.row];
                    [tblReminderList reloadData];
                }
                if ((!section0Array || !section0Array.count) && (!section1Array || !section1Array.count) && (!section2Array || !section2Array.count)){
                    btnEdit.hidden=YES;
                }
                else
                    btnEdit.hidden=NO;
                
//                [section0Array removeObjectAtIndex:indexPath.row];
//                if (!section0Array || !section0Array.count||!section1Array || !section1Array.count||!section2Array || !section2Array.count){
//                    btnEdit.hidden=YES;
//                }
//                else
//                    btnEdit.hidden=NO;
//                [tblReminderList reloadData];
                
            });
        });
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnNotificationsClick:(id)sender {
    
    NotificationsViewController *notifications;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        notifications=[[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController_iPhone5" bundle:nil];
    }
    else
    {
        notifications=[[NotificationsViewController alloc] initWithNibName:@"NotificationsViewController" bundle:nil];
    }
    notifications.arrayNotifications=notificationArray;
    [self.navigationController pushViewController:notifications animated:YES ];
    [notifications release];   
}

- (IBAction)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)dealloc
{
    [tblReminderList release];
    [btnEdit release];
    [super dealloc];
}

@end
