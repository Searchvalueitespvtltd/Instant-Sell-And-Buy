//
//  AddLocationViewController.m
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "AddLocationViewController.h"
#import "ItemDetailsViewController.h"
#import "ItemDetails.h"
#import "StoredData.h"
#import "MapViewController.h"

@interface AddLocationViewController ()

@end

@implementation AddLocationViewController
@synthesize txtCity,txtHomeAddress,txtZipCode,pickerview;
@synthesize btnRadioAddress,btnRadioCurLoc;
@synthesize locationManager,userCurrentLocation;
@synthesize locView,txtState;


@synthesize pickerContainer,btnCountry,btnState,countryArray,stateArray,toolBar,longitude,latitude;

int buttonTouched = 0;


#define CURRENTLOCATION 1
#define MANUALENTRY     2
int isSelectedOption    = 1;
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
    self.navigationController.navigationBarHidden=YES;
    
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];

    [self.btnRadioAddress setSelected:YES];
    
//    if([[StoredData sharedData]longitude].length >0)
//    {
//        [self.btnRadioCurLoc setSelected:YES];
//        [self.txtHomeAddress setUserInteractionEnabled:YES];
//        [self.txtCity setUserInteractionEnabled:YES];
//        [self.btnCountry setUserInteractionEnabled:YES];
//        [self.btnState setUserInteractionEnabled:YES];
//        [self.txtZipCode setUserInteractionEnabled:YES];
//        
////        [self.btnRadioCurLoc setSelected:YES];
////        lblCurrCoordinates.hidden = NO;
////        [self.txtHomeAddress setUserInteractionEnabled:NO];
////        [self.txtCity setUserInteractionEnabled:NO];
////        [self.btnCountry setUserInteractionEnabled:NO];
////        [self.btnState setUserInteractionEnabled:NO];
////        [self.txtZipCode setUserInteractionEnabled:NO];
//    }
//    else
//    {
//        [self.btnRadioAddress setSelected:YES];
//        lblCurrCoordinates.hidden = YES;
//        [self.txtHomeAddress setUserInteractionEnabled:YES];
//        [self.txtCity setUserInteractionEnabled:YES];
//        [self.btnCountry setUserInteractionEnabled:YES];
//        [self.btnState setUserInteractionEnabled:YES];
//        [self.txtZipCode setUserInteractionEnabled:YES];
//    }
    
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
//    self.countryArray=[[NSMutableArray alloc]initWithObjects:@"United Kingdom",nil];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];    
    
    
    
    
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    [self performSelector:@selector(initLocationManager)];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    if ([ItemDetails sharedInstance].isEditing){
           
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"HOMEADDRESS"] isEqual:[NSNull null]]) {
            txtHomeAddress.text = [[ItemDetails sharedInstance].dicLocDetail valueForKey:@"HOMEADDRESS"];
            txtHomeAddress.text = [txtHomeAddress.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                                 withString:@""];
        }
        
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"CITY"] isEqual:[NSNull null]]) {
           txtCity.text = [[ItemDetails sharedInstance].dicLocDetail valueForKey:@"CITY"];
            txtCity.text = [txtCity.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                   withString:@""];
        }
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"STATETEXT"] isEqual:[NSNull null]]) {
            txtState.text = [[ItemDetails sharedInstance].dicLocDetail valueForKey:@"STATETEXT"];
            txtState.text = [txtState.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                     withString:@""];

        }
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"ZIPCODE"] isEqual:[NSNull null]]) {
            txtZipCode.text = [[ItemDetails sharedInstance].dicLocDetail valueForKey:@"ZIPCODE"];
            txtZipCode.text = [txtZipCode.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                    withString:@""];
        }
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"COUNTRYTEXT"] isEqual:[NSNull null]]) {
           [btnCountry setTitle:[NSString stringWithFormat:@"%@",[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"COUNTRYTEXT"]] forState:UIControlStateNormal];
            btnCountry.titleLabel.text = [btnCountry.titleLabel.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                                               withString:@""];

        }
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"status"] isEqual:[NSNull null]]) {
            statusLoc =[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"status"];
        }

        if ([statusLoc isEqualToString:@"0"]) {
            isSelectedOption = CURRENTLOCATION;
            [btnRadioCurLoc setSelected:YES];
            [btnRadioAddress setSelected:NO];
            
        }
        else
        {
            isSelectedOption = MANUALENTRY;
            [btnRadioCurLoc setSelected:NO];
            [btnRadioAddress setSelected:YES];
        }

    }

    
    
    [ItemDetails sharedInstance].isSelected =0;
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    
	[self.view addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	[gestureRecognizer release];

//    if(isSelectedOption==CURRENTLOCATION)
//    {
//        [Utils startActivityIndicatorInView:self.view withMessage:@""];
//        locationManager.delegate = self;
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
//        
//        [locationManager startUpdatingLocation];
//        [self performSelector:@selector(showTime) withObject:nil afterDelay:1.0];
//    }
//    
//    lblCurrCoordinates.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"textfield.png"]];
//    lblCurrCoordinates.text = [NSString stringWithFormat:@"  %@ , %@  ",[StoredData sharedData].latitude , [StoredData sharedData].longitude];
//    [lblCurrCoordinates sizeToFit];
//    if([[ItemDetails sharedInstance].dicLocDetail count]>0)
//    {
//        if([[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"EntryType"]isEqualToString:@"loc"])
//        {
//            isSelectedOption    =   CURRENTLOCATION;
//            [btnRadioCurLoc setSelected:YES];
//            [btnRadioAddress setSelected:NO];
//            [self setBtnActive:YES];
//            
//        }
//        else
//        {
    if ([[ItemDetails sharedInstance].dicLocDetail count]>0)
    {
        isSelectedOption = [[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"EntryType"]intValue];
        
        txtHomeAddress.text = [[ItemDetails sharedInstance].dicLocDetail objectForKey:@"HOMEADDRESS"];
        txtCity.text = [[ItemDetails sharedInstance].dicLocDetail objectForKey:@"CITY"];
        
        [btnCountry setTitle:[NSString stringWithFormat:@"%@",[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"COUNTRYTEXT"]]forState:UIControlStateNormal];
        
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"ZIPCODE"] isEqual:[NSNull null]]){
        txtZipCode.text = [[ItemDetails sharedInstance].dicLocDetail objectForKey:@"ZIPCODE"];
        }
        if (![[[ItemDetails sharedInstance].dicLocDetail valueForKey:@"STATETEXT"] isEqual:[NSNull null]]){
        txtState.text =[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"STATETEXT"];
        }
        
        if (isSelectedOption == 1)
        {
            [btnRadioCurLoc setSelected:YES];
            [btnRadioAddress setSelected:NO];
        }
        else
        {
            [btnRadioCurLoc setSelected:NO];
            [btnRadioAddress setSelected:YES];
        }

    }
    
    
