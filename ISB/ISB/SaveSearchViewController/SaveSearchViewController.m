//
//  SaveSearchViewController.m
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SaveSearchViewController.h"
#import "MySavedSearch.h"
#import "ItemDetails.h"

@interface SaveSearchViewController ()

@end

@implementation SaveSearchViewController
@synthesize searchTxtField,switchIsNotify;
@synthesize strCategoryName,strCategoryId,strIsNotify;


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
    arrDelData = [[NSMutableArray alloc]init];

    
    context=[App managedObjectContext];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [ItemDetails sharedInstance].isSelected=0;
    strIsNotify = @"0";
    [super viewWillAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma  - mark Button Methods

-(IBAction)btnCancelClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSaveClicked:(id)sender
{
    
//    NSLog(@"%@",strIsNotify);
    
    [searchTxtField resignFirstResponder];
    
    if ([searchTxtField.text isEqualToString:@""])
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        return;
    }
    
    [self fetchData:searchTxtField.text];

}


-(IBAction)switchIsNotifyClicked:(id)sender
{
    if (switchIsNotify.on)
    {
        strIsNotify = @"1";
    }
    else
    {
        strIsNotify = @"0";
    }
    [searchTxtField resignFirstResponder];
}


#pragma - mark Call WebService for delete

-(void)callWebServiceForDelete:(NSString *)categoryID
{
        //    //http://it0091.com/ISB/index.php/userSearches/delete?user_id=1&category_id=1
    NSString *ur=[NSString stringWithFormat:@"userSearches/delete?user_id=%@&category_id=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"USERID"],categoryID];
   
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:ur]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    //[request setHTTPBody:postData];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
//    NSLog(@"%@",s);
    NSArray *result = [s JSONValue];
    if ([[result objectAtIndex:0] isEqual: @"error"])
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to delete or no record to delete." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
    }
    else
    {
        [self delete:arrDelData];
    }
}


#pragma  - mark Call Webservice

-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];

    [objService sendRequestToServer:[NSString stringWithFormat:@"userSearches/save?user_id=%@&category_id=%@&is_notify=%@&search_name=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],self.strCategoryId,self.strIsNotify,self.searchTxtField.text] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
//         [Utils showAlertView:kAlertTitle message:@"Now you have been enabled notifications for this search." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];   

            [self saveToDatabase];
            
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Please try again later for notifications." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Please try again later for notifications." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
}
 
 
#pragma mark - Save Data From Core Data
-(void)saveToDatabase
{
    MySavedSearch *savedsearch = (MySavedSearch *)[NSEntityDescription insertNewObjectForEntityForName:@"MySavedSearch" inManagedObjectContext:context];

    [savedsearch setCategory_id:strCategoryId];
    [savedsearch setCategory_name:strCategoryName];
    
    [savedsearch setIsNotify:[NSString stringWithFormat:@"%@",strIsNotify]];
    [savedsearch setSearchName:searchTxtField.text];
    [savedsearch setUserId:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    
    NSError *error;
    if (![context save:&error])
    {
        //NSLog(@"ERROR--%@",error);
        abort();
    }

    alertSearchSaved = [[UIAlertView alloc] initWithTitle:kAlertTitle
                                                      message:@"Search saved."
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [alertSearchSaved show];
    [alertSearchSaved release];
        
}


 #pragma mark - Fetch Data From Core Data
 -(void)fetchData:(NSString *)strSearchName
 {
 NSEntityDescription *entity = [NSEntityDescription entityForName:@"MySavedSearch" inManagedObjectContext:context];
 
 // Setup the fetch request
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 [request setEntity:entity];
 
 NSPredicate *pred1 =
 [NSPredicate predicateWithFormat:@"(searchName LIKE [c] %@)",strSearchName];
 
 NSPredicate *pred2 =
 [NSPredicate predicateWithFormat:@"(userId LIKE [c] %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
 
 NSArray *compPredicatesList = [NSArray arrayWithObjects:pred1,pred2, nil];
 
 NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
 
 [request setPredicate: CompPrediWithAnd];
 
 
 // Fetch the records and handle an error
 NSError *error;
 NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
 ////NSLog(@"Fetched:%@",mutableFetchResults);
 
 if (mutableFetchResults.count>0)
 {
     arrDelData = [[NSMutableArray arrayWithArray:mutableFetchResults]retain];
     
     
     alertNameReplaced = [[UIAlertView alloc] initWithTitle:kAlertTitle
                                                       message:@"This name already exists.\nWhat would you like to do ?"
                                                      delegate:self
                                             cancelButtonTitle:@"Replace"
                                             otherButtonTitles:@"New name",nil];
     [alertNameReplaced show];
     [alertNameReplaced release];
     
     
     
 }
     else
     {
         
         if ([strIsNotify isEqualToString:@"1"])
         {
             [self callWebService];
         }
         else
         {
             [self saveToDatabase];
         }
     }
 }

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView ==alertNameReplaced)
    {
        if (buttonIndex == 0)
        {
            if ([[[arrDelData objectAtIndex:0]valueForKey:@"isNotify"] isEqualToString:@"1"])
            {
                [Utils startActivityIndicatorInView:self.view withMessage:nil];
                [self callWebServiceForDelete:[[arrDelData objectAtIndex:0]valueForKey:@"category_id"]];
            }
            else
            {
                [self delete:arrDelData];
            }
        
        }

    }
    if (alertView == alertSearchSaved)
    {
        if (buttonIndex == 0)
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}


 #pragma mark - Delete Data In Core Data
 -(void)delete:(NSMutableArray*)arrDeleteItem
 {
 //EMPTY GROUP TABLE
 NSFetchRequest *request = [[NSFetchRequest alloc] init];
 NSEntityDescription *entity = [NSEntityDescription entityForName:@"MySavedSearch" inManagedObjectContext:context];
 
 // Optionally add an NSPredicate if you only want to delete some of the objects.
 
 [request setEntity:entity];
 
 NSPredicate *pred1 =
 [NSPredicate predicateWithFormat:@"(searchName LIKE[c] %@)",[[arrDeleteItem objectAtIndex:0]valueForKey:@"searchName"]];
 
 NSPredicate *pred2 =
 [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
 
 NSArray *compPredicatesList = [NSArray arrayWithObjects:pred1,pred2, nil];
 
 NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
 
 [request setPredicate: CompPrediWithAnd];
 
 NSArray *myObjectsToDelete = [context executeFetchRequest:request error:nil];
 NSError *error=nil;
 for (MySavedSearch *objectToDelete in myObjectsToDelete)
 {
     [context deleteObject:objectToDelete];
 
     if (![context save:&error])
     {
         //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
         abort();
     }
 }
     if ([strIsNotify isEqualToString:@"1"])
     {
        [self callWebService];
     }
     else
     {
         [self saveToDatabase];
     }
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

- (void)dealloc {
    [searchTxtField release];
    [super dealloc];
}
@end
