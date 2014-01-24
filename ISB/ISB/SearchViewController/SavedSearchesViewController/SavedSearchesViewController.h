//
//  SavedSearchesViewController.h
//  ISB
//
//  Created by chetan shishodia on 17/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedSearchesViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate, UIAlertViewDelegate>
{
    IBOutlet UITableView *tblSavedSearchList;
    NSManagedObjectContext *context;
    NSMutableArray *arrSavedData;
    IBOutlet UIButton *btnEdit;
    NSString *strCatId;
    NSString *strSearchName;
    UIAlertView *alertNoData;
//    int index;
}


-(IBAction)btnBackClicked:(id)sender;

-(IBAction)btnAddORDeleteRowsClicked:(id)sender;

@end
