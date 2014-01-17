//
//  MapViewController.m
//  ISB
//
//  Created by AppRoutes on 15/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize mapview,locationSubTitle,locationTitle;
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
    mapview.mapType = MKMapTypeStandard;
 mapview.showsUserLocation = YES;
    // Do any additional setup after loading the view from its nib.
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude =[[StoredData sharedData].latitude floatValue];
    NSLog(@"lat:%f",[[StoredData sharedData].latitude floatValue]);
    annotationCoord.longitude =[[StoredData sharedData].longitude floatValue];
    NSLog(@"lat:%f",[[StoredData sharedData].longitude floatValue]);
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = locationTitle;
    annotationPoint.subtitle =locationSubTitle;
    mapview.mapType = MKMapTypeStandard;

    MKCoordinateSpan span = {.latitudeDelta =  0.05, .longitudeDelta =  0.05};
    MKCoordinateRegion region = {annotationCoord, span};
    [mapview setRegion:region];
    [self.view addSubview:mapview];
    [mapview addAnnotation:annotationPoint];
}
- (IBAction)backClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation
{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc]
                                  initWithAnnotation:annotation
                                  reuseIdentifier:@"currentloc"];
    annView.pinColor = MKPinAnnotationColorPurple;
    UIButton *myDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    myDetailButton.frame = CGRectMake(0, 0, 23, 23);
    myDetailButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    myDetailButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [myDetailButton addTarget:self
                       action:@selector(checkButtonTapped)
             forControlEvents:UIControlEventTouchUpInside];
    
    annView.rightCalloutAccessoryView = myDetailButton;
        annView.animatesDrop=NO;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    return annView;
}

-(void)checkButtonTapped
{
[self.navigationController popViewControllerAnimated:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [mapview release];
    [super dealloc];
}
@end
