//
//  PostLinkedInViewC.m
//  ISB
//
//  Created by AppRoutes on 23/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "PostLinkedInViewC.h"
#import "JSONKit.h"

@interface PostLinkedInViewC ()

@end

@implementation PostLinkedInViewC
@synthesize oAuthLoginView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.txtVw.text isEqualToString:@"Share Something Here..."]) {
        self.txtVw.text=@"";
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text=@"Share Something Here...";
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self linkedIn];
    self.txtVw.text=@"Share Something Here...";
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    if (App.isShared) {
        [self.navigationController popViewControllerAnimated:YES ];
        App.isShared=NO;
    }
}
- (void)linkedIn
{
    App.isShared=NO;
//    if ([Utils isIPhone_5]) {
//        oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:@"OAuthLoginView_iPhone5" bundle:nil];
//
//    }else
    oAuthLoginView = [[OAuthLoginView alloc] initWithNibName:nil bundle:nil];
    [oAuthLoginView retain];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginViewDidFinish:)
                                                 name:@"loginViewDidFinish"
                                               object:oAuthLoginView];
  //  [self.navigationController pushViewController:oAuthLoginView animated:YES];
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
    
//    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            [[NSDictionary alloc]
//                             initWithObjectsAndKeys:
//                             @"anyone",@"code",nil], @"visibility",
//                            self.txtVw.text, @"comment",[[NSDictionary alloc]
//                                                     initWithObjectsAndKeys:
//                                                     self.txtVw.text,@"description",
//                                                     // @"www.google.com",@"submittedUrl",
//                                                     @"Instant Sell and Buy",@"title"
//                                                     ,nil],@"content", nil];
    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
                            [[NSDictionary alloc]
                             initWithObjectsAndKeys:
                             @"anyone",@"code",nil], @"visibility",
                            self.txtVw.text, @"comment", nil];
//    NSDictionary *update = [[NSDictionary alloc] initWithObjectsAndKeys:
//                            [[NSDictionary alloc]
//                             initWithObjectsAndKeys:
//                             @"anyone",@"code",nil], @"visibility",
//                            self.txtVw.text, @"comment",[[NSDictionary alloc]
//                                                         initWithObjectsAndKeys:
//                                                         self.txtVw.text,@"description",
//                                                         // @"www.google.com",@"submittedUrl",
//                                                         @"title goes here",@"title",
//                                                         @"http://economy.blog.ocregister.com/files/2009/01/linkedin-logo.jpg",@"submittedUrl",nil],@"content", nil];
    
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
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_txtVw release];
    [super dealloc];
}
- (IBAction)btnPost:(id)sender {
    if ([self.txtVw.text isEqualToString:@""] || [self.txtVw.text isEqualToString:@"Share Something Here..."]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Enter some text to post" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }else{
    [self postOnLinkedIn];
       // [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)btnStopEditing:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
