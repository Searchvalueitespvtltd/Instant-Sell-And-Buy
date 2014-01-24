//
//  ProfileViewController.m
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#define kRatingAll @"rating_all"
#define kRatingCount @"rating_count"
#define kRatingItemDescribed @"rating_item_as_described"
#define kRatingPostage @"rating_postage"
#define kRatingService @"rating_service"
#define kChats @"chats"
#define kCity @"city"
#define kCountryId @"country_id"
#define kCountryName @"country_name"
#define kCreated_by @"created_by"
#define kCreated_dt @"created_dt"
#define kDeviceToken @"device_token"
#define kDisplayName @"display_name"
#define kEmail @"email"
#define kGenderId @"gender_id"
#define kFName @"fname"
#define kHomeAdr @"home_addr"
#define kId @"id"
#define kISDCode @"isd_code"
#define kLastModifiedBy @"last_modified_by"
#define kLastModifiedDt @"last_modified_dt"
#define kLName @"lname"
#define kPayPalAccount @"paypal_account"
#define kPrimaryPhone @"primary_phone"
#define kProfilePicPath @"profile_pic_path"
#define kPwd @"pwd"
#define kPwdChangeReqd @"pwd_change_reqd"
#define kStateName @"state_name"
#define kUniqueId @"unique_id"
#define kStatus @"status"
#define kUserLevel @"user_level"
#define kUserName @"username"
#define kZipCode @"zipcode"

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

- (BOOL) checkForNullString:(NSString*)string;

- (NSString*) stringWithoutNullValue:(NSString*) str;



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

