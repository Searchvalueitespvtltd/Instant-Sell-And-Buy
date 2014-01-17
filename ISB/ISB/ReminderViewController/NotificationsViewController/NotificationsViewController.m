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
@synthesize arrayNotifications;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrayNotifications count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CellHomeAppliances" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
//
//    UIView *selectionColor = [[UIView alloc] init];
//    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
//    
//    UIImageView *couponImage = (UIImageView *)[cell.contentView viewWithTag:100];
//    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageURL,[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"pic_path"]];
//    
//    Product *prod=[self.arrSearchItem objectAtIndex:indexPath.row];
//    
//    if(prod.image != nil)
//    {
//        couponImage.image  = prod.image;
//        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
//        indicator.hidden=YES;
//    }
//    else
//    {
//        
//        //        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        //
//        //        [data setObject:imgUrl forKey:@"ImageUrl"];
//        //        [data setObject:indexPath forKey:@"IndexPath"];
//        //        [data setObject:[[self.arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"id"];
//        if ([imgUrl isEqualToString:@"0"]) {
//            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
//            indicator.hidden=YES;
//        }
//        else {
//            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
//            indicator.hidden=NO;
//            //            [self performSelectorInBackground:@selector(fetchImage:) withObject:data];
//        }
//        
//        // [data release];
//    }
//    
//    UILabel *itemDescription = (UILabel *)[cell.contentView viewWithTag:101];
//    
//    cell.selectedBackgroundView = selectionColor;
//    
//    // added by chetan ..
//    
//    //    if (![self.arrItemList count] == 0)
//    //    {
//    itemDescription.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
//    itemDescription.text = [[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"title"];
//    NSString *mystring = [[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"location_latlong"];
//    itemDescription.highlightedTextColor = [UIColor blackColor];
//    double currlat = [[[StoredData sharedData] latitude] doubleValue];
//    double currlong = [[[StoredData sharedData] longitude] doubleValue];
//    
//    CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:currlat longitude:currlong];
//    //         NSString *mystring = [self.arrSearchItem valueForKey:@"location_latlong"];
//    
//    NSArray *ary = [mystring componentsSeparatedByString:@","];
//    double servlat = [[ary objectAtIndex:0]doubleValue];
//    double servlong = [[ary objectAtIndex:1]doubleValue];
//    CLLocation *serverLocation = [[CLLocation alloc] initWithLatitude:servlat longitude:servlong];
//    NSLog(@"servlat :%f",servlat);
//    NSLog(@"servlong :%f",servlong);
//    NSLog(@"currlat :%f",currlat);
//    NSLog(@"currlong :%f",currlong);
//    //    double disTanceInKm = [self getDistanceFromLocA:currLocation andLocB:serverLocation];
//    
//    UILabel *itemLoc = (UILabel *)[cell.contentView viewWithTag:102];
//    
//    itemLoc.font = [UIFont fontWithName:@"Avenir Next Condensed" size:12.0];
//    //    itemLoc.text = [NSString stringWithFormat:@"$%@",[[self.arrSearchItem profileobjectAtIndex:indexPath.row]valueForKey:@"loc"]];
//    
//    mDistance = [self getDistanceFromLocA:currLocation andLocB:serverLocation];
//    if (mDistance >= 0)
//    {
//        mDistance  = mDistance/1000 ;
//        NSLog(@"km:%f",mDistance);
//        //mLblDistance.text = [NSString stringWithFormat:@"%.3f",mDistance];
//    }
//    
//    itemLoc.text =[NSString stringWithFormat:@"%.2fKm",mDistance];
//    
//    itemLoc.highlightedTextColor = [UIColor blackColor];
//    
//    
//    UILabel *itemPrice = (UILabel *)[cell.contentView viewWithTag:103];
//    
//    itemPrice.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
//    itemPrice.text = [NSString stringWithFormat:@"$%@",[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"price"]];
//    itemPrice.highlightedTextColor = [UIColor whiteColor];
//    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

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

- (void)dealloc {
    [_tblNotificationList release];
    [super dealloc];
}

@end
