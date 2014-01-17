//
//  AddPayPalViewController.h
//  ISB
//
//  Created by Pankaj on 10/29/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddPayPalViewController : UIViewController{
    NSManagedObjectContext *context;
}
@property (retain, nonatomic) IBOutlet UITextField *txtPaypal;
- (IBAction)btnBack:(id)sender;

- (IBAction)btnSubmit:(id)sender;
@end
