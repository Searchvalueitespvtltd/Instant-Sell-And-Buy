//
//  HomeAppliancesViewController.h
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeAppliancesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate>
{
    NSMutableArray *arrSearchItem;
    NSMutableArray *arrSaveItem;
    NSMutableDictionary *dicSearchItemList;
    double mDistance;
    NSMutableDictionary *dicSearchItemImages;
    UITableView *tblSearchResult;
    UISearchBar *searchBar;
    IBOutlet UIButton *btnSaveSearch;
    
    NSManagedObjectContext *context;
    NSMutableArray *arrSaveData;
    
    bool isFromSavedSearch;
    
}

@property(retain,nonatomic)IBOutlet UITextField *txtSearch;
@property(retain,nonatomic)IBOutlet UITableView *tblSearchResult;

@property(retain,nonatomic)IBOutlet UISearchBar *srchBar;

@property(retain,nonatomic) NSMutableArray *arrSearchItem;
@property(retain,nonatomic) NSMutableArray *arrSearchItemCopy;
@property(retain,nonatomic) NSMutableArray *arrSaveItem;
//@property(retain,nonatomic) NSMutableDictionary *dicSearchItemList;
@property(retain,nonatomic) NSMutableDictionary *dicSearchItemImages;

@property(retain,nonatomic) NSMutableString * strCategoryID;
@property(retain,nonatomic)NSMutableString * strViewTitle;
@property(retain,nonatomic)NSMutableString *strViewHeading;
@property(retain,nonatomic)NSString *strHeading;

@property(retain,nonatomic) IBOutlet UILabel *lblViewTitle;
@property(assign,nonatomic) bool isFromSavedSearch;
@property(assign,nonatomic) BOOL isFromNearBy;
@property(retain,nonatomic) NSString * longg;
@property(retain,nonatomic) NSString *latt;

-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnFavClicked:(id)sender;
-(IBAction)btnSearchCancelClicked:(id)sender;


@end
