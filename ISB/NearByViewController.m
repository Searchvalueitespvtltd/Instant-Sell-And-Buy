//
//  NearByViewController.m
//  ISB
//
//  Created by Pankaj on 10/12/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "NearByViewController.h"
#import "HomeAppliancesViewController.h"
#import "MKMAPViewController.h"
#import "Product.h"
@interface NearByViewController ()

@end

@implementation NearByViewController
@synthesize latt,longt;
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
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSearch:(id)sender {
    if ([self.txtSearchField.text isEqualToString:@""])
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter a name." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        return;
    }else
    {
//        HomeAppliancesViewController *homeAppliance=[[HomeAppliancesViewController alloc]initWithNibName:@"HomeAppliancesViewController" bundle:nil];
//        homeAppliance.isFromNearBy=YES;
//        homeAppliance.isFromSavedSearch=NO;
//        homeAppliance.strHeading=self.txtSearchField.text;
//        homeAppliance.latt=latt;
//        homeAppliance.longg=longt;
//
//        [self.navigationController pushViewController:homeAppliance animated:YES];
//
        [Utils startActivityIndicatorInView:self.view withMessage:@""];
        [self callSearchNearByWebService];
        
        
    }
}


#pragma  - mark Call Webservice

-(void)callSearchNearByWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/searchlatlong?q=%@&slat=%@&slong=%@&skm=10",self.txtSearchField.text,self.latt,self.longt] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            arrSearchItem = [[NSMutableArray alloc]init];
            
            for (id obj in inResponseDic) {
                Product *prod=[[Product alloc]init];
                prod.id=[[obj valueForKey:@"id"] integerValue];
                prod.category_name=[obj valueForKey:@"category_name"];
                prod.city=[obj valueForKey:@"city"];
                prod.desc=[obj valueForKey:@"desc"];
                prod.rating_count=[obj valueForKey:@"rating_count"];
                prod.paymenttype_name=[obj valueForKey:@"paymenttype_name"];
                prod.paymenttype_id = [obj valueForKey:@"paymenttype_id"];
                prod.availability=[obj valueForKey:@"availability"];
                prod.postagetype_id = [obj valueForKey:@"postagetype_id"];
                //                prod.seller_pic = [obj valueForKey:@"seller_pic"];
                if ([[obj valueForKey:@"seller_pic"] isEqual:[NSNull null]] || ![[obj valueForKey:@"seller_pic"] length]>0)
                {
                    prod.seller_pic=@"1";
                }else
                    prod.seller_pic = [obj valueForKey:@"seller_pic"];
                //   prod.pic_path=[obj valueForKey:@"pic_path"];
                if ([[obj valueForKey:@"pic_path"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path"] length]>0)
                {
                    prod.pic_path=@"1";
                }else
                    prod.pic_path=[obj valueForKey:@"pic_path"];
                
                if ([[obj valueForKey:@"pic_path2"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path2"] length]>0) {
                    prod.pic_path2=@"1";
                }else
                    prod.pic_path2=[obj valueForKey:@"pic_path2"];
                
                if ([[obj valueForKey:@"pic_path3"] isEqual:[NSNull null]] || ![[obj valueForKey:@"pic_path3"] length]>0) {
                    prod.pic_path3=@"1";
                }else
                    prod.pic_path3=[obj valueForKey:@"pic_path3"];
                
                prod.price=[obj valueForKey:@"price"];
                prod.title= [obj valueForKey:@"title"];
                prod.user_name= [obj valueForKey:@"user_name"];
                prod.postagetype_name=[obj valueForKey:@"postagetype_name"];
                prod.location_latlong= [obj valueForKey:@"location_latlong"];
                prod.postage= [obj valueForKey:@"postage"];
                prod.zipcode= [obj valueForKey:@"zipcode"];
                prod.is_watch=[obj valueForKey:@"is_watch"];
                prod.sender_email = [obj valueForKey:@"sender_email"];
                prod.default_pic = [obj valueForKey:@"default_pic"];
                prod.created_by = [[obj valueForKey:@"created_by"] integerValue];
                prod.item_code=[obj valueForKey:@"item_code"];
                prod.rating_all=[obj valueForKey:@"rating_all"];
                prod.rating_postage=[obj valueForKey:@"rating_postage"];
                prod.rating_service=[obj valueForKey:@"rating_service"];
                prod.rating_item_as_described=[obj valueForKey:@"rating_item_as_described"];
                
                [arrSearchItem addObject:prod];
            }
            [Utils stopActivityIndicatorInView:self.view];

            
            MKMAPViewController *map=[[MKMAPViewController alloc]initWithNibName:@"MKMAPViewController" bundle:nil];
            map.longg=longt;
            map.latt=latt;
            map.strHeading=self.txtSearchField.text;
            map.arrSearchItem=arrSearchItem;
            [self.navigationController pushViewController:map animated:YES];

            //            self.arrSearchItem = [NSMutableArray arrayWithArray:inResponseDic];
        }
        else
        {
            [Utils stopActivityIndicatorInView:self.view];

            [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
    else
    {
        [Utils stopActivityIndicatorInView:self.view];

        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}
#pragma
#pragma  - mark Update location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    // NSLog(@"lat%f - lon%f", location.coordinate.latitude, location.coordinate.longitude);
    latt=[NSString stringWithFormat:@"%f",location.coordinate.latitude] ;
    longt=[NSString stringWithFormat:@"%f",location.coordinate.longitude] ;
}

#pragma
#pragma  - mark Textfield Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
    
}
- (void)dealloc {
//    [_txtSearchField release];
//    [super dealloc];
}
- (void)viewDidUnload {
    [self setTxtSearchField:nil];
    [super viewDidUnload];
}
@end
