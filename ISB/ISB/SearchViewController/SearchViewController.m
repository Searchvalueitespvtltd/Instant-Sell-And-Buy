//
//  SearchViewController.m
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SearchViewController.h"
#import "CategoryViewController.h"
#import "SavedSearchesViewController.h"
#import "HomeAppliancesViewController.h"
#import "RecentSearch.h"
#import "NearByViewController.h"
@interface SearchViewController ()
{
    bool alertShowing;
}
@property(assign,nonatomic) bool alertShowing;

@end

@implementation SearchViewController
@synthesize tblSearchResult,txtSearch;
@synthesize srchBar;
@synthesize alertShowing;

@synthesize arrSearchItem;
@synthesize dicSearchItemImages,dicSearchItemList;

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
    self.navigationController.navigationBarHidden=YES;
    context=[App managedObjectContext];
 arrSearchItem = [[NSMutableArray alloc]init];
     arrSearchItemCopy = [[NSMutableArray alloc]init];
    searchResults=[[NSArray alloc]init];
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    dicSearchItemList = [[NSMutableDictionary alloc]init];
    dicSearchItemImages = [[NSMutableDictionary alloc]init];
//    [self callWebService];

    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [ItemDetails sharedInstance].isSelected =0;

        [self fetchData:@"RecentSearch"];
    if (!arrSearchItem || !arrSearchItem.count){
        btnClear.hidden=YES;
    }
    else
        btnClear.hidden=NO;
    
    [tblSearchResult reloadData];
     [super viewWillAppear:YES];
}

//-(void)fetchData:(NSString *)tableName
//{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
//    
//	// Setup the fetch request
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	[request setEntity:entity];
//    NSPredicate *pred =
//    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
//     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
//    [request setPredicate:pred];
//    
//    
//    // Fetch the records and handle an error
//	NSError *error;
//	NSMutableArray *mutableFetchResults = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
//    ////NSLog(@"Fetched:%@",mutableFetchResults);
//    
//	if (!mutableFetchResults)
//	{
//		//NSLog(@"Cant Fetch");
//	}
//    if([tableName isEqualToString:@"RecentSearch"])
//    {
//        for(RecentSearch *ev in mutableFetchResults)
//        {
//           // arrSearchItem = mutableFetchResults;
//            [arrSearchItem addObject: ev];
//        }
//    }
//    [tblSearchResult reloadData];
//}

