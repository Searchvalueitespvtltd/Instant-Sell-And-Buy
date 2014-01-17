//
//  PriceAndPostageViewController.m
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "PriceAndPostageViewController.h"
#import "ItemDetailsViewController.h"
#import "ItemDetails.h"
#import "AppDelegate.h"

@interface PriceAndPostageViewController ()

@end

@implementation PriceAndPostageViewController
@synthesize txtProductPostage,txtProductPrice,pickerPostageType,arrPostageType,strPaymentType,btnPostageType,strPriceAndPostage;
@synthesize dicPriceAndPostage;
@synthesize btnRadioCash,btnRadioPaypal;
@synthesize DoneButton,btnCurrencySymbol,btnPostageSymbol;
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
    self.pickerContainer.frame = CGRectMake(0, 1000, 320, 261);

//    self.pickerPostageType.hidden = YES;
    self.strPaymentType = [[NSString alloc]init];

    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callWebService) withObject:nil afterDelay:0.1];
    // Do any additional setup after loading the view from its nib.
}
//-(void)getPostage{
//    
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    [self performSelector:@selector(callWebService) withObject:nil afterDelay:0.1];
//}
-(void)viewWillAppear:(BOOL)animated
{
    if ([ItemDetails sharedInstance].isEditing) {
        NSArray *priceArray=[[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"Price"] componentsSeparatedByString:@" "];
               if ([priceArray count]>1) {
            [btnCurrencySymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
 [btnPostageSymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
                   txtProductPrice.text = [priceArray objectAtIndex:2];
        }else
            txtProductPrice.text = [priceArray objectAtIndex:0];

      NSArray *postageArrayNew=[[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"Postage"] componentsSeparatedByString:@" "];
        if ([postageArrayNew count]>1) {
           // [btnPostageSymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
           // [btnPostageSymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
            txtProductPostage.text = [postageArrayNew objectAtIndex:2];
        }else
            txtProductPostage.text = [postageArrayNew objectAtIndex:0];
        
     //   txtProductPostage.text = [[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"Postage"];
        [btnPostageType setTitle:[NSString stringWithFormat:@"%@",[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"PostageText"]] forState:UIControlStateNormal];
//        btnPostageType.titleLabel.text =[dicEditItemDetail valueForKey:@"postagetype_name"];
        paymenttype =[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"PaymentType"];
        self.strPriceAndPostage = [[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"];
        if ([paymenttype isEqualToString:@"1"]) {
            [self.btnRadioPaypal setSelected:YES];
            [self.btnRadioCash setSelected:NO];
            self.strPaymentType = @"1";

        }
        else
        {
            [self.btnRadioPaypal setSelected:NO];
            [self.btnRadioCash setSelected:YES];
            self.strPaymentType = @"2";
        }
//        NSString *str=[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PaymentType"];
//        NSArray *arrPost=[str componentsSeparatedByString:@","];
//        for (int j=0; j<[arrPost count]; j++) {
//            UIButton *button=(UIButton *)[self.view viewWithTag:61+j];
//            [button setSelected:YES];
//        }
        
        
        
        
    }else
    {
    
    [ItemDetails sharedInstance].isSelected =0;

    if([[ItemDetails sharedInstance].dicPriceDetail count]>0)
    {
//        txtProductPostage.text = [[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"Postage"]; 
//        //txtProductPrice.text = [[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"Price"];
//        NSArray *priceArray=[[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"Price"] componentsSeparatedByString:@" "];
//        txtProductPrice.text = [priceArray objectAtIndex:0];
//        if ([priceArray count]>1) {
////            btnCurrencySymbol.titleLabel.text=[priceArray objectAtIndex:1];
//            [btnCurrencySymbol setTitle:[priceArray objectAtIndex:1] forState:UIControlStateNormal];
//        }
        
        NSArray *priceArray=[[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"Price"] componentsSeparatedByString:@" "];
        if ([priceArray count]>1) {
            [btnCurrencySymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
            [btnPostageSymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
            txtProductPrice.text = [priceArray objectAtIndex:2];
        }else
            txtProductPrice.text = [priceArray objectAtIndex:0];
        
        NSArray *postageArrayNew=[[[ItemDetails sharedInstance].dicPriceDetail valueForKey:@"Postage"] componentsSeparatedByString:@" "];
        if ([postageArrayNew count]>1) {
            // [btnPostageSymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
            // [btnPostageSymbol setTitle:[[priceArray objectAtIndex:0] stringByAppendingFormat:@" %@",[priceArray objectAtIndex:1]] forState:UIControlStateNormal];
            txtProductPostage.text = [postageArrayNew objectAtIndex:2];
        }else
            txtProductPostage.text = [postageArrayNew objectAtIndex:0];
        
        [btnPostageType setTitle:[NSString stringWithFormat:@"%@",[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageText"]] forState:UIControlStateNormal];
        self.strPriceAndPostage = [[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"];
        if([[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PaymentType"] intValue]==1)
        {
            self.strPaymentType = @"1";
            [self.btnRadioPaypal setSelected:YES];
            [self.btnRadioCash setSelected:NO];
        }
        else
        {
            self.strPaymentType = @"2";
            [self.btnRadioPaypal setSelected:NO];
            [self.btnRadioCash setSelected:YES];

        }
//        NSString *paymntType = [[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PaymentType"];
        
        //if
        
    }
    }
//    [ItemDetails sharedInstance].dicPriceDetail = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.txtProductPrice.text,@"Price",self.txtProductPostage.text,@"Postage",self.strPriceAndPostage,@"PostageType",self.strPaymentType,@"PaymentType",  nil];
    
    
    [super viewWillAppear:YES];
}

#pragma mark - Call Webservice

-(void)callWebService
{
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:@"postageTypes/get" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];

        if([inResponseDic isKindOfClass:[NSArray class]])
        {
//            self.arrPostageType = [NSMutableArray arrayWithArray:inResponseDic];
//            isSelected=NO;
//            isCurrency=NO;
//
//            [UIView beginAnimations:nil context:NULL];
//            [UIView setAnimationDuration:0.3];
//            if([[UIScreen mainScreen] bounds].size.height>480)
//            {
//                self.pickerContainer.frame = CGRectMake(0, 240, 320, 261);
//            }
//            else
//            {
//                self.pickerContainer.frame = CGRectMake(0, 153, 320, 261);
//            }
//            
//            [UIView commitAnimations];
//            [pickerPostageType reloadAllComponents];
            
            
            postageArray=[[NSMutableArray alloc]initWithArray:inResponseDic];
            NSArray *fontArray=[UIFont fontNamesForFamilyName:@"Avenir Next Condensed"];
            for (int i=0; i<[inResponseDic count]; i++) {
                UIButton *checkButton=[UIButton buttonWithType:UIButtonTypeCustom];
                [checkButton setBackgroundImage:[UIImage imageNamed:@"checkboxOff.png"] forState:UIControlStateNormal];
                [checkButton setBackgroundImage:[UIImage imageNamed:@"checkboxOn.png"] forState:UIControlStateSelected];
                [checkButton setTag:51+i];
                [checkButton addTarget:self action:@selector(postageChecked:) forControlEvents:UIControlEventTouchUpInside];
                [checkButton setFrame:CGRectMake(140, 175+i*35, 19, 19)];
                [self.view addSubview:checkButton];
                
                UILabel *postageLabel=[[UILabel alloc]initWithFrame:CGRectMake(181, 173+i*35, 120, 24)];
                [postageLabel setText:[[inResponseDic objectAtIndex:i] valueForKey:@"name"]];
                [postageLabel setFont:[UIFont fontWithName:[fontArray objectAtIndex:5] size:17] ];
                [postageLabel setBackgroundColor:[UIColor clearColor]];
                [postageLabel setTag:81+i];
                [self.view addSubview:postageLabel];
            
            }
//            if ([ItemDetails sharedInstance].isEditing) {
                NSString *str=[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"];
                NSArray *arrPost=[str componentsSeparatedByString:@","];
                for (int j=0; j<[arrPost count]; j++) {
                    UIButton *button;
                    switch ([arrPost[j] integerValue]) {
                        case 1:
                            button=(UIButton *)[self.view viewWithTag:50+[arrPost[j] integerValue]];
                            [button setSelected:YES];
                            break;
                        case 2:
                            button=(UIButton *)[self.view viewWithTag:50+[arrPost[j] integerValue]];
                            [button setSelected:YES];
                            break;
                        case 3:
                            button=(UIButton *)[self.view viewWithTag:50+[arrPost[j] integerValue]];
                            [button setSelected:YES];
                            break;
                        default:
                            break;
                    }
//                    UIButton *button=(UIButton *)[self.view viewWithTag:51+j];
//                    [button setSelected:YES];
                }
//            }
  
        }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    NSLog(@"%@",inError);
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

-(void)postageChecked:(id)sender{
//    NSLog(@"%d",[sender tag]);
    UIButton *button=(UIButton *)sender;
    [button setSelected:![button isSelected]];
}


#pragma - mark PickerView Delegates

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    [self hidePicker];
    if (isCurrency) {
        [btnCurrencySymbol setTitle:[arrPostageType objectAtIndex:row] forState:UIControlStateNormal];
        [btnPostageSymbol setTitle:[arrPostageType objectAtIndex:row] forState:UIControlStateNormal];


    }else{
    isSelected = YES;
    self.strPriceAndPostage = [[arrPostageType objectAtIndex:row]valueForKey:@"id"];
    [btnPostageType setTitle:[NSString stringWithString:[[arrPostageType objectAtIndex:row]valueForKey:@"name"]] forState:UIControlStateNormal];
    }
}

-(NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (isCurrency) {
        return [arrPostageType objectAtIndex:row];
    }else
        return [[arrPostageType objectAtIndex:row]valueForKey:@"name"];
}

//
//-(CGFloat) pickerView:(UIPickerView *) pickerView widthForComponent:(NSInteger)component{
//    
//    return 340;
//}
//

-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40.0;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (![arrPostageType count] == 0)
    {
        return [arrPostageType count];

    }
    else
    {
        return 10;
    }
}

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}




#pragma  - mark Button Methods

- (IBAction)hidePicker:(id)sender {
    for (int i=0; i<[postageArray count]; i++) {
        UIButton *button=(UIButton *)[self.view viewWithTag:51+i];
        UILabel *label=(UILabel *)[self.view viewWithTag:81+i];
        [button setHidden:NO];
        [label setHidden:NO];
    }
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.pickerContainer.frame = CGRectMake(0, 1000, 320, 261);
    
    [UIView commitAnimations];
    if(isSelected==NO&& isCurrency==NO)
    {
        if([arrPostageType count]>0)
        {
            self.strPriceAndPostage = [[arrPostageType objectAtIndex:0]valueForKey:@"id"];
            [self.btnPostageType setTitle:[[self.arrPostageType objectAtIndex:0]objectForKey:@"name"] forState:UIControlStateNormal];
        }
    }else if(isCurrency){
       // [btnCurrencySymbol setTitle:[arrPostageType objectAtIndex:0] forState:UIControlStateNormal];
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnPostageTypeClicked:(id)sender
{
    [self.view endEditing:YES];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [self performSelector:@selector(callWebService) withObject:nil afterDelay:0.1];
//    self.pickerPostageType.hidden = NO;
//    [self.txtProductPostage resignFirstResponder];
//    [self.txtProductPrice resignFirstResponder];
//    [self callWebService];
//    [self showPicker];
}

-(IBAction)btnRadioPaypalClicked:(id)sender
{
    
}

-(IBAction)btnRadioCashPickupClicked:(id)sender
{
    
}

-(IBAction)btnRadioClicked:(id)sender
{
    if ([sender tag] ==100)
    {
        if([btnRadioPaypal isSelected])
        {
            [btnRadioPaypal setSelected:NO];
        }
        else   
        {
            self.strPaymentType = @"1";
            [btnRadioPaypal setSelected:YES];
            [btnRadioCash setSelected:NO];
//            NSLog(@"Payment type = %@",strPaymentType);
        }

    }
    else if ([sender tag] ==200)
    {
        if([btnRadioCash isSelected])
        {
            [btnRadioCash setSelected:NO];
        }
        else
        {
            self.strPaymentType = @"2";
            [btnRadioCash setSelected:YES];
            [btnRadioPaypal setSelected:NO];
//              NSLog(@"Payment type = %@",strPaymentType);
        }
            
    }
}

- (IBAction)btnCurrency:(id)sender {
//    isSelected=NO;
    isCurrency=YES;
    if (![Utils isIPhone_5])
    {
        for (int i=0; i<[postageArray count]; i++)
        {
            UIButton *button=(UIButton *)[self.view viewWithTag:51+i];
            UILabel *label=(UILabel *)[self.view viewWithTag:81+i];
            [button setHidden:YES];
            [label setHidden:YES];
            //  [pickerPostageType bringSubviewToFront:button];
        }
    }else
    {
        UIButton *button=(UIButton *)[self.view viewWithTag:53];
        UILabel *label=(UILabel *)[self.view viewWithTag:83];
        [button setHidden:YES];
        [label setHidden:YES];
        
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.pickerContainer.frame = CGRectMake(0, 240, 320, 261);
    }
    else
    {
        self.pickerContainer.frame = CGRectMake(0, 153, 320, 261);
    }
    
    [UIView commitAnimations];
    
   
    self.arrPostageType=[[NSMutableArray alloc]initWithObjects:@"US $",@"NOK kr",@"GBP £",@"AU $",@"Euro €", nil];
    [pickerPostageType reloadAllComponents];

 
}

- (IBAction)btnPostageType:(id)sender {
}

- (IBAction)btnPaymentTypeNew:(id)sender {
    UIButton *button=(UIButton*)sender;
    [button setSelected:![button isSelected]];
    
}


-(IBAction)btnDoneClicked:(id)sender
{
    if ([self.txtProductPrice text].length==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter product price." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    if ([[self.btnCurrencySymbol titleLabel] text].length==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Please select currency." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    if ([self.txtProductPostage text].length==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter product postage." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    
//    if (btnPostageType.titleLabel.text.length == 0)
//    if ([self.strPriceAndPostage isEqualToString: @""])
//    {
//        [Utils showAlertView:kAlertTitle message:@"Please select postage type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
    
    if (self.strPaymentType.length ==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Please select payment type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    if (self.btnCurrencySymbol.titleLabel.text.length ==0)
    {
        [Utils showAlertView:kAlertTitle message:@"Please select currency type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    
    
    NSMutableArray *arr=[[NSMutableArray alloc]init];
    NSString *str=@"";
    for (int i=0; i<[postageArray count]; i++) {
        UIButton *button=(UIButton *)[self.view viewWithTag:51+i];
        if ([button isSelected]) {
           // [arr addObject:[NSString stringWithFormat:@"%d",i+1]];
            str=[str stringByAppendingFormat:@"%d,",i+1];
        }
    }
    if (![str isEqualToString:@""]) {
        str=[str substringToIndex:[str length]-1];
    }else
    {
        [Utils showAlertView:kAlertTitle message:@"Please select Postage type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }

//    NSString *strPayment=@"";
//
//    for (int i=0; i<2; i++) {
//        UIButton *button=(UIButton *)[self.view viewWithTag:61+i];
//        if ([button isSelected]) {
//            // [arr addObject:[NSString stringWithFormat:@"%d",i+1]];
//            strPayment=[strPayment stringByAppendingFormat:@"%d,",i+1];
//        }
//    }
//    if (![strPayment isEqualToString:@""]) {
//        strPayment=[strPayment substringToIndex:[str length]-1];
//    }else
//    {
//        [Utils showAlertView:kAlertTitle message:@"Please select Payment type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        return;
//    }
    
    
//    ItemDetailsViewController *item = [[ItemDetailsViewController alloc]init];
    NSString *strPostage=[self.btnCurrencySymbol.titleLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.txtProductPostage.text]];
    [ItemDetails sharedInstance].dicPriceDetail = [NSMutableDictionary dictionaryWithObjectsAndKeys:[self.btnCurrencySymbol.titleLabel.text stringByAppendingString:[NSString stringWithFormat:@" %@",self.txtProductPrice.text]],@"Price",strPostage,@"Postage",str,@"PostageType",self.strPaymentType,@"PaymentType",@"all",@"PostageText",nil];
    
    
//    NSLog(@" price => %d",[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PaymentType"]intValue]);

    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showPicker//:(UIButton*)val
{
    
    isSelected=NO;
    [UIView animateWithDuration:0.75 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if ([Utils isIPhone_5]) {
                             self.pickerPostageType.transform=CGAffineTransformMakeTranslation(0,-239);

                         }
                         else
                         {
                             self.pickerPostageType.transform=CGAffineTransformMakeTranslation(0,-259);
                         }
                     }
                     completion:^(BOOL finished) {
                     }];
    
    
}
-(void)hidePicker
{
    
    [UIView animateWithDuration:0.75 delay:0.0 options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if ([Utils isIPhone_5]) {
                             self.pickerPostageType.transform=CGAffineTransformMakeTranslation(0,239);
                             
                         }
                         else
                         {
                             self.pickerPostageType.transform=CGAffineTransformMakeTranslation(0,259);
                         }

                     }
                     completion:^(BOOL finished) {}];
}


#pragma - mark TextField Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (!self.DoneButton)
    {
        self.DoneButton = [NumberKeypadDecimalPoint keypadForTextField:textField];
    }
    else
    {
        //if we go from one field to another - just change the textfield, don't reanimate the decimal point button
        self.DoneButton.currentTextField = textField;
    }
	
}


-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == DoneButton.currentTextField)
    {
		/*
		 Hide the number keypad
		 */
		[self.DoneButton removeButtonFromKeyboard];
		self.DoneButton = nil;
		[self doneButton];
	}
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
	if (DoneButton)
	{
		DoneButton.currentTextField = textField;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return [string isEqualToString:@""] ||
//    ([string stringByTrimmingCharactersInSet:
//      [[NSCharacterSet decimalDigitCharacterSet] invertedSet]].length > 0);
//    
//}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSCharacterSet *nonNumberSet = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    if ([string rangeOfCharacterFromSet:nonNumberSet].location != NSNotFound)
    {
        [Utils showAlertView:kAlertTitle message:@"Please enter numeric values only." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return NO;
    }
    return YES;
}


- (void)doneButton
{
    
    [txtProductPostage resignFirstResponder];
	[txtProductPrice resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_pickerContainer release];
    [_toolBar release];
    [_hideBar release];
    [btnCurrencySymbol release];
    [btnPostageSymbol release];
    [super dealloc];
}
@end
