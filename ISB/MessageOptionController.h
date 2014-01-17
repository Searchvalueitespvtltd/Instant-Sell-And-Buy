//
//  MessageOptionController.h
//  ISB
//
//  Created by Pankaj on 9/13/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageOptionController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray *Option;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) int index;

- (IBAction)btnBack:(id)sender;

@end
