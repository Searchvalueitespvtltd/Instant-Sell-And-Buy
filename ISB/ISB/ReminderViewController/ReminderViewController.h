//
//  ReminderViewController.h
//  ISB
//
//  Created by AppRoutes on 12/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReminderViewController : UIViewController
{

    NSMutableArray *section0Array;
    NSMutableArray  *section1Array;
    NSMutableArray *section2Array;
}

@property (retain, nonatomic) IBOutlet UITableView *tblReminderList;
- (IBAction)btnNotificationsClick:(id)sender;
- (IBAction)btnBackClick:(id)sender;

@end
