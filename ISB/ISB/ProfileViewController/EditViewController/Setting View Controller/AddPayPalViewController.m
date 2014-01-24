//
//  AddPayPalViewController.m
//  ISB
//
//  Created by Pankaj on 10/29/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "AddPayPalViewController.h"
#import "Users.h"
@interface AddPayPalViewController ()

@end

@implementation AddPayPalViewController

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
    context=[APP_DELEGATE managedObjectContext];
    NSString *payPaliD=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"paypal_account"]];
    self.txtPaypal.text=payPaliD;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)callWebService
{
//    http://chat.eitcl.co.uk/devchat/index.php/users/paypal/?userid=73&paypal_account=ojosfj@ssf.com2
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/paypal/?userid=%@&paypal_account=%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"],self.txtPaypal.text] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
     
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
        if([inReqIdentifier rangeOfString:@"users/paypal/?"].length > 0)
    {
        
        if([[inResponseDic objectAtIndex:0] isEqualToString:@"success"])
        {
            [Utils showAlertView:kAlertTitle message:@"Your PayPal have been successfully updated" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [self saveToDatabase];
            [[NSUserDefaults standardUserDefaults ] setValue:self.txtPaypal.text forKey:@"paypal_account"];
            [[NSUserDefaults standardUserDefaults] synchronize];
           
            [self.navigationController popViewControllerAnimated:YES];
        
        }
        
    }
        
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

- (void)dealloc {
    [_txtPaypal release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtPaypal:nil];
    [super viewDidUnload];
}
- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSubmit:(id)sender {
    if ([self.txtPaypal.text isEqualToString:@""]) {
        [Utils showAlertView:@"" message:@"Please enter PayPal id" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        return;
    }
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *email = [self.txtPaypal.text stringByTrimmingCharactersInSet:set];
    NSString *regix = @"\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regix];
    
    if (![predicate evaluateWithObject:email])
    {
        [Utils showAlertView:kAlertTitle message:@"Email is not in correct format." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        self.txtPaypal.text=@"";
        return;
    }
    
    [Utils startActivityIndicatorInView:self.view withMessage:@""];
    [self callWebService];
}

#pragma mark - Save to database

-(void)saveToDatabase
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    
    NSString * userId=[[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"] ;
    
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(userid LIKE[c] %@)",userId];
    //     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
    //    NSPredicate *pred2 =
    //    [NSPredicate predicateWithFormat:@"(profile_pic_path LIKE[c] %@)",[dicProfileData objectForKey:@"profile_pic_path"]];
    
    //    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred,pred2, nil];
    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    // Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    if ([mutableFetchResults count]==0)
    {
        
    }else{
        Users* user = [mutableFetchResults objectAtIndex:0];
        [user setPaypal_account:self.txtPaypal.text];
        
        
        if (![context save:&error])
        {
            //NSLog(@"ERROR--%@",error);
            abort();
        }
    }
}
@end
