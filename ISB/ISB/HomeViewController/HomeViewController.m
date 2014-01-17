//
//  HomeViewController.m
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "CXMPPController.h"
#import "XMPPPrivacy.h"

#import "HomeViewController.h"
#import "ProfileViewController.h"
#import "SettingViewController.h"
#import "SavedSearchesViewController.h"
#import "MySavedSearch.h"
#import "LastViewItems.h"
#import "ItemViewController.h"
#import "SellViewController.h"
#import "MessageViewController.h"
#import "MyISBViewController.h"
#import "ItemDetails.h"
#import "ChatViewController.h"
#import "Users.h"
#import "ReminderViewController.h"
#import "MessageOptionController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize txtSearch;
@synthesize lblBuyValue,lblMessagesValue,lblReminderValue,lblSavedValue,lblSellValue,lblWatchValue,lblChatValue;
@synthesize scrllView;

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
    app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    imgReminderValue.hidden = YES;
    imgMessageValue.hidden = YES;
    imgSavedValue.hidden = YES;
    imgChatValue.hidden = YES;
    
    lblReminderValue.hidden = YES;
    lblMessagesValue.hidden = YES;
    lblSavedValue.hidden = YES;
    lblChatValue.hidden = YES;
    
    lblLastViewedItems.hidden = YES;
    
    context=[App managedObjectContext];
    arrSavedData = [[NSMutableArray alloc]init];
    arrLastViewedItems = [[NSMutableArray alloc]init];
//    arrUserData = [[NSMutableArray alloc]init];

    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [ItemDetails sharedInstance].isSelected =0;
    arrSavedData = nil;
    arrLastViewedItems = nil;
    [self fetchUserData:@"Users"];
    [self fetchSavedData:@"MySavedSearch"];
    [self fetchLastViewData:@"LastViewItems"];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self performSelector:@selector(callCountService)];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
//        });
//    });
    
    [self callCountService];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"totalItemSell"])
    {
        lblSellValue.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"totalItemSell"]];
    }
    
    if (arrSavedData.count > 0)
    {
        imgSavedValue.hidden = NO;
        lblSavedValue.hidden = NO;
        lblSavedValue.text = [NSString stringWithFormat:@"%d",arrSavedData.count];
    }
    else
    {
        imgSavedValue.hidden = YES;
        lblSavedValue.hidden = YES;
    }
    
    if (arrLastViewedItems.count>0)
    {
        lblLastViewedItems.hidden = NO;
//        [self populateImages];
    }
    
    [self populateImages];
    [super viewWillAppear:YES];
}


-(void)viewWillDisappear:(BOOL)animated
{
    [Utils stopActivityIndicatorInView:self.view];
    
    [super viewWillDisappear:YES];
}

///////////////////////////////////////////////////////////////////////////////////////////////
-(void)callCountService
{
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/home_count?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];   
}

///////////////////////////////////////////////////////////////////////////////////////////////

