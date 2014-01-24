//
//  HomeAppliancesViewController.m
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "HomeAppliancesViewController.h"
#import "ItemViewController.h"
#import "Product.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"
#import "SaveSearchViewController.h"
#import "LastViewItems.h"
#import "Defines.h"
#import "ItemDetails.h"
@interface HomeAppliancesViewController ()
{
    bool alertShowing;
}
@property(assign,nonatomic) bool alertShowing;


@end

@implementation HomeAppliancesViewController
@synthesize txtSearch,tblSearchResult;
@synthesize srchBar;
@synthesize alertShowing;
@synthesize arrSearchItem,arrSearchItemCopy,arrSaveItem;
@synthesize dicSearchItemImages;//,dicSearchItemList;
@synthesize strCategoryID,strViewTitle,strViewHeading;
@synthesize lblViewTitle;
@synthesize isFromSavedSearch;


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
    
    if (strViewHeading)
    {
        self.lblViewTitle.text = [NSString stringWithFormat:@"%@",strViewHeading];
        btnSaveSearch.hidden = YES;
    }
    else if (self.isFromNearBy){
        self.lblViewTitle.text = [NSString stringWithFormat:@"%@",self.strHeading];
        btnSaveSearch.hidden = NO;    }
    else
    {
        self.lblViewTitle.text = [NSString stringWithFormat:@"%@",strViewTitle];
        btnSaveSearch.hidden = NO;
    }
//    self.arrSearchItem = [[NSMutableArray alloc]init];
//    self.arrSaveItem = [[NSMutableArray alloc]init];
    dicSearchItemList = [[NSMutableDictionary alloc]init];
    dicSearchItemImages = [[NSMutableDictionary alloc]init];
    [srchBar setBackgroundImage:[UIImage new]];
    [srchBar setTranslucent:YES];
    [HttpRequestProcessor shareHttpRequest];
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    [self callWebService];
//    NSLog(@"category id = %@",self.strCategoryID);
    i=0;
    j=0;
    
    
    arrSaveData = [[NSMutableArray alloc]init];
    context=[App managedObjectContext];

    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 44.0, 320, 44.0)];
    searchBar.delegate = self;
    searchBar.tintColor = [UIColor blackColor];
     [self.view addSubview:searchBar];
    [ItemDetails sharedInstance].isSelected =0;

    if (isFromSavedSearch)
    {
        btnSaveSearch.hidden = YES;
        isFromSavedSearch = NO;
    }
    
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    if (strViewHeading)
    {
        [self callSearchWebService];
    }else if (self.isFromNearBy){
        [self callSearchNearByWebService];
    }
    else
    {
        [self callWebService];
    }
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.tblSearchResult.frame = CGRectMake(0, 113, 320, self.view.frame.size.height-163);
    }
    else
    {
        self.tblSearchResult.frame = CGRectMake(0, 112, 320, self.view.frame.size.height-163);
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [Utils stopActivityIndicatorInView:self.view];
    [super viewWillDisappear:YES];
}

#pragma  - mark Call Webservice

