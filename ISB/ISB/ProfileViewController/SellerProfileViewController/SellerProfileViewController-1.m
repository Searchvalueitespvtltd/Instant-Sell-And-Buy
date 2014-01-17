//
//  ProfileViewController.m
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SellerProfileViewController.h"
#import "EditViewController.h"
#import "SellViewController.h"
#import "Users.h"
#import "CXMPPController.h"
#import "ItemViewController.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"

@interface SellerProfileViewController ()

@end

@implementation SellerProfileViewController
@synthesize profileNameLbl,emailAddressLbl,profilePicImg,locationlbl,yearLbl,imgUserDefaultImage,ContactNoLbl;
@synthesize strItemId,strUserId,service,postage,itemDescribed;

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
    self.service = 0.0;
    self.postage = 0.0;
    self.postage = 0.0;
    [self ShowDefaultRating];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self callUserDetailService];
    [super viewWillAppear:YES];
}

- (IBAction)backButton:(id)sender
{
    ItemViewController *itemDetailView=[[ItemViewController alloc]init];
    itemDetailView.isWatching = 1;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ShowDefaultRating
{
    service = 5 ; // round off the values.
    postage = 5;
    itemDescribed = 5;
    
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

-(void)callUserDetailService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/get?user_id=%@",strUserId] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"Response is = %@",inResponseDic);
    if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
    {
        NSString *mystring;
        //            NSLog(@"Response is = %@",inResponseDic);
        profileNameLbl.text = [[inResponseDic objectAtIndex:0]valueForKey:@"display_name"];
        locationlbl.text = [[inResponseDic objectAtIndex:0]valueForKey:@"country_name"];
        emailAddressLbl.text = [[inResponseDic objectAtIndex:0]valueForKey:@"email"];

        mystring = [[inResponseDic objectAtIndex:0]valueForKey:@"created_dt"];
        NSArray *stringWithoutChar = [mystring componentsSeparatedByString:@" "];
        mystring = [stringWithoutChar objectAtIndex:0];
        stringWithoutChar = [mystring componentsSeparatedByString:@"-"];
        mystring = [stringWithoutChar objectAtIndex:0];
        yearLbl.text = mystring;

        ContactNoLbl.text = [[inResponseDic objectAtIndex:0]valueForKey:@"primary_phone"];
        
        NSString *imagepath = [[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"];
        NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
        
//        if (imagepath.length>0 || [[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"]isEqual:[NSNull null]])
//        {
//        [self doFetchEditionImage:[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"] withIndex:0];
//        }
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
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
//        if (![imageData isEqual:[NSNull null]])
//        {
//            self.imgUserDefaultImage.hidden = YES;
//            profilePicImg.image = [UIImage imageWithData:imageData];
//        }
        
        self.service = [[[inResponseDic objectAtIndex:0]valueForKey:@"rating_service"] floatValue];
        self.postage = [[[inResponseDic objectAtIndex:0]valueForKey:@"rating_postage"] floatValue];
        self.itemDescribed = [[[inResponseDic objectAtIndex:0]valueForKey:@"rating_item_as_described"] floatValue];
        
        [self callUserrating];
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
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


-(void)callUserrating
{
//    float service = 3.6 ; // round off the values.
//    float postage = 1;
//    float itemDescribed = 5;

    for (int i = 1;i<=(int)service;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:10+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
    }
//    if (service > (int)service)
//    {
//        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:10+(int)service+1];
//        [imgRating setImage:[UIImage imageNamed:@"star_half"]];
//    }
    for (int i = 1;i<=(int)postage;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:20+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
    }
//    if (postage > (int)postage )
//    {
//        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:20+(int)postage+1];
//        [imgRating setImage:[UIImage imageNamed:@"star_half"]];
//    }
    for (int i = 1;i<=(int)itemDescribed;i++)
    {
        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:30+i];
        [imgRating setImage:[UIImage imageNamed:@"starRatingOn"]];
    }
//    if (itemDescribed > (int)itemDescribed && !((int)itemDescribed ==5))
//    {
//        UIImageView *imgRating=(UIImageView *)[self.view viewWithTag:30+(int)itemDescribed+1];
//        [imgRating setImage:[UIImage imageNamed:@"star_half"]];
//    }
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
    [ContactNoLbl release];
    [super dealloc];
}

@end
