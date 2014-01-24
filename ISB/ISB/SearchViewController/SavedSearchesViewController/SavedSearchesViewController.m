//
//  SavedSearchesViewController.m
//  ISB
//
//  Created by chetan shishodia on 17/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SavedSearchesViewController.h"
#import "MySavedSearch.h"
#import "HomeAppliancesViewController.h"

@interface SavedSearchesViewController ()

@end

@implementation SavedSearchesViewController

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
    arrSavedData = [[NSMutableArray alloc]init];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    

    [ItemDetails sharedInstance].isSelected =0;

    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];

    [self fetchData:@"MySavedSearch"];
    [self reloadInputViews];
    [Utils stopActivityIndicatorInView:self.view];
    if (![arrSavedData count] > 0)
    {
        alertNoData = [[UIAlertView alloc] initWithTitle:kAlertTitle message:@"You have not saved any search." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertNoData show];
        [alertNoData release];
        
    }
    if (!arrSavedData || !arrSavedData.count){
        btnEdit.hidden=YES;
    }
    else
        btnEdit.hidden=NO;
    [super viewWillAppear:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==alertNoData)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

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

	if (!mutableFetchResults)
	{
		//NSLog(@"Cant Fetch");
	}
    if([tableName isEqualToString:@"MySavedSearch"])
    {
        for(MySavedSearch *ev in mutableFetchResults)
        {
            arrSavedData = mutableFetchResults;
        
        }
    }
}

#pragma mark - Delete Data In Core Data
-(void)delete:(NSString*)srchName
{
    //EMPTY GROUP TABLE
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MySavedSearch" inManagedObjectContext:context];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [request setEntity:entity];
    
    
    NSPredicate *pred1 =
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    
    
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"searchName LIKE[c] %@",srchName];
    
    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred1,pred2, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:request error:nil];
    NSError *error=nil;
    for (MySavedSearch *objectToDelete in myObjectsToDelete)
    {
        [context deleteObject:objectToDelete];
//        if (!arrSavedData || !arrSavedData.count){
//            btnEdit.hidden=YES;
//        }
//        else
//            btnEdit.hidden=NO;
        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        }
    }
}


#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [arrSavedData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // addded by chetan..
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    // added by chetan ..
    
    
    if (![arrSavedData count] == 0)
    {
        cell.textLabel.text =  [[arrSavedData objectAtIndex:indexPath.row]valueForKey:@"searchName"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    
    home.strCategoryID = [[arrSavedData objectAtIndex:indexPath.row]valueForKey:@"category_id"];
    home.strViewTitle = [[arrSavedData objectAtIndex:indexPath.row]valueForKey:@"searchName"];
    home.isFromSavedSearch = YES;
    
    
    [self.navigationController pushViewController:home animated:YES ];
    
    [HomeAppliancesViewController release];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        strCatId = [[arrSavedData objectAtIndex:indexPath.row]valueForKey:@"category_id"];
        strSearchName = [[arrSavedData objectAtIndex:indexPath.row]valueForKey:@"searchName"];
        
        NSString * strIsNotify = [NSString stringWithFormat:@"%@",[[arrSavedData objectAtIndex:indexPath.row]valueForKey:@"isNotify"]];
        
//        NSLog(@"is_notify = %@",strIsNotify);
        
        if ([strIsNotify isEqualToString:@"1"])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self callWebServiceForDelete:strCatId];
                [arrSavedData removeObjectAtIndex:indexPath.row];
                if (!arrSavedData || !arrSavedData.count){
                    btnEdit.hidden=YES;
                }
                else
                    btnEdit.hidden=NO;
                [tblSavedSearchList reloadData];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                });
            });
        }
        else
        {
            [self delete:strSearchName];
            [arrSavedData removeObjectAtIndex:indexPath.row];
            if (!arrSavedData || !arrSavedData.count){
                btnEdit.hidden=YES;
            }
            else
                btnEdit.hidden=NO;
            [tblSavedSearchList reloadData];
        }
    }
//     [Utils stopActivityIndicatorInView:self.view];
}


#pragma - mark Call WebService

-(void)callWebServiceForDelete:(NSString *)categoryID
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
//    //http://it0091.com/ISB/index.php/userSearches/delete?user_id=1&category_id=1
    NSString *ur=[NSString stringWithFormat:@"userSearches/delete?user_id=%@&category_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"],categoryID];
    
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:ur]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    
//    NSLog(@"%@",s);
//    [Utils stopActivityIndicatorInView:self.view];
    if (!arrSavedData || !arrSavedData.count){
        btnEdit.hidden=YES;
    }
    else
        btnEdit.hidden=NO;
    NSArray *result = [s JSONValue];
    if ([[result objectAtIndex:0] isEqual: @"error"])
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to delete or no record to delete." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    }
    else
         {
             [self delete:strSearchName];
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

         }
     [Utils stopActivityIndicatorInView:self.view];
}


#pragma marks - Button Methods

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnAddORDeleteRowsClicked:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [tblSavedSearchList setEditing:NO animated:NO];
        [tblSavedSearchList reloadData];
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [tblSavedSearchList setEditing:YES animated:YES];
        [tblSavedSearchList reloadData];
        [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