-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
//    [objService sendRequestToServer:@"items/get?category_id=1&status=1" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/get?category_id=%@&status=1&watch_user_id=%@",self.strCategoryID,[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    //    [objService sendRequestToServer:[NSString stringWithFormat:@"items/get?status=1",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)callSearchWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/search?q=%@",strViewHeading] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
//    http://chat.eitcl.co.uk/devchat/index.php/items/searchlatlong?q=rusty&slat=28.4302371&slong=77.8595962d&skm=10
}
-(void)callSearchNearByWebService
{
   
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/searchlatlong?q=%@&slat=%@&slong=%@&skm=10",self.strHeading,self.latt,self.longg] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            self.arrSaveItem = [NSMutableArray arrayWithArray:inResponseDic];
            
            self.arrSearchItem = [[NSMutableArray alloc]init];
            for (id obj in inResponseDic) {
                Product *prod=[[Product alloc]init];
                prod.id=[[obj valueForKey:@"id"] integerValue];
                prod.category_name=[obj valueForKey:@"category_name"];
                prod.city=[obj valueForKey:@"city"];
                prod.desc=[obj valueForKey:@"desc"];
                prod.rating_count=[obj valueForKey:@"rating_count"];
                prod.paymenttype_name=[obj valueForKey:@"paymenttype_name"];
                prod.paymenttype_id = [obj valueForKey:@"paymenttype_id"];
                prod.availability=[obj valueForKey:@"availability"];
                prod.postagetype_id = [obj valueForKey:@"postagetype_id"];
//                prod.seller_pic = [obj valueForKey:@"seller_pic"];
                if ([[obj valueForKey:@"seller_pic"] isEqual:[NSNull null]] || ![[obj valueForKey:@"seller_pic"] length]>0)
                {
                    prod.seller_pic=@"1";
                }else
                    prod.seller_pic = [obj valueForKey:@"seller_pic"];
             //   prod.pic_path=[obj valueForKey:@"pic_path"];
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
                prod.postage= [obj valueForKey:@"postage"];
                prod.zipcode= [obj valueForKey:@"zipcode"];
                prod.is_watch=[obj valueForKey:@"is_watch"];
                prod.sender_email = [obj valueForKey:@"sender_email"];
                prod.default_pic = [obj valueForKey:@"default_pic"];
                prod.created_by = [[obj valueForKey:@"created_by"] integerValue];
                prod.item_code=[obj valueForKey:@"item_code"];
                
                prod.rating_all=[obj valueForKey:@"rating_all"];
                prod.rating_postage=[obj valueForKey:@"rating_postage"];
                prod.rating_service=[obj valueForKey:@"rating_service"];
                prod.rating_item_as_described=[obj valueForKey:@"rating_item_as_described"];

                [self.arrSearchItem addObject:prod];
            }
//            self.arrSearchItem = [NSMutableArray arrayWithArray:inResponseDic];
            self.arrSearchItemCopy=[NSMutableArray arrayWithArray:self.arrSearchItem];
            [self performSelector:@selector(bringImages:) withObject:self.arrSearchItem afterDelay:0];
//            NSLog(@"Response is = %@",self.arrSearchItem);
            [tblSearchResult reloadData];
           }
        else
        {
            
            if(self.alertShowing==NO)
            {
                [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                self.alertShowing = YES;
            }
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.alertShowing = NO;
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
//            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
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
        [self.tblSearchResult reloadData];
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


#pragma mark --
#pragma mark UISearchBar method

// End search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1

{
	searchBar1.showsCancelButton = YES;
	searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
	[tblSearchResult reloadData];

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
        [tblSearchResult reloadData];
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
    [tblSearchResult reloadData];
    
    
    if(searchText.length==0)
    {
        ////NSLog(@"hello");
        //  ReleaseObject(namesList)
        self.arrSearchItem=[[NSMutableArray alloc]initWithArray:self.arrSearchItemCopy];
//        tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
        [tblSearchResult reloadData];
  
        
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
    [tblSearchResult reloadData];
    [searchBar1 setShowsCancelButton:NO];
	//_mySearchBar.text = @"";
	
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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 250, 20)];
    label.font = [UIFont fontWithName:@"Avenir Next Condensed" size:13.0];
    NSString *string;
    if (strViewHeading)
    {
        string = [NSString stringWithFormat:@"%d Items found in %@",[self.arrSearchItem count],strViewHeading];
    }else if (self.isFromNearBy){
        string = [NSString stringWithFormat:@"%d Items found in your location",[self.arrSearchItem count]];
    }
    else
    {
        string = [NSString stringWithFormat:@"%d Items found in %@",[self.arrSearchItem count],strViewTitle];
    }
    
//    NSString *string = [NSString stringWithFormat:@"%d Items found in %@",[self.arrSearchItem count],strViewTitle];
    
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
//    UIImageView *imgholder = [[UIImageView alloc] initWithFrame:CGRectMake(294, 2, 17, 17)];
//    UIImage *img = [UIImage imageNamed:@"iconImageView.png"];
//    imgholder.image=img;
//    [view addSubview:imgholder];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom]; //3
//    [button setFrame:CGRectMake(294, 2, 17, 17 )];
//    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];//2
//    [view addSubview:button];
    
    /* Section header is in 0th index... */
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithRed:166/255.0 green:177/255.0 blue:186/255.0 alpha:1.0]]; //your background color...
    
    return view;

}
//- (void)buttonPressed:(UIButton *)sender{
//    NSLog(@"hi");

