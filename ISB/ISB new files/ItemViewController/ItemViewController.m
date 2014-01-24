//
//  ItemViewController.m
//  ISB
//
//  Created by AppRoutes on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController
@synthesize scrollView,shareView,overlay;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
         [scrollView setScrollEnabled:YES];
    // Do any additional setup after loading the view from its nib.
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        self.scrollView.frame = CGRectMake(0, 60, 320, self.view.frame.size.height-44);
    }
    else
    {
        self.scrollView.frame = CGRectMake(0, 60, 320, self.view.frame.size.height-44);
    }
shareView.frame = CGRectMake(0, 1000, 320, 261);
  scrollView.contentSize = CGSizeMake(0, 800);
}
- (IBAction)BuyItmClick:(id)sender {
}
- (IBAction)contectSellerClick:(id)sender {
    [self.view bringSubviewToFront:self.shareView];
    [self setViewMovedUp:YES];
}
-(void)setViewMovedUp:(BOOL)isMovedUp{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // if you want to slide up the view
    scrollView.userInteractionEnabled=NO;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        shareView.frame = CGRectMake(0, 340, 320, 261);
    }
    else
    {
        shareView.frame = CGRectMake(0, 270, 320, 261);
    }
    
   
  self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"overlay.png"]];
  
//    CGRect rect = self.shareView.frame;
    
//    if (isMovedUp)
//    {
//        if (rect.origin.y==548 || rect.origin.y==460) {
//            
//            
//            //isKeyBoardDown = NO;
//            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
//            // 2. increase the size of the view so that the area behind the keyboard is covered up.
//            rect.origin.y -= 208;
//        }
//        //        rect.size.height += 150;
//    }
//    else
//    {
//        if (rect.origin.y==252 || rect.origin.y==340) {
//            // revert back to the normal state.
//            rect.origin.y += 208;
//            //        rect.size.height -= 150;
//            //isKeyBoardDown = YES;
//        }
//    }
//    self.shareView.frame = rect;
    [UIView commitAnimations];

}
- (IBAction)btnShareEvent:(id)sender {
    switch ([sender tag]) {
        case 1000:
            [self.view sendSubviewToBack:self.shareView];
            self.overlay.hidden=YES;
            [self setViewMovedUp:NO];
            
            break;
        case 1001:
            [self.view sendSubviewToBack:self.shareView];
            self.overlay.hidden=YES;
            [self setViewMovedUp:NO];
        case 1002:
//            [self actionEmailComposer:[NSArray arrayWithObject:@""] Message:[self.lblTeamsVsTeams.text stringByAppendingString:[NSString stringWithFormat:@"\n\n%@\nhttps://www.facebook.com/pages/My-Sports-Diary/344984742294419\n\nMy SportsDiary",self.lblEventDetails.text]] Subject:@"MySportsDiary"];
            [self.view sendSubviewToBack:self.shareView];
            self.overlay.hidden=YES;
            [self setViewMovedUp:NO];
            break;
        default:
            break;
    }
    
}
- (IBAction)cancelBtnClick:(id)sender {
    shareView.frame = CGRectMake(0, 1000, 320, 261);
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    scrollView.userInteractionEnabled=YES;
}
- (IBAction)searchClick:(id)sender {
}
- (IBAction)watchClick:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_searchBtn release];
    [_watchBtn release];
    [UIScrollView release];
    [_productImage release];
    [_productTitleLbl release];
    [_distanceLabel release];
    [_productDiscriptionTxtView release];
    [_itemLocationValueLbl release];
    [_itemLocationValueLbl release];
    [_PostageValueLbl release];
    [_itemCodeValueLbl release];
    [_buyItemBtn release];
    [_contectSellerBtn release];
    [super dealloc];
}
@end
