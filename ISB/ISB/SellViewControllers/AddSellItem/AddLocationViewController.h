//
//  AddLocationViewController.h
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
@interface AddLocationViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource,CLLocationManagerDelegate>
{
    NSMutableArray *stateArray;
    NSMutableArray *countryArray;
    int country_id;
    int state_id;
    NSMutableDictionary * adicLocation;
    IBOutlet UILabel *lblCurrCoordinates;
    NSMutableDictionary *dicEditItemDetail;
     BOOL isSelected;
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSString *statusLoc;
}

@property (retain, nonatomic) NSMutableArray *stateArray;
@property (retain, nonatomic) NSMutableArray *countryArray;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) CLLocation* userCurrentLocation;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
@property(retain,nonatomic)IBOutlet UITextField *txtHomeAddress , *txtCity , *txtZipCode;
@property(retain,nonatomic)IBOutlet UITextField *txtState;
@property (retain, nonatomic) IBOutlet UIButton *btnCountry;
@property (retain, nonatomic) IBOutlet UIButton *btnState;
@property(retain,nonatomic)IBOutlet UIPickerView *pickerview;
@property(retain,nonatomic)IBOutlet UIButton *btnRadioCurLoc, *btnRadioAddress;

@property (strong, nonatomic) IBOutlet UIView *pickerContainer;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property(retain,nonatomic)IBOutlet UIView *locView;


-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnRadioCurrentLocClicked:(id)sender;
-(IBAction)btnRadioAddressClicked:(id)sender;
-(IBAction)btnStateClicked:(id)sender;
-(IBAction)btnCountryClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;

-(IBAction)btnRadioClicked:(id)sender;

//- (IBAction)showStatePicker:(id)sender;
//- (IBAction)showCountryPicker:(id)sender;
- (IBAction)hidePicker:(id)sender;

@end
