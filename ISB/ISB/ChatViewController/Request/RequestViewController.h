//
//  RequestViewController.h
//  ISB
//
//  Created by Neha Saxena on 16/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMPPPrivacy.h"

@interface RequestViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, XMPPPrivacyDelegate>
{
    UITableView		*tView;
    NSMutableArray	*userNames;
    
    NSInteger   blockUserIndex;
    
    XMPPPrivacy*    xmppprivacy;
    
    UIButton*   blockBtn;
    
    NSMutableArray* PreviousBlockList;
    NSMutableArray* PreviousRejectList;
}
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic,retain) IBOutlet NSMutableArray	*userNames;
- (IBAction) closeChat;

@end
