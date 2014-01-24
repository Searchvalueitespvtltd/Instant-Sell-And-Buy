//
//  RegistrationViewController.m
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "RegistrationViewController.h"
#define HEIGHT_PICKER_TABBAR 44
#define HEIGHT_DATA_PICKER  340
@interface RegistrationViewController ()

@end

@implementation RegistrationViewController
@synthesize scrollView,firstNameTxtField,lastNameTxtField,userNameTxtField,passwordTxtField,confirmpasswordTxtField,addressTxtField,checkBoxBtn,cityTxtPassword,confirmEmailTxtField,countryTxtField,zipCodeTxtField,phoneNoPrefixTxtField,phoneNoTxtField,emailAddressTxtField,signUpBtn,stateTxtField,termAndConditionBtn,toolBar,stateBtn,countryBtn,pickerContainer;

int textFieldTouched = 0;

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
    [scrollView setScrollEnabled:YES];
     pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
//    toolBar.frame=CGRectMake(0, [[UIScreen mainScreen] bounds].size.height, self.view.frame.size.width, HEIGHT_PICKER_TABBAR);
//    countryPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, HEIGHT_DATA_PICKER)];
//    statePicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, HEIGHT_DATA_PICKER)];
   
    stateArray=[[NSMutableArray alloc]initWithObjects:@"UP",@"MP",@"RAJ",@"DL",nil];
    countryArray=[[NSMutableArray alloc]initWithObjects:@"IND",@"AUS",@"ENG",@"PAK",nil];
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.scrollView.frame = CGRectMake(0, 106, 320, self.view.frame.size.height-44);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 106, 320, self.view.frame.size.height-44);
    }
    scrollView.contentSize = CGSizeMake(0, 800);
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch(textFieldTouched)
    {
        case 1:
            stateTxtField.text = [stateArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            break;
        case 2:
            countryTxtField.text = [countryArray objectAtIndex:[pickerView selectedRowInComponent:0]];
            break;
    }
    
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    switch(textFieldTouched)
    {
        case 1:
            return [stateArray count];
            break;
        case 2:
            return [countryArray count];
            break;
        default:
            return 0;
    }
  
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    switch(textFieldTouched)
    {
        case 1:
            return [stateArray objectAtIndex:row];
            break;
        case 2:
            return [countryArray objectAtIndex:row];
            break;
        default:
            return @"nothing";
    }
       
}
//- (void)_showPicker {
//    CGRect frame = countryPicker.frame;
//    CGRect frame1 = statePicker.frame;
//    frame.origin.y = [[UIScreen mainScreen] bounds].size.height;
//    countryPicker.frame = frame;
//    frame1.origin.y = [[UIScreen mainScreen] bounds].size.height;
//    statePicker.frame = frame1;
//    CGRect frame_toolBar=toolBar.frame;
//    frame_toolBar.origin.y = [[UIScreen mainScreen] bounds].size.height;
//    toolBar.frame = frame_toolBar;
//    [self.view addSubview:countryPicker];
//        [self.view addSubview:statePicker];
//    [UIView animateWithDuration:0.25 animations:^{
//        CGRect frame_toolBar=toolBar.frame;
//        //        if ([ [ UIScreen mainScreen ] bounds ].size.height>480) {
//        frame_toolBar.origin.y -=(HEIGHT_PICKER_TABBAR+HEIGHT_DATA_PICKER);
//        //        }else
//        //        frame_toolBar.origin.y -=(HEIGHT_DATA_PICKER);
//        toolBar.frame= frame_toolBar;
//        
//        CGRect frame = countryPicker.frame;
//        frame.origin.y -= HEIGHT_DATA_PICKER;
//        countryPicker.frame = frame;
//        CGRect frame1 = statePicker.frame;
//        frame1.origin.y -= HEIGHT_DATA_PICKER;
//        statePicker.frame = frame;
//    }];
//    
//}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-30) animated:YES];
   
}


