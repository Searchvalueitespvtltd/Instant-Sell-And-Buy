//
//  MBGalleryViewController.h
//  ImageGallery
//
//  Created by Mobinius on 26/01/13.
//  Copyright (c) 2013 Mobinius. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemImageViewController : UIViewController<UIActionSheetDelegate,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    int count;
    int countImage;
@private
    NSMutableArray *galleryImages_;
    NSInteger currentIndex_;
    NSInteger previousPage_;
}
@property (nonatomic,retain)NSString *strPicPath2;
@property (nonatomic,retain)NSString *strPicPath3;
@property (nonatomic,retain)NSString *strPicPath;
@property (nonatomic, retain)  UIImageView *prevImgView; //reusable Imageview  - always contains the previous image
@property (nonatomic, retain)  UIImageView *centerImgView; //reusable Imageview  - always contains the currently shown image
@property (nonatomic, retain)  UIImageView *nextImgView; //reusable Imageview  - always contains the next image image

@property(nonatomic, retain)NSMutableArray *galleryImages; //Array holding the image file paths
@property(nonatomic, retain)IBOutlet UIScrollView *imageHostScrollView; //UIScrollview to hold the images

@property (retain, nonatomic) IBOutlet UIButton *prevImage;
@property (retain, nonatomic) IBOutlet UIButton *nxtImage;

@property (retain, nonatomic) IBOutlet UILabel *counterTitle;//A label to update the title with the count of the image

@property (nonatomic, assign) NSInteger currentIndex;

//navigation buttons methood...
- (IBAction)nextImage:(id)sender;
- (IBAction)prevImage:(id)sender;
- (IBAction)btnDone:(id)sender;

-(void)setCounterTitle:(UILabel *)counterTitle;

#pragma mark - image loading-
//Simple method to load the UIImage, which can be extensible - 
-(UIImage *)imageAtIndex:(NSInteger)inImageIndex;

@end
