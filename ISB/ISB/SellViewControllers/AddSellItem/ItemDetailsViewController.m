//
//  ItemDetailsViewController.m
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ItemDetailsViewController.h"
#import "SelectCategoryViewController.h"
#import "PriceAndPostageViewController.h"
#import "AddLocationViewController.h"
#import "ItemDetails.h"
#import "NSData+Base64.h"
#import "ShareViewController/ShareViewController.h"
#import "AppDelegate.h"
#import "SellViewController.h"
#import "AppDelegate.h"

@interface ItemDetailsViewController ()

@end

@implementation ItemDetailsViewController
@synthesize txtviewDescription,itemDetailView;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma marks - call web service

-(void)callWebService
{
//        [Utils startActivityIndicatorInView:self.view withMessage:nil];
    {
        NSError *error=nil;
        NSArray *array=[self.dicItemDetail objectForKey:@"imageArray"];
        NSString *imgString1=[[NSString alloc]init];;
        NSString *imgString2=[[NSString alloc]init];;
        NSString *imgString3=[[NSString alloc]init];;
        NSString *str=[[NSString alloc]init];
        NSString *str1=[[NSString alloc]init];
        NSString *str2=[[NSString alloc]init];
        NSString *imageNumb1=[[NSString alloc]init];
        NSString *imageNumb2=[[NSString alloc]init];

        NSString *default_pic=[self.dicItemDetail objectForKey:@"default_pic"] ;
        NSString *strNew=[[NSString alloc]init];
        switch (array.count) {
            case 1:
                imageNumb1=[[array objectAtIndex:0] objectForKey:@"image_no"];
                switch ([imageNumb1 integerValue]) {
                    case 1:
                        imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                        str=[@"img1=" stringByAppendingString:imgString1];
                        strNew=[NSString stringWithFormat:@"img1=%@&default_pic=%@",imgString1,default_pic];
                        break;
                    case 2:
                        imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                        str=[@"img2=" stringByAppendingString:imgString1];
                        strNew=[NSString stringWithFormat:@"img2=%@&default_pic=%@",imgString1,default_pic];
                        break;
                    case 3:
                        imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                        str=[@"img3=" stringByAppendingString:imgString1];
                        strNew=[NSString stringWithFormat:@"img3=%@&default_pic=%@",imgString1,default_pic];
                        break;
                    default:
                        break;
                }
//                imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
//                str=[@"img1=" stringByAppendingString:imgString1];
//                strNew=[NSString stringWithFormat:@"img1=%@&default_pic=%@",imgString1,default_pic];
                break;
                
            case 2:
                imageNumb1=[[array objectAtIndex:0] objectForKey:@"image_no"];
                imageNumb2=[[array objectAtIndex:1] objectForKey:@"image_no"];
                imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                imgString2 = [[[array objectAtIndex:1] objectForKey:@"image"] base64Encoding];
                if ([imageNumb1 integerValue] ==1 && [imageNumb2 integerValue] ==2) {
                    str=[@"img1=" stringByAppendingString:imgString1];
                    str1=[@"img2=" stringByAppendingString:imgString2];
                    strNew=[NSString stringWithFormat:@"img1=%@&img2=%@&default_pic=%@",imgString1,imgString2,default_pic];
                }else if ([imageNumb1 integerValue] ==1 && [imageNumb2 integerValue] ==3)
                {
                    str=[@"img1=" stringByAppendingString:imgString1];
                    str1=[@"img3=" stringByAppendingString:imgString2];
                    strNew=[NSString stringWithFormat:@"img1=%@&img3=%@&default_pic=%@",imgString1,imgString2,default_pic];
                }else{
                    str=[@"img2=" stringByAppendingString:imgString1];
                    str1=[@"img3=" stringByAppendingString:imgString2];
                    strNew=[NSString stringWithFormat:@"img2=%@&img3=%@&default_pic=%@",imgString1,
                            imgString2,default_pic];
                }
               
                
                break;
            case 3:
                imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                imgString2 = [[[array objectAtIndex:1] objectForKey:@"image"] base64Encoding];
                imgString3 = [[[array objectAtIndex:2] objectForKey:@"image"] base64Encoding];
                str=[@"img1=" stringByAppendingString:imgString1];
                str1=[@"img2=" stringByAppendingString:imgString2];
                str2=[@"img3=" stringByAppendingString:imgString3];
                strNew=[NSString stringWithFormat:@"img1=%@&img2=%@&img3=%@&default_pic=%@",imgString1,imgString2,imgString3,default_pic];
                break;
            default:
                break;
        }
        

            NSData *postData = [strNew dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
            
            NSString *urlString = [NSString stringWithFormat:@"%@items/save?title=%@&desc=%@&price=%@&postage=%@&postagetype_id=%@&paymenttype_id=%@&location_latlong=%@,%@&category_id=%@&user_id=%@&home_addr=%@&city=%@&state_name=%@&country_name=%@&zip=%@",kBaseURL,[[self.dicItemDetail objectForKey:@"title"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.txtviewDescription.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"Price"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"Postage"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"],[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PaymentType"],[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"LATITUDE"],[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"LONGITUDE"],[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"id"],[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"HOMEADDRESS"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"CITY"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"STATE"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"COUNTRY"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"ZIPCODE"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            

            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            
            [request setHTTPBody:postData];
            
            NSURLResponse *response;
            NSError *err;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            
            NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",s);
            NSArray *result = [s JSONValue];
//            NSLog(@"result = %@",result);
            if([[result objectAtIndex:0]isKindOfClass:[NSDictionary class]])
            {
                [Utils showAlertView:kAlertTitle message:@"Product added successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
                [temp setObject:[self.dicItemDetail objectForKey:@"title"] forKey:@"title"];
                [ItemDetails sharedInstance].dicToShare=Nil;
                [ItemDetails sharedInstance].dicToShare=[[NSMutableDictionary alloc]init];
                [ItemDetails sharedInstance].dicToShare=temp;
                [temp release];

                ShareViewController *share;
                if ([Utils isIPhone_5]) {
                    share=[[ShareViewController alloc]initWithNibName:@"ShareViewController_iPhone5" bundle:nil];
                }else
                    share=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
                
                [self.navigationController pushViewController:share animated:YES];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
            
        }
//            }

}

-(void)callEditService
{
//    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    
        NSError *error=nil;
        NSArray *array=[self.dicItemDetail objectForKey:@"imageArray"];
        NSString *imgString1=[[NSString alloc]init];
        NSString *imgString2=[[NSString alloc]init];
        NSString *imgString3=[[NSString alloc]init];
        NSString *str=[[NSString alloc]init];
        NSString *str1=[[NSString alloc]init];
        NSString *str2=[[NSString alloc]init];
    NSString *imageNumb1=[[NSString alloc]init];
    NSString *imageNumb2=[[NSString alloc]init];
        NSString *default_pic=[self.dicItemDetail objectForKey:@"default_pic"] ;
    NSString *strNew=[[NSString alloc]init];
    switch (array.count) {
        case 1:
            imageNumb1=[[array objectAtIndex:0] objectForKey:@"image_no"];
            switch ([imageNumb1 integerValue]) {
                case 1:
                    imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                    str=[@"img1=" stringByAppendingString:imgString1];
                    strNew=[NSString stringWithFormat:@"img1=%@&default_pic=%@",imgString1,default_pic];
                    break;
                case 2:
                    imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                    str=[@"img2=" stringByAppendingString:imgString1];
                    strNew=[NSString stringWithFormat:@"img2=%@&default_pic=%@",imgString1,default_pic];
                    break;
                case 3:
                    imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
                    str=[@"img3=" stringByAppendingString:imgString1];
                    strNew=[NSString stringWithFormat:@"img3=%@&default_pic=%@",imgString1,default_pic];
                    break;
                default:
                    break;
            }
            //                imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
            //                str=[@"img1=" stringByAppendingString:imgString1];
            //                strNew=[NSString stringWithFormat:@"img1=%@&default_pic=%@",imgString1,default_pic];
            break;
            
        case 2:
            imageNumb1=[[array objectAtIndex:0] objectForKey:@"image_no"];
            imageNumb2=[[array objectAtIndex:1] objectForKey:@"image_no"];
            imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
            imgString2 = [[[array objectAtIndex:1] objectForKey:@"image"] base64Encoding];
            if ([imageNumb1 integerValue] ==1 && [imageNumb2 integerValue] ==2) {
                str=[@"img1=" stringByAppendingString:imgString1];
                str1=[@"img2=" stringByAppendingString:imgString2];
                strNew=[NSString stringWithFormat:@"img1=%@&img2=%@&default_pic=%@",imgString1,imgString2,default_pic];
            }else if ([imageNumb1 integerValue] ==1 && [imageNumb2 integerValue] ==3)
            {
                str=[@"img1=" stringByAppendingString:imgString1];
                str1=[@"img3=" stringByAppendingString:imgString2];
                strNew=[NSString stringWithFormat:@"img1=%@&img3=%@&default_pic=%@",imgString1,imgString2,default_pic];
            }else{
                str=[@"img2=" stringByAppendingString:imgString1];
                str1=[@"img3=" stringByAppendingString:imgString2];
                strNew=[NSString stringWithFormat:@"img2=%@&img3=%@&default_pic=%@",imgString1,
                        imgString2,default_pic];
            }
            
            
            break;
        case 3:
            imgString1 = [[[array objectAtIndex:0] objectForKey:@"image"] base64Encoding];
            imgString2 = [[[array objectAtIndex:1] objectForKey:@"image"] base64Encoding];
            imgString3 = [[[array objectAtIndex:2] objectForKey:@"image"] base64Encoding];
            str=[@"img1=" stringByAppendingString:imgString1];
            str1=[@"img2=" stringByAppendingString:imgString2];
            str2=[@"img3=" stringByAppendingString:imgString3];
            strNew=[NSString stringWithFormat:@"img1=%@&img2=%@&img3=%@&default_pic=%@",imgString1,imgString2,imgString3,default_pic];
            break;
        default:
            break;
    }
            NSData *postData = [strNew dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
                NSString *urlString = [NSString stringWithFormat:@"%@items/edit?title=%@&desc=%@&price=%@&postage=%@&postagetype_id=%@&paymenttype_id=%@&location_latlong=%@,%@&category_id=%@&user_id=%@&home_addr=%@&city=%@&state_name=%@&country_name=%@&zip=%@&item_id=%@",kBaseURL,[[self.dicItemDetail objectForKey:@"title"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[self.txtviewDescription.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"Price"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"Postage"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"],[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PaymentType"],[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"LATITUDE"],[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"LONGITUDE"],[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"id"],[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"HOMEADDRESS"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"CITY"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"STATE"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"COUNTRY"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"ZIPCODE"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"item_id"]];
            
            urlString = [urlString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            [request setHTTPMethod:@"POST"];
            
            [request setHTTPBody:postData];
            
            NSURLResponse *response;
            NSError *err;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
            
            NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//            NSLog(@"%@",s);
            NSArray *result = [s JSONValue];
//            NSLog(@"result = %@",result);
            if([[result objectAtIndex:0]isEqualToString:@"success"])
            {
                [Utils showAlertView:kAlertTitle message:@"Product updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             //   NSString *strUrl=[[NSString alloc]init];
                NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
                [temp setObject:[self.dicItemDetail objectForKey:@"title"] forKey:@"title"];
                [ItemDetails sharedInstance].dicToShare=Nil;
                [ItemDetails sharedInstance].dicToShare=[[NSMutableDictionary alloc]init];
                [ItemDetails sharedInstance].dicToShare=temp;
                [temp release];

                ShareViewController *share;
                if ([Utils isIPhone_5]) {
                    share=[[ShareViewController alloc]initWithNibName:@"ShareViewController_iPhone5" bundle:nil];
                }else
                    share=[[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
                
                [self.navigationController pushViewController:share animated:YES];

            }
            else
            {
                [Utils showAlertView:kAlertTitle message:@"Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
            }
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    if ([inReqIdentifier rangeOfString:@"items/edit?"].length>0)
    {
        [Utils showAlertView:kAlertTitle message:@"Product Updated successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       
        
    }else
    {
        [Utils showAlertView:kAlertTitle message:@"Product added successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=YES;
    
    if ([ItemDetails sharedInstance].isEditing){
        txtviewDescription.text = [[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"desc"];
        [self.btnCategory setTitle:[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"category_name"] forState:UIControlStateNormal];
    }else{
    [ItemDetails sharedInstance].dicLocDetail = [[NSMutableDictionary alloc]init];
    [ItemDetails sharedInstance].dicCategoryDetail = [[NSMutableDictionary alloc]init];
    [ItemDetails sharedInstance].dicPriceDetail = [[NSMutableDictionary alloc]init];
    }
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [ItemDetails sharedInstance].isSelected =0;

    [super viewWillAppear:animated];
    if([[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"name"] length]>0)
    {
        [self.btnCategory setTitle:[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"name"] forState:UIControlStateNormal];
    }
    NSLog(@"dicLocDetail : %@",[ItemDetails sharedInstance].dicLocDetail);
}
#pragma - mark Button methods

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [self hideKeyboard];
}

-(IBAction)btnCategoryClicked:(id)sender
{
    SelectCategoryViewController  *selectCategory;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        selectCategory=[[SelectCategoryViewController alloc] initWithNibName:@"SelectCategoryViewController_iPhone5" bundle:nil];
        
    }
    else{
        selectCategory=[[SelectCategoryViewController alloc] initWithNibName:@"SelectCategoryViewController" bundle:nil]; }
        [self hideKeyboard];
    [self.navigationController pushViewController:selectCategory animated:YES ];
    [selectCategory release];

}

-(IBAction)btnPriceClicked:(id)sender
{
    PriceAndPostageViewController  *priceAndPostage;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        priceAndPostage=[[PriceAndPostageViewController alloc] initWithNibName:@"PriceAndPostageViewController_iPhone5" bundle:nil];
        
    }
    else{
        priceAndPostage=[[PriceAndPostageViewController alloc] initWithNibName:@"PriceAndPostageViewController" bundle:nil]; }
        [self hideKeyboard];
    [self.navigationController pushViewController:priceAndPostage animated:YES ];
}

-(IBAction)btnLocationClicked:(id)sender
{
    AddLocationViewController  *addLocation;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        addLocation=[[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController_iPhone5" bundle:nil];
        
    }
    else{
        addLocation=[[AddLocationViewController alloc] initWithNibName:@"AddLocationViewController" bundle:nil]; }
        [self hideKeyboard];
    [self.navigationController pushViewController:addLocation animated:YES ];
}

-(IBAction)btnSaveClicked:(id)sender
{
    if ([ItemDetails sharedInstance].isEditing) {
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self performSelector:@selector(callEditService) withObject:nil afterDelay:1.0];
    }
    else
    {
    if([[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"]intValue]<=0 && [[self.dicItemDetail objectForKey:@"title"] length]<=0 && [[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"id"] intValue]>0 && [txtviewDescription.text isEqualToString:@"Enter Description"])
    {
        [Utils showAlertView:kAlertTitle message:@"Please Enter All Details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
//    else
//    {
        if([[ItemDetails sharedInstance].dicCategoryDetail count]==0)
        {
            [Utils showAlertView:kAlertTitle message:@"Please select category." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            return;

        }
        else if ([txtviewDescription.text isEqualToString:@"Enter Description"])
        {
            [Utils showAlertView:kAlertTitle message:@"Please add item description." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            return;

        }
        else if([[ItemDetails sharedInstance].dicPriceDetail count]==0)
        {
            [Utils showAlertView:kAlertTitle message:@"Please add price & postage details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            return;

        }
        else if([[ItemDetails sharedInstance].dicLocDetail count]==0)
        {
            [Utils showAlertView:kAlertTitle message:@"Please add location details." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            return;
        }
        
//    }
        [Utils startActivityIndicatorInView:self.view withMessage:nil];
        [self performSelector:@selector(callWebService) withObject:nil afterDelay:1.0];
//    NSLog(@" location => %d",[[[ItemDetails sharedInstance].dicLocDetail objectForKey:@"EntryType"]intValue]);
//    NSLog(@" price => %d",[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"PostageType"]intValue]);
//
//       NSLog(@" title => %d", [[self.dicItemDetail objectForKey:@"title"]length ]);
//    NSLog(@" category => %d",[[[ItemDetails sharedInstance].dicPriceDetail objectForKey:@"id"]intValue]);
    }
}

#pragma - mark TextView Delegate

- (BOOL)textView:(UITextView *)txtView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text isEqualToString:@"\n"])
    {
        [txtView resignFirstResponder];
        return NO;
    }
    return YES;
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([self.txtviewDescription.text isEqualToString:@"Enter Description"])
    {
        self.txtviewDescription.text = @"";
    }
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    [txtviewDescription resignFirstResponder];
    if([txtviewDescription.text isEqualToString:@""])
        self.txtviewDescription.text = @"Enter Description";
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if (App.isEdit) {
//        [App.dictEditItemDetail setValue:txtviewDescription.text forKey:@"desc"];
//
//    }
}

-(void)hideKeyboard
{
    [txtviewDescription resignFirstResponder];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnCategory release];
    [super dealloc];
}
@end