-(void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

    switch (textField.tag) {
        case 101:
            [firstNameTxtField resignFirstResponder];
            [lastNameTxtField becomeFirstResponder];
            break;
        case 102:
            [lastNameTxtField resignFirstResponder];
            [userNameTxtField becomeFirstResponder];
            break;
        case 103:
            [userNameTxtField resignFirstResponder];
            [passwordTxtField becomeFirstResponder];
            break;
        case 104:
            [passwordTxtField resignFirstResponder];
            [confirmpasswordTxtField becomeFirstResponder];
            break;
        case 105:
            [confirmpasswordTxtField resignFirstResponder];
            [addressTxtField becomeFirstResponder];
            break;
        case 106:
            [addressTxtField resignFirstResponder];
            [cityTxtPassword becomeFirstResponder];
            break;
        case 107:
            [cityTxtPassword resignFirstResponder];
            [stateTxtField becomeFirstResponder];
            [self showStatePicker:101];
            break;
        case 108:
            [stateTxtField resignFirstResponder];
            [zipCodeTxtField becomeFirstResponder];
            break;
        case 109:
            [zipCodeTxtField resignFirstResponder];
            [countryTxtField becomeFirstResponder];
              [self showCountryPicker:102];
            break;
        case 110:
            [countryTxtField resignFirstResponder];
            [phoneNoPrefixTxtField becomeFirstResponder];
            break;
        case 111:
            [phoneNoPrefixTxtField resignFirstResponder];
            [phoneNoTxtField becomeFirstResponder];
            break;
        case 112:
            [phoneNoTxtField resignFirstResponder];
            [emailAddressTxtField becomeFirstResponder];
            break;
        case 113:
            [emailAddressTxtField resignFirstResponder];
            [confirmEmailTxtField becomeFirstResponder];
            break;
        case 114:
            [confirmEmailTxtField resignFirstResponder];
            [self.scrollView setContentOffset:CGPointMake(0, 400) animated:YES];
            break;
            
        default:
            break;
            
    }
    return YES;
    
}

- (IBAction)termAndConditionClick:(id)sender {
    
}

- (IBAction)checkBoxClick:(id)sender {
    [self.view endEditing:YES];
    if([checkBoxBtn isSelected])
    {
        [checkBoxBtn setSelected:NO];
        
    }
    else
    {
        [checkBoxBtn setSelected:YES];
    }
}

- (IBAction)signUpClick:(id)sender {
    
}
- (IBAction)stopEditing:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)showStatePicker:(id)sender
{
    [stateTxtField resignFirstResponder];
   [self.scrollView setContentOffset:CGPointMake(0, stateTxtField.frame.origin.y-30) animated:YES];
    
    textFieldTouched = 1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        pickerContainer.frame = CGRectMake(0, 290, 320, 261);
        
    }
    else{
        pickerContainer.frame = CGRectMake(0, 200, 320, 261);
    }
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
    
}
- (IBAction)backButton:(id)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)showCountryPicker:(id)sender
{
     [countryTxtField resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, countryTxtField.frame.origin.y-30) animated:YES];
   
    textFieldTouched = 2;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
       pickerContainer.frame = CGRectMake(0, 290, 320, 261);
        
    }
    else{
        pickerContainer.frame = CGRectMake(0, 200, 320, 261);
        }
    
    [UIView commitAnimations];
    [pickerView reloadAllComponents];
}

- (IBAction)hidePicker:(id)sender
{
     
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    [UIView commitAnimations];
    if (textFieldTouched == 1) {
        [zipCodeTxtField becomeFirstResponder];
    }
    else
        [phoneNoPrefixTxtField becomeFirstResponder];
   
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload
{
    [self setPickerContainer:nil];
    [self stateTxtField:nil];
    [self countryTxtField:nil];
    [super viewDidUnload];
}
- (void)dealloc {
    [firstNameTxtField release];
    [lastNameTxtField release];
    [userNameTxtField release];
    [passwordTxtField release];
    [confirmpasswordTxtField release];
    [addressTxtField release];
    [cityTxtPassword release];
    [stateTxtField release];
    [zipCodeTxtField release];
    [emailAddressTxtField release];
    [confirmEmailTxtField release];
    [countryTxtField release];
    [phoneNoPrefixTxtField release];
    [phoneNoTxtField release];
    [signUpBtn release];
    [checkBoxBtn release];
    [super dealloc];
}
@end