//            isSelectedOption    =   MANUALENTRY;
//            [btnRadioCurLoc setSelected:NO];
//            [btnRadioAddress setSelected:YES];
//            [self setBtnActive:YES];
//        }
//        
//    }
    
    
    [super viewWillAppear:YES];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
//    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    
    // [locationManager stopUpdatingLocation];
    NSLog(@"Resolving the Address");
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
//        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
//            NSLog(@"Found locality: %@,", placemark.locality);
//            NSLog(@"Found description: %@,", placemark.description);
//            NSLog(@"Found country: %@,", placemark.country);
//            NSLog(@"Found name: %@,", placemark.name);
//            NSLog(@"Found postalCode: %@,", placemark.postalCode);
//            NSLog(@"Found subLocality: %@,", placemark.subLocality);
//            NSLog(@"Found thoroughfare: %@,", placemark.thoroughfare);
//            NSLog(@"Found subThoroughfare: %@,", placemark.subThoroughfare);
//            NSLog(@"Found subAdministrativeArea: %@,", placemark.subAdministrativeArea);
//            NSLog(@"Found areasOfInterest: %@,", placemark.areasOfInterest);
//            NSLog(@"Found administrativeArea: %@,", placemark.administrativeArea);
//            NSLog(@"Found addressDictionary: %@,", placemark.addressDictionary);
//            
//            NSLog(@"Found placemarks: %@,", placemark.addressDictionary);
            //            placemark = [placemark stringByReplacingOccurrencesOfString:@"(null)"
            //                                                 withString:@""];
            txtHomeAddress.text = [NSString stringWithFormat:@"%@\n%@",placemark.subThoroughfare, placemark.thoroughfare];
            txtHomeAddress.text = [txtHomeAddress.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                                 withString:@""];
            
            txtCity.text = [NSString stringWithFormat:@"%@",
                            placemark.locality];
            txtCity.text = [txtCity.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                         withString:@""];
            btnCountry.titleLabel.text =[NSString stringWithFormat:@"%@",
                                         placemark.country];
            btnCountry.titleLabel.text = [btnCountry.titleLabel.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                         withString:@""];
            txtState.text = [NSString stringWithFormat:@"%@",
                                       placemark.administrativeArea
                                       ];
            txtState.text = [txtState.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                         withString:@""];
            txtZipCode.text = [NSString stringWithFormat:@"%@",
                               placemark.postalCode];
            txtZipCode.text = [txtZipCode.text stringByReplacingOccurrencesOfString:@"(null)"
                                                                         withString:@""];
            
            [Utils stopActivityIndicatorInView:self.view];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}





