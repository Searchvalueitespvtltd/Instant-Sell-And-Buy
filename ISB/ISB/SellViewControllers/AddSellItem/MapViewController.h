//
//  MapViewController.h
//  ISB
//
//  Created by AppRoutes on 15/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "StoredData.h"
@interface MapViewController : UIViewController<MKMapViewDelegate,MKAnnotation,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}
@property (retain, nonatomic) IBOutlet MKMapView *mapview;
@property (retain, nonatomic) NSString *locationTitle;
@property (retain, nonatomic) NSString *locationSubTitle;
@property (retain, nonatomic)  NSMutableDictionary *fullAddressDic;

@end
