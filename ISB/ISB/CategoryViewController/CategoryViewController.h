//
//  CategoryViewController.h
//  ISB
//
//  Created by chetan shishodia on 26/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *arrItemCategory;
    NSManagedObjectContext *context;
}

@property(retain,nonatomic)IBOutlet UITableView *tblCategory;

@property(retain,nonatomic)NSMutableArray *arrItemCategory;

@property(retain,nonatomic)NSMutableDictionary *dicDetailItem;
-(IBAction)btnBackClicked:(id)sender;

@end
