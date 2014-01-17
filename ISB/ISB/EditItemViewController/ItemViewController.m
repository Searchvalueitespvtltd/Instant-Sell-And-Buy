//
//  ItemViewController.m
//  ISB
//
//  Created by AppRoutes on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.


#import "ItemViewController.h"
#import "WatchItemTable.h"
#import "SMChatViewController.h"
#import "MapItemViewController.h"
#import "ItemDetails.h"
#import "Defines.h"
#import "StoredData.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"
#import "ItemImageViewController.h"
#import "SellerProfileViewController.h"
#import "LastViewItems.h"
#import "CXMPPController.h"
@interface ItemViewController ()

@end

@implementation ItemViewController
@synthesize scrollView,shareView,overlay;
@synthesize dicItemDetails,isWatching;
@synthesize buyItemBtn,contectSellerBtn,distanceLabel,itemCodeValueLbl,itemLocationValueLbl,lblPrice,PostageValueLbl,productDiscriptionTxtView,productImage,productTitleLbl,searchBtn,watchBtn,smsView,txtSms,overlayImage,countLableValue;

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
//    self.navigationController.navigationBarHidden=YES;
    context=[App managedObjectContext];
    [scrollView setScrollEnabled:YES];
        if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.scrollView.frame = CGRectMake(0, 113, 320, self.view.frame.size.height-44);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 112, 320, self.view.frame.size.height-44);
    }
    [HttpRequestProcessor shareHttpRequest];
    shareView.frame = CGRectMake(0, 1000, 320, 261);
    smsView.frame = CGRectMake(0, 1000, 320, 261);
    scrollView.contentSize = CGSizeMake(0, 850);
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    flagPaypalCancel = FALSE;
    [ItemDetails sharedInstance].isSelected =0;
    [txtSms resignFirstResponder];
    
//    NSLog(@"result: %@",dicItemDetails);
//    NSLog(@"%d",isWatching);
    if (isWatching==1)
    {
        [watchBtn setSelected:YES];
    }
    else
    {
        [watchBtn setSelected:NO];   
    }
    overlayImage.hidden=YES;
    [self showScrollView];
    
//    if (![[self.dicItemDetails valueForKey:@"pic_path"] isEqual:[NSNull null]]&& ![[self.dicItemDetails valueForKey:@"pic_path"] isEqualToString:@"1"])
//    {
//        [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path"] withIndex:5001];
//    }
//    if (![[self.dicItemDetails valueForKey:@"pic_path2"] isEqual:[NSNull null]]&& ![[self.dicItemDetails valueForKey:@"pic_path2"] isEqualToString:@"1"])
//    {
//        [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path2"] withIndex:5002];
//    }
//    if (![[self.dicItemDetails valueForKey:@"pic_path3"] isEqual:[NSNull null]]&& ![[self.dicItemDetails valueForKey:@"pic_path3"] isEqualToString:@"1"])
//    {
//        [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path3"] withIndex:5003];
//    }
    
//    [self performSelector:@selector(bringImages:) withObject:imageArray];
//    [self performSelector:@selector(showdata) withObject:nil afterDelay:0.1];
    [self showdata];
    if ([[self.dicItemDetails valueForKey:@"availability"] isEqualToString:@"AVAILABLE"]) {
        [self.buyItemBtn setHidden:NO];
    }else{
        [self.buyItemBtn setHidden:YES];
    }
    
    
    [super viewWillAppear:YES];
}

#pragma mark fetch images

-(void)bringImages:(NSArray *)inResponseDic
{
    for (int i=0;i<[inResponseDic count];i++)
    {
//        Product *temp=[inResponseDic objectAtIndex:i];
//        [self doFetchEditionImage:temp.pic_path withIndex:temp.id];
        
    }
}

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
      //  NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
       
        
            if (img)
            {
                UIImageView *imageV=(UIImageView *)[self.view viewWithTag:inRequest.index];
                imageV.image = img;
               UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[scrollView viewWithTag:inRequest.index+1000];
                [indicator stopAnimating];
                indicator.hidden=YES;
                
            }
            
            
        //
    }
   // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
