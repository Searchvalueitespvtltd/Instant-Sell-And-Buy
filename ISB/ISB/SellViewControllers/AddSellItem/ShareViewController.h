//
//  ShareViewController.h
//  ISB
//
//  Created by AppRoutes on 23/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
#import "ItemDetails.h"
#import "Defines.h"
@interface ShareViewController : UIViewController
@property (strong, retain) NSString *message;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSMutableDictionary *dicShared;
- (IBAction)btnFacebook:(id)sender;
- (IBAction)btnTwitter:(id)sender;
- (IBAction)btnLinkedIn:(id)sender;
- (IBAction)btnDone:(id)sender;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;


@end
