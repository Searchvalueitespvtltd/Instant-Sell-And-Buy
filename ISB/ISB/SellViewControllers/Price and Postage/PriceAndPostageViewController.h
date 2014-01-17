//
//  PriceAndPostageViewController.h
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberKeypadDecimalPoint.h"

@interface PriceAndPostageViewController : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray *arrPostageType;
    NSString *strPaymentType;
    NSString *strPriceAndPostage;
    NSMutableDictionary *dicPriceAndPostage;
    BOOL isSelected;
    BOOL isCurrency;

    NSMutableArray *postageArray;
    NumberKeypadDecimalPoint *DoneButton;
    NSMutableDictionary *dicEditItemDetail;
    NSString *paymenttype;

}
@property (retain, nonatomic) IBOutlet UIButton *btnCurrencySymbol;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *hideBar;
@property (retain, nonatomic) IBOutlet UIToolbar *toolBar;
@property(retain,nonatomic) NSString *strPriceAndPostage;
@property(retain,nonatomic)IBOutlet UITextField * txtProductPrice, *txtProductPostage;
@property(retain,nonatomic) IBOutlet UIPickerView * pickerPostageType;
@property(retain,nonatomic) NSMutableArray *arrPostageType;
@property(retain,nonatomic) NSString *strPaymentType;
@property(retain,nonatomic) IBOutlet UIButton *btnPostageType;
@property(retain,nonatomic) NSMutableDictionary *dicPriceAndPostage;

@property(retain,nonatomic) IBOutlet UIButton *btnRadioPaypal, * btnRadioCash;

@property (retain, nonatomic) IBOutlet UIView *pickerContainer;
@property(nonatomic,retain)NumberKeypadDecimalPoint *DoneButton;
@property (retain, nonatomic) IBOutlet UIButton *btnPostageSymbol;



- (IBAction)hidePicker:(id)sender;

-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnPostageTypeClicked:(id)sender;
-(IBAction)btnRadioPaypalClicked:(id)sender;
-(IBAction)btnRadioCashPickupClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;

-(IBAction)btnRadioClicked:(id)sender;
- (IBAction)btnCurrency:(id)sender;
- (IBAction)btnPostageType:(id)sender;
- (IBAction)btnPaymentTypeNew:(id)sender;

@end