-(void)showScrollView
{
    for(UIView * view in scrllForImage.subviews)
    {
       
        if([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview]; view = nil;
        }
    }
    
    count=0;
//    if ([[self.dicItemDetails valueForKey:@"pic_path"] length]>0) {
//        count=1;
//        
//    }
//    if ([[self.dicItemDetails valueForKey:@"pic_path"] length]>0 && ![[self.dicItemDetails valueForKey:@"pic_path2"] isEqualToString:@"1"]) {
//        count=2;
//    }
//
//    if ([[self.dicItemDetails valueForKey:@"pic_path"] length]>0 && ![[self.dicItemDetails valueForKey:@"pic_path2"] isEqualToString:@"1"]&&![[self.dicItemDetails valueForKey:@"pic_path3"] isEqualToString:@"1"])
//    {
//        count=3;
//    }
    
    NSString *strTemp1 = [self.dicItemDetails valueForKey:@"pic_path"];
    strTemp2 = [self.dicItemDetails valueForKey:@"pic_path2"];
    strTemp3 = [self.dicItemDetails valueForKey:@"pic_path3"];
    if ([strTemp1 length]>1 && [strTemp2 length]>1 &&[strTemp3 length]>1 ) {
        count=3;
    }else if (([strTemp1 length]>1 && [strTemp2 length]>1 )|| ([strTemp1 length]>1 && [strTemp3 length]>1) || ([strTemp2 length]>1 && [strTemp3 length]>1)){
        count=2;
    }else
        count=1;
    
    CGFloat scrollY=0.0f;
    for (int i=0; i<count; i++) {
        CGRect myimagerect1 = CGRectMake(10+i*320,8,300,205);
        UIActivityIndicatorView *indicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        UIButton *btnImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        btnImageButton.frame = CGRectMake(5,5,70,70);
        btnImageButton.frame = CGRectMake(10+i*320,8,300,205);
        [btnImageButton setTag:7001+i];
        
        UIImageView *myimage1 = [[UIImageView alloc]initWithFrame:myimagerect1];
        myimage1.tag=5001+i;
        myimage1.contentMode = UIViewContentModeScaleAspectFit;
        myimage1.opaque = YES;
        indicator.tag=6001+i;
        indicator.center=myimage1.center;
        [indicator startAnimating];
//        [btnImageButton setBackgroundColor:[UIColor redColor]]; // for test
//        [myimage1 setBackgroundColor:[UIColor blueColor]]; // for test
        [btnImageButton addSubview:myimage1];
        [scrllForImage addSubview:btnImageButton];

        [scrllForImage addSubview:indicator];
        [scrllForImage addSubview:myimage1];
        scrollY += myimage1.frame.size.width+23;
        
//        scrollY += btnImageButton.frame.size.width+23;
        
        [btnImageButton addTarget:self action:@selector(nextview:) forControlEvents:UIControlEventTouchUpInside];
        
        [scrllForImage setScrollEnabled:YES];

    }
    switch (count) {
        case 1:
            if ([strTemp1 length]>1)  {
               [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path"] withIndex:5001]; 
            }else if ([strTemp2 length]>1)
            {
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path2"] withIndex:5001];
            }else
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path3"] withIndex:5001];
            break;
        case 2:
            
            if ([strTemp1 length]>1 && [strTemp2 length]>1)  {
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path"] withIndex:5001];
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path2"] withIndex:5002];

            }else if ([strTemp2 length]>1 && [strTemp3 length]>1)
            {
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path2"] withIndex:5001];
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path3"] withIndex:5002];
            }else
            {
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path"] withIndex:5001];
                [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path3"] withIndex:5002];
            }
            break;
        case 3:
            [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path"] withIndex:5001];
            [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path2"] withIndex:5002];
            [self doFetchEditionImage:[self.dicItemDetails valueForKey:@"pic_path3"] withIndex:5003];

            break;
        default:
            break;
    }
    [scrllForImage setScrollEnabled:YES];
    scrllForImage.contentSize = CGSizeMake(scrollY, 215);
//    CGRect myimagerect1 = CGRectMake(10,8,300,205);
//    CGRect myimagerect2 = CGRectMake(10+320,8,300,205);
//    CGRect myimagerect3 = CGRectMake(10+640,8,300,205);
//    UIImageView *myimage1 = [[UIImageView alloc]initWithFrame:myimagerect1];
//    myimage1.tag=5001;
////   UIActivityIndicatorView *act
//    UIImageView *myimage2 = [[UIImageView alloc]initWithFrame:myimagerect2];
//    myimage2.tag=5002;
//    
//    UIImageView *myimage3 = [[UIImageView alloc]initWithFrame:myimagerect3];
//    myimage3.tag=5003;
//    
//    myimage1.contentMode = UIViewContentModeScaleAspectFit;
//    myimage2.contentMode = UIViewContentModeScaleAspectFit;
//    myimage3.contentMode = UIViewContentModeScaleAspectFit;
//    
//    [myimage1 setContentMode:UIViewContentModeScaleAspectFit];
//    myimage1.opaque = YES;
//    [scrllForImage addSubview:myimage1];
//    scrollY += myimage1.frame.size.width+23;
//    
//    [myimage2 setContentMode:UIViewContentModeScaleAspectFit];
//    myimage2.opaque = YES;
//    [scrllForImage addSubview:myimage2];
//    scrollY += myimage2.frame.size.width+23;
//    
//    [myimage3 setContentMode:UIViewContentModeScaleAspectFit];
//    myimage3.opaque = YES;
//    [scrllForImage addSubview:myimage3];
//    scrollY += myimage3.frame.size.width+23;
//    
//    [scrllForImage setScrollEnabled:YES];
//    scrllForImage.contentSize = CGSizeMake(scrollY, 215);
}

-(void)nextview:(UIButton*)sender
{
    
    //[self.view addSubview:scrllForImage2];
    // [self showScrollView2];
    ItemImageViewController *itemImageViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemImageViewController=[[ItemImageViewController alloc] initWithNibName:@"ItemImageViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemImageViewController=[[ItemImageViewController alloc] initWithNibName:@"ItemImageViewController" bundle:nil];
    }

//    NSMutableArray *arr=[[NSMutableArray alloc]init];
//    for (int i=0; i<count; i++) {
//        UIImageView *image=(UIImageView*)[self.view viewWithTag:5001+i];
//        if (image.image) {
//            [arr addObject:image.image];
//            
//        }
//    }
//    itemImageViewController.imgarray = arr;
    itemImageViewController.strPicPath2 =strTemp2;
    itemImageViewController.strPicPath3 =strTemp3;
    itemImageViewController.strPicPath =  [self.dicItemDetails valueForKey:@"pic_path"];
    itemImageViewController.prevImage =  [self.dicItemDetails valueForKey:@"pic_path"];
    
    [self presentViewController:itemImageViewController animated:NO completion:nil];
    [itemImageViewController release];
}

-(void)populateImages
{
    for(UIView * view in scrllForImage.subviews)
    {
        if([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview]; view = nil;
        }
    }
    
    scrollView.pagingEnabled = YES;
    
    CGFloat scrollY=0.0f;
    CGRect myimagerect1 = CGRectMake(10,8,300,205);
    CGRect myimagerect2 = CGRectMake(10+320,8,300,205);
    CGRect myimagerect3 = CGRectMake(10+640,8,300,205);
    UIImageView *myimage1 = [[UIImageView alloc]initWithFrame:myimagerect1];
    myimage1.tag=1001;
    UIImageView *myimage2 = [[UIImageView alloc]initWithFrame:myimagerect2];
    myimage2.tag=1002;

    UIImageView *myimage3 = [[UIImageView alloc]initWithFrame:myimagerect3];
    myimage3.tag=1003;

    myimage1.contentMode = UIViewContentModeScaleAspectFit;
    myimage2.contentMode = UIViewContentModeScaleAspectFit;
    myimage3.contentMode = UIViewContentModeScaleAspectFit;
    
    
    NSString *imagepath1 = [self.dicItemDetails valueForKey:@"pic_path"];
    NSString *imagepath2 = [self.dicItemDetails valueForKey:@"pic_path2"];
    NSString *imagepath3 = [self.dicItemDetails valueForKey:@"pic_path3"];
    arrayImages = [[NSMutableArray alloc]initWithObjects:imagepath1,imagepath2,imagepath3, nil];
    
//    NSLog(@"arrImg:%d",[arrayImages count]);
    
    
    NSString* imageUrlstr1 = [kImageURL stringByAppendingString:imagepath1];
    NSString* imageUrlstr2 = [kImageURL stringByAppendingString:imagepath2];
    NSString* imageUrlstr3 = [kImageURL stringByAppendingString:imagepath3];
    
    
    //    NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr1]];
    //    NSData *imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr2]];
    //    NSData *imageData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr3]];
    
    
//    myimage1.image = [UIImage imageNamed:@"btnDeletePhoto@2x.png"];
//    myimage2.image = [UIImage imageNamed:@"nextbackBg@2x.png"];
//    myimage3.image = [UIImage imageNamed:@"logoAbout@2x.png"];
//    
    
    
    
    //
    //    if (![imageData1 isEqual: [NSNull null]])
    //    {
    //        myimage1.image = [UIImage imageWithData:imageData1];
    //
    //    }
    //
    //    if (![imageData2 isEqual: [NSNull null]])
    //    {
    //        myimage2.image = [UIImage imageWithData:imageData2];
    //    }
    //
    //    if (![imageData3 isEqual: [NSNull null]])
    //    {
    //        myimage3.image = [UIImage imageWithData:imageData3];
    //    }
    
       dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr1]];
          NSData *imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr2]];
           NSData *imageData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr3]];
   
    
          dispatch_async(dispatch_get_main_queue(), ^{
              if (![imageData1 isEqual: [NSNull null]])
                {
                   myimage1.image = [UIImage imageWithData:imageData1];
                    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[scrollView viewWithTag:400];
                                    indicator.hidden=YES;
             }
  
               if (![imageData2 isEqual: [NSNull null]])
                {
                  myimage2.image = [UIImage imageWithData:imageData2];
                    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[scrollView viewWithTag:400];
                    indicator.hidden=YES;
               }
   
               if (![imageData3 isEqual: [NSNull null]])
                {
                   myimage3.image = [UIImage imageWithData:imageData3];
                    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[scrollView viewWithTag:400];
                    indicator.hidden=YES;
                }
  
            });
        });
    
    [myimage1 setContentMode:UIViewContentModeScaleAspectFit];
    myimage1.opaque = YES;
    [scrllForImage addSubview:myimage1];
    scrollY += myimage1.frame.size.width+23;
    
    [myimage2 setContentMode:UIViewContentModeScaleAspectFit];
    myimage2.opaque = YES;
    [scrllForImage addSubview:myimage2];
    scrollY += myimage2.frame.size.width+23;
    
    [myimage3 setContentMode:UIViewContentModeScaleAspectFit];
    myimage3.opaque = YES;
    [scrllForImage addSubview:myimage3];
    scrollY += myimage3.frame.size.width+23;
    
    //    [myimage1 release];
    //    [myimage2 release];
    //    [myimage3 release];
    
    
    [scrllForImage setScrollEnabled:YES];
    
    //        scrollY += myimage1.frame.size.width+5;
    
    scrllForImage.contentSize = CGSizeMake(scrollY, 215);
}



