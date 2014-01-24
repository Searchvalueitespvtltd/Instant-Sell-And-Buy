//
//  AboutViewController.h
//  ISB
//
//  Created by AppRoutes on 19/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
    IBOutlet UITextView *txtViewAbout;
    IBOutlet UILabel *lblGoToLink;
}
- (IBAction)backBtn:(id)sender;

-(IBAction)btnGOTOClicked:(id)sender;

@end
