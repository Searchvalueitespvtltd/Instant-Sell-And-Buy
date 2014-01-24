//
//  PostLinkedInViewC.h
//  ISB
//
//  Created by AppRoutes on 23/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthLoginView.h"
@interface PostLinkedInViewC : UIViewController
@property (retain, nonatomic) IBOutlet UITextView *txtVw;
@property (nonatomic, retain) OAuthLoginView *oAuthLoginView;
- (IBAction)btnPost:(id)sender;
- (IBAction)btnStopEditing:(id)sender;
- (IBAction)btnBack:(id)sender;

@end
