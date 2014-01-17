//
//  ItemViewController.m
//  ISB
//
//  Created by AppRoutes on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "EditItemViewController.h"
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
#import "ShareViewController.h"
#import "AddSellItemViewController.h"
#import "NetworkService.h"

@interface EditItemViewController ()

@end

@implementation EditItemViewController
@synthesize distanceLabel,itemCodeValueLbl,itemLocationValueLbl,lblPrice,PostageValueLbl,productTitleLbl,scrollView,productDiscriptionTxtView,btnEdit;

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
    self.navigationController.navigationBarHidden=YES;
    
//    btnEdit.hidden = YES;
//    if (App.isEdit == YES)
//    {
//        btnEdit.hidden = NO;
//    }

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
    scrollView.contentSize = CGSizeMake(0, 850);
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    flagPaypalCancel = FALSE;
    [ItemDetails sharedInstance].isSelected =0;
    if ([[self.dicItemDetails valueForKey:@"availability"] isEqualToString:@"AVAILABLE"]) {
        [_makeItAvailableOutlet setEnabled:NO];
    }else
        [_makeItAvailableOutlet setEnabled:YES];

    [self showScrollView];

    [self showdata];
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
//        btnBuy.userInteractionEnabled = NO;
//        btnContact.userInteractionEnabled = NO;
    }
    
//    productTitleLbl.text = [[self.dicItemDetails objectAtIndex:0] valueForKey:@"title"];
    productTitleLbl.text = [self.dicItemDetails valueForKey:@"title"];
    
    NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
    [temp setObject:productTitleLbl.text forKey:@"title"];
    [ItemDetails sharedInstance].dicToShare=Nil;
    [ItemDetails sharedInstance].dicToShare=[[NSMutableDictionary alloc]init];
    [ItemDetails sharedInstance].dicToShare=temp;
    [temp release];
    
    //ForKey:@"title"];
    lblPrice.text = [NSString stringWithFormat:@"%@",[self.dicItemDetails  valueForKey:@"price"]];
 //   NSArray *aray=[[self.dicItemDetails  valueForKey:@"price"] componentsSeparatedByString:@" "];
    //    PostageValueLbl.text = [[[aray objectAtIndex:0] stringByAppendingFormat:@" %@",[aray objectAtIndex:1]] stringByAppendingFormat:@" %@",[self.dicItemDetails valueForKey:@"postage"]];
//    if ([aray count]>1) {
//        PostageValueLbl.text = [[[aray objectAtIndex:0] stringByAppendingFormat:@" %@",[aray objectAtIndex:1]] stringByAppendingFormat:@" %@",[self.dicItemDetails valueForKey:@"postage"]];
//    }else
        PostageValueLbl.text = [self.dicItemDetails valueForKey:@"postage"];
    if (![[self.dicItemDetails valueForKey:@"item_code"] isEqual: [NSNull null]])
    {
        itemCodeValueLbl.text = [self.dicItemDetails valueForKey:@"item_code"];
    }
   
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
//        NSLog(@"km:%f",mDistance);
        //mLblDistance.text = [NSString stringWithFormat:@"%.3f",mDistance];
    }
    
    distanceLabel.text =[NSString stringWithFormat:@"%.2fKm",mDistance];
    NSMutableArray *postageArray=[[NSMutableArray alloc]initWithObjects:@"Courier",@"Air Cargo",@"Pick", nil];
    NSArray *fontArray=[UIFont fontNamesForFamilyName:@"Avenir Next Condensed"];
    NSString *str=[self.dicItemDetails valueForKey:@"postagetype_id"];
    NSArray *arrPost=[str componentsSeparatedByString:@","];
    for (int i=0; i<[postageArray count]; i++) {
        UIButton *radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [radioButton setFrame:CGRectMake(160, 569+i*30, 19, 19)];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"checkboxOff.png"] forState:UIControlStateNormal];
        [radioButton setBackgroundImage:[UIImage imageNamed:@"checkboxOn.png"] forState:UIControlStateSelected];
    //    [radioButton addTarget:self action:@selector(radioButClicked:) forControlEvents:UIControlEventTouchUpInside];
        [radioButton setUserInteractionEnabled:NO];
        [radioButton setTag:301+i];
        
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 569+i*30, 100, 20)];
        [label setText:[postageArray objectAtIndex:i]];
        [label setFont:[UIFont fontWithName:[fontArray objectAtIndex:5] size:17] ];
        [label setBackgroundColor:[UIColor clearColor]];
        [self.scrollView addSubview:label];
        [self.scrollView addSubview:radioButton];
        
        if ([arrPost containsObject:[NSString stringWithFormat:@"%d",i+1]]) {
            [radioButton setSelected:YES];
        }
    }