- (IBAction)saveRatingBtn:(id)sender
{
    NetworkService* netwrkServiceObj = [[NetworkService alloc] init];
    [userDetailDictionary setObject:@"2" forKey:kRatingCount];
    [userDetailDictionary setObject:@"2" forKey:kRatingAll];
    [userDetailDictionary setObject:@"2" forKey:kRatingItemDescribed];
    [userDetailDictionary setObject:@"2" forKey:kRatingPostage];
    [userDetailDictionary setObject:@"2" forKey:kRatingService];
    NSString* requestStr = [NSString stringWithFormat:@"users/edit?username=%@&fname=%@&lname=%@&device_token=%@&home_adr=%@&city=%@&state_name=%@&country_id=%@&primary_phone=%@&isd_code=%@&email=%@&paypal_account=%@&chats=%@&country_name=%@&created_by=%@&created_dt=%@&display_name=%@&gender_id=%@&id=%@&last_modified_by=%@&last_modified_dt=%@&profile_pic_path=%@&pwd=%@&pwd_change_reqd=%@&rating_all=%@&rating_count=%@&rating_item_as_described=%@&rating_postage=%@&rating_service=%@&status=%@&unique_id=%@&user_level=%@&zipcode=%@",[userDetailDictionary objectForKey:kUserName],[userDetailDictionary objectForKey:kFName], [userDetailDictionary objectForKey:kLName], [userDetailDictionary objectForKey:kDeviceToken], [userDetailDictionary objectForKey:kHomeAdr], [userDetailDictionary objectForKey:kCity],[userDetailDictionary objectForKey:kStateName], [userDetailDictionary objectForKey:kCountryId],[userDetailDictionary objectForKey:kPrimaryPhone], [userDetailDictionary objectForKey:kISDCode],[userDetailDictionary objectForKey:kEmail], [userDetailDictionary objectForKey:kPayPalAccount], [userDetailDictionary objectForKey:kChats], [userDetailDictionary objectForKey:kCountryName], [userDetailDictionary objectForKey:kCreated_by], [userDetailDictionary objectForKey:kCreated_dt], [userDetailDictionary objectForKey:kDisplayName],[userDetailDictionary objectForKey:kGenderId], [userDetailDictionary objectForKey:kId], [userDetailDictionary objectForKey:kLastModifiedBy], [userDetailDictionary objectForKey:kLastModifiedDt], [userDetailDictionary objectForKey:kProfilePicPath], [userDetailDictionary objectForKey:kPwd], [userDetailDictionary objectForKey:kPwdChangeReqd], [userDetailDictionary objectForKey:kRatingAll], [userDetailDictionary objectForKey:kRatingCount], [userDetailDictionary objectForKey:kRatingItemDescribed], [userDetailDictionary objectForKey:kRatingPostage], [userDetailDictionary objectForKey:kRatingService], [userDetailDictionary objectForKey:kStatus], [userDetailDictionary objectForKey:kUniqueId], [userDetailDictionary objectForKey:kUserLevel],[userDetailDictionary objectForKey:kZipCode]];
    
    [netwrkServiceObj sendRequestToServer:requestStr dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];

//    requestStr = [requestStr stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSURL* url = [NSURL URLWithString:[kBaseURL stringByAppendingString:requestStr]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    
//       
//    NSURLResponse *response;
//    NSError *err;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//    
//    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    //    NSLog(@"%@",s);
//    NSArray *result = [s JSONValue];
//    //    NSLog(@"result: %@",result);
//    
//    if([[result objectAtIndex:0]isEqualToString:@"success"])
//    {
//        [Utils showAlertView:nil message:@"We have updated your details !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//      //  [self delete];
//       // [self saveToDatabase];
//    }
//    else
//    {
//        [Utils showAlertView:nil message:@"Error!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    }
//    
//    [Utils stopActivityIndicatorInView:self.view];
//    NSString *urlString = [NSString stringWithFormat:@"users/edit?username=%@&fname=%@&lname=%@&zip=%@&device_token=%@&home_addr=%@&city=%@&state_name=%@&country_id=%@&primary_phone=%@&isd_code=%@&email=%@&paypal_account=%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"],firstNameTxtField.text,lastNameTxtField.text,zipCodeTxtField.text,[[NSUserDefaults standardUserDefaults]valueForKey:kDevicetoken],addressTxtField.text,cityTxtPassword.text,stateTxtField.text,Country_id,phoneNoTxtField.text,phoneNoPrefixTxtField.text,emailAddressTxtField.text,self.txtPayPalaccountId.text];
//    urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingString:urlString]];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    
//    if(self.imgCamera.image != NULL)
//    {
//        NSString *imgString = [UIImagePNGRepresentation(self.imgCamera.image) base64Encoding];
//        NSString *str=[@"img=" stringByAppendingString:imgString];
//        NSData *postData = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        [request setHTTPBody:postData];
//    }
//    
//    
//    NSURLResponse *response;
//    NSError *err;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
//    
//    NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    //    NSLog(@"%@",s);
//    NSArray *result = [s JSONValue];
//    //    NSLog(@"result: %@",result);
    

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
    if ([inResponseDic count] >0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            if (userDetailDictionary)
            {
                [userDetailDictionary release];
            }
            
            userDetailDictionary = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[inResponseDic objectAtIndex:0]];
            NSString *mystring;
        //            NSLog(@"Response is = %@",inResponseDic);
            profileNameLbl.text = [self stringWithoutNullValue:[[inResponseDic objectAtIndex:0] valueForKey:@"display_name"]];
           // profileNameLbl.text = (NSString*)[[inResponseDic objectAtIndex:0]valueForKey:@"display_name"];
            locationlbl.text = [self stringWithoutNullValue:[[inResponseDic objectAtIndex:0] valueForKey:@"country_name"]];
            //locationlbl.text = (NSString*)[[inResponseDic objectAtIndex:0]valueForKey:@"country_name"];
            emailAddressLbl.text = [self stringWithoutNullValue:[[inResponseDic objectAtIndex:0] valueForKey:@"email"]];
            //emailAddressLbl.text = (NSString*)[[inResponseDic objectAtIndex:0]valueForKey:@"email"];
            mystring = [self stringWithoutNullValue:[[inResponseDic objectAtIndex:0] valueForKey:@"created_dt"]];
           // mystring = (NSString*)[[inResponseDic objectAtIndex:0]valueForKey:@"created_dt"];
            NSArray *stringWithoutChar = [mystring componentsSeparatedByString:@" "];
            mystring = (NSString*)[stringWithoutChar objectAtIndex:0];
            stringWithoutChar = [mystring componentsSeparatedByString:@"-"];
            mystring = (NSString*)[stringWithoutChar objectAtIndex:0];
            yearLbl.text = mystring;
            ContactNoLbl.text = [self stringWithoutNullValue:[[inResponseDic objectAtIndex:0] valueForKey:@"primary_phone"]];
           // ContactNoLbl.text = (NSString*)[[inResponseDic objectAtIndex:0]valueForKey:@"primary_phone"];
            NSString* imagepath = [self stringWithoutNullValue:[[inResponseDic objectAtIndex:0] valueForKey:@"profile_pic_path"]];
            //NSString *imagepath = (NSString*)[[inResponseDic objectAtIndex:0]valueForKey:@"profile_pic_path"];
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
            NSLog(@"service is ---------------------->%f,",self.service);
            NSLog(@"postage is ---------------------->%f,",self.postage);
            NSLog(@"Item Described is ---------------------->%f,",self.itemDescribed);

            [self callUserrating];
        }
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


#pragma mark - Private methods Implementation

- (BOOL) checkForNullString:(NSString*)string
{
    if ([string isEqual:[NSNull null]])
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (NSString*) stringWithoutNullValue:(NSString*) str
{
    if ([self checkForNullString:str])
    {
        return @"";
    }
    else
    {
        return str;
    }
}

@end
