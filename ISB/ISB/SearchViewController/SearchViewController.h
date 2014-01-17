//
//  SearchViewController.h
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate>
{
    NSMutableArray *arrSearchItem;
    NSMutableArray *arrSearchItemCopy;

    NSMutableDictionary *dicSearchItemList;
    NSMutableDictionary *dicSearchItemImages;
    UITableView *tblSearchResult;
    NSManagedObjectContext *context;
    NSArray *searchResults;
    IBOutlet UIButton *btnClear;
}

@property(retain,nonatomic)NSManagedObjectContext *context;
@property(retain,nonatomic)IBOutlet UITextField *txtSearch;
@property(retain,nonatomic) IBOutlet UITableView *tblSearchResult;
@property(retain,nonatomic)IBOutlet UISearchBar *srchBar;

@property(retain,nonatomic) NSMutableArray *arrSearchItem;
@property(retain,nonatomic)NSMutableDictionary *dicSearchItemList;
@property(retain,nonatomic)NSMutableDictionary *dicSearchItemImages;
- (IBAction)btnNearBy:(UIButton *)sender;

-(IBAction)btnSearchCancelClicked:(id)sender;
@end
