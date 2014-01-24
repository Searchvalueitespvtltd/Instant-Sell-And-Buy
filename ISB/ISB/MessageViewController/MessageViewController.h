//
//  MessageViewController.h
//  ISB
//
//  Created by AppRoutes on 28/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageViewController : UIViewController <UISearchBarDelegate,UISearchDisplayDelegate>
{
    NSMutableArray *arrMessageList,*arrMessageListCopy;
    IBOutlet UIButton *btnEdit;
    NSMutableArray * arrMessageId;
    int numberOfDays;
    int index;
    int DeleteIndex;
//    NSString *strSelectedRow;
}
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) IBOutlet UIButton *editBtn;
@property (retain, nonatomic) IBOutlet UIButton *cancelBtn;
@property (retain, nonatomic) IBOutlet UITableView *messageTableView;
@property ( nonatomic) int messageType;


-(IBAction)btnAddORDeleteRowsClicked:(id)sender;
-(IBAction)btnBackClicked:(id)sender;


@end
