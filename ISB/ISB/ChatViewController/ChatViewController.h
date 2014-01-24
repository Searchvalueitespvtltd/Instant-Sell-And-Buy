//
//  ChatViewController.h
//  ISB
//
//  Created by Neha Saxena on 26/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"
#import "TURNSocket.h"
#import "SMMessageDelegate.h"

@interface ChatViewController : UIViewController<UITableViewDelegate, UITableViewDataSource,SMMessageDelegate>
{
    UITableView		*tView;
	NSMutableArray *turnSockets;
    NSMutableArray	*messages;
    NSMutableArray	*userNames;
    NSMutableArray	*responseArray;
     NSMutableArray	*imageArray;
    
    NSMutableArray* blockList;
    NSMutableArray* rejectedList;
    NSMutableArray* activeJabberIdList;
    NSMutableArray* previousBlockList;
    NSMutableArray* previousRejectedList;
    NSMutableArray* activeLocalList;
    NSMutableDictionary*    blockUserImageList;
    NSMutableDictionary*    rejectedUserImageList;
    NSMutableDictionary*    newActiveUserImageList;

}
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic,retain) IBOutlet UIButton *btnRequest;
- (IBAction) closeChat;
- (IBAction)btnPendingRequest:(id)sender;
@end