-(void)willKeyBoardShow
{
    CGRect selfFrame = locView.frame;
  //  NSLog(@"willKeyBoardShow");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [locView setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 100, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
}
-(void)willKeyBoardHide
{
    CGRect selfFrame = locView.frame;
    
    NSLog(@"willKeyBoardHide");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    [locView setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 100, selfFrame.size.width, selfFrame.size.height)];
    
    [UIView commitAnimations];
    
}


#pragma - mark Picker Delegates

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    [stateTxtField resignFirstResponder];
//    [countryTxtField resignFirstResponder];
    //    if ([sender tag] ==100)

    switch(buttonTouched)
    {
        case 1:
            //    [btnPostageType setTitle:[NSString stringWithString:[[arrPostageType objectAtIndex:row]valueForKey:@"name"]] forState:UIControlStateNormal];
            

    [self.btnState setTitle:[[self.stateArray objectAtIndex:row] valueForKey:@"name"] forState:UIControlStateNormal];
            

            
//            = [[self.stateArray objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"name"];
            
            state_id = [[[self.stateArray objectAtIndex:row] objectForKey:@"id"]intValue];
            break;
        case 2:
            
            isSelected = YES;
            
            [self.btnCountry setTitle:[[self.countryArray objectAtIndex:row]valueForKey:@"short_name"] forState:UIControlStateNormal];
            country_id = [[[self.countryArray objectAtIndex:row] objectForKey:@"id"]intValue];
            
//            countryTxtField.text = [self.countryArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
//            country_id = 235;
                       country_id = [[[self.countryArray objectAtIndex:row] objectForKey:@"id"]intValue];
            break;
    }
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    switch(buttonTouched)
    {
        case 1:
            return [self.stateArray count];
            break;
        case 2:
            return [self.countryArray count];
            break;
        default:
            return 0;
    }
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    switch(buttonTouched)
    {
        case 1:
            return [[self.stateArray objectAtIndex:row] objectForKey:@"name"];
            break;
        case 2:
            return [[self.countryArray objectAtIndex:row] objectForKey:@"short_name"];
            break;
        default:
            return @"nothing";
    }
    
}


#pragma  - mark Button Methods

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)mapClick:(id)sender {
    MapViewController *mapViewController;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        mapViewController=[[MapViewController alloc] initWithNibName:@"MapViewController_iPhone5" bundle:nil];
        
    }
    else{
        mapViewController=[[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil]; }
    NSString *address=[@" " stringByAppendingFormat:@"%@,%@,%@",txtCity.text,txtState.text,btnCountry.titleLabel.text];
    mapViewController.locationTitle = txtHomeAddress.text;
    mapViewController.locationSubTitle = address;
    [self.navigationController pushViewController:mapViewController animated:YES ];
    [mapViewController release];
    
}


-(IBAction)btnRadioCurrentLocClicked:(id)sender
{
    if([[StoredData sharedData]longitude].length>0)
    {
//        [self.btnRadioCurLoc setSelected:YES];
//        [self.btnRadioAddress setSelected:NO];
//        [self.txtHomeAddress setUserInteractionEnabled:NO];
//        [self.txtCity setUserInteractionEnabled:NO];
//        [self.btnCountry setUserInteractionEnabled:NO];
//        [self.btnState setUserInteractionEnabled:NO];
//        [self.txtZipCode setUserInteractionEnabled:NO];
    }
}

