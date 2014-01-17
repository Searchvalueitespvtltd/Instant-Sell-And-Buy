//
//  ProfileViewController.m
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ProfileViewController.h"
#import "EditViewController.h"
#import "SellViewController.h"
#import "Users.h"
#import "CXMPPController.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController
@synthesize profileNameLbl,emailAddressLbl,profilePicImg,locationlbl,yearLbl,imgUserDefaultImage;

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
}

-(void)viewWillAppear:(BOOL)animated
{
   
    [ItemDetails sharedInstance].isSelected =0;

    context=[App managedObjectContext];
    userData=[[NSMutableArray alloc]init];
//    [self fetchData:@"Users"];
    if ([userData count]==0)
    {
//        [self callUserDetailService];
    }
    else
    {
        Users *ev=(Users*)[userData objectAtIndex:0];
        self.emailAddressLbl.text=ev.email;
        self.profilePicImg.image = [UIImage imageWithData:ev.image];
        self.profileNameLbl.text=ev.display_name;
        self.locationlbl.text=ev.country;
        
        mystring = ev.created_dt;
        NSArray *stringWithoutChar = [mystring componentsSeparatedByString:@" "];
        mystring = [stringWithoutChar objectAtIndex:0];
        stringWithoutChar = [mystring componentsSeparatedByString:@"-"];
        mystring = [stringWithoutChar objectAtIndex:0];
        //        yearLbl.text = mystring;
        self.yearLbl.text=mystring;
        
//        self.yearLbl.text=ev.created_dt;
//        if (![self.profilePicImg.image isEqual:[NSNull null]])
        if (!self.profilePicImg.image)

        {
            self.imgUserDefaultImage.image=[UIImage imageNamed:@"userIcon.png"];
        }
        else
        {
        self.imgUserDefaultImage.hidden = YES;
        }

    }
     [self callUserratingService];
[self callUserDetailService];
   
        [super viewWillAppear:YES];
}

-(void)callUserratingService
{
    float service = 5 ; // round off the values.
    float postage = 5;
    float itemDescribed = 5;
    
    for (int i = 1;i<=(int)service;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:10+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOff"]];
    }
    for (int i = 1;i<=(int)postage;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:20+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOff"]];
    }
    for (int i = 1;i<=(int)itemDescribed;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:30+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOff"]];
    }
}

//-(void)callUserratingService
//{
//    float service = 3.6 ; // round off the values.
//    float postage = 1;
//    float itemDescribed = 5;
//    
//    for (int i = 1;i<=(int)service;i++)
//    {
//        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:10+i];
//        [imgRating setImage:[UIImage imageNamed:@"rating"]];
//    }
////    if (service > (int)service)
////    {
////        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:10+(int)service+1];
////        [imgRating setImage:[UIImage imageNamed:@"star_half"]];
////    }
//    for (int i = 1;i<=(int)postage;i++)
//    {
//        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:20+i];
//        [imgRating setImage:[UIImage imageNamed:@"rating"]];
//    }
////    if (postage > (int)postage )
////    {
////        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:20+(int)postage+1];
////        [imgRating setImage:[UIImage imageNamed:@"star_half"]];
////    }
//    for (int i = 1;i<=(int)itemDescribed;i++)
//    {
//        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:30+i];
//        [imgRating setImage:[UIImage imageNamed:@"rating"]];
//    }
////    if (itemDescribed > (int)itemDescribed && !((int)itemDescribed ==5))
////    {
////        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:30+(int)itemDescribed+1];
////        [imgRating setImage:[UIImage imageNamed:@"star_half"]];
////    }
//}

- (IBAction)profileEditClick:(id)sender
{
    EditViewController *editViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        editViewController=[[EditViewController alloc] initWithNibName:@"EditViewController_iPhone5" bundle:nil];
    }
    else
    {
        editViewController=[[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    }
        
    [self.navigationController pushViewController:editViewController animated:YES ];
}

#pragma mark - Fetch Data From Core Data
-(void)fetchData:(NSString *)tableName
{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(username LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults]valueForKey:@"email"]];
    [request setPredicate:pred];
	// Fetch the records and handle an error
	NSError *error;
//	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];

    ////NSLog(@"Fetched:%@",mutableFetchResults);
	
	if (!mutableFetchResults)
	{
		//NSLog(@"Cant Fetch");
	}
    if([tableName isEqualToString:@"Users"])
    {
        for(Users *ev in mutableFetchResults)
        {
            userData = mutableFetchResults;
        }
    }
}

//#pragma mark - Save Data From Core Data
//-(void)saveToDatabase{
//    Users  *event = (Users *)[NSEntityDescription insertNewObjectForEntityForName:@"Users" inManagedObjectContext:context];
//    [event setDisplay_name:profileNameLbl.text];
//    [event setEmail:emailAddressLbl.text];
//    [event setCountry:locationlbl.text];
//    [event setCreated_dt:yearLbl.text];
//    if (profilePicImg.image) {
//        //        NSData *imageData=
//        [event setImage:UIImagePNGRepresentation(profilePicImg.image)];
//    }
//    NSError *error;
//    if (![context save:&error])
//    {
//        //NSLog(@"ERROR--%@",error);
//        abort();
//    }
//    
//}
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
//    for (Users *objectToDelete in myObjectsToDelete) {
//        [context deleteObject:objectToDelete];
//        
//        if (![context save:&error])
//        {
//            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//    userData=myObjectsToDelete;
//}


