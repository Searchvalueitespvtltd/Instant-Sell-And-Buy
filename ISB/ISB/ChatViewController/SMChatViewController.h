//
//  SMChatViewController.h
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "RootViewController.h"
#import "XMPP.h"
#import "TURNSocket.h"
#import "SMMessageViewTableCell.h"
#import "SMMessageDelegate.h"
#import "XMPPRoom.h"
@interface SMChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,SMMessageDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIAlertViewDelegate> {

//@interface SMChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UITextFieldDelegate> {
    NSManagedObjectContext *context;

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
    
    UIImage *myImage;
    UIImage *userImageN;
    
    
    //added by pankaj
    UIView *whiteView;
}
@property (weak, nonatomic) IBOutlet UIView *viewMessage;
@property (nonatomic, retain) UIImage *img;
@property (nonatomic,retain) IBOutlet UITextField *messageField;
@property (nonatomic,retain) NSString *chatWithUser;
@property (nonatomic,retain) IBOutlet UITableView *tView;
@property (nonatomic, retain) NSString *imageString;
@property (assign) BOOL isFromHome;

@property(assign) BOOL isRoom;

@property(assign) BOOL isFromItemView;

@property (nonatomic, retain) NSString *pic_path;

@property (nonatomic, retain) UIImage *imageU;


@property (nonatomic, retain) NSString *strUsername;
@property (retain, nonatomic) IBOutlet UILabel *labelRequestMessage;
@property (retain, nonatomic) IBOutlet UIView *requestView;


- (id) initWithUser:(NSString *) userName;
- (IBAction) sendMessage;
- (IBAction) closeChat;

@end