//}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSearchItem count];
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
    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageURL,[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"pic_path"]];
    
    Product *prod=[self.arrSearchItem objectAtIndex:indexPath.row];
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
    if(prod.image != nil)
    {
        couponImage.image  = prod.image;
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
        indicator.hidden=YES;
    }
    else
    {
        
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        
//        [data setObject:imgUrl forKey:@"ImageUrl"];
//        [data setObject:indexPath forKey:@"IndexPath"];
//        [data setObject:[[self.arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"id"] forKey:@"id"];
        if ([imgUrl isEqualToString:@"0"]) {
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
            indicator.hidden=YES;
        }
        else {
            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
            indicator.hidden=NO;
//            [self performSelectorInBackground:@selector(fetchImage:) withObject:data];
        }
        
       // [data release];
    }
    
    UIImageView *statusImage=(UIImageView *)[cell.contentView viewWithTag:5555];
    if ([[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"availability"] isEqualToString:@"SOLD"]) {
        statusImage.image=[UIImage imageNamed:@"IsbSold.png"];
        
    }else if ([[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"availability"] isEqualToString:@"AVAILABLE"]){
        statusImage.image=nil;
        
    }else{
        statusImage.image=[UIImage imageNamed:@"IsbOffermade.png"];

    }
    
    
    UILabel *itemDescription = (UILabel *)[cell.contentView viewWithTag:101];
    
    cell.selectedBackgroundView = selectionColor;
    
    // added by chetan ..
    
    //    if (![self.arrItemList count] == 0)
    //    {
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
    
    UILabel *itemLoc = (UILabel *)[cell.contentView viewWithTag:102];
    
    itemLoc.font = [UIFont fontWithName:@"Avenir Next Condensed" size:12.0];
    //    itemLoc.text = [NSString stringWithFormat:@"$%@",[[self.arrSearchItem profileobjectAtIndex:indexPath.row]valueForKey:@"loc"]];
    
    mDistance = [self getDistanceFromLocA:currLocation andLocB:serverLocation];
    if (mDistance >= 0)
    {
        mDistance  = mDistance/1000 ;
//        NSLog(@"km:%f",mDistance);
        //mLblDistance.text = [NSString stringWithFormat:@"%.3f",mDistance];
    }

    itemLoc.text =[NSString stringWithFormat:@"%.2fKm",mDistance];
    
    itemLoc.highlightedTextColor = [UIColor blackColor];
    
    
    UILabel *itemPrice = (UILabel *)[cell.contentView viewWithTag:103];

    itemPrice.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
    itemPrice.text = [NSString stringWithFormat:@"%@",[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"price"]];
    itemPrice.highlightedTextColor = [UIColor whiteColor];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [searchBar resignFirstResponder];

    [self fetchData:[arrSaveItem objectAtIndex:indexPath.row]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
               [self performSelector:@selector(saveToDatabase:) withObject:[arrSaveItem objectAtIndex:indexPath.row]];
        dispatch_async(dispatch_get_main_queue(), ^{
                        
        });
    });
    
    ItemViewController *itemDetailView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    }
    
    itemDetailView.dicItemDetails = [arrSearchItem objectAtIndex:indexPath.row];
    itemDetailView.isWatching=[[[arrSearchItem objectAtIndex:indexPath.row] valueForKey:@"is_watch"] integerValue];

    [self.navigationController pushViewController:itemDetailView animated:YES ];
    
    [itemDetailView release];
    
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
        
        profilePic = [[[UIImage alloc] initWithData:data] autorelease];
//        NSLog(@"%d",i++);
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
            

            UITableViewCell *cell = [self.tblSearchResult cellForRowAtIndexPath:indexPath];
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


#pragma mark - Button Methods

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

//////////////////////////////////////////////////////////////////////////////

-(IBAction)btnFavClicked:(id)sender
{
    SaveSearchViewController *saveSearch = [[SaveSearchViewController alloc]init];
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        saveSearch=[[SaveSearchViewController alloc] initWithNibName:@"SaveSearchViewController_iPhone5" bundle:nil];
    }
    else
    {
        saveSearch=[[SaveSearchViewController alloc] initWithNibName:@"SaveSearchViewController" bundle:nil];
    }
   
    saveSearch.strCategoryId = self.strCategoryID;
    saveSearch.strCategoryName = self.strViewTitle;
    
    [searchBar resignFirstResponder];
    
    [self.navigationController pushViewController:saveSearch animated:YES];
    
}

//////////////////////////////////////////////////////////////////////////////

