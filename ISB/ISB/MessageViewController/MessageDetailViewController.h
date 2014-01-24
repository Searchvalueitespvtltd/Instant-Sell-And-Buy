//
//  MessageDetailViewController.h
//  ISB
//
//  Created by chetan shishodia on 22/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MessageTextView.h"

@interface MessageDetailViewController : UIViewController <UIWebViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITextViewDelegate>
{
    IBOutlet UILabel *lblViewHeading, *lblDate, *lblSenderName, *lblSubject;
    IBOutlet UIWebView *webviewMessageDetail;
    NSArray *arrDetailMessage;
    NSString *strTotalMessages;
    NSInteger filteredIndexes;
    IBOutlet UITextView *txtviewDetail;
    int selectedMsgRow;
    
    IBOutlet UIButton *btnPrev, *btnNext;
    
    int index;

}
@property (retain, nonatomic) IBOutlet UIImageView *overlayImage;
@property(retain,nonatomic) NSString *strMsgId, *strSelectedMsgRow;
@property(retain,nonatomic) NSMutableArray *arrTotalMessageCount;

@property(retain,nonatomic)IBOutlet UILabel *lblViewHeading, *lblDate, *lblSenderName, *lblSubject;
@property(retain,nonatomic) IBOutlet UITextView *txtviewDetail;

@property (retain, nonatomic) IBOutlet UIView *sendMessageView;
@property (retain, nonatomic) IBOutlet MessageTextView *sentTextView;
@property (strong, nonatomic) IBOutlet UILabel *countLableValue;

@property (retain, nonatomic) IBOutlet UIButton *btnReply;
@property (retain, nonatomic) IBOutlet UIButton *btnTrash;

@property (nonatomic) int messageType;


-(IBAction)btnBackClicked:(id)sender;
-(IBAction)btnDeleteClicked:(id)sender;
-(IBAction)btnReplyClicked:(id)sender;

-(IBAction)btnPrevClicked:(id)sender;
-(IBAction)btnNextClicked:(id)sender;
- (IBAction)cancelSendMessage:(id)sender;

- (IBAction)sendMessage:(id)sender;


@end