//    NSMutableArray *paymentArray=[[NSMutableArray alloc]initWithObjects:@"PayPal",@"Cash on Pick", nil];
//    for (int i=0; i<[paymentArray count]; i++) {
//        UIButton *radioButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        [radioButton setFrame:CGRectMake(160, 680+i*30, 19, 19)];
//        [radioButton setBackgroundImage:[UIImage imageNamed:@"radioUncheck.png"] forState:UIControlStateNormal];
//        [radioButton setBackgroundImage:[UIImage imageNamed:@"radioCheck.png"] forState:UIControlStateSelected];
//        [radioButton setUserInteractionEnabled:NO];
//
//       // [radioButton addTarget:self action:@selector(paymentRadio:) forControlEvents:UIControlEventTouchUpInside];
//        [radioButton setTag:401+i];
//        
//        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(200, 680+i*30, 100, 20)];
//        [label setText:[paymentArray objectAtIndex:i]];
//        [label setFont:[UIFont fontWithName:[fontArray objectAtIndex:5] size:17] ];
//        [label setBackgroundColor:[UIColor clearColor]];
//        [self.scrollView addSubview:label];
//        [self.scrollView addSubview:radioButton];
//    }

//    NSString *imagepath = [self.dicItemDetails valueForKey:@"pic_path"];
//    NSString*imageUrlstr = [kImageURL stringByAppendingString:imagepath];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//                NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr]];
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (![imageData isEqual: [NSNull null]]) {
//                productImage.image = [UIImage imageWithData:imageData];
//                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[scrollView viewWithTag:400];
//                indicator.hidden=YES;
//                
//            }
//
//            
//        });
//    });
    
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
- (IBAction)searchClick:(id)sender {
        
        [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)watchClick:(id)sender {

    AddSellItemViewController * sellItem;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        sellItem = [[AddSellItemViewController alloc]initWithNibName:@"AddSellItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        sellItem = [[AddSellItemViewController alloc]initWithNibName:@"AddSellItemViewController" bundle:nil];
    }
    [self.navigationController pushViewController:sellItem animated:YES];

        
}
#pragma mark - Call Webservice

-(void)callWebService
{
    
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/status?item_id=%@",[_dicItemDetails valueForKey:@"id"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if ([[inResponseDic objectAtIndex:0] isEqualToString:@"success"]) {
            [Utils showAlertView:@"" message:@"Status changed to AVAILABLE successfully " delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            
            [_makeItAvailableOutlet setEnabled:NO];
        }
          }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to change status. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

- (IBAction)btnShareClick:(id)sender {
    
    

    
    ShareViewController *share;
    if ([Utils isIPhone_5]) {
        share=[[ShareViewController alloc]initWithNibName:@"ShareViewController_iPhone5" bundle:nil];
    }else
        share=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    
    [self.navigationController pushViewController:share animated:YES];
}

- (IBAction)makeItAvailableAction:(id)sender {
    
    [self callWebService];
}

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

- (void)dealloc {
   
    [UIScrollView release];
    [productTitleLbl release];
    [distanceLabel release];
    [productDiscriptionTxtView release];
    [itemLocationValueLbl release];
    [itemLocationValueLbl release];
    [PostageValueLbl release];
    [itemCodeValueLbl release];
    [_makeItAvailableOutlet release];
       [super dealloc];
}
    
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    NSUInteger newLength = [textView.text length] + [text length] - range.length;
//    return (newLength > 200) ? NO : YES;
//
//    
//}

- (void)viewDidUnload {
    [self setMakeItAvailableOutlet:nil];
    [super viewDidUnload];
}
@end
