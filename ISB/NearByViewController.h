//
//  NearByViewController.h
//  ISB
//
//  Created by Pankaj on 10/12/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@interface NearByViewController : UIViewController<CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    NSMutableArray *arrSearchItem;
}
- (IBAction)btnBack:(id)sender;
- (IBAction)btnSearch:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *txtSearchField;
@property (strong, nonatomic)     NSString * latt;
@property (strong, nonatomic)     NSString * longt;
@end
