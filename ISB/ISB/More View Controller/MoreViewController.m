//
//  MoreViewController.m
//  ISB
//
//  Created by AppRoutes on 19/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MoreViewController.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import <QuartzCore/QuartzCore.h>
#import "AboutViewController.h"
#include <sys/xattr.h>
#import "AddThis.h"
#import "OAuthLoginView.h"
#import "JSONKit.h"
#import "PostLinkedInViewC.h"
#import "SettingViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController
UIBarButtonItem *button;
@synthesize oAuthLoginView;
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
    [self.navigationController setNavigationBarHidden:YES];
    NSArray *arrTemp1 = [[NSArray alloc]
                         initWithObjects:@"Settings",@"About",@"Report a bug",nil];
    NSArray *arrTemp2 = [[NSArray alloc]
                         initWithObjects:@"Invite by SMS",@"Share on Facebook",@"Share on Twitter",@"Share on LinkedIn",@"Invite by email",nil];
//    NSArray *arrTemp3 = [[NSArray alloc]
//                         initWithObjects:@"eBay",@"Amazon",@"Facebook",@"Twitter",nil];
    NSDictionary *temp =[[NSDictionary alloc]
                         initWithObjectsAndKeys:arrTemp1,@"",arrTemp2,
                         @"Invite to ISB",nil];
    self.tableContents =temp;
    [temp release];
    [AddThisSDK setAddThisPubId:@"ra-510b78746d30fd36"];
    [AddThisSDK setAddThisApplicationId:@"ra-510b78746d30fd36"];
    //Facebook connect settings
	//CHANGE THIS FACEBOOK API KEY TO YOUR OWN!!
	[AddThisSDK setFacebookAPIKey:@"153781354820625"];
	[AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
//    self.sortedKeys =[[self.tableContents allKeys]
//                      sortedArrayUsingSelector:@selector(compare:)];
    self.sortedKeys =[self.tableContents allKeys];
                      
//NSLog(@"Linked IN %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"LinkedInoAuth"]);
    [arrTemp1 release];
    [arrTemp2 release];
 //   [arrTemp3 release];
    
//    if ([Utils isIPhone_5]) {
//        self.moreTable.frame=CGRectMake(0, 41, 320, 527);
//    }else
//        self.moreTable.frame=CGRectMake(0, 41, 320, 439);
    
   
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    [ItemDetails sharedInstance].isSelected =0;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - facebook sharing implementation

-(void)cancel:(id)sender
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationController.navigationBarHidden=YES;
}
- (void)btnFacebook {
    
    self.navigationController.navigationBarHidden=YES;
    [self.navigationController setNavigationBarHidden:YES];
//	button=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
//    self.navigationItem.title=@"Facebook";
//    self.navigationItem.leftBarButtonItem=button;
    // [button release];
    
	//alloc and initalize our FbGraph instance

}


#pragma mark table view datasource and delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.sortedKeys count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"";
            break;
        case 1:
            return @"Invite to ISB";
            break;
//        case 2:
//            return @"Integrate your ISB";
//            break;
        default:
            break;
    }
