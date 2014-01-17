//
//  NotificationsViewController.h
//  ISB
//
//  Created by AppRoutes on 12/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationsViewController : UIViewController
{
    IBOutlet UIButton *btnEdit;
}

@property (retain, nonatomic)NSMutableArray *arrayNotifications;
@property (retain, nonatomic) IBOutlet UITableView *tblNotificationList;
- (IBAction)btnBackClick:(id)sender;

@end
