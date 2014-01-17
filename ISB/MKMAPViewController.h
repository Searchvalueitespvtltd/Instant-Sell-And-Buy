//
//  MKMAPViewController.h
//  ISB
//
//  Created by Pankaj on 10/22/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "myAnnotation.h"

@interface MKMAPViewController : UIViewController<MKMapViewDelegate>{
}
- (IBAction)backButton:(id)sender;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong)  NSString *latt;

@property (nonatomic, strong) NSString *longg;
@property (nonatomic, strong) NSString * strHeading;
@property (nonatomic, strong) NSMutableArray *arrSearchItem;
@property (retain, nonatomic) IBOutlet UILabel *lblHeading;

@end
