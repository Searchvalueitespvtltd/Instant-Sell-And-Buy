//
//  MyISBViewController.m
//  ISB
//
//  Created by AppRoutes on 19/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MyISBViewController.h"
#import "ProfileViewController.h"
#import "ItemViewController.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"
#import "Product.h"
#import "ItemDetails.h"
#import "Users.h"
#import "LastViewItems.h"

@interface MyISBViewController ()

@end

@implementation MyISBViewController


//#define WATCHING 1
//#define BUYING   2
@synthesize arrSearchItem,searchBar,tblproduct,btnBuying,btnWatching,arrSearchItemCopy,dicSearchItemImages,dicSearchItemList,btnEdit;
@synthesize isBuying;
//int buttonTouched = 0;
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
     context=[App managedObjectContext];
    self.navigationController.navigationBarHidden = YES;
    //[self.btnBuying setSelected:YES];
    
//    buttonTouched=1;
    
//    if ([isBuying isEqual:@"1"])
//    {
//        [self.btnBuying setSelected:YES];
//        [self callBuyingWebService];
//    }
//    else
//    {
//        [self.btnWatching setSelected:YES];
//        [self callWatchWebService];
//    }
    
//    [self callWatchWebService];
    
    context=[App managedObjectContext];

    self.arrSearchItem = [[NSMutableArray alloc]init];
    dicSearchItemList = [[NSMutableDictionary alloc]init];
    dicSearchItemImages = [[NSMutableDictionary alloc]init];
//    [searchBar setBackgroundImage:[UIImage new]];
//    [searchBar setTranslucent:YES];
    [HttpRequestProcessor shareHttpRequest];
    // Do any additional setup after loading the view from its nib.
}



