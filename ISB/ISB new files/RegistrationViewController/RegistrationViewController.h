//
//  RegistrationViewController.h
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistrationViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *stateArray;
    NSMutableArray *countryArray;
     IBOutlet UIPickerView *pickerView;
}
@property(retain,nonatomic)IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *firstNameTxtField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTxtField;
@property (retain, nonatomic) IBOutlet UITextField *userNameTxtField;
@property (retain, nonatomic) IBOutlet UITextField *passwordTxtField;
@property (retain, nonatomic) IBOutlet UITextField *confirmpasswordTxtField;
@property (retain, nonatomic) IBOutlet UITextField *addressTxtField;
@property (retain, nonatomic) IBOutlet UITextField *cityTxtPassword;
@property (retain, nonatomic) IBOutlet UITextField *stateTxtField;
@property (retain, nonatomic) IBOutlet UITextField *zipCodeTxtField;
@property (retain, nonatomic) IBOutlet UITextField *emailAddressTxtField;
@property (retain, nonatomic) IBOutlet UITextField *confirmEmailTxtField;
@property (retain, nonatomic) IBOutlet UITextField *countryTxtField;
@property (retain, nonatomic) IBOutlet UITextField *phoneNoPrefixTxtField;
@property (retain, nonatomic) IBOutlet UITextField *phoneNoTxtField;
@property (retain, nonatomic) IBOutlet UIButton *signUpBtn;
@property (retain, nonatomic) IBOutlet UIButton *stateBtn;
@property (retain, nonatomic) IBOutlet UIButton *countryBtn;
@property (retain, nonatomic) IBOutlet UIButton *checkBoxBtn;
@property (retain, nonatomic) IBOutlet UIButton *termAndConditionBtn;
@property (strong, nonatomic) IBOutlet UIView *pickerContainer;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)showCountryPicker:(id)sender;
- (IBAction)hidePicker:(id)sender;
@end
