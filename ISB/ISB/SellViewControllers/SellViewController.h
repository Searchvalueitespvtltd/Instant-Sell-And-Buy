//
//  SellViewController.h
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSellItemViewController.h"

@interface SellViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *arrSearchItem;
    NSMutableArray *arrItemList;
    NSMutableDictionary *dicitemList;
    UITableView *tblItemList;
    NSMutableDictionary *dicItemImages;
    NSManagedObjectContext *context;
    int sellItemCount;
    IBOutlet UIButton *btnUserProfile;
    UIAlertView *alertDelete;
    int index;

}

@property(retain,nonatomic)IBOutlet UITextField * txtSearch;
@property(retain,nonatomic)IBOutlet UIButton *btnAddItem;
@property(retain,nonatomic) NSMutableArray *arrItemList;
@property(retain,nonatomic) NSMutableDictionary *dicitemList;
@property(retain,nonatomic) IBOutlet UITableView *tblItemList;

@property(retain,nonatomic)IBOutlet UISearchBar *srchBar;

@property(retain,nonatomic) NSMutableArray *arrSearchItem;
@property(retain,nonatomic) NSMutableArray *arrSearchItemCopy;




-(IBAction)btnUserProfileClicked:(id)sender;
-(IBAction)btnSearchCancelClicked:(id)sender;
-(IBAction)btnAddItemClicked:(id)sender;


@end
