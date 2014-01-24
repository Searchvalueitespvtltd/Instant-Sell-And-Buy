//
//  SelectCategoryViewController.h
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrCategory;
    NSMutableDictionary *dicSelectCategory;
     NSMutableDictionary *dicEditItemDetail;
   NSString *category_id;
}

@property(retain,nonatomic)IBOutlet UITableView *tblSelectCategory;
@property(retain,nonatomic) NSMutableArray *arrCategory;
@property(retain,nonatomic) NSMutableDictionary *dicSelectCategory;
@property(retain,nonatomic) NSString *idCategory;
@property(retain,nonatomic)IBOutlet UIButton *btnDone;



-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnAddClicked:(id)sender;
-(IBAction)btnDoneClicked:(id)sender;

@end
