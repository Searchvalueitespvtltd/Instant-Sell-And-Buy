//
//  ItemDetailsViewController.h
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemDetailsViewController : UIViewController <UITextViewDelegate>
{
    NSMutableDictionary *dicItemDetail;
    NSMutableDictionary *dicCategoryDetail;
    NSMutableDictionary *dicEditItemDetail;

}

@property(retain,nonatomic)IBOutlet UITextView *txtviewDescription;
@property(retain,nonatomic)IBOutlet UIView *itemDetailView;
@property (retain, nonatomic) IBOutlet UIButton *btnCategory;

@property(retain,nonatomic) NSMutableDictionary *dicItemDetail;
@property(retain,nonatomic) NSMutableArray *dicItemImages;
//@property(retain,nonatomic) NSMutableDictionary *dicCategoryDetail;
//@property(retain,nonatomic) NSMutableDictionary *dicPriceDetail;
//@property(retain,nonatomic) NSMutableDictionary *dicLocDetail;




// last view details

@property(retain,nonatomic) UIImage *prodImage;
@property(retain,nonatomic) NSString *imgTitle;

//@property(retain,nonatomic) NSString *strSelectedCategory;

//@property(retain,nonatomic) IBOutlet UIButton *btnSelectedCategory;




-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnCategoryClicked:(id)sender;
-(IBAction)btnPriceClicked:(id)sender;
-(IBAction)btnLocationClicked:(id)sender;
-(IBAction)btnSaveClicked:(id)sender;
@end
