//
//  ItemViewController.h
//  ISB
//
//  Created by AppRoutes on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import <MessageUI/MessageUI.h>
#import "MessageTextView.h"

#import "PayPal.h"
#import "PayPalPayment.h"


typedef enum PaymentStatuses {
	PAYMENTSTATUS_SUCCESS,
	PAYMENTSTATUS_FAILED,
	PAYMENTSTATUS_CANCELED,
} PaymentStatus;

@class ItemViewController;
@interface ItemViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,
UINavigationControllerDelegate,UITextViewDelegate,PayPalPaymentDelegate>
{
double mDistance;
    UIAlertView *errorAlert;
    NSManagedObjectContext *context;
    NSMutableArray *userData;
    PaymentStatus status;
    NSString *strAmount;
    
    IBOutlet UIButton *btnContact, *btnBuy;
    
    double servlat;
    double servlong;
    double currlat;
    double currlong;
    NSMutableArray *arrayImages;
    IBOutlet UIScrollView *scrllForImage;
    NSString *strTemp2;
    NSString *strTemp3;
    int count;
    
    UIButton *referenceButton;
    UIButton *paymentReferenceButton;
    
   

}
@property (strong, nonatomic) IBOutlet UILabel *countLableValue;
@property(retain,nonatomic) NSMutableDictionary *dicItemDetails;
@property(assign) int isWatching;
@property (strong, nonatomic) IBOutlet UIImageView *overlay;
@property (retain, nonatomic) IBOutlet UIButton *searchBtn;
@property (retain, nonatomic) IBOutlet UIButton *watchBtn;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIImageView *productImage;
@property (retain, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *lblPrice;
@property (retain, nonatomic) IBOutlet UITextView *productDiscriptionTxtView;
@property (retain, nonatomic) IBOutlet UILabel *itemLocationValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *PostageValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *itemCodeValueLbl;
@property (retain, nonatomic) IBOutlet UIButton *buyItemBtn;
@property (retain, nonatomic) IBOutlet UIButton *contectSellerBtn;
@property (retain, nonatomic) IBOutlet MessageTextView *txtSms;
@property (strong, nonatomic) IBOutlet UIView *shareView;
@property (strong, nonatomic) IBOutlet UIView *smsView;
- (IBAction)cancelClick:(id)sender;
- (IBAction)sendClick:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *overlayImage;

//-(IBAction)btnGoToMapClicked:(id)sender;
-(IBAction)btnGoToMapClicked:(id)sender;
- (IBAction)SellerDetailsClick:(id)sender;


//@property(retain,nonatomic)





@end