-(void)populateImages
{    
    for(UIView * view in scrllView.subviews)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview]; view = nil;
        }
        if([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview]; view = nil;
        }
    }
    CGFloat scrollY=0.0f;
    for(int p=0;p<[arrLastViewedItems count];p++)
    {
        UIButton *btnImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        btnImageButton.frame = CGRectMake(5,5,70,70);
        btnImageButton.frame = CGRectMake(10,8,70,70);
        
        ////////////////////////////////////////////////////////////
        UIActivityIndicatorView * activityIndicator = [[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]autorelease];
        [self.view addSubview:activityIndicator];
        activityIndicator.center = btnImageButton.center;
        [activityIndicator startAnimating];
        ////////////////////////////////////////////////////////////        
        [btnImageButton setTag:p];
        CGRect myimagerect = CGRectMake(10,8,70,70);
        UIImageView *myimage = [[UIImageView alloc]initWithFrame:myimagerect];
        
        NSString *strImagepath = [[NSString alloc]init];

        int temp = [[[arrLastViewedItems objectAtIndex:p] valueForKey:@"default_pic"] integerValue];
        switch (temp)
        {
            case 1:
                if ([[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage"])
                {
                    [myimage setImage:[UIImage imageWithData:[[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage"]]];
                }
                else
                {
                    strImagepath = [kImageURL stringByAppendingString:[[arrLastViewedItems objectAtIndex:p]valueForKey:@"pic_path"]];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: strImagepath]];
                        [myimage setImage:[UIImage imageWithData:imageData1]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    });
                }
                
                break;
            case 2:
                if ([[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage2"])
                {
                    [myimage setImage:[UIImage imageWithData:[[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage2"]]];
                }
                else
                {
                    strImagepath = [kImageURL stringByAppendingString:[[arrLastViewedItems objectAtIndex:p]valueForKey:@"pic_path2"]];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: strImagepath]];
                        [myimage setImage:[UIImage imageWithData:imageData1]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    });
                }
                
                break;
            case 3:
                if ([[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage3"])
                {
                    [myimage setImage:[UIImage imageWithData:[[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage3"]]];
                }
                else
                {
                    strImagepath = [kImageURL stringByAppendingString:[[arrLastViewedItems objectAtIndex:p]valueForKey:@"pic_path3"]];
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: strImagepath]];
                        [myimage setImage:[UIImage imageWithData:imageData1]];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                    });
                }
                
                break;
            default:
                break;
        }
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            
//            NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: strImagepath]];
//            [myimage setImage:[UIImage imageWithData:imageData1]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//            });
//        });

//        [myimage setImage:[UIImage imageWithData:[[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage"]]];
        
        ////////////////////////////////////////////////////////////
                [activityIndicator stopAnimating];
        ////////////////////////////////////////////////////////////

        [myimage setContentMode:UIViewContentModeScaleAspectFit];
        myimage.opaque = YES;
        [btnImageButton addSubview:myimage];
        [myimage release];
       // btnImageButton.backgroundColor=[UIColor yellowColor];
        [btnImageButton addTarget:self action:@selector(nextview:) forControlEvents:UIControlEventTouchUpInside];
//        [btnImageButton setBackgroundImage:[UIImage imageWithData:[[arrLastViewedItems objectAtIndex:p] valueForKey:@"itemImage"]] forState:UIControlStateNormal];
//        [btnImageButton.imageView setContentMode:UIViewContentModeScaleAspectFit];

        CGRect btnRect = btnImageButton.frame;
        btnRect.origin.x = scrollY;
        [btnImageButton setFrame:btnRect];
        
        UIImageView *status=[[UIImageView alloc]initWithFrame:CGRectMake(btnRect.origin.x+17, btnRect.origin.y+15, 55, 55)];
     //   status.center=btnImageButton.center;
        status.contentMode=UIViewContentModeScaleAspectFit;
        if ([[[arrLastViewedItems objectAtIndex:p] valueForKey:@"availability"] isEqualToString:@"SOLD"]) {
            status.image=[UIImage imageNamed:@"IsbSold.png"];

        }else if([[[arrLastViewedItems objectAtIndex:p] valueForKey:@"availability"] isEqualToString:@"AVAILABLE"]){
            status.image=nil;
        }else{
            status.image=[UIImage imageNamed:@"IsbOffermade.png"];

        }
        
        


        [scrllView setScrollEnabled:YES];
        
        [scrllView addSubview:btnImageButton];
        [scrllView addSubview:status];

        scrollY += btnImageButton.frame.size.width+5;
    }
    scrllView.contentSize = CGSizeMake(scrollY, 50);

}


-(void)nextview:(UIButton*)sender
{
    ItemViewController *itemDetailView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    }
    
    itemDetailView.dicItemDetails = [arrLastViewedItems objectAtIndex:[sender tag]];
    itemDetailView.isWatching = [[[arrLastViewedItems objectAtIndex:[sender tag]] valueForKey:@"is_watch"] integerValue];
    [self.navigationController pushViewController:itemDetailView animated:YES ];
    
    [itemDetailView release];
}





///////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////


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

-(void)fetchSavedData:(NSString *)tableName
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
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
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
        if([tableName isEqualToString:@"MySavedSearch"])
        {
            for(MySavedSearch *ev in mutableFetchResults)
            {
                arrSavedData = mutableFetchResults;
            }
        }

    }
    
}


-(void)fetchLastViewData:(NSString *)tableName
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
    [NSPredicate predicateWithFormat:@"(userId LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
    
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
	if (!mutableFetchResults)
	{
		//NSLog(@"Cant Fetch");
	}
    
    arrLastViewedItems=nil;
    arrLastViewedItems=[[NSMutableArray alloc]init];
    NSArray* reversedArray = [[NSArray alloc]init];

    if (mutableFetchResults.count>0)
	{
        if([tableName isEqualToString:@"LastViewItems"])
        {
           
            for(LastViewItems *ev in mutableFetchResults)
            {
                reversedArray = mutableFetchResults;
            }
            arrLastViewedItems= [[[reversedArray reverseObjectEnumerator] allObjects] mutableCopy];
        }
	}
}




#pragma  mark  - Button Methods

-(IBAction)btnUserProfileClicked:(id)sender
{
//    [self hideKeyBoard];
    
    ProfileViewController *profileViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController_iPhone5" bundle:nil];
        
    }
    else{
        profileViewController=[[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil]; }
    
    [self.navigationController pushViewController:profileViewController animated:YES ];
    [profileViewController release];
    

}

-(IBAction)btnSettingClicked:(id)sender
{
//    [self hideKeyBoard];
    SettingViewController *setting;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        setting=[[SettingViewController alloc] initWithNibName:@"SettingViewController_iPhone5" bundle:nil];
        
    }
    else
    {
        setting=[[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:setting animated:YES ];
    [setting release];
    
}

-(IBAction)btnReminderClicked:(id)sender
{
    [self hideKeyBoard];
    ReminderViewController *reminderView ;
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        reminderView=[[ReminderViewController alloc] initWithNibName:@"ReminderViewController_iPhone5" bundle:nil];
        
    }
    else
    {
        reminderView=[[ReminderViewController alloc] initWithNibName:@"ReminderViewController" bundle:nil];
    }
    
    [self.navigationController pushViewController:reminderView animated:YES ];
    [reminderView release];

}

-(IBAction)btnMessagesClicked:(id)sender
{
    [self hideKeyBoard];
    
//    MessageViewController *messageView ;
//    
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController_iPhone5" bundle:nil];
//        
//    }
//    else
//    {
//        messageView=[[MessageViewController alloc] initWithNibName:@"MessageViewController" bundle:nil];
//    }
//    
//    [self.navigationController pushViewController:messageView animated:YES ];
//    [messageView release];

    MessageOptionController *message=[[MessageOptionController alloc]initWithNibName:@"MessageOptionController" bundle:nil];
    [self.navigationController pushViewController:message animated:YES ];
        [message release];
    
}

-(IBAction)btnSavedClicked:(id)sender
{
//    [self hideKeyBoard];
    
    
//    AppDelegate *delegate = APP_DELEGATE;
//    [delegate removeHomeScreen:@"1"];

    
    
    
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

    [savedSearch release];
}

-(IBAction)btnSearchCancelClicked:(id)sender
{
    [self hideKeyBoard];
    txtSearch.text = @"";
}

-(IBAction)btnBuyingClicked:(id)sender
{
     [ItemDetails sharedInstance].isSelected=1;
    AppDelegate *delegate = APP_DELEGATE;
    [delegate removeHomeScreen:@"2"];
}

-(IBAction)btnSellingClicked:(id)sender
{
    [ItemDetails sharedInstance].isSelected=0;
//    SellViewController *sellView;
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        sellView=[[SellViewController alloc] initWithNibName:@"SellViewController_iPhone5" bundle:nil];
//        
//    }
//    else
//    {
//        sellView=[[SellViewController alloc] initWithNibName:@"SellViewController" bundle:nil];
//    }
//    
//    [self.navigationController pushViewController:sellView animated:YES ];
    AppDelegate *delegate = APP_DELEGATE;
    [delegate removeHomeScreen:@"3"];

//    [self.tabBarController setSelectedIndex:3];

//    [sellView release];

}

-(IBAction)btnWatchClicked:(id)sender
{
    AppDelegate *delegate = APP_DELEGATE;
    [delegate removeHomeScreen:@"2"];
}

- (IBAction)goToChatScreen:(id)sender
{
    AppDelegate * delegate = APP_DELEGATE;
   // delegate.strchatBadgeValue = nil;
    
    [[[[[self tabBarController]tabBar]items]objectAtIndex:0]setBadgeValue:delegate.strchatBadgeValue];
    
    ChatViewController *chat = nil;
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        chat=[[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
        
    }
    else
    {
        chat=[[ChatViewController alloc] initWithNibName:@"ChatViewControlleriphone4" bundle:nil];
    }
    [self.navigationController pushViewController:chat animated:YES ];
    [chat release];
    if (App.chatMessageCount!=0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int count=0;
            [self setChatCount:count];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
            });
        });
    }
    
    
    
}

- (void ) setChatCount:(int)count
{
    // http://chat.eitcl.co.uk/devchat/index.php/users/update_chats?user_id=1&chat_count=1
    NSString *str=[NSString stringWithFormat:@"http://chat.eitcl.co.uk/devchat/index.php/users/update_chats?user_id=%@&chat_count=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],count];
    
    NSURL *url = [NSURL URLWithString:str];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    
    NSURLResponse *response;
    NSError *err;
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    
    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSDictionary *result = [s JSONValue];
    
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


-(void)hideKeyBoard
{
    [txtSearch resignFirstResponder];
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"Response is = %@",inResponseDic);
    
    
    lblSellValue.text       = [[inResponseDic objectAtIndex:0] valueForKey:@"sell"];
    lblWatchValue.text      = [[inResponseDic objectAtIndex:0] valueForKey:@"watch"];
    lblBuyValue.text        = [[inResponseDic objectAtIndex:0] valueForKey:@"buy"];
    lblMessagesValue.text   = [[inResponseDic objectAtIndex:0] valueForKey:@"msgs"];
    lblReminderValue.text   = [[inResponseDic objectAtIndex:0] valueForKey:@"reminders"];
   // lblSavedValue.text = [[inResponseDic objectAtIndex:0]valueForKey:@"saved"];
    lblChatValue.text       = [[inResponseDic objectAtIndex:0] valueForKey:@"chats"];//[[inResponseDic objectAtIndex:0]valueForKey:@""];
    
    App.chatMessageCount    =[[[inResponseDic objectAtIndex:0] valueForKey:@"chats"] integerValue];
    
    if ([lblMessagesValue.text isEqualToString:@"0"])
    {
        imgMessageValue.hidden = YES;
        lblMessagesValue.hidden = YES;
    }
    else
    {
        imgMessageValue.hidden = NO;
        lblMessagesValue.hidden = NO;
    }
    
//    if (![(lblSavedValue.text)isEqualToString:@"0"]) {
//        imgSavedValue.hidden = NO;
//        lblSavedValue.hidden = NO;
//        
//    }

    if ([lblReminderValue.text isEqualToString:@"0"])
    {
        imgReminderValue.hidden = YES;
        lblReminderValue.hidden = YES;
    }
    else
    {
        imgReminderValue.hidden = NO;
        lblReminderValue.hidden = NO;
    }
    
    if ([lblChatValue.text isEqualToString:@"0"])
    {
        imgChatValue.hidden = YES;
        lblChatValue.hidden = YES;
    }
    else
    {
        imgChatValue.hidden = NO;
        lblChatValue.hidden = NO;
    }
    
    //lblSavedValue.text = [[inResponseDic objectAtIndex:0]valueForKey:@"saved"];
    
    
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"*** requestErrorHandler *** and Error : %@",[inError debugDescription]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