-(IBAction)btnRadioAddressClicked:(id)sender
{
    
}

-(IBAction)btnStateClicked:(id)sender
{
    
}

-(IBAction)btnCountryClicked:(id)sender
{
    
}

-(IBAction)btnDoneClicked:(id)sender
{
        if([self.txtZipCode.text isEqualToString:@""] || [self.txtHomeAddress.text isEqualToString:@""] || [self.txtCity.text isEqualToString:@""] || [txtState.text isEqualToString:@"State"] || [self.btnCountry.titleLabel.text isEqualToString:@"Country"])
        {
            [Utils showAlertView:kAlertTitle message:@"Please enter all the fields." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        else
        {
             NSString *urlString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@,%@,%@,%@,%@,&sensor=true",[self.txtHomeAddress.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.txtCity.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.txtZipCode.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.btnCountry.titleLabel.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[txtState.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            
            NSError *error=nil;
            NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] encoding:NSUTF8StringEncoding error:&error];
            
            NSDictionary *location = [[locationString JSONValue] retain];
            if ([[location objectForKey: @"results"] count]>0)
            {
                id obj = [location objectForKey: @"results"];
                
                adicLocation =  [[NSMutableDictionary alloc]init];
                adicLocation= [[[obj  objectAtIndex:0] valueForKey:@"geometry"] valueForKey:@"location"];
                [ItemDetails sharedInstance].dicLocDetail = [[[NSMutableDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:isSelectedOption],@"EntryType",self.txtHomeAddress.text,@"HOMEADDRESS",self.txtCity.text,@"CITY",self.txtZipCode.text,@"ZIPCODE",self.btnCountry.titleLabel.text,@"COUNTRY",[NSString stringWithFormat:@"%@",self.txtState.text],@"STATE",self.txtState.text,@"STATETEXT",self.btnCountry.titleLabel.text,@"COUNTRYTEXT",[adicLocation valueForKey:@"lng"],@"LONGITUDE",    [adicLocation valueForKey:@"lat"],@"LATITUDE", nil] retain];
                
              //  [NSNumber numberWithInteger: isSelectedOption];
                
            [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:@"Unable to get your address location. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                return;
            }
//            [self.navigationController popViewControllerAnimated:YES];
        }
//    }
}

//- (void)setBtnActive:(BOOL)active
//{
//    lblCurrCoordinates.hidden = active;
//    [self.txtHomeAddress setUserInteractionEnabled:active];
//    [self.txtCity setUserInteractionEnabled:active];
//    [self.btnCountry setUserInteractionEnabled:active];
//    [self.btnState setUserInteractionEnabled:active];
//    [self.txtZipCode setUserInteractionEnabled:active];
//}

-(IBAction)btnRadioClicked:(id)sender
{
    if ([sender tag] ==100)
    {
        
        [Utils startActivityIndicatorInView:self.view withMessage:@""];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        [locationManager startUpdatingLocation];
        [self performSelector:@selector(showTime) withObject:nil afterDelay:1.0];
        
        isSelectedOption = CURRENTLOCATION;
        [btnRadioCurLoc setSelected:YES];
        [btnRadioAddress setSelected:NO];


    }
    else if ([sender tag] ==200)
    {
        isSelectedOption    =   MANUALENTRY;
        [btnRadioAddress setSelected:YES];
        [btnRadioCurLoc setSelected:NO];
        
//        if ([[ItemDetails sharedInstance].dicLocDetail count]>0)
//        {
//            txtHomeAddress.text = [[ItemDetails sharedInstance].dicLocDetail objectForKey:@"HOMEADDRESS"];
//            txtCity.text = [[ItemDetails sharedInstance].dicLocDetail objectForKey:@"CITY"];
//            
//            [btnCountry setTitle:[NSString stringWithFormat:@"%@",[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"COUNTRYTEXT"]]forState:UIControlStateNormal];
//            
//            txtZipCode.text = [[ItemDetails sharedInstance].dicLocDetail objectForKey:@"ZIPCODE"];
//            
//            [btnState setTitle:[NSString stringWithFormat:@"%@",[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"STATETEXT"]]forState:UIControlStateNormal];
//        }

        
  
//        [self setBtnActive:YES];
        
    }
}


- (void)showTime
{
    locationManager.delegate = self;
    locationManager.delegate = nil;
    //    [locationManager startUpdatingLocation];
    
}



#pragma - mark Textfield Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == txtZipCode) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 8) ? NO : YES;
    }
    else
    {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 30) ? NO : YES;
        
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)callCounties
{
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    if([[UIScreen mainScreen] bounds].size.height>480)
//    {
//        pickerContainer.frame = CGRectMake(0, 240, 320, 261);    
//    }
//    else
//    {
//        pickerContainer.frame = CGRectMake(0, 153, 320, 261);
//    }
//    
//    [UIView commitAnimations];
//    [pickerview reloadAllComponents];
       NetworkService *objService = [NetworkService sharedInstance];
      [objService sendRequestToServer:[NSString stringWithFormat:@"countries/get"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}
//-(void)callStates
//{
//    NetworkService *objService = [NetworkService sharedInstance];
//    [objService sendRequestToServer:[NSString stringWithFormat:@"states/get?country_id=235"] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
//    
//}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    // NSLog(@"Response is = %@",inResponseDic);
    
    //    if ([inReqIdentifier rangeOfString:@"short_name"].length>0) {
    //        [pickerView reloadAllComponents];
    //    }
    
     if([inReqIdentifier rangeOfString:@"states/get?"].length>0){
        if([[inResponseDic objectAtIndex:0] isKindOfClass:[NSDictionary class]])
        {
            [self.stateArray removeAllObjects];
            self.stateArray = inResponseDic;
            NSLog(@"Response is = %@",self.stateArray);
            
            [btnState setTitle:@"Bedfordshire" forState:UIControlStateNormal];
            //stateTxtField.text = @"Bedfordshire";
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            if([[UIScreen mainScreen] bounds].size.height>480)
            {
                pickerContainer.frame = CGRectMake(0, 240, 320, 261);
                
            }
            else{
                pickerContainer.frame = CGRectMake(0, 153, 320, 261);
            }
            
            [UIView commitAnimations];
            [pickerview reloadAllComponents];
        }
    }
    else
    {
        [self.countryArray removeAllObjects];
        self.countryArray = inResponseDic;
//        NSLog(@"Response is = %@",self.countryArray);
        
        //[btnState setTitle:@"Bedfordshire" forState:UIControlStateNormal];
        //stateTxtField.text = @"Bedfordshire";
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3];
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            pickerContainer.frame = CGRectMake(0, 240, 320, 261);
            
        }
        else{
            pickerContainer.frame = CGRectMake(0, 153, 320, 261);
        }
        
        [UIView commitAnimations];
        [pickerview reloadAllComponents];
        
    }
    
}


