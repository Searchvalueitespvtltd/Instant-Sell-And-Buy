//
//  ItemViewController.h
//  ISB
//
//  Created by AppRoutes on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface EditItemViewController : UIViewController<
UINavigationControllerDelegate,UITextViewDelegate>
{
    double mDistance;
    UIAlertView *errorAlert;
    NSManagedObjectContext *context;
    NSMutableArray *userData;
    NSString *strAmount;
    double servlat;
    double servlong;
    double currlat;
    double currlong;
    NSMutableArray *arrayImages;
    IBOutlet UIScrollView *scrllForImage;
    NSString *strTemp2;
    NSString *strTemp3;
    int count;
}
@property(retain,nonatomic) NSMutableDictionary *dicItemDetails;
@property(assign) int isWatching;
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property (retain, nonatomic) IBOutlet UILabel *productTitleLbl;
@property (retain, nonatomic) IBOutlet UILabel *distanceLabel;
@property (retain, nonatomic) IBOutlet UILabel *lblPrice;
@property (retain, nonatomic) IBOutlet UITextView *productDiscriptionTxtView;
@property (retain, nonatomic) IBOutlet UILabel *itemLocationValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *PostageValueLbl;
@property (retain, nonatomic) IBOutlet UILabel *itemCodeValueLbl;
- (IBAction)btnShareClick:(id)sender;
- (IBAction)makeItAvailableAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIButton *makeItAvailableOutlet;

-(IBAction)btnGoToMapClicked:(id)sender;
@end