//    return [self.sortedKeys objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)table
 numberOfRowsInSection:(NSInteger)section {
    NSArray *listData =[self.tableContents objectForKey:
                        [self.sortedKeys objectAtIndex:section]];
    return [listData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    NSArray *listData;
    switch (indexPath.section) {
        case 0:
            listData =[self.tableContents objectForKey:
                       @""];
            break;
        case 1:
            listData =[self.tableContents objectForKey:
                       @"Invite to ISB"];
            break;
//        case 2:
//            listData =[self.tableContents objectForKey:@"Integrate your ISB"];
//            break;
        default:
            break;
    }
    
    
    UITableViewCell * cell = [tableView
                              dequeueReusableCellWithIdentifier: SimpleTableIdentifier];
    
    if(cell == nil) {
        
        cell = [[[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault
                 reuseIdentifier:SimpleTableIdentifier] autorelease];
        UIView *selectionColor = [[UIView alloc] init];
      //selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        
    
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
    
//        NSUInteger cellPosition;
//        if (indexPath.row == 0) {
//            cellPosition = 0;
//        } else {
//            cellPosition = 1;
//        }
//        
//        NSInteger numberOfRows = [tableView numberOfRowsInSection:indexPath.section];
//        if (indexPath.row == numberOfRows - 1) {
//            if (cellPosition == 0) {
//                cellPosition = 3;
//            } else {
//                cellPosition = 2;
//            }
//        }
//        
//        if (cellPosition != 2) {
//            selectionColor.layer.cornerRadius = 10;
//            CALayer *patchLayer;
//            if (cellPosition == 0) {
//                patchLayer = [CALayer layer];
//                patchLayer.frame = CGRectMake(0, 0, 302, 40);
//                patchLayer.backgroundColor = [[UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1] CGColor];
//                [selectionColor.layer addSublayer:patchLayer];
//            } else if (cellPosition == 2) {
//                patchLayer = [CALayer layer];
//                patchLayer.frame = CGRectMake(0, 0, 302, 40);
//                patchLayer.backgroundColor = [[UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1] CGColor];
//                [selectionColor.layer addSublayer:patchLayer];
//            }
//        }
        cell.selectedBackgroundView = selectionColor;
        
    }
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                case 1:
                    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 2:
                    cell.accessoryType=UITableViewCellAccessoryNone;
                    break;
                default:
                    break;
            }
            break;
           case 1:
            cell.accessoryType=UITableViewCellAccessoryNone;
            break;
//        case 2:
//            cell.accessoryType=UITableViewCellAccessoryNone;
//            break;
        default:
            break;
    }
    NSUInteger row = [indexPath row];
    cell.textLabel.text = [listData objectAtIndex:row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *listData=[[NSArray alloc]init];
    AboutViewController *about;
    SettingViewController *setting;
    PostLinkedInViewC *post;
    switch (indexPath.section) {
        case 0:
            listData =[self.tableContents objectForKey:
                       @""];
            switch (indexPath.row) {
                case 0:
                    if ([Utils isIPhone_5]) {
                        setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController_iPhone5" bundle:nil];
                    }else
                        setting=[[SettingViewController alloc]initWithNibName:@"SettingViewController" bundle:nil];
                    [self.navigationController pushViewController:setting animated:YES];
                    break;
                case 1:
                    if ([Utils isIPhone_5]) {
                        about=[[AboutViewController alloc]initWithNibName:@"AboutViewController_iPhone5" bundle:nil];
                    }else
                        about=[[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
                    [self.navigationController pushViewController:about animated:YES];
                    break;
                case 2:
                {
                    NSString * strTicket;
                    
                    //////////
                    
                    NSDate *currDate = [NSDate date];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
                    [dateFormatter setDateFormat:@"ddMMYY"];
                    NSString *currentTime = [dateFormatter stringFromDate:currDate];
                    NSLog(@"%@",currentTime);
                    
                    //////////ddMMYY
                    
                    int number = arc4random_uniform(90000000) + 10000000;
                    
                    strTicket = [[NSString stringWithFormat:@"%@",[[[[NSUserDefaults standardUserDefaults]objectForKey:@"USER_NAME"] stringByAppendingString:[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%@",currentTime]]] stringByAppendingString:[NSString stringWithFormat:@"%d",number]]]stringByReplacingOccurrencesOfString:@" " withString:@""];
                    
                    //                    [self actionEmailComposer:[NSArray arrayWithObject:@"Info@eitcl.co.uk"] Message:@"Report a bug" Subject:@"Report a bug"];
                    [self actionEmailComposer:[NSArray arrayWithObject:@"Info@eitcl.co.uk"] Message:@"Report a bug" Subject:[NSString stringWithFormat:@"Report a bug %@",strTicket]];
                    break;
                }
//                    [self actionEmailComposer:[NSArray arrayWithObject:@"Info@eitcl.co.uk"] Message:@"Report a bug" Subject:@"Report a bug"];
                  //  break;
                default:
                    break;
            }
            break;
        case 1:
            listData =[self.tableContents objectForKey:
                       @"Invite to ISB"];
           // NSString *phoneToSms;
           // NSString *phoneToSmsEncoded;
            switch (indexPath.row) {
                case 0:
//                    phoneToSms = @"www.eitcl.co.uk/instantbuyandsell";
//                    phoneToSmsEncoded = [phoneToSms stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
//                    NSURL *url = [[NSURL alloc] initWithString:phoneToSmsEncoded];
                    
//                    [[UIApplication sharedApplication] openURL:url];
                    [self sendMessage:[NSMutableArray arrayWithObject:@""] Message:@"" Subject:@""];
                    break;
                case 1:
                    
                    messageNew=[NSString stringWithFormat:@"%@ is using ISB app to sell his items instantly.Download ISB now.",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"]];
                    [AddThisSDK shareURL:@"http://www.facebook.com/pages/Instant-Sell-Buy/220452178111647?skip_nax_wizard=true"
                             withService:@"facebook"
                                   title:@"ISB"
                             description:messageNew];
                    break;
                case 2:
                    if ([TWTweetComposeViewController canSendTweet]) {
                        [MoreViewController openTWComposerInViewController:self withText:@"I’m using ISB to sell my unused items instantly. www.eitcl.co.uk/instantsellandbuy"];
                    }
                    else {
                        [MoreViewController showNoTWAccountAlertInViewController:self];
                    }
                    break;
                case 3:
//                    if ([Utils isIPhone_5])
//                    {
//                        post=[[PostLinkedInViewC alloc]initWithNibName:@"PostLinkedInViewC_iPhone5" bundle:nil];
//                    }else
//                    {
                        post=[[PostLinkedInViewC alloc]initWithNibName:@"PostLinkedInViewC" bundle:nil];
//                    }
                    
                    [self.navigationController pushViewController:post animated:NO];
                //    [self linkedIn];
                    break;
                case 4:
                    
                    pageLink = @"www.eitcl.co.uk/instantsellandbuy"; // replace it with yours
                    //pageLink = @"wuer qwy bn iqsyre bv ";
                    iTunesLink = @"http://link-to-mygreatapp"; // replate it with yours
                    emailBody =
                    [NSString stringWithFormat:@"<p>Hey,   <p>  I started using ISB. It&rsquo;s a cool app that lets you buy and sell items instantly.</p> ISB is easy to use and works on all apple mobile devices.</p><p>&bull; FREE instant Live Chat with Buyer or Seller of the Item.<p> &bull; FREE instant SMS to Buyer or Seller of the Item. <p>&bull; FREE instant mails to Buyer or Seller of the item. <p>&bull; Instant share of the item with your family, friends and professional colleagues. <p>&bull; FREE notification of favourite items near your current GPS location.</p></p></p></p><p>Get ISB: <a href=\"www.eitcl.co.uk/instantbuyandsell\">%@</a> <p>App store: <a href=\"http://link-to-mygreatapp\">%@</a> <p>Yours,<p> %@ </p></p></p></p></p>", pageLink, iTunesLink,[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"]];
                    [self actionEmailComposer:[NSArray arrayWithObject:@""] Message:emailBody Subject:@"ISB"];
                    
                    break;

                default:
                    break;
            }

            break;

        default:
            break;
    }

    NSUInteger row = [indexPath row];
    NSString *rowValue = [listData objectAtIndex:row];
    
//    NSString *message = [[NSString alloc] initWithFormat:rowValue];
//    UIAlertView *alert = [[UIAlertView alloc]
//                          initWithTitle:@"You selected"
//                          message:message delegate:nil
//                          cancelButtonTitle:@"OK"
//                          otherButtonTitles:nil];
//    [alert show];
//    [alert release];
//    [message release];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Message Api implementation
-(void)sendMessage:(NSMutableArray*)arrayPhoneNumbers Message:(NSString*) msg1 Subject:(NSString*) sub
{
    MFMessageComposeViewController *messageView = [[MFMessageComposeViewController alloc]init];
    if ([MFMessageComposeViewController canSendText])
    {
//        NSString *messageBody = msg1;
        NSString *messageBody = @"Hey, I started using Instant Sell & Buy. It’s a cool app that lets you buy and sell items instantly! www.eitcl.co.uk/instantsellandbuy";
        messageView.body = messageBody;
        
        messageView.recipients = arrayPhoneNumbers;
        messageView.messageComposeDelegate=self;
        [self presentModalViewController:messageView animated:YES];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //   NSString *msgcancelled;
    switch (result)
    {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:Nil];
    
}

#pragma mark - Mail Api implementation

- (IBAction)actionEmailComposer:(NSArray*)mailAddress Message:(NSString*) msg1 Subject:(NSString*)sub
{
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:sub];
    [controller setMessageBody:msg1 isHTML:YES];
    
   // [controller addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"photo name"];
    [controller setToRecipients:mailAddress];
;
    if (controller) [self presentViewController:controller animated:YES completion:nil];
    
    
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    // Notifies users about errors associated with the interface
    UIAlertView *alert;
    switch (result)
    {
        case MFMailComposeResultCancelled:
            
            
            break;
        case MFMailComposeResultSaved:
            
            break;
            
        case MFMailComposeResultSent:
            
            alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Email Sent Successfully" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            
            break;
        case MFMailComposeResultFailed:
            //NSLog(@"Result: failed");
            alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Email Sending Failed" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
            [alert show];
            break;
            
        default:
            //NSLog(@"Result: not sent");
            break;
    }
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark Twitter 
+(void)showNoTWAccountAlertInViewController:(UIViewController *)vc
{
    TWTweetComposeViewController *twViewC = [[TWTweetComposeViewController alloc] init];
    //Try to present Twitter composer which will show "No Twitter Accounts" alert if Twitter account not configured in device
    [vc presentModalViewController:twViewC animated:YES];
    [twViewC release];
    
    //hide the tweet screen
    twViewC.view.hidden = YES;
    //hide the keyboard
    [twViewC.view endEditing:YES];
    
    //fire tweetComposeView to show "No Twitter Accounts" alert view on iOS5.1
    twViewC.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        [vc dismissModalViewControllerAnimated:NO];
    };
}

+(void)openTWComposerInViewController:(UIViewController *)vc withText:(NSString *)initialText
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    [twitter setInitialText:initialText];
    [vc presentModalViewController:twitter animated:YES];
    [twitter release];
    
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        //    NSString *title = @"Tweet";
        NSString *msg;
        
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"You bailed on your tweet...";
        else msg = @"Hurray! Your tweet was tweeted!";
        
        //        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        //        [alertView show];
        //        [alertView release];
        
        [vc dismissModalViewControllerAnimated:YES];
    };
}
- (void)linkedIn
{
   oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    [oAuthLoginView retain];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oAuthLoginView];
    
    [self presentViewController:oAuthLoginView animated:YES completion:Nil];
}
-(void) loginViewDidFinish:(NSNotification*)notification
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];

//    [[NSUserDefaults standardUserDefaults] setObject:App.oAuthLoginView forKey:@"LinkedInoAuth"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
 
    // We're going to do these calls serially just for easy code reading.
    // They can be done asynchronously
    // Get the profile, then the network updates
  //  [self profileApiCall];
	[self postOnLinkedIn];
}
- (void)postOnLinkedIn
{
  
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/shares"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    //    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
    //                            [[NSDictionary alloc]
    //                             initWithObjectsAndKeys:
    //                             @"anyone",@"code",nil], @"visibility",
    //                            statusTextView.text, @"comment", nil];
    
    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc]
                             initWithObjectsAndKeys:
                             @"anyone",@"code",nil], @"visibility",
                            @"App Test", @"comment",[[NSDictionary alloc]
                                                             initWithObjectsAndKeys:
                                                             @"description goes here",@"description",
                                                             // @"www.google.com",@"submittedUrl",
                                                             @"title goes here",@"title",
                                                             @"http://economy.blog.ocregister.com/files/2009/01/linkedin-logo.jpg",@"submittedUrl",nil],@"content", nil];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *updateString = [update JSONString];
    
    [request setHTTPBodyWithString:updateString];
	[request setHTTPMethod:@"POST"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(postUpdateApiCallResult:didFinish:)
                  didFailSelector:@selector(postUpdateApiCallResult:didFail:)];
    [request release];
}
- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    // The next thing we want to do is call the network updates
   [self networkApiCall];
    
}
- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    OAMutableURLRequest *request =
    [[OAMutableURLRequest alloc] initWithURL:url
                                    consumer:oAuthLoginView.consumer
                                       token:oAuthLoginView.accessToken
                                    callback:nil
                           signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request
                         delegate:self
                didFinishSelector:@selector(networkApiCallResult:didFinish:)
                  didFailSelector:@selector(networkApiCallResult:didFail:)];
    [request release];
    
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
       
       
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}

- (void)postUpdateApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@",[error description]);
}
- (void)dealloc {
    [_moreTable release];
    [super dealloc];
}
@end