#pragma mark - Fetch Data From Core Data
-(void)fetchData:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
    
    // Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
    arrSearchItem=nil;
    arrSearchItemCopy=nil;
    arrSearchItem=[[NSMutableArray alloc]init];
    arrSearchItemCopy=[[NSMutableArray alloc]init];
    
	if (!mutableFetchResults)
	{
		//NSLog(@"Cant Fetch");
	}
    if([tableName isEqualToString:@"RecentSearch"])
    {
        for(RecentSearch *ev in mutableFetchResults)
        {
            arrSearchItem = mutableFetchResults;
        }
    }
    arrSearchItemCopy=[NSMutableArray arrayWithArray:arrSearchItem];
    //    [tblSavedSearchList reloadData];
}
- (IBAction)BtnClearClick:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"ISB" message:@"Tap Continue to clear Recent Searches" delegate:self
 cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [alert show];
   // [alert release];

     
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"working");
        [self delete];
        btnClear.hidden=YES;
        [tblSearchResult reloadData];
           }
}
//#pragma mark - Delete Data In Core Data
-(void)delete{
    //EMPTY GROUP TABLE
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentSearch" inManagedObjectContext:context];

    // Optionally add an NSPredicate if you only want to delete some of the objects.

    [fetchRequest setEntity:entity];

    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error=nil;
    for (RecentSearch *objectToDelete in myObjectsToDelete) {
        [context deleteObject:objectToDelete];

        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    arrSearchItem=nil;
   // arrSearchItem=[[NSMutableArray alloc]init];
}


#pragma  - mark Call Webservice

-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/get?status=1&watch_user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
//     [NSString stringWithFormat:@"items/get?category_id=%@&status=1&watch_user_id=%@",self.strCategoryID,[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]]
//    [objService sendRequestToServer:[NSString stringWithFormat:@"items/get?status=1",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
- (IBAction)categoriesClick:(id)sender
{
    CategoryViewController *categoryViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        categoryViewController=[[CategoryViewController alloc] initWithNibName:@"CategoryViewController_iPhone5" bundle:nil];
        
    }
    else{
        categoryViewController=[[CategoryViewController alloc] initWithNibName:@"CategoryViewController" bundle:nil]; }
    
    [self.navigationController pushViewController:categoryViewController animated:YES ];
   // [categoryViewController release];
    
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            self.arrSearchItem = [NSMutableArray arrayWithArray:inResponseDic];
            
//            NSLog(@"Response is = %@",self.arrSearchItem);
            [tblSearchResult reloadData];
        }
        else
        {
            
            
            if(self.alertShowing==NO)
            {
                [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                self.alertShowing = YES;
            }
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
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


#pragma mark - TableView Delegates

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;   
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *customview = [[UIView alloc]init]; //autorelease];
//    
//    NSArray* nibcell  = [[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil];
//    
//    [customview addSubview:[nibcell objectAtIndex:0]];
//    
//    return customview;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
////    int count = [arrSearchItem count];
////	if(self.editing) count++;
////	return count;
//
//    return [self.arrSearchItem count];
//}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
    } else {
        return [self.arrSearchItem count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
//    
//    if (cell == nil)
//    {
//        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
//        NSLog(@"%@",[searchResults objectAtIndex:indexPath.row]);
        
        
        RecentSearch *ev=(RecentSearch*)[searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = ev.item_name;
    }else{
        RecentSearch *ev=(RecentSearch*)[arrSearchItem objectAtIndex:indexPath.row];
        cell.textLabel.text =  ev.item_name;
        
    }
//    if (![arrSearchItem count] == 0)
//    {
//        cell.textLabel.text =  [[arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"item_name"];
//    }
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
//    UIView *selectionColor = [[UIView alloc] init];
//    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
//    
//    UIImageView *couponImage = (UIImageView *)[cell.contentView viewWithTag:100];
//    NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageURL,[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"pic_path"]];
//    
//    if([dicSearchItemImages objectForKey:indexPath] != nil)
//    {
//        couponImage.image  = [dicSearchItemImages objectForKey:indexPath];
//        NSLog(@"Image %d Exists = %@",indexPath.row,[dicSearchItemImages objectForKey:indexPath]);
//    }
//    else
//    {
//        
//        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
//        
//        [data setObject:imgUrl forKey:@"ImageUrl"];
//        [data setObject:indexPath forKey:@"IndexPath"];
//        
//        if ([imgUrl isEqualToString:@"0"]) {
//            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
//            indicator.hidden=YES;
//        }
//        else {
//            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
//            indicator.hidden=NO;
//            [self performSelectorInBackground:@selector(fetchImage:) withObject:data];
//        }
//        
//        [data release];
//    }
//    
//    UILabel *itemName = (UILabel *)[cell.contentView viewWithTag:200];
//    
//    cell.selectedBackgroundView = selectionColor;
//    
//    // added by chetan ..
//    
//    //    if (![self.arrItemList count] == 0)
//    //    {
//    itemName.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
//    itemName.text = [[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"title"];
//    itemName.highlightedTextColor = [UIColor blackColor];
    
    return cell;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 74;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.dicSearchItemList = [self.arrSearchItem objectAtIndex:indexPath.row];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    HomeAppliancesViewController *home;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        home=[[HomeAppliancesViewController alloc] initWithNibName:@"HomeAppliancesViewController_iPhone5" bundle:nil];
    }
    else
    {
        home=[[HomeAppliancesViewController alloc] initWithNibName:@"HomeAppliancesViewController" bundle:nil];
    }
  
    home.strViewHeading = [[arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"item_name"];
    
    
    [self.navigationController pushViewController:home animated:YES ];
    
  //  [HomeAppliancesViewController release];
    
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//    {
//        // Delete the row from the data source.
//        [arrSearchItem removeObjectAtIndex:indexPath.row];
//        [tblSearchResult reloadData];
//    }
//    else if (editingStyle == UITableViewCellEditingStyleInsert)
//    {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//        NSString *any = srchBar.text;
//        [arrSearchItem insertObject:any atIndex:[arrSearchItem count]];
//        [tblSearchResult reloadData];
//    }
//}
-(void)fetchImage:(NSMutableDictionary *)dict
{
	//NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
    NSIndexPath *indexPath = (NSIndexPath *)[dict objectForKey:@"IndexPath"];
    NSString *imageUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ImageUrl"]];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithString:imageUrl]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *profilePic = nil;
    
    if (data) {
        
        profilePic = [[UIImage alloc] initWithData:data] ;
        
        if (profilePic) {
            [dicSearchItemImages setObject:profilePic forKey:indexPath];
            UITableViewCell *cell = [self.tblSearchResult cellForRowAtIndexPath:indexPath];
//            UIActivityIndicatorView *indicate=(UIActivityIndicatorView *)[cell.contentView viewWithTag:300];
//            indicate.hidden=YES;
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
    
  //  [pool release];
}

#pragma - mark Button Methods

- (IBAction)btnNearBy:(UIButton *)sender {
    NearByViewController *nearby=[[NearByViewController alloc]initWithNibName:@"NearByViewController" bundle:nil];
    [self.navigationController pushViewController:nearby animated:YES];
}

-(IBAction)btnSearchCancelClicked:(id)sender
{
    
}

- (IBAction)savedSearchesClick:(id)sender {
    
    SavedSearchesViewController *savedSearch;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        savedSearch=[[SavedSearchesViewController alloc] initWithNibName:@"SavedSearchesViewController_iPhone5" bundle:nil];
        
    }
    else
    {
        savedSearch=[[SavedSearchesViewController alloc] initWithNibName:@"SavedSearchesViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:savedSearch animated:YES ];
  //  [savedSearch release];
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

#pragma - mark SearchBar Delegates
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    searchResults=[[NSArray alloc]init];
    NSPredicate *resultPredicate = [NSPredicate
                                    predicateWithFormat:@"item_name contains[cd] %@",
                                    searchText];

    searchResults = [arrSearchItem filteredArrayUsingPredicate:resultPredicate];
  //  [tblSearchResult reloadData];
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    if (searchResults) {
        searchResults=nil;
        searchResults=[[NSArray alloc]init];
    }
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    return YES;
}
#pragma - mark SearchBar Delegates

#pragma mark --
#pragma mark UISearchBar method

// End search
//- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1
//
//{
//	searchBar1.showsCancelButton = YES;
//	searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
//	[tblSearchResult reloadData];
//    
//}
//
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1
//
//{
//    //	CGRect make=searchBar1.frame;
//    //    make.size.width=290;
//    //    searchBar1.frame=make;
//    //    [searchBarView addSubview:remainingSearchSpace];
//	searchBar1.showsCancelButton = YES;
//}
//
//- (void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
//{
//    
//    //[searchText isEqualToString:@""];
//    
//	if([searchBar1.text isEqualToString:@""]||searchBar1.text==nil){
//		self.arrSearchItem=[[NSMutableArray alloc]initWithArray:arrSearchItemCopy];
//        
//        
//        //		tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
//        [tblSearchResult reloadData];
//	}
//}
////- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
////{
////    [searchBar1 setShowsCancelButton:YES];
////    for (UIView *subview in searchBar1.subviews)
////    {
////        if ([subview isKindOfClass:[UIButton class]])
////        {
////            int64_t delayInSeconds = .001;
////            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
////            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
////                
////                
////                UIButton * cancelButton = (UIButton *)subview;
////                [cancelButton setHidden:NO];
////                [cancelButton setEnabled:YES];
////                
////            });
////        }
////    }
////    [searchBar1 resignFirstResponder];
////    
////}
//- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    
//    NSString *searchText = [searchBar1.text stringByReplacingCharactersInRange:range withString:text];
//    NSMutableArray *searchWordsArr = [[NSMutableArray alloc] init];
//    NSString *newStr1= [searchText stringByReplacingOccurrencesOfString:@"," withString:@" "];
//    NSMutableArray *tempArray = (NSMutableArray*)[newStr1 componentsSeparatedByString:@" "];
//    for (NSString *str in tempArray) {
//        NSString *tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//        if([tempStr length])
//        {
//            [searchWordsArr addObject:tempStr];
//        }
//    }
//    
//    NSMutableArray *subpredicates = [NSMutableArray array];
//    for(NSString *term in searchWordsArr)
//    {
//        NSPredicate *p = [NSPredicate predicateWithFormat:@"item_name contains[cd] %@", term];
//        [subpredicates addObject:p];
//    }
//    
//    // //NSLog(@"all array %@",SharedAppDelegate.arrContacts);
//    NSMutableArray *tempArry = [[NSMutableArray alloc] initWithArray:arrSearchItemCopy];
//    
//    NSPredicate *filter = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
//    
//    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:[tempArry filteredArrayUsingPredicate:filter]];
//    //NSLog(@"finalarray is %@",finalArray);
//    self.arrSearchItem=[[NSMutableArray alloc]initWithArray:finalArray];
//    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:[contactsPage contactsGrouping:finalArray]];
// //   [tblSearchResult reloadData];
//    
//    
//    if(searchText.length==0)
//    {
//        ////NSLog(@"hello");
//        //  ReleaseObject(namesList)
//        self.arrSearchItem=[[NSMutableArray alloc]initWithArray:arrSearchItemCopy];
//        //        tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
//    //    [tblSearchResult reloadData];
//        
//        
//        return YES;
//    }
//    
//    return YES;
//}
//
//
//
//// Cancel search
//- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
//{
//    searchBar1.text=@"";
//    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
//    self.arrSearchItem=[[NSMutableArray alloc]initWithArray:arrSearchItemCopy];
//    [self.view endEditing:YES];
//    [tblSearchResult reloadData];
//    [searchBar1 setShowsCancelButton:NO];
//	//_mySearchBar.text = @"";
//	
//}

- (void) searchBarSearchButtonClicked:(UISearchBar*) theSearchBar
{
    HomeAppliancesViewController *itemView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemView=[[HomeAppliancesViewController alloc] initWithNibName:@"HomeAppliancesViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemView=[[HomeAppliancesViewController alloc] initWithNibName:@"HomeAppliancesViewController" bundle:nil];
    }
    //    NSString *strTemp;
    //    strTemp = [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"id"];
     NSString *searchText = [srchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    itemView.strViewHeading  = (NSMutableString*)[NSString stringWithFormat:@"%@",searchText];
//    itemView.strCategoryID = [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"id"];
//    itemView.strViewTitle = [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"name"];
    [self saveToDatabase:searchText];
//    [self saveToDatabase:nil];
//    [self saveToDatabase:@""];
    [srchBar resignFirstResponder];

    [self.navigationController pushViewController:itemView animated:YES ];
   // [itemView release];

}
-(void)saveToDatabase:(NSString *)inSearchBarText
{
    if (!inSearchBarText || [inSearchBarText length] <= 0)
        return;
//    for(int i=0; i<=[arrSearchItem count]; i++)
//    {
//        if(![inSearchBarText isEqualToString:[arrSearchItem objectAtIndex:i]])
//        {
//            NSLog("String is equal");
//        }
//    }
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"RecentSearch" inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
   
    NSPredicate *pred2 =
    [NSPredicate predicateWithFormat:@"(item_name LIKE[c] %@)",inSearchBarText];
    
    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred,pred2, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    // Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count]==0) {
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
