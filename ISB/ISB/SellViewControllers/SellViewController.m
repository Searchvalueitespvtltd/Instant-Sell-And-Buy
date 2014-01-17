//
//  SellViewController.m
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SellViewController.h"
#import "ProfileViewController.h"
#import "ItemViewController.h"
#import "AppDelegate.h"
#import "Product.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"
#import "EditItemViewController.h"
#import "SellItems.h"

@interface SellViewController ()
{
    bool alertShowing;
}
@property(assign,nonatomic) bool alertShowing;
@end

@implementation SellViewController
@synthesize txtSearch,btnAddItem;
@synthesize arrItemList,dicitemList;
@synthesize tblItemList;
@synthesize alertShowing;
@synthesize srchBar;
@synthesize arrSearchItem,arrSearchItemCopy;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

int i;
int j;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    
    self.arrItemList = [[NSMutableArray alloc]init];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    dicitemList = [[NSMutableDictionary alloc]init];
    dicItemImages = [[NSMutableDictionary alloc]init];
    self.arrSearchItem = [[NSMutableArray alloc]init];
    [srchBar setBackgroundImage:[UIImage new]];
    [srchBar setTranslucent:YES];
    [HttpRequestProcessor shareHttpRequest];
    context=[App managedObjectContext];

    
//    [self callWebService];
    i = 0;
    j = 0;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
//    srchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 44.0, 320, 44.0)];
//    srchBar.delegate = self;
//    srchBar.tintColor = [UIColor blackColor];
//    [self.view addSubview:srchBar];
  [ItemDetails sharedInstance].isSelected=0;
    [self fetchUserData:@"Users"];

    [self callWebService];
}

#pragma mark - Fetch Data From Core Data

-(void)fetchUserData:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    ////////////////////////////////////////////////////////////////////////////////
    //    NSFetchedResultsController *fetchedResultsController = nil;
    //
    //    [fetchedResultsController.fetchedObjects count];
    //    NSLog(@"total rows=%i",[fetchedResultsController.fetchedObjects count]);
    ////////////////////////////////////////////////////////////////////////////////
    
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(userid LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
    
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
	if (!mutableFetchResults)
	{
        //		NSLog(@"Cant Fetch");
	}
    
    if (mutableFetchResults.count>0)
    {
        if([tableName isEqualToString:@"Users"])
        {
            if (![[mutableFetchResults objectAtIndex:0]valueForKey:@"image"])
            {
                [btnUserProfile setImage:[UIImage imageNamed:@"iconUserProfile.png"] forState:UIControlStateNormal];
            }
            else
            {
                NSData *imageData = [[mutableFetchResults objectAtIndex:0]valueForKey:@"image"];
                [btnUserProfile setImage:[UIImage imageWithData:imageData ] forState:UIControlStateNormal];
            }
        }
    }
}

#pragma mark - Call Webservice

