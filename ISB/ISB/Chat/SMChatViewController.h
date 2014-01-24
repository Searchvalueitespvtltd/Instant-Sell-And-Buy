//
//  SMChatViewController.h
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RootViewController.h"
#import "XMPP.h"
#import "TURNSocket.h"
#import "SMMessageViewTableCell.h"
#import "SMMessageDelegate.h"
#import "XMPPRoom.h"
@interface SMChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, SMMessageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate> {

	UITextField		*messageField;
	NSString		*chatWithUser;
	UITableView		*tView;
	NSMutableArray	*messages;
	NSMutableArray *turnSockets;
        UIImagePickerController * picker;
 //   XMPPRoom *xmppRoom;
     XMPPRoom *room;
    BOOL isMovedUp;
    BOOL isKeyBoard;
	
}
@property (weak, nonatomic) IBOutlet UIView *viewMessage;

@property (nonatomic,retain) IBOutlet UITextField *messageField;
@property (nonatomic,retain) NSString *chatWithUser;
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) NSString *imageString;
@property(assign) BOOL isRoom;

- (id) initWithUser:(NSString *) userName;
- (IBAction) sendMessage;
- (IBAction) closeChat;

@end
