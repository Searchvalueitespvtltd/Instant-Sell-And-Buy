//
//  MoreViewController.h
//  ISB
//
//  Created by AppRoutes on 19/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "OAuthLoginView.h"
@interface MoreViewController : UIViewController<MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate>
{
    NSString *messageNew;
    NSString *iTunesLink;
    NSString *pageLink;
    NSString *emailBody;
}
@property (retain, nonatomic) IBOutlet UITableView *moreTable;
@property (nonatomic,retain) NSDictionary *tableContents;
@property (nonatomic,retain) NSArray *sortedKeys;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
@end
