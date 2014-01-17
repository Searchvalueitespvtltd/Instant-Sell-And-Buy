//
//  UserDetailViewController.m
//  ISB
//
//  Created by AppRoutes on 13/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "UserDetailViewController.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"

@interface UserDetailViewController ()

@end

@implementation UserDetailViewController
@synthesize viewReview,lblViewTitle,strUserId,strItemId,strItem_as_described,strPostage,strService,strViewTitle,imgUserDefaultImage,profilePicImg;
@synthesize lblContectNumber,lblCustAdd,lblCustName,lblDealAmount,lblEmailId;

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
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    self.lblViewTitle.text = strViewTitle;
    self.strService = @"0";
    self.strPostage = @"0";
    self.strItem_as_described = @"0";
    
    if ([strViewTitle isEqualToString:@"Buyer Details"])
    {
        self.viewReview.hidden = YES;
    }
    else
    {
        self.viewReview.hidden = NO;
        [self ShowDefaultRating];
    }
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self callUserDetailServise];
    
    [super viewWillAppear:YES];
}

-(void)ShowDefaultRating
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Methods

-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnReviewClicked:(id)sender
{
    UIButton *btnReview  = (UIButton *)sender;
    NSString *tag = [NSString stringWithFormat:@"%d",btnReview.tag];

    if ([[tag substringToIndex:1]isEqualToString:@"1"])
    {
        for (int i = 101;i<=101+5;i++)
        {
            UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:i-90];
            [imgRating setImage:[UIImage imageNamed:@"starRatingOff"]];
        }
        
        for (int i = 101;i<=[tag integerValue];i++)
        {
            UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:i-90];
            [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
        }
        self.strService = [NSString stringWithFormat:@"%d",[tag integerValue]-100];
    }
    
    if ([[tag substringToIndex:1]isEqualToString:@"2"])
    {
        for (int i = 201;i<=201+5;i++)
        {
            UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:i-180];
            [imgRating setImage:[UIImage imageNamed:@"starRatingOff"]];
        }
        for (int i = 201;i<=[tag integerValue];i++)
        {
            UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:i-180];
            [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
        }
        self.strPostage = [NSString stringWithFormat:@"%d",[tag integerValue]-200];
    }
    
    if ([[tag substringToIndex:1]isEqualToString:@"3"])
    {
        for (int i = 301;i<=301+5;i++)
        {
            UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:i-270];
            [imgRating setImage:[UIImage imageNamed:@"starRatingOff"]];
        }
        for (int i = 301;i<=[tag integerValue];i++)
        {
            UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:i-270];
            [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
        }
        self.strItem_as_described = [NSString stringWithFormat:@"%d",[tag integerValue]-300];
    }
}

-(IBAction)btnSendReview:(id)sender
{
    if ([strService isEqualToString:@"0"]&&[strPostage isEqualToString:@"0"]&&[strItem_as_described isEqualToString:@"0"])
    {
        [Utils showAlertView:kAlertTitle message:@"Are you sure you don't want to rate?" delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO"];
        return;
    }
    else
    {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self callUserRatingService];
    }
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
      //  [Utils startActivityIndicatorInView:self.view withMessage:nil];
       // [self callUserRatingService];
    }
}


#pragma mark - Call WebService
-(void)callUserDetailServise
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/get?user_id=%@",strUserId] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)callUserRatingService
{
    NetworkService *objService = [[NetworkService alloc]init];
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"ratings/save?user_id=%@&item_id=%@&service=%@&postage=%@&item_as_described=%@",strUserId,strItemId,strService,strPostage,strItem_as_described] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"Response is = %@",inResponseDic);
    if([inReqIdentifier rangeOfString:@"users/get?"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
//            NSLog(@"Response is = %@",inResponseDic);
            lblCustName.text = [[inResponseDic objectAtIndex:0]valueForKey:@"display_name"];
            lblCustAdd.text = [[inResponseDic objectAtIndex:0]valueForKey:@"country_name"];
            lblEmailId.text = [[inResponseDic objectAtIndex:0]valueForKey:@"email"];
            lblContectNumber.text = [[inResponseDic objectAtIndex:0]valueForKey:@"primary_phone"];
            
            NSString *imagepath = [[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"];
            NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
            
//            if (imagepath.length>0 || [[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"]isEqual:[NSNull null]])
//            {
//                [self doFetchEditionImage:[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"] withIndex:0];
//            }
            
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


            // "created_dt": "2013-08-01 06:57:52"
        }
        else
        {
            
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Feedback send successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
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
    [aRequest SetResponseHandler:@selector(handledImage:) ];
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
}

- (void)dealloc
{
    [lblCustName release];
    [lblCustAdd release];
    [lblEmailId release];
    [lblContectNumber release];
    [lblDealAmount release];
    [super dealloc];
}
@end