-(void)callWebService
{

//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    
    NetworkService *objService = [[NetworkService alloc]init];
//    [objService sendRequestToServer:@"items/get" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];

    [objService sendRequestToServer:[NSString stringWithFormat:@"items/get?userid=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
-(void)callItemDeleteService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/delete?item_id=%@",[[arrSearchItem objectAtIndex:index] valueForKey:@"id"]]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    if ([inReqIdentifier rangeOfString:@"items/delete?"].length>0)
    {
        
    }
    else
    {
       if([inResponseDic isKindOfClass:[NSArray class]])
       {
            if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
            {
                self.arrSearchItem = [[NSMutableArray alloc]init];
                sellItemCount = 0;
                for (id obj in inResponseDic) {
                    Product *prod=[[Product alloc]init];
                    prod.id=[[obj valueForKey:@"id"] integerValue];
                    prod.category_name=[obj valueForKey:@"category_name"];
                    
                     prod.category_id=[[obj valueForKey:@"category_id"] integerValue];
                     prod.home_addr=[obj valueForKey:@"home_addr"];
                     prod.country_name=[obj valueForKey:@"country_name"];
                    prod.paymenttype_id=[obj valueForKey:@"paymenttype_id"];
                  //  prod.postagetype_id=[obj valueForKey:@""];
                    prod.city=[obj valueForKey:@"city"];
                    prod.desc=[obj valueForKey:@"desc"];
                    prod.status = [obj valueForKey:@"status"];
                    prod.paymenttype_name=[obj valueForKey:@"paymenttype_name"];
                    prod.availability=[obj valueForKey:@"availability"];

                    prod.postagetype_id = [obj valueForKey:@"postagetype_id"];
                    prod.state_name =[obj valueForKey:@"state_name"];
                    if (![[obj valueForKey:@"pic_path"] isEqual:[NSNull null]]) {
                        prod.pic_path=[obj valueForKey:@"pic_path"];
                    }
                    if (![[obj valueForKey:@"pic_path2"] isEqual:[NSNull null]]){
                        prod.pic_path2=[obj valueForKey:@"pic_path2"];

                    }
                    if (![[obj valueForKey:@"pic_path3"] isEqual:[NSNull null]]){
                        prod.pic_path3=[obj valueForKey:@"pic_path3"];
                    }
                    if ([[obj valueForKey:@"seller_pic"] isEqual:[NSNull null]] || ![[obj valueForKey:@"seller_pic"] length]>0)
                    {
                        prod.seller_pic=@"1";
                    }else
                        prod.seller_pic = [obj valueForKey:@"seller_pic"];

                 //   prod.pic_path=[obj valueForKey:@"pic_path"];
                    prod.price=[obj valueForKey:@"price"];
                    prod.title= [obj valueForKey:@"title"];
                    prod.user_name= [obj valueForKey:@"user_name"];
                    prod.postagetype_name=[obj valueForKey:@"postagetype_name"];
                    prod.location_latlong= [obj valueForKey:@"location_latlong"];
                    prod.postage= [obj valueForKey:@"postage"];
                    prod.zipcode= [obj valueForKey:@"zipcode"];
                    prod.default_pic = [obj valueForKey:@"default_pic"];
                    prod.item_code=[obj valueForKey:@"item_code"];
                    sellItemCount++;
                    [self.arrSearchItem addObject:prod];
                }

                // [self fetchData:@"SellItems"];
                
                //            self.arrSearchItem = [NSMutableArray arrayWithArray:inResponseDic];
                self.arrSearchItemCopy=[NSMutableArray arrayWithArray:self.arrSearchItem];
                [self performSelector:@selector(bringImages:) withObject:self.arrSearchItem afterDelay:0];
//                NSLog(@"Response is = %@",self.arrSearchItem);
                [tblItemList reloadData];
            }
//            {
//                self.arrItemList = [NSMutableArray arrayWithArray:inResponseDic];
//                
//                NSLog(@"Response is = %@",self.arrItemList);
//                [tblItemList reloadData];
//            }
            else
            {
                
                
                if(self.alertShowing==NO)
                {
                    [Utils showAlertView:kAlertTitle message:@"You are not selling any items. Please add product." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    self.alertShowing = YES;
                }
            }
        }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please add product." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    }
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        index = 0;
        //  strProductId=[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"id"];
        
         index = indexPath.row;
        alertDelete = [[UIAlertView alloc]initWithTitle:kAlertTitle message:@"Do you really want to delete this item?" delegate:self
                                      cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
        
        [alertDelete show];
        [alertDelete release];
        
        //               [self callItemDeleteService];
        //
        //
        //        [arrSearchItem removeObjectAtIndex:indexPath.row];
        //        [arrSearchItemCopy removeObjectAtIndex:indexPath.row];
        //        [tblItemList reloadData];
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==alertDelete)
    {
        if (buttonIndex == 0)
        {
            [self callItemDeleteService];
            
            //
            [arrSearchItem removeObjectAtIndex:index];
            [arrSearchItemCopy removeObjectAtIndex:index];
            [tblItemList reloadData];
            // [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alertShowing = NO;
}

#pragma mark - Fetch Data From Core Data
-(void)fetchData:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    //    NSPredicate *pred =
    //    [NSPredicate predicateWithFormat:@"(username LIKE[c] %@)",
    //     [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
    //    [request setPredicate:pred];
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
    
    // Fetch the records and handle an error
	NSError *error;
	NSArray *mutableFetchResults = [context executeFetchRequest:request error:&error];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
    if (mutableFetchResults.count==0)
    {        
        SellItems *sellItem = (SellItems *)[NSEntityDescription insertNewObjectForEntityForName:@"SellItems" inManagedObjectContext:context];
        
        [sellItem setSellCount:[NSString stringWithFormat:@"%d",sellItemCount]];
        
        [sellItem setUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
        
        NSError *error;
        if (![context save:&error])
        {
            //NSLog(@"ERROR--%@",error);
            abort();
        }
        
    }
    else
    {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"SellItems" inManagedObjectContext:context];
        
        // Setup the fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSPredicate *pred =
        [NSPredicate predicateWithFormat:@"(userId LIKE [c] %@)",
         [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
        [request setPredicate:pred];

        NSError *error;
        SellItems *sellItem = [[context executeFetchRequest:request error:&error] objectAtIndex: 0];
        
        if (sellItem)
        {
            //SellItems *sellItem = (SellItems *)[NSEntityDescription insertNewObjectForEntityForName:@"SellItems" inManagedObjectContext:context];
            
            [sellItem setSellCount:[NSString stringWithFormat:@"%d",sellItemCount]];
            
            if (![context save:&error])
            {
                //NSLog(@"ERROR--%@",error);
                abort();
            }
        }

    }
}

/*

 -(void)saveToDatabase:(NSString *)inSearchBarText
 {
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentSearch" inManagedObjectContext:context];
 
 // Setup the fetch request
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 [request setEntity:entity];
 
 NSPredicate *pred =
 [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
 [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
 [request setPredicate:pred];
 
 NSPredicate *pred2 =
 [NSPredicate predicateWithFormat:@"(item_name Contains[c] %@)",srchBar.text];
 
 NSArray *compPredicatesList = [NSArray arrayWithObjects:pred,pred2, nil];
 
 NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
 
 [request setPredicate: CompPrediWithAnd];
 // Fetch the records and handle an error
 NSError *error;
 NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
 if ([mutableFetchResults count]==0) 
 {
 RecentSearch *savedsearch = (RecentSearch *)[NSEntityDescription insertNewObjectForEntityForName:@"RecentSearch" inManagedObjectContext:context];
 
 [savedsearch setItem_name:inSearchBarText];
 [savedsearch setUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
 NSError *error;
 if (![context save:&error])
 {
 //NSLog(@"ERROR--%@",error);
 abort();
 }
 }
 
 }
 
 

//*/


#pragma mark fetch images

-(void)bringImages:(NSArray *)inResponseDic
{
    for (int i=0;i<[inResponseDic count];i++)
    {
        Product *temp=[inResponseDic objectAtIndex:i];
        if ([temp.default_pic isEqualToString:@"1"]) {
            [self doFetchEditionImage:temp.pic_path withIndex:temp.id];
        }
        else if ([temp.default_pic isEqualToString:@"2"]){
            [self doFetchEditionImage:temp.pic_path2 withIndex:temp.id];
        }
        else
        {
        [self doFetchEditionImage:temp.pic_path3 withIndex:temp.id];
        }

    
        
    }
}

-(void)doFetchEditionImage:(NSString *)inImageId withIndex:(NSInteger)index
{
    SHRequestSampleImage *aRequest = [[SHRequestSampleImage alloc] initWithURL: nil] ;
    [aRequest setImageId:inImageId];
    [aRequest SetResponseHandler:@selector(handledImage:) ];
    [aRequest SetErrorHandler:@selector(errorHandler:)];
    [aRequest SetResponseHandlerObj:self];
    [aRequest SetRequestType:eRequestType1];
    aRequest.index = index;
    
    [gHttpRequestProcessor ProcessImage: aRequest];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //ß aRequest = nil;
    
}

-(void)errorHandler:(SHBaseRequestImage *)inRequest
{
    //  NSLog(@"*** errorHandler ***");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

//For scroll View
-(void)handledImage:(SHBaseRequestImage *)inRequest
{
    NSData *aImageData =  [inRequest GetResponseData];
    SHRequestSampleImage * aCurrReq = (SHRequestSampleImage *)inRequest;
    if (aImageData)
    {
//        NSLog(@"%d",inRequest.index);
        UIImage * img = [UIImage imageWithData: aImageData];
        NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
        NSInteger filteredIndexes = [self.arrSearchItem indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
            NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
            return [ID isEqualToString:cellIndex];
        }];
//        NSLog(@"filteredIndexes %d",filteredIndexes);
        if (filteredIndexes != NSNotFound) {
            Product *aTemp= [self.arrSearchItem objectAtIndex: filteredIndexes];
            if (img)
            {
                aTemp.image = img;
            }
            
            [self.arrSearchItem replaceObjectAtIndex:filteredIndexes withObject:aTemp];
            [self.tblItemList reloadData];
        }
        NSInteger filteredIndexesCopy = [self.arrSearchItemCopy indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
            NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
            return [ID isEqualToString:cellIndex];
        }];
        Product *aTempCopy= [self.arrSearchItemCopy objectAtIndex: filteredIndexesCopy];
        if (img)
        {
            aTempCopy.image = img;
        }
        [self.arrSearchItemCopy replaceObjectAtIndex:filteredIndexesCopy withObject:aTempCopy];
        
        // self.arrSearchItemCopy=[[NSMutableArray alloc]initWithArray:self.arrSearchItem];
        //
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


#pragma  - mark Button Methods

-(IBAction)btnUserProfileClicked:(id)sender
{
    ProfileViewController *profileViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iPhone5" bundle:nil];
        
    }
    else
    {
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:profileViewController animated:YES ];
    [profileViewController release];
    
//    [self.tabBarController setSelectedIndex:0];

}

-(IBAction)btnSearchCancelClicked:(id)sender
{
    txtSearch.text = @"";
    [ItemDetails sharedInstance].isEditing=NO;

    [txtSearch resignFirstResponder];
}

-(IBAction)btnAddItemClicked:(id)sender
{
    App.isEdit = NO;
    [ItemDetails sharedInstance].isEditing=NO;
    AddSellItemViewController * sellItem;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        sellItem = [[AddSellItemViewController alloc]initWithNibName:@"AddSellItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        sellItem = [[AddSellItemViewController alloc]initWithNibName:@"AddSellItemViewController" bundle:nil];
    }
    [self.navigationController pushViewController:sellItem animated:YES];
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSearchItem count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"cellForSellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // addded by chetan..
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    
    
    UIImageView *couponImage = (UIImageView *)[cell.contentView viewWithTag:100];
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageURL,[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"pic_path"]];
    
    Product *prod=[self.arrSearchItem objectAtIndex:indexPath.row];
    
    if(prod.image != nil)
    {
        couponImage.image  = prod.image;
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
        indicator.hidden=YES;
    }
    else
    {
    
//    if([dicItemImages objectForKey:indexPath] != nil)
//    {
//        couponImage.image  = [dicItemImages objectForKey:indexPath];
//        NSLog(@"Image %d Exists = %@",indexPath.row,[dicItemImages objectForKey:indexPath]);
//    }
//    else
//    {
//        
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        
//        [data setObject:imgUrl forKey:@"ImageUrl"];
//        [data setObject:indexPath forKey:@"IndexPath"];
        
        if ([imgUrl isEqualToString:@"0"]) {
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
            indicator.hidden=YES;
        }
        else {
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
            indicator.hidden=NO;
//            [self performSelectorInBackground:@selector(fetchImage:) withObject:data];
        }
        
//        [data release];
    }
    
    UILabel *itemName = (UILabel *)[cell.contentView viewWithTag:200];
    
    cell.selectedBackgroundView = selectionColor;
    
    // added by chetan ..
    
//    if (![self.arrItemList count] == 0)
//    {
        itemName.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
        itemName.text = [[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"title"];
        itemName.highlightedTextColor = [UIColor blackColor];
    
    
    NSString *strStatus = [[self.arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"status"];
    
    UIImageView *statusImage = (UIImageView *)[cell.contentView viewWithTag:400];
    UILabel *lblStatusName = (UILabel *)[cell.contentView viewWithTag:500];
    
    if([strStatus isEqualToString:@"0"])
    {
        statusImage.image = [UIImage imageNamed:@"btnGrey.png"];
        lblStatusName.text = @"In Review";
    }
    else
    {
        statusImage.image = [UIImage imageNamed:@"btnBlue.png"];
        lblStatusName.text = @"On Sale";
    }
    
    
//    }
      
    return cell;
}

-(void)fetchImage:(NSMutableDictionary *)dict
{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSIndexPath *indexPath = (NSIndexPath *)[dict objectForKey:@"IndexPath"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ImageUrl"]];
    NSInteger imId=[[dict objectForKey:@"id"] integerValue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithString:imageUrl]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *profilePic = nil;
//    NSLog(@"%d j==",j++);
    if (data) {
        
//        profilePic = [[[UIImage alloc] initWithData:data] autorelease];
        NSLog(@"%d",i++);
        if (profilePic) {
//            NSLog(@"%@  Count : %d",indexPath, [self.arrSearchItem count]);
            if (indexPath.row<[self.arrSearchItem count]) {
                
                Product *prodct=[self.arrSearchItem objectAtIndex:indexPath.row];
                prodct.image=profilePic;
                [self.arrSearchItem replaceObjectAtIndex:indexPath.row withObject:prodct];
                //            Product *prodctCopy=[self.arrSearchItemCopy objectAtIndex:indexPath.row];
                //                prodctCopy.image=profilePic;
                
            }
            else{
                Product *prodct=[self.arrSearchItemCopy objectAtIndex:indexPath.row];
                prodct.image=profilePic;
            }
            //            [self.tblSearchResult reloadData];
            //            for (int i=0; i<[self.arrSearchItem count]; i++) {
            //                Product *prod=[self.arrSearchItem objectAtIndex:i];
            //                if (imId == [[prod valueForKey:@"id"]integerValue] )
            //                {
            //                   prod.image=profilePic;
            //                    [self.arrSearchItem replaceObjectAtIndex:i withObject:prod];
            //                    break;
            //
            //                }
            //            }
            //            for (int i=0; i<[self.arrSearchItemCopy count]; i++) {
            //                Product *prod=[self.arrSearchItemCopy objectAtIndex:i];
            //                if (imId == [[prod valueForKey:@"id"]integerValue] )
            //                {
            //                    prod.image=profilePic;
            //                    [self.arrSearchItemCopy replaceObjectAtIndex:i withObject:prod];
            //                    break;
            //
            //                }
            //            }
            //            [self.tblSearchResult reloadData];
            
            //            for (id obj in self.arrSearchItem) {
            //                if (imId == [[obj valueForKey:@"id"]integerValue] ) {
            //                    Product *prod=(Product*)obj;
            //                    prod.image=profilePic;
            //                    [self.tblSearchResult reloadData];
            //                    break;
            //                }
            //            }
            //            for (id obj in self.arrSearchItemCopy) {
            //                if (imId == [[obj valueForKey:@"id"]integerValue] ) {
            //                    Product *prod=(Product*)obj;
            //                    prod.image=profilePic;
            //                    [self.tblSearchResult reloadData];
            //                    break;
            //                }
            //            }
            
            //            [dicSearchItemImages setObject:profilePic forKey:indexPath];
            UITableViewCell *cell = [self.tblItemList cellForRowAtIndexPath:indexPath];
            UIActivityIndicatorView *indicate=(UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
            indicate.hidden=YES;
            UIImageView *friendImage = (UIImageView *)[cell.contentView viewWithTag:100];
            [friendImage setHidden:NO];
            friendImage.image = profilePic;
        }
        else
        {
            
        }
    }
    else {
        
    }
    
    [pool release];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 74;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//      //  strProductId=[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"id"];
//
//               // [self callUnbuyingService];
//             
//       
//        [arrSearchItem removeObjectAtIndex:indexPath.row];
//        [arrSearchItemCopy removeObjectAtIndex:indexPath.row];
//        [tblItemList reloadData];
//    }
//    
//    
//    
//}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    App.isEdit=YES;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     EditItemViewController  *itemDetailView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemDetailView=[[EditItemViewController alloc] initWithNibName:@"EditItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemDetailView=[[EditItemViewController alloc] initWithNibName:@"EditItemViewController" bundle:nil];
    }
    
    itemDetailView.dicItemDetails = [arrSearchItem objectAtIndex:indexPath.row];
    itemDetailView.isWatching=[[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"is_watch"] integerValue];
    
    [self.navigationController pushViewController:itemDetailView animated:YES ];
    
    [itemDetailView release];
    
   // App.dictEditItemDetail =[arrSearchItem objectAtIndex:indexPath.row];
    [ItemDetails sharedInstance].dicLocDetail = [[NSMutableDictionary alloc]init];
    [ItemDetails sharedInstance].dicCategoryDetail = [[NSMutableDictionary alloc]init];
    [ItemDetails sharedInstance].dicPriceDetail = [[NSMutableDictionary alloc]init];
    [ItemDetails sharedInstance].dicOtherdetails = [[NSMutableDictionary alloc]init];

    
    NSMutableDictionary *tempLoc=[[NSMutableDictionary alloc]init];
    if ([[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"home_addr"]) {
         [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"home_addr"] forKey:@"HOMEADDRESS"];
    }else
         [tempLoc setValue:@"abcd" forKey:@"HOMEADDRESS"];
   
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"city"] forKey:@"CITY"];
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"zipcode"] forKey:@"ZIPCODE"];
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"country_name"] forKey:@"COUNTRY"];
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"state_name"] forKey:@"STATE"];
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"state_name"] forKey:@"STATETEXT"];
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"country_name"] forKey:@"COUNTRYTEXT"];
    [tempLoc setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"status"] forKey:@"status"];
    NSArray *lat_long=[[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"location_latlong"] componentsSeparatedByString:@","];
    [tempLoc setValue:[lat_long objectAtIndex:1] forKey:@"LONGITUDE"];
    [tempLoc setValue:[lat_long objectAtIndex:0] forKey:@"LATITUDE"];
    [ItemDetails sharedInstance].dicLocDetail=tempLoc;
    //[lat_long release];
    [tempLoc release];
    
    
    
    NSMutableDictionary *tempPrice=[[NSMutableDictionary alloc]init];
    [tempPrice setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"price"] forKey:@"Price"];
    [tempPrice setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"postage"] forKey:@"Postage"];
    [tempPrice setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"postagetype_id"] forKey:@"PostageType"];
    [tempPrice setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"paymenttype_id"] forKey:@"PaymentType"];
    [tempPrice setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"postagetype_name"] forKey:@"PostageText"];

    [ItemDetails sharedInstance].dicPriceDetail=tempPrice;
    [tempPrice release];

    
    NSMutableDictionary *tempCategory=[[NSMutableDictionary alloc]init];
    [tempCategory setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"category_name"] forKey:@"category_name"];
    [tempCategory setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"category_id"] forKey:@"id"];
    
    
    [ItemDetails sharedInstance].dicCategoryDetail=tempCategory;
    [tempCategory release];
    [ItemDetails sharedInstance].isEditing=YES;
    
    NSMutableDictionary *otherDetails=[[NSMutableDictionary alloc]init];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"title"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"pic_path"] forKey:@"pic_path"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"pic_path2"] forKey:@"pic_path2"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"pic_path3"] forKey:@"pic_path3"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"default_pic"] forKey:@"default_pic"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"category_id"] forKey:@"category_id"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"desc"] forKey:@"desc"];
    [otherDetails setValue:[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"item_id"];

    [ItemDetails sharedInstance].dicOtherdetails=otherDetails;

  //  sellItem.dicItemDetails=otherDetails;
    [otherDetails release];
   // sellItem.dicItemDetails = [arrSearchItem objectAtIndex:indexPath.row];
    //[self.navigationController pushViewController:sellItem animated:YES];

}

