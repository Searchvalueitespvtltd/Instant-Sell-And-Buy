//
//  MapViewController.h
//  ISB
//
//  Created by chetan shishodia on 31/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapItemViewController : UIViewController <MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate>
{
    IBOutlet MKMapView *mapView;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (assign,nonatomic) double serv_latitude,serv_longitude;//,curr_latitute,curr_longitude;
-(IBAction)btnBackClicked:(id)sender;

@end
