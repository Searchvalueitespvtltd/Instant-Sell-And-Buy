//
//  ShareViewController.m
//  ISB
//
//  Created by AppRoutes on 23/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ShareViewController.h"
#import "AddThis.h"
#import <Social/Social.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "OAuthLoginView.h"
#import "JSONKit.h"

@interface ShareViewController ()


@end

@implementation ShareViewController
@synthesize oAuthLoginView,message,imageUrl;
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
    
    message=[NSString stringWithFormat:@"Username is selling %@ item on Instant Sell & Buy to check products download Instant Sell & Buy from app store", [[ItemDetails sharedInstance].dicToShare valueForKey:@"title"]];
  //  imageUrl=[[ItemDetails sharedInstance].dicToShare valueForKey:@"imageUrl"];
    [AddThisSDK setAddThisPubId:@"ra-510b78746d30fd36"];
    [AddThisSDK setAddThisApplicationId:@"ra-510b78746d30fd36"];
    //Facebook connect settings
	//CHANGE THIS FACEBOOK API KEY TO YOUR OWN!!
	[AddThisSDK setFacebookAPIKey:@"153781354820625"];
	[AddThisSDK setFacebookAuthenticationMode:ATFacebookAuthenticationTypeFBConnect];
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
#pragma mark Twitter
+(void)showNoTWAccountAlertInViewController:(UIViewController *)vc
{
    TWTweetComposeViewController *twViewC = [[TWTweetComposeViewController alloc] init];
    //Try to present Twitter composer which will show "No Twitter Accounts" alert if Twitter account not configured in device
    [vc presentViewController:twViewC animated:YES completion:nil];
    [twViewC release];
    
    //hide the tweet screen
    twViewC.view.hidden = YES;
    //hide the keyboard
    [twViewC.view endEditing:YES];
    
    //fire tweetComposeView to show "No Twitter Accounts" alert view on iOS5.1
    twViewC.completionHandler = ^(TWTweetComposeViewControllerResult result) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    };
}

+(void)openTWComposerInViewController:(UIViewController *)vc withText:(NSString *)initialText
{
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    NSArray *array=[initialText componentsSeparatedByString:@"!!!"];

    [twitter setInitialText:initialText];
    [twitter setTitle:@"Instant Sell & Buy"];
    
    
   // [twitter set]
    [vc presentViewController:twitter animated:YES completion:nil];
    
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
        
        [vc dismissViewControllerAnimated:YES completion:nil];
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
   // [self.navigationController pushViewController:oAuthLoginView animated:YES];
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
    
   
    NSString *messageNew=[NSString stringWithFormat:@"%@ is selling %@ item on Instant Sell & Buy. To check products download Instant Sell & Buy from app store",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"], [[ItemDetails sharedInstance].dicToShare valueForKey:@"title"]];
    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc]
                             initWithObjectsAndKeys:
                             @"anyone",@"code",nil], @"visibility",
                            messageNew, @"comment", nil];
//    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            [[NSDictionary alloc]
//                             initWithObjectsAndKeys:
//                             @"anyone",@"code",nil], @"visibility",
//                            @"Instant Sell & Buy", @"comment",[[NSDictionary alloc]
//                                                     initWithObjectsAndKeys:
//                                                     [[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"desc"],@"description",
//                                                     // @"www.google.com",@"submittedUrl",
//                                                     messageNew,@"title",
//                                                     imageUrl,@"submittedUrl",nil],@"content", nil];
    
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


- (IBAction)btnFacebook:(id)sender {
    [AddThisSDK shareURL:@"http://www.facebook.com/pages/Instant-Sell-Buy/220452178111647?skip_nax_wizard=true"
             withService:@"facebook"
                   title:@"Instant Sell & Buy"
             description:[NSString stringWithFormat:@"%@ is selling %@ item on Instant Sell & Buy. To check products download Instant Sell & Buy from app store",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"],[[ItemDetails sharedInstance].dicToShare valueForKey:@"title"]]];
}

- (IBAction)btnTwitter:(id)sender {
    if ([TWTweetComposeViewController canSendTweet]) {
     //   NSString *messageWithUrl=[message stringByAppendingFormat:@"!!! %@",imageUrl];
        [ShareViewController openTWComposerInViewController:self withText:[NSString stringWithFormat:@"%@ is selling %@ item on Instant Sell & Buy. To check products download Instant Sell & Buy from app store",[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"], [[ItemDetails sharedInstance].dicToShare valueForKey:@"title"]]];
    }
    else {
        [ShareViewController showNoTWAccountAlertInViewController:self];
    }
}

- (IBAction)btnLinkedIn:(id)sender {
    [self linkedIn];
}

- (IBAction)btnDone:(id)sender {
                   [self.navigationController popToRootViewControllerAnimated:YES];

}
@end
