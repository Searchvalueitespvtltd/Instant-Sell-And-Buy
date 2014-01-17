//
//  MyISBViewController.h
//  ISB
//
//  Created by AppRoutes on 19/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemDetailsViewController.h"

@interface MyISBViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,UISearchDisplayDelegate,UIAlertViewDelegate>
{
double mDistance;
    int buttonTouched;
    NSString *strProductId;
    UIAlertView *alertDelete;
    int index;
    NSManagedObjectContext *context;
    IBOutlet UIButton *btnUserProfile;
    
}
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *btnBuying;
@property (retain, nonatomic) IBOutlet UITableView *tblproduct;
@property (retain, nonatomic) IBOutlet UIButton *btnWatching;
@property (retain, nonatomic) IBOutlet UIButton *btnEdit;
@property(retain,nonatomic) NSMutableArray *arrSearchItem;
@property(retain,nonatomic) NSMutableArray *arrSearchItemCopy;
@property(retain,nonatomic) NSMutableDictionary *dicSearchItemList;
@property(retain,nonatomic) NSMutableDictionary *dicSearchItemImages;

@property(retain,nonatomic) NSString *isBuying;

@end
