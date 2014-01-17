//
//  MKMAPViewController.m
//  ISB
//
//  Created by Pankaj on 10/22/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MKMAPViewController.h"
#import "Product.h"
#import "ItemViewController.h"
#define METERS_PER_MILE 1609.344

@interface MKMAPViewController ()

@end

@implementation MKMAPViewController
@synthesize mapView;

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
    if (![Utils isIPhone_5]) {
        [self.mapView setFrame:CGRectMake(0, 40, 320, 420)];
    }
    self.lblHeading.text=self.strHeading;
    
//    for (Product *obj in self.arrSearchItem) {
//        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
//        if (![obj.location_latlong isEqual:[NSNull null]]) {
//            NSArray *arrLoc=[[NSArray alloc]initWithArray:[[NSString stringWithFormat:@"%@",obj.location_latlong] componentsSeparatedByString:@","]];
//            
//            NSNumber *numlat=[[NSNumber alloc] initWithDouble:[[arrLoc objectAtIndex:0] doubleValue]];
//            NSNumber *numlon=[[NSNumber alloc] initWithDouble:[[arrLoc objectAtIndex:1] doubleValue]];
//            CLLocationCoordinate2D theCoordinate5;
//            
//            theCoordinate5.latitude=[numlat doubleValue];;
//            theCoordinate5.longitude=[numlon doubleValue];
//            point.coordinate = theCoordinate5;
//            
//            CLLocationCoordinate2D coordinate1;
//            coordinate1.latitude = [numlat doubleValue];
//            coordinate1.longitude = [numlon doubleValue];
//            myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate1 title:[obj valueForKey:@"title"]];
//            [self.mapView addAnnotation:annotation];
//            
//        }
    
            
//            if (![[obj valueForKey:@"title"] isEqual:[NSNull null]]) {
//                point.title = [obj valueForKey:@"title"];
//                
//                
//                [self.mapView addAnnotation:point];
//                
//            }
        
        
    // Add an annotation
    self.mapView.delegate = self;

//    for (Product *obj in self.arrSearchItem) {
    for (int i=0; i<[self.arrSearchItem count]; i++) {
        
    
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        if (![[[self.arrSearchItem objectAtIndex:i] valueForKey:@"location_latlong"] isEqual:[NSNull null]]) {
            NSArray *arrLoc=[[NSArray alloc]initWithArray:[[NSString stringWithFormat:@"%@",[[self.arrSearchItem objectAtIndex:i] valueForKey:@"location_latlong"]] componentsSeparatedByString:@","]];
            
            NSNumber *numlat=[[NSNumber alloc] initWithDouble:[[arrLoc objectAtIndex:0] doubleValue]];
            NSNumber *numlon=[[NSNumber alloc] initWithDouble:[[arrLoc objectAtIndex:1] doubleValue]];
            CLLocationCoordinate2D theCoordinate5;
            
            theCoordinate5.latitude=[numlat doubleValue];;
            theCoordinate5.longitude=[numlon doubleValue];
            point.coordinate = theCoordinate5;
            
            CLLocationCoordinate2D coordinate1;
            coordinate1.latitude = [numlat doubleValue];
            coordinate1.longitude = [numlon doubleValue];
            myAnnotation *annotation = [[myAnnotation alloc] initWithCoordinate:coordinate1 title:[[self.arrSearchItem objectAtIndex:i]  valueForKey:@"title"]];
            annotation.tag=[NSNumber numberWithInt:i];
            [self.mapView addAnnotation:annotation];
        }
    }
    
        
    
    
    
    

//    [self callSearchNearByWebService];

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated{
    
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [self.latt doubleValue];
    zoomLocation.longitude= [self.longg doubleValue];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(zoomLocation, 15000, 12000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}
-(void)callSearchNearByWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"items/searchlatlong?q=%@&slat=%@&slong=%@&skm=10",self.strHeading,self.latt,self.longg] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {

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
                
//                [arrSearchItem addObject:prod];
            }
            self.mapView.delegate = self;

            //            self.arrSearchItem = [NSMutableArray arrayWithArray:inResponseDic];
        }
        else
        {
            
                [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

#pragma MapDelegate Methods
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 15000, 12000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
//    self.latt=[NSString stringWithFormat:@"%f",userLocation.coordinate.latitude];
//    self.longg=[NSString stringWithFormat:@"%f",userLocation.coordinate.longitude];

    
}
#pragma mark -MapView Delegate Methods
//6
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    //7
    if([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    //8
    static NSString *identifier = @"myAnnotation";
    MKPinAnnotationView * annotationView = (MKPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (!annotationView)
    {
        //9
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.pinColor = MKPinAnnotationColorPurple;
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;
    }else {
        annotationView.annotation = annotation;
    }
    myAnnotation *annot=(myAnnotation *)annotation;
    UIButton *button=[UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    button.tag = [annot.tag intValue];
    [button addTarget:self action:@selector(annotationClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    annotationView.rightCalloutAccessoryView = button;
    return annotationView;
}

-(void)annotationClicked:(UIButton *)sender{
    ItemViewController *itemDetailView;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController_iPhone5" bundle:nil];
    }
    else
    {
        itemDetailView=[[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    }
    
    itemDetailView.dicItemDetails = [self.arrSearchItem objectAtIndex:sender.tag];
    itemDetailView.isWatching=[[[self.arrSearchItem objectAtIndex:sender.tag] valueForKey:@"is_watch"] integerValue];
    
    [self.navigationController pushViewController:itemDetailView animated:YES ];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)dealloc {
//    [_lblHeading release];
//    [super dealloc];
//}
- (void)viewDidUnload {
    [self setLblHeading:nil];
    [super viewDidUnload];
}
@end