-(void)showdata
{
    if ([[self.dicItemDetails valueForKey:@"user_name"]isEqual:[[NSUserDefaults standardUserDefaults] objectForKey:@"USER_NAME"]])
    {
        btnBuy.hidden=YES;
        btnContact.hidden=YES;
        //[self.scrollView setContentOffset:CGPointMake(0, 630) animated:YES];
        scrollView.contentSize = CGSizeMake(0, 800);
    }
    
//    productTitleLbl.text = [[self.dicItemDetails objectAtIndex:0] valueForKey:@"title"];
    productTitleLbl.text = [self.dicItemDetails valueForKey:@"title"];//ForKey:@"title"];
    lblPrice.text = [NSString stringWithFormat:@"%@",[self.dicItemDetails  valueForKey:@"price"]];
//    NSArray *aray=[[self.dicItemDetails  valueForKey:@"price"] componentsSeparatedByString:@" "];
//    PostageValueLbl.text = [[[aray objectAtIndex:0] stringByAppendingFormat:@" %@",[aray objectAtIndex:1]] stringByAppendingFormat:@" %@",[self.dicItemDetails valueForKey:@"postage"]];
//    if ([aray count]>1) {
//        PostageValueLbl.text = [[[aray objectAtIndex:0] stringByAppendingFormat:@" %@",[aray objectAtIndex:1]] stringByAppendingFormat:@" %@",[self.dicItemDetails valueForKey:@"postage"]];
//    }else
        PostageValueLbl.text = [self.dicItemDetails valueForKey:@"postage"];
    if (![[self.dicItemDetails valueForKey:@"item_code"] isEqual: [NSNull null]])
    {
        itemCodeValueLbl.text = [self.dicItemDetails valueForKey:@"item_code"];
    }
   
    UILabel *userName = (UILabel *)[scrollView viewWithTag:500];
    userName.text=[NSString stringWithFormat:@"( %@",[self.dicItemDetails valueForKey:@"user_name"]];
//    int countRate=0;
//    if (![[self.dicItemDetails valueForKey:@"rating_all"] isEqual:[NSNull null]] ) {
//        countRate=[[self.dicItemDetails valueForKey:@"rating_all"] integerValue];
//    }
//    for (int i=1; i<=countRate; i++) {
//        UIButton *but=(UIButton *)[scrollView viewWithTag:500 + i];
//        [but setSelected:YES];
//    }
    UILabel *reviewCount = (UILabel *)[scrollView viewWithTag:499];
    reviewCount.text=[NSString stringWithFormat:@"%@ )",[self.dicItemDetails valueForKey:@"rating_count"]];
    

    
    itemLocationValueLbl.text = [self.dicItemDetails  valueForKey:@"city"];
    productDiscriptionTxtView.text = [self.dicItemDetails valueForKey:@"desc"];
    currlat = [[[StoredData sharedData] latitude] doubleValue];
    currlong = [[[StoredData sharedData] longitude] doubleValue];
    
    CLLocation *currLocation = [[CLLocation alloc] initWithLatitude:currlat longitude:currlong];
    //         NSString *mystring = [self.arrSearchItem valueForKey:@"location_latlong"];
    NSString *mystring = [self.dicItemDetails valueForKey:@"location_latlong"];
    NSArray *ary = [mystring componentsSeparatedByString:@","];
     servlat = [[ary objectAtIndex:0]doubleValue];
     servlong = [[ary objectAtIndex:1]doubleValue];
    CLLocation *serverLocation = [[CLLocation alloc] initWithLatitude:servlat longitude:servlong];
    mDistance = [self getDistanceFromLocA:currLocation andLocB:serverLocation];
    if (mDistance >= 0)
    {
        mDistance  = mDistance/1000 ;
        NSLog(@"km:%f",mDistance);
        //mLblDistance.text = [NSString stringWithFormat:@"%.3f",mDistance];
    }
    
    distanceLabel.text =[NSString stringWithFormat:@"%.2fKm",mDistance];
   // NSMutableArray *postageArray=[[NSMutableArray alloc]initWithObjects:@"Air Cargo",@"Courier",@"Pick", nil];
    NSArray *fontArray=[UIFont fontNamesForFamilyName:@"Avenir Next Condensed"];

//    for (int i=0; i<[postageArray count]; i++) {
//        UIButton *radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        [radioButton setFrame:CGRectMake(160, 569+i*30, 19, 19)];
//        [radioButton setBackgroundImage:[UIImage imageNamed:@"radioUncheck.png"] forState:UIControlStateNormal];
//        [radioButton setBackgroundImage:[UIImage imageNamed:@"radioCheck.png"] forState:UIControlStateSelected];
//        [radioButton addTarget:self action:@selector(radioButClicked:) forControlEvents:UIControlEventTouchUpInside];
//        [radioButton setTag:301+i];
//        
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 569+i*30, 100, 20)];
//        [label setText:[postageArray objectAtIndex:i]];
//        [label setFont:[UIFont fontWithName:[fontArray objectAtIndex:5] size:17] ];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [self.scrollView addSubview:label];
//        [self.scrollView addSubview:radioButton];postagetype_id
//    }
    NSString *str=[self.dicItemDetails valueForKey:@"postagetype_id"];
    NSArray *arrPost=[str componentsSeparatedByString:@","];
    for (int j=0; j<[arrPost count]; j++) {
        UIButton *radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setFrame:CGRectMake(160, 569+j*30, 19, 19)];

        [radioButton setBackgroundImage:[UIImage imageNamed:@"radioUncheck.png"] forState:UIControlStateNormal];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"radioCheck.png"] forState:UIControlStateSelected];
        [radioButton addTarget:self action:@selector(radioButClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 569+j*30, 100, 20)];
        [label setFont:[UIFont fontWithName:[fontArray objectAtIndex:5] size:17]];
        [label setBackgroundColor:[UIColor clearColor]];
        [radioButton setTag:300+[arrPost[j] integerValue]];

        switch ([arrPost[j] integerValue]) {
            case 1:
                label.text=@"Courier";
                break;
            case 2:
                label.text=@"Air Cargo";
                break;
            case 3:
                label.text=@"Pick";
                break;
            default:
                break;
        }
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:radioButton];
    }
    
}
-(void)paymentRadio:(id)sender{
    UIButton *button=(UIButton *)sender;
    if (paymentReferenceButton) {
        [paymentReferenceButton setSelected:NO];
    }
    [button setSelected:![button isSelected]];
    paymentReferenceButton=button;
}
-(void)radioButClicked:(id)sender{
    UIButton *button=(UIButton *)sender;
    if (referenceButton) {
        [referenceButton setSelected:NO];
    }
    [button setSelected:![button isSelected]];
    
    referenceButton=button;

}
-(double)getDistanceFromLocA:(CLLocation *)inLocA andLocB:(CLLocation *)inLocB
{
    //    CLLocation *locA = [[CLLocation alloc] initWithLatitude:location.latitude longitude:[[StoredData sharedData]longitude]];
    //
    //    CLLocation *locB = [[CLLocation alloc] initWithLatitude:lat2 longitude:long2];
    
    CLLocationDistance distance = [inLocA distanceFromLocation:inLocB];
    
    //Distance in Meters
    
    //1 meter == 100 centimeter
    
    //1 meter == 3.280 feet
    
    //1 meter == 10.76 square feet
    
    return distance;
}
- (IBAction)BuyItmClick:(id)sender
{
    if (!referenceButton) {
        [Utils showAlertView:@"" message:@"Select Postage method" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        return;
    }
    if ([[self.dicItemDetails valueForKey:@"paymenttype_id"]isEqual:@"1"])
    {
        [self retryInitialization];
        [self simplePayment];
        status = PAYMENTSTATUS_CANCELED;
        [[PayPal getPayPalInst]setDelegate:self];
    }
    else
    {
        [self callBuyService];
    }
   
}

-(void)retryInitialization
{
    [PayPal initializeWithAppID:@"APP-6BT56084883032942" forEnvironment:ENV_LIVE];
   // [PayPal initializeWithAppID:@"APP-80W284485P519543T" forEnvironment:ENV_SANDBOX];
}
- (void)simplePayment
{
    [PayPal getPayPalInst].shippingEnabled = TRUE;
    PayPalPayment *payment = [[[PayPalPayment alloc] init] autorelease];
    
    [PayPal getPayPalInst].delegate=self;
//	payment.recipient = @"amg130877@gmail.com";
    payment.recipient = @"Example@gail.com";
    //	payment.description = @"Teddy Bear";
	payment.merchantName = @"ISB";
    NSArray *priceArray1 =[[self.dicItemDetails  valueForKey:@"price"] componentsSeparatedByString:@" "];
    NSArray *priceArray2 =[[self.dicItemDetails  valueForKey:@"postage"] componentsSeparatedByString:@" "];
    
//    NSLog(@"Total Price = %@\n%@",priceArray1,priceArray2);
    
   // float sum = [[priceArray1 objectAtIndex:2] floatValue]+[[priceArray2 objectAtIndex:2] floatValue];
    
  //  float sum = [[NSDecimalNumber decimalNumberWithString:[priceArray1 objectAtIndex:2]] floatValue]+[[NSDecimalNumber decimalNumberWithString:[priceArray2 objectAtIndex:2]] floatValue];
    
//    payment.subTotal = sum;
    NSString *postage_id=[NSString stringWithFormat:@"%d",referenceButton.tag-300];
    float sum=0.0;
    
    if (![postage_id isEqualToString:@"3"])
    {
        //        NSLog(@" postage id ==> %@",postage_id);
        sum = [[priceArray1 objectAtIndex:2] floatValue]+[[priceArray2 objectAtIndex:2] floatValue];
    }
    else
    {
        sum = [[priceArray1 objectAtIndex:2] floatValue];
    }
    

    payment.subTotal =[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",sum]];
    
//     NSLog(@"Total Price = %f",sum);
    
    //  @"$",@"kr",@"£",@"AU$",@"€"
    //@"US $",@"NOK kr",@"GBP £",@"AU $",@"Euro €
    if ([priceArray1 count]>1) {
        if ([[priceArray1 objectAtIndex:0] isEqualToString:@"US"]) {
            payment.paymentCurrency = @"USD";
            
        }else if ([[priceArray1 objectAtIndex:0] isEqualToString:@"NOK"]){
            payment.paymentCurrency = @"NOK";
            
        }else if ([[priceArray1 objectAtIndex:0] isEqualToString:@"GBP"]){
            payment.paymentCurrency = @"GBP";
            
        }else if ([[priceArray1 objectAtIndex:0] isEqualToString:@"AU"]){
            payment.paymentCurrency = @"AUD";
        }else
            payment.paymentCurrency = @"EUR";
        
    }
    
	//subtotal of all items, without tax and shipping
    
	[[PayPal getPayPalInst] checkoutWithPayment:payment];
}

- (void)paymentCanceled
{
	status = PAYMENTSTATUS_CANCELED;
    
    flagPaypalCancel = TRUE;
    // Cheged here by me for previous voucher code just below one line
    //     [self paypalCheckoutWithType:strAmount];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"" forKey:@"strVoucherCode"];    
}

- (void)paymentSuccessWithKey:(NSString *)payKey andStatus:(PayPalPaymentStatus)paymentStatus
{
//    NSLog(@"strVoucher %@",strVoucherCode);
 //   NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
//	NSLog(@"severity: %@", severity);
	//NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
//	NSLog(@"category: %@", category);
//	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
//	NSLog(@"errorId: %@", errorId);
//	NSString *message1 = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
//	NSLog(@"message: %@", message1);
    
	status = PAYMENTSTATUS_SUCCESS;
}


- (void)paymentLibraryExit
{
//    SpaVoucherPurchasedViewController *obj = [[SpaVoucherPurchasedViewController alloc] initWithNibName:@"SpaVoucherPurchasedViewController" bundle:nil];
    
	UIAlertView *alert = nil;
	switch (status) {
		case PAYMENTSTATUS_SUCCESS:
        {
            [Utils startActivityIndicatorInView:self.view withMessage:@""];
            [self callBuyService];
			
            
            [Utils stopActivityIndicatorInView:self.view];            
        }
            
			break;
		case PAYMENTSTATUS_FAILED:
			alert = [[UIAlertView alloc] initWithTitle:@"Order failed"
											   message:@"Your order failed. Touch \"Buy this item\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            break;
		case PAYMENTSTATUS_CANCELED: {
			alert = [[UIAlertView alloc] initWithTitle:@"Order cancelled"
											   message:@"You cancelled your order. Touch \"Buy this item\" to try again."
											  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            flagPaypalCancel = FALSE;
//            strVoucherCode = @"";
//            strAmount = @"";
//            obj.strVoucherCode=strVoucherCode;
//            NSLog(@"strVoucherCode %@",strVoucherCode);
//            obj.strPrice = strAmount;
        }
			break;
	}
	[alert show];
	[alert release];
}



- (void)paymentFailedWithCorrelationID:(NSString *)correlationID {
    
    NSString *severity = [[PayPal getPayPalInst].responseMessage objectForKey:@"severity"];
//	NSLog(@"severity: %@", severity);
	NSString *category = [[PayPal getPayPalInst].responseMessage objectForKey:@"category"];
//	NSLog(@"category: %@", category);
	NSString *errorId = [[PayPal getPayPalInst].responseMessage objectForKey:@"errorId"];
//	NSLog(@"errorId: %@", errorId.description);
	NSString *message1 = [[PayPal getPayPalInst].responseMessage objectForKey:@"message"];
//	NSLog(@"message: %@", message1);
    
	status = PAYMENTSTATUS_FAILED;
}






- (IBAction)contectSellerClick:(id)sender {
    overlayImage.hidden=NO;

    [self.view bringSubviewToFront:self.shareView];
    [self setViewMovedUp:YES];
}
-(void)setViewMovedUp:(BOOL)isMovedUp
{
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // if you want to slide up the view
//    scrollView.userInteractionEnabled=NO;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        shareView.frame = CGRectMake(0, 300, 320, 261);
    }
    else
    {
        shareView.frame = CGRectMake(0, 220, 320, 261);
    }
    
   
//  self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay.png"]];
  
//    CGRect rect = self.shareView.frame;
    
//    if (isMovedUp)
//    {
//        if (rect.origin.y==548 || rect.origin.y==460) {
//            
//            
//            //isKeyBoardDown = NO;
//            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
//            // 2. increase the size of the view so that the area behind the keyboard is covered up.
//            rect.origin.y -= 208;
//        }
//        //        rect.size.height += 150;
//    }
//    else
//    {
//        if (rect.origin.y==252 || rect.origin.y==340) {
//            // revert back to the normal state.
//            rect.origin.y += 208;
//            //        rect.size.height -= 150;
//            //isKeyBoardDown = YES;
//        }
//    }
//    self.shareView.frame = rect;
    [UIView commitAnimations];

}
- (IBAction)btnShareEvent:(UIButton *)sender {
    SMChatViewController *chat ;

    switch ([sender tag]) {
        case 1000:
            [self.view bringSubviewToFront:self.smsView];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.4]; // if you want to slide up the view
//            scrollView.userInteractionEnabled=NO;
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                smsView.frame = CGRectMake(5, 50, 310, 229);
            }
            else
            {
                    smsView.frame = CGRectMake(5, 20, 310, 229);
            }
            [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//            self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay.png"]];
            [UIView commitAnimations];
            shareView.frame = CGRectMake(0, 1000, 320, 261);
//            if ([MFMessageComposeViewController canSendText])
//                // The device can send email.
//            {
//                [self displaySMSComposerSheet];
//            }
//            else
//                // The device can not send email.
//            {
//                errorAlert = [[UIAlertView alloc]
//                              initWithTitle:kAlertTitle message:@"Device not configured to send SMS." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                [errorAlert show];
//
////                self.feedbackMsg.hidden = NO;
////                self.feedbackMsg.text = @"Device not configured to send SMS.";
//            }
            break;
        case 1001:
            //            [self.view sendSubviewToBack:self.shareView];
            //            self.overlay.hidden=YES;
            //            [self setViewMovedUp:NO];
            //            SMChatViewController *chat = nil;
#pragma mark - edited_by_nehaa
                    {
            
                        if([[UIScreen mainScreen] bounds].size.height>480)
                        {
                            chat=[[SMChatViewController alloc] initWithNibName:@"SMChatViewController" bundle:nil];
            //
                        }
                        else
                        {
                            chat=[[SMChatViewController alloc] initWithNibName:@"SMChatViewControlleriphone4" bundle:nil];
                        }
                        chat.isFromItemView=YES;
                        chat.strUsername = [NSString stringWithFormat:@"%@",[self.dicItemDetails  valueForKey:@"user_name"]];
                        chat.pic_path=[self.dicItemDetails  valueForKey:@"seller_pic"];
                        [self.navigationController pushViewController:chat animated:YES ];
                        [chat release];
                    }
            //            <presence from=\'" + Datas.jid.getFullJid() + "\' to=\'" + _jid.getFullJid() + "\' type='subscribe'/>
//        {
//            NSLog(@"%@",[NSString stringWithFormat:@"%@",[self.dicItemDetails  valueForKey:@"user_name"]]);
//            NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
//            
//            [body addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",[self.dicItemDetails  valueForKey:@"user_name"],STRChatServerURL]];
//            [body addAttributeWithName:@"type" stringValue:@"subscribe"];
//            
//            [gCXMPPController.xmppStream sendElement:body];
//            [Utils showAlertView:@"ISB" message:[NSString stringWithFormat:@"Your request has been sent to %@.",[self.dicItemDetails valueForKey:@"user_name"]] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            UIButton *button = (UIButton*)sender;
//            button.enabled = NO;
//        }
#pragma mark - end editing
            break;
            
        case 1002:
            [self.view sendSubviewToBack:self.shareView];
            self.overlay.hidden=YES;
            [self setViewMovedUp:NO];
            if ([MFMailComposeViewController canSendMail])
                // The device can send email.
            {
                [self displayMailComposerSheet];
            }
            else
                // The device can not send email.
            {
                errorAlert = [[UIAlertView alloc]
                              initWithTitle:kAlertTitle message:@"Device not configured to send mail." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [errorAlert show];
//                self.feedbackMsg.hidden = NO;
//                self.feedbackMsg.text = @"Device not configured to send mail.";
            }

            break;
        default:
            break;
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        shareView.frame = CGRectMake(0, 1000, 320, 261);
        smsView.frame = CGRectMake(0, 1000, 320, 261);
//        self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
//        scrollView.userInteractionEnabled=YES;
        overlayImage.hidden=YES;

    }
}
- (IBAction)cancelBtnClick:(id)sender {
    shareView.frame = CGRectMake(0, 1000, 320, 261);
    smsView.frame = CGRectMake(0, 1000, 320, 261);
//    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    scrollView.userInteractionEnabled=YES;
    overlayImage.hidden=YES;

}
- (IBAction)searchClick:(id)sender {
        
        [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)watchClick:(id)sender {


    if ([watchBtn isSelected]) {
        [watchBtn setSelected:NO];
        [self callUnwatchService];
        //[self delete];
        
    }
    else{
        [watchBtn setSelected:YES];
        [self callWatchService];
       // [self saveToDatabase];
    }
    
}
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Fetch Data From Core Data

-(void)fetchData:(NSMutableArray *)arrData
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WatchItemTable" inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    NSPredicate *pred1 =
    [NSPredicate predicateWithFormat:@"(user_id LIKE[c] %@)",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    
    NSPredicate *pred2 =
    [NSPredicate predicateWithFormat:@"(product_id LIKE[c] %@)",[NSString stringWithFormat:@"%@",[self.dicItemDetails valueForKey:@"id"]]];
    
    NSArray *compPredicatesList = [NSArray arrayWithObjects:pred1,pred2, nil];
    
    NSPredicate *CompPrediWithAnd = [NSCompoundPredicate andPredicateWithSubpredicates:compPredicatesList];
    
    [request setPredicate: CompPrediWithAnd];
    
    // Fetch the records and handle an error
//	NSError *error;
//	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
//    if (mutableFetchResults.count>0)
//    {
//        [watchBtn setSelected:YES];
//    }
    
}


//-(void)fetchData:(NSString *)tableName
//{
//    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
//    
//	// Setup the fetch request
//	NSFetchRequest *request = [[NSFetchRequest alloc] init];
//	[request setEntity:entity];
//    
//    //    NSPredicate *pred =
//    //    [NSPredicate predicateWithFormat:@"(username = %@)",
//    //     [[NSUserDefaults standardUserDefaults] objectForKey:@"email"]];
//    //    [request setPredicate:pred];
//    NSPredicate *pred =
//    [NSPredicate predicateWithFormat:@"(user_id = %@)",
//     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
//    [request setPredicate:pred];
//    
//    
//    // Fetch the records and handle an error
//	NSError *error;
//	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
//    ////NSLog(@"Fetched:%@",mutableFetchResults);
//    
//	if (!mutableFetchResults)
//	{
//		//NSLog(@"Cant Fetch");
//	}
//    if([tableName isEqualToString:@"WatchItemTable"])
//    {
//        for(WatchItemTable *ev in mutableFetchResults)
//        {
//            userData = mutableFetchResults;
//        }
//    }
//    
//}

#pragma mark - Save Data From Core Data

-(void)updateDatabase :(NSString *)isWatch
{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"LastViewItems" inManagedObjectContext:context]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id == %@", [self.dicItemDetails valueForKey:@"id"]];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSArray *results = [context executeFetchRequest:request error:&error];
    if ([results count]!=0) {
    LastViewItems* favoritsGrabbed = [results objectAtIndex:0];
    favoritsGrabbed.is_watch = isWatch;
    if (![context save:&error])
    {
        //NSLog(@"ERROR--%@",error);
        abort();
    }
    }
}

-(void)saveToDatabase
{
    WatchItemTable  *event = (WatchItemTable *)[NSEntityDescription insertNewObjectForEntityForName:@"WatchItemTable" inManagedObjectContext:context];
    
    [event setProduct_id:[NSString stringWithFormat:@"%@",[self.dicItemDetails valueForKey:@"id"]]];
    [event setUser_id:[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"] ];
       NSError *error;
    if (![context save:&error])
    {
        //NSLog(@"ERROR--%@",error);
        abort();
    }
    
}

#pragma mark - Button Methods

-(IBAction)btnGoToMapClicked:(id)sender
{
    MapItemViewController *mapItem;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        mapItem=[[MapItemViewController alloc] initWithNibName:@"MapItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        mapItem=[[MapItemViewController alloc] initWithNibName:@"MapItemViewController" bundle:nil];
    }
    
    mapItem.serv_latitude = servlat;
    mapItem.serv_longitude = servlong;
//    mapItem.curr_latitute = currlat;
//    mapItem.curr_longitude = currlong;
    
    [self.navigationController pushViewController:mapItem animated:YES ];
    
    [mapItem release];
}

- (IBAction)SellerDetailsClick:(id)sender {
    SellerProfileViewController *sellerProfile;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        sellerProfile=[[SellerProfileViewController alloc] initWithNibName:@"SellerProfileViewController_iPhone5" bundle:nil];
    }
    else
    {
        sellerProfile=[[SellerProfileViewController alloc] initWithNibName:@"SellerProfileViewController" bundle:nil];
    }
    
    sellerProfile.strUserId = [NSString stringWithFormat:@"%@",[self.dicItemDetails  valueForKey:@"created_by"]];
    sellerProfile.strItemId = [NSString stringWithFormat:@"%@",[self.dicItemDetails  valueForKey:@"id"]];
    [self.navigationController pushViewController:sellerProfile animated:YES ];
    
    [sellerProfile release];
}




#pragma mark - Delete Data In Core Data
-(void)delete{
    //EMPTY GROUP TABLE
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"WatchItemTable" inManagedObjectContext:context];
    
    // Optionally add an NSPredicate if you only want to delete some of the objects.
    
    [fetchRequest setEntity:entity];
    
    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
    NSError *error=nil;
    for (WatchItemTable *objectToDelete in myObjectsToDelete) {
        [context deleteObject:objectToDelete];
        
        if (![context save:&error])
        {
            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    userData=[myObjectsToDelete mutableCopy];
}

# pragma Call WebService

-(void)callSmsService
{
    [Utils startActivityIndicatorInView:self.view withMessage:@"Sending.."];
    NetworkService *objService = [NetworkService sharedInstance];
//    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/send?msg_id=0&from_user_id=%@&to_user_id=%@&msg_title=ISB&msg_body=%@",,,] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/send?msg_id=%@&from_user_id=%@&to_user_id=%@&msg_body=%@&msg_title=ISB",@"0",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[self.dicItemDetails valueForKey:@"created_by"],txtSms.text] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)callWatchService
{
    [Utils startActivityIndicatorInView:self.view withMessage:@"WATCH"];
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"itemWatch/save?user_id=%@&product_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[self.dicItemDetails valueForKey:@"id"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)callBuyService
{
    [Utils startActivityIndicatorInView:self.view withMessage:@""];
    NetworkService *objService = [NetworkService sharedInstance];
    NSString *postage_id=[NSString stringWithFormat:@"%d",referenceButton.tag-300];


    [objService sendRequestToServer:[NSString stringWithFormat:@"itemSold/add?buyer_id=%@&item_id=%@&payment_id=%@&postage_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[self.dicItemDetails valueForKey:@"id"],[self.dicItemDetails valueForKey:@"paymenttype_id"],postage_id] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    
    //http://chat.eitcl.co.uk/devchat/index.php/itemSold/add?buyer_id=1&item_id=49&payment_id=1
}


-(void)callUnwatchService
{
    [Utils startActivityIndicatorInView:self.view withMessage:@"UNWATCH"];
    NetworkService *objService = [NetworkService sharedInstance];
    [objService sendRequestToServer:[NSString stringWithFormat:@"itemWatch/delete?user_id=%@&product_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[self.dicItemDetails valueForKey:@"id"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
//    NSLog(@"Response is = %@",inResponseDic);
    if([inReqIdentifier rangeOfString:@"itemWatch/save?"].length>0)
    {
        
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [self updateDatabase:@"1"];
            [Utils showAlertView:kAlertTitle message:@"Item added successfully in watching list" delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        //        [self.navigationController popToRootViewControllerAnimated:YES];
        //
    }
    else if ([inReqIdentifier rangeOfString:@"itemBuy/save?"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [Utils showAlertView:kAlertTitle message:@"Item added successfully in buying list" delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }

        
    }
    else if ([inReqIdentifier rangeOfString:@"msgs/send?"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [Utils showAlertView:kAlertTitle message:@"SMS sent" delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        
    }
    else if ([inReqIdentifier rangeOfString:@"itemSold/add?"].length>0)
    {
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [Utils showAlertView:kAlertTitle message:@"You have buy item successfully." delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
else
    
{
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [self updateDatabase:@"0"];
            [Utils showAlertView:kAlertTitle message:@"Item deleted successfully from watching list" delegate :self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Error" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        
        
}

    
}
-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    //    NSLog(@"*** requestErrorHandler *** and Error : %@",[inError debugDescription]);
    
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheet
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
    NSString *subject=[NSString stringWithFormat:@"Instant Sell & Buy (%@ %@)",[self.dicItemDetails valueForKey:@"title"],[self.dicItemDetails valueForKey:@"item_code"]];
	[picker setSubject:subject];
	
	// Set up recipients
	NSArray *toRecipients = [NSArray arrayWithObject:[NSString stringWithFormat:@"%@",[self.dicItemDetails valueForKey:@"sender_email"]]];
	NSArray *ccRecipients = [NSArray arrayWithObjects:@"", @"", nil];
	NSArray *bccRecipients = [NSArray arrayWithObject:@""];
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];
	[picker setBccRecipients:bccRecipients];
	
	// Attach an image to the email
//	NSString *path = [[NSBundle mainBundle] pathForResource:@"rainy" ofType:@"jpg"];
//	NSData *myData = [NSData dataWithContentsOfFile:path];
//	[picker addAttachmentData:myData mimeType:@"image/jpeg" fileName:@"rainy"];
	
	// Fill out the email body text
	NSString *emailBody = @"Hello From ISB!";
	[picker setMessageBody:emailBody isHTML:NO];
	
	[self presentViewController:picker animated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an SMS composition interface inside the application.
// -------------------------------------------------------------------------------
- (void)displaySMSComposerSheet
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;
	
    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    picker.body = @"Hello from ISB!";
    
	[self presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{

	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"Mail sending canceled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		case MFMailComposeResultSaved:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"Mail saved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		case MFMailComposeResultSent:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"Mail sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		case MFMailComposeResultFailed:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"Mail sending failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		default:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"Mail not sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
	}
    overlayImage.hidden=YES;

	[self dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:

//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
            
          errorAlert = [[UIAlertView alloc]
                                       initWithTitle:kAlertTitle message:@"SMS sending canceled" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		case MessageComposeResultSent:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"SMS sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		case MessageComposeResultFailed:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"SMS sending failed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errorAlert show];
			break;
		default:
            errorAlert = [[UIAlertView alloc]
                          initWithTitle:kAlertTitle message:@"SMS not sent" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			break;
	}
    
	[self dismissViewControllerAnimated:YES completion:NULL];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [searchBtn release];
    [watchBtn release];
    [UIScrollView release];
    [productImage release];
    [productTitleLbl release];
    [distanceLabel release];
    [productDiscriptionTxtView release];
    [itemLocationValueLbl release];
    [itemLocationValueLbl release];
    [PostageValueLbl release];
    [itemCodeValueLbl release];
    [buyItemBtn release];
    [contectSellerBtn release];
    [overlayImage release];
    [super dealloc];
}
- (IBAction)cancelClick:(id)sender
{
    smsView.frame = CGRectMake(0, 1000, 320, 261);
//    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    scrollView.userInteractionEnabled=YES;
    txtSms.text=@"";
    countLableValue.text = @"250";
    [txtSms resignFirstResponder];
    overlayImage.hidden=YES;

}

- (IBAction)sendClick:(id)sender {
    if (![txtSms.text isEqualToString:@""]) {
        [self callSmsService];
        txtSms.text = @"";
        countLableValue.text = @"250";
        overlayImage.hidden=YES;
        [txtSms resignFirstResponder];
        
    }else{
        [Utils showAlertView:@"" message:@"Write some message to send" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}
    
- (void)textViewDidChange:(UITextView *)textView{
    int textMaxcount=250;
    //    NSInteger newTextLength = [aTextView.text length] - range.length;
    NSInteger newTextLength = textMaxcount-[textView.text length];
    countLableValue.text =[NSString stringWithFormat:@"%i", newTextLength];
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    aTextView.text = [NSString stringWithFormat:@"%i", 250];
    // "Length of existing text" - "Length of replaced text" + "Length of replacement text"
    //    int textMaxcount=250;
    
    //    NSInteger newTextLength = [aTextView.text length] - range.length;
    //     NSInteger newTextLength = textMaxcount-[aTextView.text length];
    if ([countLableValue.text integerValue]<1) {
        if (range.location==249 && range.length==1) {
            return YES;
        }
        return NO;
    }
    //    countLableValue.text =[NSString stringWithFormat:@"%i", newTextLength];
    return YES;
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSUInteger newLength = [textView.text length] + [text length] - range.length;
//    return (newLength > 200) ? NO : YES;
//
//    
//}

@end