- (IBAction)itemForSaleClick:(id)sender {
    
//    SellViewController *sellViewController;
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        sellViewController=[[SellViewController alloc] initWithNibName:@"SellViewController_iPhone5" bundle:nil];
//        
//    }
//    else{
//        sellViewController=[[SellViewController alloc] initWithNibName:@"SellViewController" bundle:nil]; }
//    
//    [self.navigationController pushViewController:sellViewController animated:YES ];
//    [sellViewController release];
    
    [self.tabBarController setSelectedIndex:3];
    
}
- (IBAction)backButton:(id)sender
{    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)callUserDetailService
{
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/get?username=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"Response is = %@",inResponseDic);
    profileNameLbl.text = [[inResponseDic objectAtIndex:0]valueForKey:@"display_name"];
   // displayName=[[inResponseDic objectAtIndex:0]valueForKey:@"display_name"];
    locationlbl.text = [[inResponseDic objectAtIndex:0]valueForKey:@"country_name"];
    emailAddressLbl.text= [[inResponseDic objectAtIndex:0]valueForKey:@"email"];
    mystring = [[inResponseDic objectAtIndex:0]valueForKey:@"created_dt"];
    NSArray *stringWithoutChar = [mystring componentsSeparatedByString:@" "];
    mystring = [stringWithoutChar objectAtIndex:0];
   stringWithoutChar = [mystring componentsSeparatedByString:@"-"];
    mystring = [stringWithoutChar objectAtIndex:0];
    yearLbl.text = mystring;
   // locationlbl.text= [[inResponseDic objectAtIndex:0]valueForKey:@"country_name"];
//    locationlbl.text= [[inResponseDic objectAtIndex:0]valueForKey:@"home_addr"];
    
    NSString *imagepath = [[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"];
    NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
//    if (imagepath.length>0 || [[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"]isEqual:[NSNull null]])
//    {
//        [self doFetchEditionImage:[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"] withIndex:0];
//        //self.imgUserDefaultImage.hidden = YES;
//    }
//    else
//    {
//        self.imgUserDefaultImage.hidden = NO;
//    }
    
    ////////////////////////////////////////
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![imageData isEqual:[NSNull null]])
            {
                                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                self.imgUserDefaultImage.hidden = YES;
                profilePicImg.image = [UIImage imageWithData:imageData];
            }
            
        });
    });
    
    ////////////////////////////////////////

    
    
//    NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
    
//    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
//    if (![imageData isEqual:[NSNull null]]) {
//        self.imgUserDefaultImage.hidden = YES;
//        profilePicImg.image = [UIImage imageWithData:imageData];
//    }
    
    //////////// User rating block starts ////////////

    float service = 0.0;
    float postage = 0.0;
    float itemDescribed = 0.0;
    
    if (![[[inResponseDic objectAtIndex:0] valueForKey:@"rating_service"]isEqual:[NSNull null]])
    {
         service = [[[inResponseDic objectAtIndex:0] valueForKey:@"rating_service"] floatValue];
    }
    if (![[[inResponseDic objectAtIndex:0] valueForKey:@"rating_postage"]isEqual:[NSNull null]])
    {
         postage = [[[inResponseDic objectAtIndex:0] valueForKey:@"rating_postage"] floatValue]; 
    }
    if (![[[inResponseDic objectAtIndex:0] valueForKey:@"rating_item_as_described"]isEqual:[NSNull null]])
    {
         itemDescribed = [[[inResponseDic objectAtIndex:0] valueForKey:@"rating_item_as_described"] floatValue];
    }
    
    for (int i = 1;i<=(int)service;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:10+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
    }
    for (int i = 1;i<=(int)postage;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:20+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
    }
    for (int i = 1;i<=(int)itemDescribed;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:30+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
    }

    //////////// User rating block ends //////////// 
    
 //   [self delete];
  //  [self saveToDatabase];
 
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"*** requestErrorHandler *** and Error : %@",[inError debugDescription]);
}

#pragma mark fetch images

-(void)doFetchEditionImage:(NSString *)inImageId withIndex:(NSInteger)index
{
    SHRequestSampleImage *aRequest = [[SHRequestSampleImage alloc] initWithURL: nil] ;
    [aRequest setImageId:inImageId];
    [aRequest SetResponseHandler:@selector(handledImage:)];
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
    if (aImageData)
    {
//        NSLog(@"%d",inRequest.index);
        UIImage * img = [UIImage imageWithData: aImageData];
        
        if (img)
        {
            self.imgUserDefaultImage.hidden = YES;
            profilePicImg.image = img;
        }
    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
-(IBAction)btnSignOutClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults]setValue:@"" forKey:@"USERID"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"isKeepMeLoginEnabled"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [gCXMPPController disconnect];
    
    AppDelegate *delegate = APP_DELEGATE;
    [delegate showHomeScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{   
    [locationlbl release];
    [emailAddressLbl release];
    [yearLbl release];
    [super dealloc];
}

@end
