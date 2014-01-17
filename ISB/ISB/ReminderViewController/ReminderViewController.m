//
//  ReminderViewController.m
//  ISB
//
//  Created by AppRoutes on 12/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ReminderViewController.h"
#import "NotificationsViewController.h"
@interface ReminderViewController ()

@end

@implementation ReminderViewController

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
    
//    section0Array = [[NSArray arrayWithObjects:@"Send SMS", nil] retain];
//    section1Array = [[NSArray arrayWithObjects:@"Accounts", nil] retain];
//    
//    section2Array = [[NSArray arrayWithObjects:@"There are currently no selling reminders", nil] retain];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - TableView Delegates

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

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
     
    
    
    switch (indexPath.section) {
        case 0:
            if (![section0Array count] == 0)
            {
                cell.textLabel.text =  [[section0Array objectAtIndex:indexPath.row]valueForKey:@"name"];
            }
            else
            cell.textLabel.text = @"There are currently no recent activity";
            break;
        case 1:
            if (![section1Array count] == 0)
            {
                cell.textLabel.text =  [[section0Array objectAtIndex:indexPath.row]valueForKey:@"name"];
            }
            else
            cell.textLabel.text = @"There are currently no buying reminders";
            break;
        case 2:
            if (![section2Array count] == 0)
            {
                cell.textLabel.text =  [[section0Array objectAtIndex:indexPath.row]valueForKey:@"name"];
            }
            else
            cell.textLabel.text = @"There are currently no selling reminders";
            break;
            
        default:
            break;
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    cell.textLabel.backgroundColor = cell.contentView.backgroundColor;
//    
//}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    [self.navigationController pushViewController:notifications animated:YES ];
    [notifications release];

    
}

- (IBAction)btnBackClick:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)dealloc {
    [_tblReminderList release];
    [super dealloc];
}

@end