#pragma - mark TextView Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark --
#pragma mark UISearchBar method

// End search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1

{
	searchBar1.showsCancelButton = YES;
	searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
	[tblItemList reloadData];
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1

{
    //	CGRect make=searchBar1.frame;
    //    make.size.width=290;
    //    searchBar1.frame=make;
    //    [searchBarView addSubview:remainingSearchSpace];
	searchBar1.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    
    //[searchText isEqualToString:@""];
    
	if([searchBar1.text isEqualToString:@""]||searchBar1.text==nil){
		self.arrSearchItem=[[NSMutableArray alloc]initWithArray:self.arrSearchItemCopy];
        
        
        //		tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
        [tblItemList reloadData];
	}
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:YES];
    for (UIView *subview in searchBar1.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            int64_t delayInSeconds = .001;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                
                UIButton * cancelButton = (UIButton *)subview;
                [cancelButton setHidden:NO];
                [cancelButton setEnabled:YES];
                
            });
        }
    }
    [searchBar1 resignFirstResponder];
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *searchText = [searchBar1.text stringByReplacingCharactersInRange:range withString:text];
    NSMutableArray *searchWordsArr = [[NSMutableArray alloc] init];
    NSString *newStr1= [searchText stringByReplacingOccurrencesOfString:@"," withString:@" "];
    NSMutableArray *tempArray = (NSMutableArray*)[newStr1 componentsSeparatedByString:@" "];
    for (NSString *str in tempArray) {
        NSString *tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([tempStr length])
        {
            [searchWordsArr addObject:tempStr];
        }
    }
    
    NSMutableArray *subpredicates = [NSMutableArray array];
    for(NSString *term in searchWordsArr)
    {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"title contains[cd] %@", term];
        [subpredicates addObject:p];
    }
    
    // //NSLog(@"all array %@",SharedAppDelegate.arrContacts);
    NSMutableArray *tempArry = [[NSMutableArray alloc] initWithArray:arrSearchItemCopy
                                ];
    
    NSPredicate *filter = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:[tempArry filteredArrayUsingPredicate:filter]];
    //NSLog(@"finalarray is %@",finalArray);
    self.arrSearchItem=[[NSMutableArray alloc]initWithArray:finalArray];
    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:[contactsPage contactsGrouping:finalArray]];
    [tblItemList reloadData];
    
    
    if(searchText.length==0)
    {
        ////NSLog(@"hello");
        //  ReleaseObject(namesList)
        self.arrSearchItem=[[NSMutableArray alloc]initWithArray:self.arrSearchItemCopy];
        //        tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
        [tblItemList reloadData];
        
        
        return YES;
    }
    
    return YES;
}



// Cancel search
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    searchBar1.text=@"";
    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
    self.arrSearchItem=[[NSMutableArray alloc]initWithArray:self.arrSearchItemCopy];
    [self.view endEditing:YES];
    [tblItemList reloadData];
    [searchBar1 setShowsCancelButton:NO];
	//_mySearchBar.text = @"";
}





//#pragma - mark SearchBar Delegates
//
//-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
//{
//    
//}
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    
//}
//
//- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
//{
//    
//}
//
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
//{
//    [srchBar resignFirstResponder];
//}
//
//- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar
//{
//    [srchBar resignFirstResponder];
//}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