-(IBAction)btnSearchCancelClicked:(id)sender
{
//    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Save Data From Core Data
-(void)saveToDatabase:(NSMutableArray *)arrData
{
//    arrSaveData = [NSMutableArray arrayWithArray:arrData];
    LastViewItems *lastViewed = (LastViewItems *)[NSEntityDescription insertNewObjectForEntityForName:@"LastViewItems" inManagedObjectContext:context];
    
    
    if (![[arrData valueForKey:@"country_id"] isEqual:[NSNull null]])
    {
        [lastViewed setCountry_id:[arrData valueForKey:@"country_id"]];
    }
    
    if (![[arrData valueForKey:@"sender_email"] isEqual:[NSNull null]])
    {
        [lastViewed setSender_email:[arrData valueForKey:@"sender_email"]];
    }
    if (![[arrData valueForKey:@"is_watch"] isEqual:[NSNull null]])
    {
        [lastViewed setIs_watch:[arrData valueForKey:@"is_watch"]];
    }
    if (![[arrData valueForKey:@"default_pic"] isEqual:[NSNull null]])
    {
        [lastViewed setDefault_pic:[arrData valueForKey:@"default_pic"]];
    }
    
    if (![[arrData valueForKey:@"country_name"] isEqual:[NSNull null]])
    {
        [lastViewed setCountry_name:[arrData valueForKey:@"country_name"]];
    }
    if (![[arrData valueForKey:@"home_addr"] isEqual:[NSNull null]])
    {
        [lastViewed setHome_addr:[arrData valueForKey:@"home_addr"]];
    }
    if (![[arrData valueForKey:@"item_code"] isEqual:[NSNull null]])
    {
        [lastViewed setItem_code:[arrData valueForKey:@"item_code"]];
    }
    if (![[arrData valueForKey:@"last_modified_by"] isEqual:[NSNull null]])
    {
        [lastViewed setLast_modified_by:[arrData valueForKey:@"last_modified_by"]];
    }
    if (![[arrData valueForKey:@"last_modified_dt"] isEqual:[NSNull null]])
    {
        [lastViewed setLast_modified_dt:[arrData valueForKey:@"last_modified_dt"]];
    }
    if (![[arrData valueForKey:@"state_id"] isEqual:[NSNull null]])
    {
        [lastViewed setState_id:[arrData valueForKey:@"state_id"]];
    }
    if (![[arrData valueForKey:@"state_name"] isEqual:[NSNull null]])
    {
        [lastViewed setState_name:[arrData valueForKey:@"state_name"]];
    }

    [lastViewed setAvailability:[arrData valueForKey:@"availability"]];
    [lastViewed setRating_all:[arrData valueForKey:@"rating_all"]];
    [lastViewed setRating_count:[arrData valueForKey:@"rating_count"]];
    [lastViewed setRating_item_as_described:[arrData valueForKey:@"rating_item_as_described"]];
    [lastViewed setRating_postage:[arrData valueForKey:@"rating_postage"]];
    [lastViewed setRating_service:[arrData valueForKey:@"rating_service"]];

    
    
    [lastViewed setCategory_id:[arrData valueForKey:@"category_id"]];
    [lastViewed setCategory_name:[arrData valueForKey:@"category_name"]];
    [lastViewed setCity:[arrData valueForKey:@"city"]];

    [lastViewed setCreated_by:[arrData valueForKey:@"created_by"]];
    [lastViewed setCreated_dt:[arrData valueForKey:@"created_dt"]];
    [lastViewed setDesc:[arrData valueForKey:@"desc"]];

    [lastViewed setId:[arrData valueForKey:@"id"]];
    if ([[arrData valueForKey:@"seller_pic"] isEqual:[NSNull null]] || ![[arrData valueForKey:@"seller_pic"] length]>0)
    {
        [lastViewed setSeller_pic:@"1"];
    }else
    [lastViewed setSeller_pic:[arrData valueForKey:@"seller_pic"]];
    [lastViewed setLocation_latlong:[arrData valueForKey:@"location_latlong"]];
    [lastViewed setPaymenttype_id:[arrData valueForKey:@"paymenttype_id"]];
    [lastViewed setPaymenttype_name:[arrData valueForKey:@"paymenttype_name"]];
       [lastViewed setDefault_pic:[arrData valueForKey:@"default_pic"]];
    if ([[arrData valueForKey:@"default_pic"]isEqual:[NSNull null]])
    {
        if (![[arrData valueForKey:@"pic_path"] isEqual:[NSNull null]])
        {
            NSString *imagepath = [arrData valueForKey:@"pic_path"];
            NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
            [lastViewed setItemImage:imageData];
        }
    }
    else
    {
    
    if ([[arrData valueForKey:@"default_pic"]isEqualToString:@"1"])
    {
        if (![[arrData valueForKey:@"pic_path"] isEqual:[NSNull null]])
        {
            NSString *imagepath = [arrData valueForKey:@"pic_path"];
            NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
            [lastViewed setItemImage:imageData];
        }
    }
   else if ([[arrData valueForKey:@"default_pic"]isEqualToString:@"2"])
    {
        if (![[arrData valueForKey:@"pic_path2"] isEqual:[NSNull null]])
        {
            NSString *imagepath = [arrData valueForKey:@"pic_path2"];
            NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
            [lastViewed setItemImage2:imageData];
        }
    }
    else if ([[arrData valueForKey:@"default_pic"]isEqualToString:@"3"])
    {
        if (![[arrData valueForKey:@"pic_path3"] isEqual:[NSNull null]])
        {
            NSString *imagepath = [arrData valueForKey:@"pic_path3"];
            NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
            
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
            [lastViewed setItemImage3:imageData];
        }
    }
    else
    {
        NSString *imagepath = [arrData valueForKey:@"pic_path"];
        NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
        
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
        [lastViewed setItemImage:imageData];
    
    }
    }
    if (![[arrData valueForKey:@"pic_path"] isEqual:[NSNull null]])
    {
        [lastViewed setPic_path:[arrData valueForKey:@"pic_path"]];
    }
    if (![[arrData valueForKey:@"pic_path2"] isEqual:[NSNull null]])
    {
        [lastViewed setPic_path2:[arrData valueForKey:@"pic_path2"]];   
    }
    if (![[arrData valueForKey:@"pic_path3"] isEqual:[NSNull null]])
    {
        [lastViewed setPic_path3:[arrData valueForKey:@"pic_path3"]]; 
    }

//    if ([[arrData valueForKey:@"pic_path"] isEqual:[NSNull null]])
//    {
//        [lastViewed setPic_path:@"1"];
//    }
//    else
//    {
//         [lastViewed setPic_path:[arrData valueForKey:@"pic_path"]];
//    }
//    
//    if ([[arrData valueForKey:@"pic_path2"] isEqual:[NSNull null]])
//    {
//        [lastViewed setPic_path:@"1"];
//    }
//    else
//    {
//        [lastViewed setPic_path:[arrData valueForKey:@"pic_path2"]];
//    }
//
//    if ([[arrData valueForKey:@"pic_path3"] isEqual:[NSNull null]] )
//    {
//        [lastViewed setPic_path:@"1"];
//    }
//    else
//    {
//        [lastViewed setPic_path:[arrData valueForKey:@"pic_path3"]];
//    }
    
    [lastViewed setPostage:[arrData valueForKey:@"postage"]];
    [lastViewed setPostagetype_id:[arrData valueForKey:@"postagetype_id"]];
    [lastViewed setPostagetype_name:[arrData valueForKey:@"postagetype_name"]];
    [lastViewed setPrice:[arrData valueForKey:@"price"]];

    [lastViewed setStatus:[arrData valueForKey:@"status"]];
    [lastViewed setTitle:[arrData valueForKey:@"title"]];
    [lastViewed setUser_name:[arrData valueForKey:@"user_name"]];
    [lastViewed setZipcode:[arrData valueForKey:@"zipcode"]];
    [lastViewed setUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [lastViewed setItem_code:[arrData valueForKey:@"item_code"]];

    NSError *error;
    if (![context save:&error])
    {
        //NSLog(@"ERROR--%@",error);
        abort();
    }
}

#pragma mark - Fetch Data From Core Data
-(void)fetchData:(NSMutableArray *)arrData
{  
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LastViewItems" inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSPredicate *pred1 =
    [NSPredicate predicateWithFormat:@"(id LIKE[c] %@)",[arrData valueForKey:@"id"]];
    
    NSPredicate *pred2 =
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    
    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred1,pred2, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    
    // Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
    if (mutableFetchResults.count>0)
    {
        [self delete:mutableFetchResults];
    }
    
}

#pragma mark - Delete Data In Core Data
-(void)delete:(NSMutableArray*)arrDeleteItem
{
    //EMPTY GROUP TABLE
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LastViewItems" inManagedObjectContext:context];

    // Optionally add an NSPredicate if you only want to delete some of the objects.

    [request setEntity:entity];
    
    NSPredicate *pred1 =
    [NSPredicate predicateWithFormat:@"(id LIKE[c] %@)",[[arrDeleteItem objectAtIndex:0]valueForKey:@"id"]];
    
    NSPredicate *pred2 =
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];

    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred1,pred2, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:request error:nil];
    NSError *error=nil;
    for (LastViewItems *objectToDelete in myObjectsToDelete)
    {
        [context deleteObject:objectToDelete];

        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
//    arrSaveData=myObjectsToDelete;
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
