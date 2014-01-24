//
//  EditViewController.h
//  ISB
//
//  Created by AppRoutes on 03/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    NSMutableArray *stateArray;
    NSMutableArray *countryArray;
//    int country_id;
    int state_id;
    UIImagePickerController *picker;
    NSManagedObjectContext *context;
    NSMutableArray *userData;
    BOOL isSelected;
}
@property (retain, nonatomic) IBOutlet UITextField *txtPayPalaccountId;
@property(retain,nonatomic)IBOutlet UIImageView *imgUserDefaultImage;
@property (retain, nonatomic)NSString *Country_id;
@property (retain, nonatomic)NSString *stringCountry_id;
@property (retain, nonatomic) IBOutlet NSString *year;
@property (retain, nonatomic) IBOutlet NSString *created_Date;
@property (retain, nonatomic) IBOutlet UILabel *userNameLbl;
@property(retain,nonatomic)IBOutlet UIImageView *imgCamera;
@property(retain,nonatomic)IBOutlet UIImageView *imgBackCamera;
@property (retain, nonatomic)UIImagePickerController *picker;
@property (retain, nonatomic) NSMutableArray *stateArray;
@property (retain, nonatomic) NSMutableArray *countryArray;
@property (retain, nonatomic) NSMutableArray *cityArray;
@property (retain,nonatomic)IBOutlet UIPickerView *pickerView;
@property (retain,nonatomic)IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *firstNameTxtField;
@property (retain, nonatomic) IBOutlet UITextField *lastNameTxtField;
;
@property (retain, nonatomic) IBOutlet UITextField *addressTxtField;
@property (retain, nonatomic) IBOutlet UITextField *cityTxtPassword;
@property (retain, nonatomic) IBOutlet UITextField *stateTxtField;
@property (retain, nonatomic) IBOutlet UITextField *zipCodeTxtField;
@property (retain, nonatomic) IBOutlet UITextField *emailAddressTxtField;
@property (retain, nonatomic) IBOutlet UITextField *countryTxtField;
@property (retain, nonatomic) IBOutlet UITextField *phoneNoPrefixTxtField;
@property (retain, nonatomic) IBOutlet UITextField *phoneNoTxtField;
@property (retain, nonatomic) IBOutlet UIButton *signUpBtn;
@property (retain, nonatomic) IBOutlet UIButton *stateBtn;
@property (retain, nonatomic) IBOutlet UIButton *profileImgBtn;
@property (retain, nonatomic) IBOutlet UIButton *countryBtn;
@property (strong, nonatomic) IBOutlet UIView *pickerContainer;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)showStatePicker:(id)sender;
- (IBAction)showCountryPicker:(id)sender;
- (IBAction)hidePicker:(id)sender;
@end
