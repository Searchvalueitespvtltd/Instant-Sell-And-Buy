//
//  CategoryViewController.m
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "CategoryViewController.h"
#import "NetworkService.h"
#import "HomeAppliancesViewController.h"
#import "CategoryTable.h"

@interface CategoryViewController ()
//{
//    bool alertShowing;
//}
//@property(assign,nonatomic) bool alertShowing;
@end

@implementation CategoryViewController
@synthesize tblCategory,arrItemCategory,dicDetailItem;
//@synthesize alertShowing;

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
    
//    self.arrItemCategory = [[NSMutableArray alloc]init];
//    [self fetchData:@"CategoryTable"];

//    if ([arrItemCategory count]==0) {
    if ([Utils isInternetAvailable]) {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self callWebService];
    }else{
        self.arrItemCategory = [[NSMutableArray alloc]init];
            [self fetchData:@"CategoryTable"];
    }
        
//    }
    
    // Do any additional setup after loading the view from its nib.
}


-(void)viewWillAppear:(BOOL)animated
{
    [ItemDetails sharedInstance].isSelected =0;
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.tblCategory.frame = CGRectMake(self.tblCategory.frame.origin.x, self.tblCategory.frame.origin.y, 320, self.view.frame.size.height-85);
    }
    else
    {
        self.tblCategory.frame = CGRectMake(self.tblCategory.frame.origin.x, self.tblCategory.frame.origin.y, 320, self.view.frame.size.height-100);
    }


//    if (dicDetailItem) {
//        
//    }
//    [self callWebService];
}


#pragma mark - Save Data From Core Data
-(void)saveToDatabase : (NSArray *)responseArray{
    for (id obj in responseArray) {
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryTable" inManagedObjectContext:context];
        // Setup the fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        NSPredicate *pred2 =
        [NSPredicate predicateWithFormat:@"(id == %@)",[obj valueForKey:@"id"] ];
        [request setPredicate: pred2];
        NSError *error;
        NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
        if ([mutableFetchResults count]==0) {
        CategoryTable  *event = (CategoryTable *)[NSEntityDescription insertNewObjectForEntityForName:@"CategoryTable" inManagedObjectContext:context];
        [event setId:[obj valueForKey:@"id"]];
        [event setName:[obj valueForKey:@"name"]];
        
        if (![context save:&error])
        {
            abort();
        }
        }
    }
}
//
//#pragma mark - Delete Data In Core Data
//-(void)delete{
//    //EMPTY GROUP TABLE
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
//
//    // Optionally add an NSPredicate if you only want to delete some of the objects.
//
//    [fetchRequest setEntity:entity];
//
//    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
//    NSError *error=nil;
//    for (CategoryTable *objectToDelete in myObjectsToDelete) {
//        [context deleteObject:objectToDelete];
//
//        if (![context save:&error])
//        {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//    arrItemCategory=myObjectsToDelete;
//}

#pragma mark - Fetch Data From Core Data
-(void)fetchData:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    //    NSPredicate *pred =
    //    [NSPredicate predicateWithFormat:@"(id LIKE[c] %@)",
    //     userNameLbl.text];
    //    [request setPredicate:pred];
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
	
	if (!mutableFetchResults)
	{
		//NSLog(@"Cant Fetch");
	}
    if([tableName isEqualToString:@"CategoryTable"])
    {
        arrItemCategory=[[NSMutableArray alloc]init];

        for(CategoryTable *ev in mutableFetchResults)
        {
            arrItemCategory = mutableFetchResults;
        }
    }
}


#pragma mark - Call Webservice

-(void)callWebService
{
    
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:@"categories/get" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        
         [self saveToDatabase:inResponseDic];
        self.arrItemCategory = [NSMutableArray arrayWithArray:inResponseDic];
        // [self.arrCategory addObjectsFromArray:inResponseDic];
//        NSLog(@"Response is = %@",arrItemCategory);
        [tblCategory reloadData];
        
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




#pragma mark - TableView Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (![arrItemCategory count] == 0)
    {
        return [arrItemCategory count];
    }
    else
    {
        return 10;
    }
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
    
    
//    NSLog(@"Response is = %@",arrItemCategory);
   // userData=[[NSMutableArray alloc]init];
  //  [self fetchData:@"CategoryTable"];
//    CategoryTable *ev=(CategoryTable*)[userData objectAtIndex:0];
//    for (id obj in userData)
//    {
//    
//    }
//    cell.textLabel.text = ev.name;

    if (![arrItemCategory count] == 0)
    {
        cell.textLabel.text =  [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"name"];
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
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
    
    itemView.strCategoryID = [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"id"];
    itemView.strViewTitle = [[arrItemCategory objectAtIndex:indexPath.row]valueForKey:@"name"];
    
        [self.navigationController pushViewController:itemView animated:YES ];
        [itemView release];
    
    
    
//    self.dicSelectCategory = [arrCategory objectAtIndex:indexPath.row];
//    indexpathrow = indexPath.row;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
