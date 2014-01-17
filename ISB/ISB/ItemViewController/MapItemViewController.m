//
//  MapViewController.m
//  ISB
//
//  Created by chetan shishodia on 31/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MapItemViewController.h"

@interface MapItemViewController ()

@end

@implementation MapItemViewController
//@synthesize curr_latitute,curr_longitude,serv_latitude,serv_longitude;
@synthesize serv_longitude,serv_latitude;

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
    mapView.mapType = MKMapTypeStandard;
//    mapView.showsUserLocation = YES;
    
    // Do any additional setup after loading the view from its nib.
//    CLLocationCoordinate2D curr_annotationCoord;
    CLLocationCoordinate2D serv_annotationCoord;
    
//    curr_annotationCoord.latitude =[[StoredData sharedData].latitude floatValue];
//    curr_annotationCoord.longitude =[[StoredData sharedData].longitude floatValue];

    serv_annotationCoord.latitude = serv_latitude;
    serv_annotationCoord.longitude = serv_longitude;
    
//    NSLog(@"lat:%f",[[StoredData sharedData].latitude floatValue]);
//    NSLog(@"lat:%f",[[StoredData sharedData].longitude floatValue]);
    
//    MKPointAnnotation *curr_annotationPoint = [[MKPointAnnotation alloc] init];
    MKPointAnnotation *serv_annotationPoint = [[MKPointAnnotation alloc]init];
    
//    curr_annotationPoint.coordinate = curr_annotationCoord;
    serv_annotationPoint.coordinate = serv_annotationCoord;
    
    MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
//     MKCoordinateSpan span = {.latitudeDelta =  0.5, .longitudeDelta =  0.5};
    MKCoordinateRegion region = {serv_annotationCoord, span};
    [mapView setRegion:region];
    [self.view addSubview:mapView];
//    [mapView addAnnotation:curr_annotationPoint];
    [mapView addAnnotation:serv_annotationPoint];
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
//    MKPinAnnotationView *curr_annView=[[MKPinAnnotationView alloc]
//                                  initWithAnnotation:annotation
//                                  reuseIdentifier:@"Your location"];
    MKPinAnnotationView *item_annView=[[MKPinAnnotationView alloc]
                                       initWithAnnotation:annotation
                                       reuseIdentifier:@"Item location"];
//    curr_annView.pinColor = MKPinAnnotationColorPurple;
    item_annView.pinColor = MKPinAnnotationColorPurple;
    
//    UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    myDetailButton.frame = CGRectMake(0, 0, 23, 23);
//    myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    [myDetailButton addTarget:self
//                       action:@selector(checkButtonTapped)
//             forControlEvents:UIControlEventTouchUpInside];
    
//    annView.rightCalloutAccessoryView = myDetailButton;
//    curr_annView.animatesDrop=NO;
    item_annView.animatesDrop=NO;
//    curr_annView.canShowCallout = YES;
    item_annView.canShowCallout = YES;
//    curr_annView.calloutOffset = CGPointMake(-5, 5);
    item_annView.calloutOffset = CGPointMake(-5, 5);
//    return curr_annView;
    return item_annView;
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
