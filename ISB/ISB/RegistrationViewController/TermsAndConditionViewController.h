//
//  TermsAndConditionViewController.h
//  ISB
//
//  Created by chetan shishodia on 16/08/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface TermsAndConditionViewController : UIViewController<MFMailComposeViewControllerDelegate>
{
    IBOutlet UIWebView *webviewTerms;
}


-(IBAction)btnBackClicked:(id)sender;

@end