-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

- (IBAction)showStatePicker:(id)sender
{
    [self.view endEditing:YES];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callStates) withObject:nil afterDelay:1.0];
    buttonTouched = 1;
}


- (IBAction)showCountryPicker:(id)sender
{
    [self.view endEditing:YES];
    buttonTouched = 2;
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self performSelector:@selector(callCounties) withObject:nil afterDelay:1.0];
    //[self callCounties];
}

- (IBAction)hidePicker:(id)sender
{
    [self.view endEditing:YES];
    
//    if (buttonTouched == 2)
//    {
//        [btnCountry setTitle:@"United Kingdom" forState:UIControlStateNormal];
////        countryTxtField.text=@"United Kingdom";
////        [zipCodeTxtField becomeFirstResponder];
//    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
    if (buttonTouched == 2)
    {
    if(isSelected==NO)
    {
        
        if([countryArray count]>0)
        {
//            self.stringCountry_id = [[countryArray objectAtIndex:0]valueForKey:@"id"];
            country_id =[[[self.countryArray objectAtIndex:0] objectForKey:@"id"]intValue];
            [self.btnCountry setTitle:[[self.countryArray objectAtIndex:0]valueForKey:@"short_name"] forState:UIControlStateNormal];
        }
        
    }
    }
//    else
//        [phoneNoPrefixTxtField becomeFirstResponder];
    
}
-(void)hideKeyboard
{
    [txtCity resignFirstResponder];
    [txtHomeAddress resignFirstResponder];
    [txtState resignFirstResponder];
    [txtZipCode resignFirstResponder];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [btnCountry release];
    [btnState release];
    [super dealloc];
}
@end
