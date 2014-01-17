//
//  AddSellItemViewController.h
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSellItemViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
{
    UIImagePickerController *picker;
    NSMutableDictionary *dicAddSellItem;
    UIButton *instance;
    UIButton *radioInstance;
     
    NSMutableArray *imageArray;
    NSString *stringDefaultPic;
  //  NSMutableDictionary *dicItemDetails;
    IBOutlet UIButton *btnImageCamera1;
    IBOutlet UIButton *btnImageCamera2;
    IBOutlet UIButton *btnImageCamera3;
    IBOutlet UIButton *btnSaveAndCont;

    
}

@property(retain,nonatomic)IBOutlet UIButton *btnEdit;
@property(retain,nonatomic)IBOutlet UITextField *txtProductTitle;
@property(retain,nonatomic)IBOutlet UIView *addPhotoView;
@property(retain,nonatomic)IBOutlet UIButton *addPhotoButton1;
@property (strong, nonatomic) IBOutlet UIImageView *overlay;
@property (strong, nonatomic) IBOutlet UIView *takePhotoView;
@property(retain,nonatomic)IBOutlet UIView *AddSellItemView;

@property(retain,nonatomic)IBOutlet UIImageView *imgCamera1;
@property(retain,nonatomic)IBOutlet UIImageView *imgCamera2;
@property(retain,nonatomic)IBOutlet UIImageView *imgCamera3;
@property(retain,nonatomic)IBOutlet UIImageView *imgBackCamera;


@property(retain,nonatomic) NSMutableDictionary *dicAddSellItem;
@property(retain,nonatomic) NSMutableDictionary *dicItemDetails;


-(IBAction)btnBackClicked:(id)sender;

-(IBAction)btnAddPhotoClicked:(id)sender;
-(IBAction)btnSaveClicked:(id)sender;

-(IBAction)btnTakePicClicked:(id)sender;
-(IBAction)btnChoosePicClicked:(id)sender;
-(IBAction)btnCancelClicked:(id)sender;


@end