-(void)viewWillAppear:(BOOL)animated
{
    [self fetchUserData:@"Users"];
    if (!arrSearchItem || !arrSearchItem.count){
        btnEdit.hidden=YES;
    }
    else
        btnEdit.hidden=NO;

    
    if ([ItemDetails sharedInstance].isSelected ==1)
    {
        buttonTouched=2;
        [self.btnBuying setSelected:YES];
        [self.btnWatching setSelected:NO];
        UIImage *buttonImage = [UIImage imageNamed:@"btnEdit.png"];
        [btnEdit setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        [self callBuyingWebService];
    }
    else{
        buttonTouched=1;
        [self.btnWatching setSelected:YES];
        [self.btnBuying setSelected:NO];
        UIImage *buttonImage = [UIImage imageNamed:@"btnUnwatch.png"];
        [btnEdit setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [btnEdit setTitle:nil forState:UIControlStateNormal];
        [self callWatchWebService];
    }
    [tblproduct setEditing:NO];
    self.editing=NO;
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


-(double)getDistanceFromLocA:(CLLocation *)inLocA andLocB:(CLLocation *)inLocB
{
    //    CLLocation *locA = [[CLLocation alloc] initWithLatitude:location.latitude longitude:[[StoredData sharedData]longitude]];
    //
    //    CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
    
    CLLocationDistance distance = [inLocA distanceFromLocation:inLocB];
    
    //Distance in Meters
    
    //1 meter == 100 centimeter
    
    //1 meter == 3.280 feet
    
    //1 meter == 10.76 square feet
    
    return distance;
}
- (IBAction)userProfileClick:(id)sender {
 
    ProfileViewController *profileViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iPhone5" bundle:nil];
        
    }
    else{
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil]; }
    
    [self.navigationController pushViewController:profileViewController animated:YES ];
   // [profileViewController release];

}

-(void)callWatchWebService
{
    [Utils startActivityIndicatorInView:self.view withMessage:@"Loading..."];
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"itemWatch/get_items?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)callUnwatchService
{
    
  [Utils startActivityIndicatorInView:self.view withMessage:@""];
//    NSLog(@"%@ ",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]);
    
    //    NSLog(@"%@ ",strProductId);
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"itemWatch/delete?user_id=%@&product_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[[arrSearchItem objectAtIndex:index] valueForKey:@"id"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)callUnbuyingService
{
    
    [Utils startActivityIndicatorInView:self.view withMessage:@""];
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"itemBuy/delete?user_id=%@&product_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[[arrSearchItem objectAtIndex:index] valueForKey:@"id"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)callBuyingWebService
{
    [Utils startActivityIndicatorInView:self.view withMessage:@"Loading..."];
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"itemBuy/get_items?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inReqIdentifier rangeOfString:@"itemBuy/get_items?"].length>0)
    {
        if([inResponseDic isKindOfClass:[NSArray class]])
        {
            if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {

//            is_watch=[arrSearchItem ]
          //  self.arrSearchItem = [NSMutableArray arrayWithArray:inResponseDic];
            self.arrSearchItem=nil;
            self.arrSearchItemCopy =nil;
            self.arrSearchItem = [[NSMutableArray alloc]init];
            self.arrSearchItemCopy = [[NSMutableArray alloc]init];
           
//            NSLog(@"Response is = %@",self.arrSearchItem);
            
            for (id obj in inResponseDic) {
                Product *prod=[[Product alloc]init];
                prod.id=[[obj valueForKey:@"id"] integerValue];
                prod.category_name=[obj valueForKey:@"category_name"];
                prod.created_by=[[obj valueForKey:@"created_by"] integerValue] ;

                prod.city=[obj valueForKey:@"city"];
                prod.desc=[obj valueForKey:@"desc"];
//                prod.seller_pic = [obj valueForKey:@"seller_pic"];
                prod.availability=[obj valueForKey:@"availability"];
                prod.rating_count=[obj valueForKey:@"rating_count"];
                prod.postagetype_id=[obj valueForKey:@"postagetype_id"];

                prod.paymenttype_name=[obj valueForKey:@"paymenttype_name"];
                
                if ([[obj valueForKey:@"seller_pic"] isEqual:[NSNull null]] || ![[obj valueForKey:@"seller_pic"] length]>0)
                {
                    prod.seller_pic=@"1";
                }else
                    prod.seller_pic = [obj valueForKey:@"seller_pic"];
                
                
                
                if ([[obj valueForKey:@"pic_path"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path"] length]>0)
                {
                    prod.pic_path=@"1";
                }else
                    prod.pic_path=[obj valueForKey:@"pic_path"];
                
                if ([[obj valueForKey:@"pic_path2"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path2"] length]>0) {
                    prod.pic_path2=@"1";
                }else
                    prod.pic_path2=[obj valueForKey:@"pic_path2"];
                
                if ([[obj valueForKey:@"pic_path3"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path3"] length]>0) {
                    prod.pic_path3=@"1";
                }else
                    prod.pic_path3=[obj valueForKey:@"pic_path3"];                prod.price=[obj valueForKey:@"price"];
                prod.title= [obj valueForKey:@"title"];
                prod.user_name= [obj valueForKey:@"user_name"];
                prod.postagetype_name=[obj valueForKey:@"postagetype_name"];
                prod.location_latlong= [obj valueForKey:@"location_latlong"];
                prod.postage= [obj valueForKey:@"postage"];
                prod.zipcode= [obj valueForKey:@"zipcode"];
                prod.default_pic = [obj valueForKey:@"default_pic"];               prod.is_watch=[obj valueForKey:@"is_watch"];
                prod.rating_all=[obj valueForKey:@"rating_all"];
                prod.rating_postage=[obj valueForKey:@"rating_postage"];
                prod.rating_service=[obj valueForKey:@"rating_service"];
                prod.item_code=[obj valueForKey:@"item_code"];

                prod.rating_item_as_described=[obj valueForKey:@"rating_item_as_described"];
                [self.arrSearchItem addObject:prod];
                 [self.arrSearchItemCopy addObject:prod];
                if (!arrSearchItem || !arrSearchItem.count){
                    btnEdit.hidden=YES;
                }
                else
                    btnEdit.hidden=NO;
                

            }
           // self.arrSearchItemCopy=[NSMutableArray arrayWithArray:inResponseDic];
            [self performSelector:@selector(bringImages:) withObject:self.arrSearchItem afterDelay:0];

            
            [tblproduct reloadData];

        }
        else
        {
            
           // btnEdit.hidden=YES;
            self.arrSearchItem=nil;
            self.arrSearchItemCopy =nil;
            
            if (!arrSearchItem || !arrSearchItem.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
            [tblproduct reloadData];
           [Utils showAlertView:kAlertTitle message:@"No items found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        }
    }
    else if ([inReqIdentifier rangeOfString:@"itemWatch/delete?"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            
            [self updateDatabase:@"0"];
            [arrSearchItem removeObjectAtIndex:index];
            [arrSearchItemCopy removeObjectAtIndex:index];
            if (!arrSearchItem || !arrSearchItem.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
            [tblproduct reloadData];
//            [Utils showAlertView:kAlertTitle message:@"Item added successfully in buying list" delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            if (!arrSearchItem || !arrSearchItem.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
//            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        
        
    }
    else if ([inReqIdentifier rangeOfString:@"itemBuy/delete?"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [arrSearchItem removeObjectAtIndex:index];
            [arrSearchItemCopy removeObjectAtIndex:index];
            if (!arrSearchItem || !arrSearchItem.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
            [tblproduct reloadData];

            //            [Utils showAlertView:kAlertTitle message:@"Item added successfully in buying list" delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            if (!arrSearchItem || !arrSearchItem.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
            //            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        
        
    }
else
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            
            self.arrSearchItem=nil;
            self.arrSearchItemCopy =nil;
                        self.arrSearchItem = [[NSMutableArray alloc]init];
            self.arrSearchItemCopy = [[NSMutableArray alloc]init];
//            NSLog(@"Response is = %@",self.arrSearchItem);
          //  self.arrSearchItemCopy=[NSMutableArray arrayWithArray:inResponseDic];
            for (id obj in inResponseDic) {
                Product *prod=[[Product alloc]init];
                prod.id=[[obj valueForKey:@"id"] integerValue];
                prod.category_name=[obj valueForKey:@"category_name"];
                prod.city=[obj valueForKey:@"city"];
                prod.desc=[obj valueForKey:@"desc"];
                prod.created_by=[[obj valueForKey:@"created_by"] integerValue] ;
//                prod.seller_pic = [obj valueForKey:@"seller_pic"];
                prod.availability=[obj valueForKey:@"availability"];
                prod.rating_count=[obj valueForKey:@"rating_count"];
                prod.postagetype_id=[obj valueForKey:@"postagetype_id"];


                prod.paymenttype_name=[obj valueForKey:@"paymenttype_name"];
                
                if ([[obj valueForKey:@"seller_pic"] isEqual:[NSNull null]] || ![[obj valueForKey:@"seller_pic"] length]>0)
                {
                    prod.seller_pic=@"1";
                }else
                    prod.seller_pic = [obj valueForKey:@"seller_pic"];
                
                if ([[obj valueForKey:@"pic_path"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path"] length]>0)
                {
                    prod.pic_path=@"1";
                }else
                    prod.pic_path=[obj valueForKey:@"pic_path"];
                
                if ([[obj valueForKey:@"pic_path2"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path2"] length]>0) {
                    prod.pic_path2=@"1";
                }else
                    prod.pic_path2=[obj valueForKey:@"pic_path2"];
                
                if ([[obj valueForKey:@"pic_path3"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path3"] length]>0) {
                    prod.pic_path3=@"1";
                }else
                    prod.pic_path3=[obj valueForKey:@"pic_path3"];
                prod.price=[obj valueForKey:@"price"];
                prod.title= [obj valueForKey:@"title"];
                prod.user_name= [obj valueForKey:@"user_name"];
                prod.postagetype_name=[obj valueForKey:@"postagetype_name"];
                prod.location_latlong= [obj valueForKey:@"location_latlong"];
                prod.default_pic = [obj valueForKey:@"default_pic"];
                prod.postage= [obj valueForKey:@"postage"];
                prod.zipcode= [obj valueForKey:@"zipcode"];
                prod.rating_all=[obj valueForKey:@"rating_all"];
                prod.rating_postage=[obj valueForKey:@"rating_postage"];
                prod.rating_service=[obj valueForKey:@"rating_service"];
                prod.item_code=[obj valueForKey:@"item_code"];

                prod.rating_item_as_described=[obj valueForKey:@"rating_item_as_described"];
                [self.arrSearchItem addObject:prod];
                  [self.arrSearchItemCopy addObject:prod];
                
            }
            [self performSelector:@selector(bringImages:) withObject:self.arrSearchItem afterDelay:0];
            if (!arrSearchItem || !arrSearchItem.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
            [tblproduct reloadData];
        }
    else
    {
        
        self.arrSearchItem=nil;
        self.arrSearchItemCopy =nil;
        [tblproduct reloadData];
        if (!arrSearchItem || !arrSearchItem.count){
            btnEdit.hidden=YES;
        }
        else
            btnEdit.hidden=NO;
        [Utils showAlertView:kAlertTitle message:@"No items found." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    }
}


-(void)updateDatabase :(NSString *)isWatch{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"LastViewItems" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [[arrSearchItem objectAtIndex:index] valueForKey:@"id"]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if ([results count]!=0)
    {
    LastViewItems* favoritsGrabbed = [results objectAtIndex:0];
    favoritsGrabbed.is_watch = isWatch;
    if (![context save:&error])
    {
        //NSLog(@"ERROR--%@",error);
        abort();
    }
    }
    
}



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
            [tblproduct reloadData];
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

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}


- (IBAction)editBtnClick:(id)sender {
    
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [tblproduct setEditing:NO animated:NO];
        [tblproduct reloadData];
        if(buttonTouched==2)
        {
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
        }
        else
        {
            UIImage *buttonImage = [UIImage imageNamed:@"btnUnwatch.png"];
            [btnEdit setBackgroundImage:buttonImage forState:UIControlStateNormal];
            [btnEdit setTitle:nil forState:UIControlStateNormal];
            
        }
    }
    else
    {
        [super setEditing:YES animated:YES];
        [tblproduct setEditing:YES animated:YES];
        [tblproduct reloadData];
        if(buttonTouched==2)
        {
            [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
        }
        else
        {
            UIImage *buttonImage = [UIImage imageNamed:@"btnEdit.png"];
            [btnEdit setBackgroundImage:buttonImage forState:UIControlStateNormal];
            [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
        
        }
        
        //        [self saveToDatabase];
    }

    
}

- (IBAction)watchingProductClick:(id)sender {
    buttonTouched=1;
    [btnEdit setTitle:nil forState:UIControlStateNormal];
    UIImage *buttonImage = [UIImage imageNamed:@"btnUnwatch.png"];
    [btnEdit setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [tblproduct setEditing:NO animated:YES];
    [self.btnWatching setSelected:YES];
    [self.btnBuying setSelected:NO];
    [self callWatchWebService];
}
- (IBAction)buyingProductClick:(id)sender {
    buttonTouched=2;
    UIImage *buttonImage = [UIImage imageNamed:@"btnEdit.png"];
    [btnEdit setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    [tblproduct setEditing:NO animated:YES];

    [self.btnBuying setSelected:YES];
    [self.btnWatching setSelected:NO];
    [self callBuyingWebService];
}

#pragma mark fetch images

//-(void)bringImages:(NSArray *)inResponseDic
//{
//    for (int i=0;i<[inResponseDic count];i++)
//    {
//        Product *temp=[inResponseDic objectAtIndex:i];
//        [self doFetchEditionImage:temp.pic_path withIndex:temp.id];
//        
//    }
//}

#pragma mark UISearchBar method

// End search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1

{
	searchBar1.showsCancelButton = YES;
	searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
//	[tblproduct reloadData];
    
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
        [tblproduct reloadData];
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
    NSMutableArray *tempArry = [[NSMutableArray alloc] initWithArray:arrSearchItemCopy];
    
    NSPredicate *filter = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:[tempArry filteredArrayUsingPredicate:filter]];
    //NSLog(@"finalarray is %@",finalArray);
    self.arrSearchItem=[[NSMutableArray alloc]initWithArray:finalArray];
    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:[contactsPage contactsGrouping:finalArray]];
    [tblproduct reloadData];
    
    
    if(searchText.length==0)
    {
        ////NSLog(@"hello");
        //  ReleaseObject(namesList)
        self.arrSearchItem=[[NSMutableArray alloc]initWithArray:self.arrSearchItemCopy];
        //        tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
        [tblproduct reloadData];
        
        
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
    [tblproduct reloadData];
    [searchBar1 setShowsCancelButton:NO];
	//_mySearchBar.text = @"";
	
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.arrSearchItem count];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (buttonTouched==1) {
        return @"Unwatch";
    }
    else
        return @"Delete";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CellHomeAppliances" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    
    UIImageView *couponImage = (UIImageView *)[cell.contentView viewWithTag:100];
    Product *prod=[self.arrSearchItem objectAtIndex:indexPath.row];
    
    if(prod.image != nil)
    {
        couponImage.image  = prod.image;
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
        indicator.hidden=YES;
    }
    
    
//    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageURL,[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"pic_path"]];
    
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imgUrl]];
//    if (![imageData isEqual: [NSNull null]]) {
//        couponImage.image = [UIImage imageWithData:imageData];
//    }
    UILabel *userName = (UILabel *)[cell.contentView viewWithTag:500];
    userName.text=[prod valueForKey:@"user_name"];
    int count=0;
    if (![[prod valueForKey:@"rating_all"] isEqual:[NSNull null]] ) {
        count=[[prod valueForKey:@"rating_all"] integerValue];
    }
    
    for (int i=1; i<=count; i++) {
        UIButton *but=(UIButton *)[cell.contentView viewWithTag:500 + i];
        [but setSelected:YES];
    }

    UILabel *itemDescription = (UILabel *)[cell.contentView viewWithTag:101];
    
    cell.selectedBackgroundView = selectionColor;
    
      itemDescription.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
    itemDescription.text = [[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"title"];
    NSString *mystring = [[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"location_latlong"];
    itemDescription.highlightedTextColor = [UIColor blackColor];
    double currlat = [[[StoredData sharedData] latitude] doubleValue];
    double currlong = [[[StoredData sharedData] longitude] doubleValue];
    
    CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:currlat longitude:currlong];
    //         NSString *mystring = [self.arrSearchItem valueForKey:@"location_latlong"];
    
    NSArray *ary = [mystring componentsSeparatedByString:@","];
    double servlat = [[ary objectAtIndex:0]doubleValue];
    double servlong = [[ary objectAtIndex:1]doubleValue];
    CLLocation *serverLocation = [[CLLocation alloc] initWithLatitude:servlat longitude:servlong];
//    NSLog(@"servlat :%f",servlat);
//    NSLog(@"servlong :%f",servlong);
//    NSLog(@"currlat :%f",currlat);
//    NSLog(@"currlong :%f",currlong);
    //    double disTanceInKm = [self getDistanceFromLocA:currLocation andLocB:serverLocation];
    
    UIImageView *statusImage=(UIImageView *)[cell.contentView viewWithTag:5555];
    if ([[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"availability"] isEqualToString:@"SOLD"]) {
        statusImage.image=[UIImage imageNamed:@"IsbSold.png"];
        
    }else if ([[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"availability"] isEqualToString:@"AVAILABLE"]){
        statusImage.image=nil;
        
    }else{
        statusImage.image=[UIImage imageNamed:@"IsbOffermade.png"];
        
    }
    
    UILabel *itemLoc = (UILabel *)[cell.contentView viewWithTag:102];
    
    itemLoc.font = [UIFont fontWithName:@"Avenir Next Condensed" size:12.0];
    //    itemLoc.text = [NSString stringWithFormat:@"$%@",[[self.arrSearchItem profileobjectAtIndex:indexPath.row]valueForKey:@"loc"]];
    
    mDistance = [self getDistanceFromLocA:currLocation andLocB:serverLocation];
    if (mDistance >= 0)
    {
        mDistance  = mDistance/1000 ;
    //    NSLog(@"km:%f",mDistance);
        //mLblDistance.text = [NSString stringWithFormat:@"%.3f",mDistance];
    }
    
    itemLoc.text =[NSString stringWithFormat:@"%.2fKm",mDistance];
    
    itemLoc.highlightedTextColor = [UIColor blackColor];
  strProductId = [[arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"id"];
    
    UILabel *itemPrice = (UILabel *)[cell.contentView viewWithTag:103];
    
    itemPrice.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
    itemPrice.text = [NSString stringWithFormat:@"%@",[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"price"]];
    itemPrice.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
         strProductId=[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"id"];
       
        index = indexPath.row;

//        [arrSearchItem removeObjectAtIndex:indexPath.row];
//        [arrSearchItemCopy removeObjectAtIndex:indexPath.row];
        [tblproduct reloadData];
    }
    if (buttonTouched==1) {
        alertDelete = [[UIAlertView alloc]initWithTitle:kAlertTitle message:@"Do you really want to unwatch this item?" delegate:self
                                      cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
    }
    else{
    alertDelete = [[UIAlertView alloc]initWithTitle:kAlertTitle message:@"Do you really want to delete this item?" delegate:self
                                  cancelButtonTitle:@"YES" otherButtonTitles:@"NO",nil];
    }
    
    [alertDelete show];
    [alertDelete release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==alertDelete)
    {
        if (buttonIndex == 0)
        {
            switch(buttonTouched)
            {
                case 1:
                    [self callUnwatchService];
                    break;
                case 2:
                    [self callUnbuyingService];
                    break;
            }            //

        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchBar resignFirstResponder];
    
    ItemViewController *itemDetailView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    }
    //    NSString *strTemp;
    //    strTemp = [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"id"];
    if ([btnBuying isSelected]) {
        itemDetailView.isWatching = [[[arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"is_watch"]integerValue];
    }else{
    itemDetailView.isWatching = 1;
    }
    itemDetailView.dicItemDetails = [arrSearchItem objectAtIndex:indexPath.row];
    //     [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self.navigationController pushViewController:itemDetailView animated:YES ];
    
  //  [itemDetailView release];
    
    
    
    //    self.dicSelectCategory = [arrCategory objectAtIndex:indexPath.row];
    //    indexpathrow = indexPath.row;
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)dealloc {
//    [UISearchBar release];
//    [tblproduct release];
//    [btnWatching release];
//    [btnBuying release];
//    [super dealloc];
//}
@end
