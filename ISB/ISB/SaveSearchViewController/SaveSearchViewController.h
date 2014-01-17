//
//  SaveSearchViewController.h
//  ISB
//
//  Created by AppRoutes on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveSearchViewController : UIViewController <UIAlertViewDelegate>
{
    NSManagedObjectContext *context;
    NSMutableArray *arrDelData;
    UIAlertView *alertNameReplaced, *alertSearchSaved;
}

@property (retain, nonatomic) IBOutlet UITextField *searchTxtField;

@property(retain,nonatomic) NSString *strCategoryId;
@property(retain,nonatomic) NSString *strCategoryName;
@property(retain,nonatomic) NSString *strIsNotify;

@property(retain,nonatomic)IBOutlet UISwitch *switchIsNotify;



-(IBAction)btnCancelClicked:(id)sender;
-(IBAction)btnSaveClicked:(id)sender;
-(IBAction)switchIsNotifyClicked:(id)sender;



@end
