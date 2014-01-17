//
//  MBGalleryViewController.m
//  ImageGallery
//
//  Created by Mobinius on 26/01/13.
//  Copyright (c) 2013 Mobinius. All rights reserved.
//

#import "ItemImageViewController.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"

@implementation ItemImageViewController
@synthesize galleryImages = galleryImages_;
@synthesize imageHostScrollView = imageHostScrollView_;
@synthesize currentIndex = currentIndex_;

@synthesize prevImage,strPicPath,strPicPath2,strPicPath3;
@synthesize nxtImage;

@synthesize counterTitle;

@synthesize prevImgView;
@synthesize centerImgView;
@synthesize nextImgView;


// this implementation does a negative safe modulo operation, to compensate for this
//    NSLog(@"MOD -1 m 5 = %d", -1 % 5); => -1
//    NSLog(@"MOD -7 m 5 = %d", -7 % 5); => -2
//    NSLog(@"MOD -7 m 5 = %d", (5 + (-7 % 5)) % 5); => 3
// see also http://stackoverflow.com/questions/989943/weird-objective-c-mod-behavior
#define safeModulo(x,y) ((y + x % y) % y)


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // setup the scrollview
    // the scrollview holds 3 uiimageviews in a row, to make nice swipe possible
    galleryImages_=[[NSMutableArray alloc]init];
    count=0;
    countImage=0;
    if ([self.strPicPath length]>1 && [self.strPicPath2 length]>1 &&[self.strPicPath3 length]>1 ) {
        count=3;
    }else if (([self.strPicPath length]>1 && [self.strPicPath2 length]>1 )|| ([self.strPicPath length]>1 && [self.strPicPath3 length]>1) || ([self.strPicPath2 length]>1 && [self.strPicPath3 length]>1)){
        count=2;
    }else
        count=1;
    
    
    if ( count==1) {
        prevImage.hidden=YES;
        nxtImage.hidden=YES;
        self.imageHostScrollView.scrollEnabled=NO;
    }
    
    
    switch (count) {
        case 1:
            if ([self.strPicPath length]>1)  {
                [self doFetchEditionImage:self.strPicPath withIndex:5001];
            }else if ([self.strPicPath2 length]>1)
            {
                [self doFetchEditionImage:self.strPicPath2 withIndex:5001];
            }else
                [self doFetchEditionImage:self.strPicPath3 withIndex:5001];
            break;
        case 2:
            
            if ([self.strPicPath length]>1 && [self.strPicPath2 length]>1)  {
                [self doFetchEditionImage:self.strPicPath withIndex:5001];
                [self doFetchEditionImage:self.strPicPath2 withIndex:5002];
                
            }else if ([self.strPicPath2 length]>1 && [self.strPicPath3 length]>1)
            {
                [self doFetchEditionImage:self.strPicPath2 withIndex:5001];
                [self doFetchEditionImage:self.strPicPath3 withIndex:5002];
            }else
            {
                [self doFetchEditionImage:self.strPicPath withIndex:5001];
                [self doFetchEditionImage:self.strPicPath3 withIndex:5002];
            }
            break;
        case 3:
            [self doFetchEditionImage:self.strPicPath withIndex:5001];
            [self doFetchEditionImage:self.strPicPath2 withIndex:5002];
            [self doFetchEditionImage:self.strPicPath3 withIndex:5003];
            
            break;
        default:
            break;
    }

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        
//        if ([self.strPicPath length]>1) {
//            NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: self.strPicPath]];
//        }
//        if ([self.strPicPath2 length]>1) {
//            NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: self.strPicPath]];
//        }
//        if ([self.strPicPath3 length]>1) {
//            NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: self.strPicPath]];
//        }
//        //            NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr1]];
//        //            NSData *imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr2]];
//        //            NSData *imageData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr3]];
//        
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//                       
//        });
//    });
    
    
}
-(void)initializeScroll
{
    self.imageHostScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame)*3, CGRectGetHeight(self.imageHostScrollView.frame));
    
    self.imageHostScrollView.delegate = self;
    
    CGRect rect = CGRectZero;
    
    rect.size = CGSizeMake(CGRectGetWidth(self.imageHostScrollView.frame), CGRectGetHeight(self.imageHostScrollView.frame));
    
    // add prevView as first in line
    UIImageView *prevView = [[UIImageView alloc] initWithFrame:rect];
    self.prevImgView = prevView;
    
    UIScrollView *scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    
    scrView.delegate = self;
    [scrView addSubview:self.prevImgView];
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    self.prevImgView.frame = scrView.bounds;
    
    // add currentView in the middle (center)
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *currentView = [[UIImageView alloc] initWithFrame:rect];
    self.centerImgView = currentView;
    //    [self.imageHostScrollView addSubview:self.centerImgView];
    
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    scrView.delegate = self;
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    [self.imageHostScrollView addSubview:scrView];
    
    [scrView addSubview:self.centerImgView];
    self.centerImgView.frame = scrView.bounds;
    
    // add nextView as third view
    rect.origin.x += CGRectGetWidth(self.imageHostScrollView.frame);
    UIImageView *nextView = [[UIImageView alloc] initWithFrame:rect];
    self.nextImgView = nextView;
    //    [self.imageHostScrollView addSubview:self.nextImgView];
    
    scrView = [[UIScrollView alloc] initWithFrame:rect];
    [self.imageHostScrollView addSubview:scrView];
    scrView.delegate = self;
    scrView.minimumZoomScale = 0.5;
    scrView.maximumZoomScale = 2.5;
    
    [scrView addSubview:self.nextImgView];
    self.nextImgView.frame = scrView.bounds;
    
    // center the scrollview to show the middle view only
    [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
    self.imageHostScrollView.userInteractionEnabled=YES;
    self.imageHostScrollView.pagingEnabled = YES;
    self.imageHostScrollView.delegate = self;
    
    self.prevImgView.contentMode = UIViewContentModeScaleAspectFit;
    prevImgView.tag=5001;
    
    self.centerImgView.contentMode = UIViewContentModeScaleAspectFit;
    centerImgView.tag=5002;
    
    self.nextImgView.contentMode = UIViewContentModeScaleAspectFit;
    nextImgView.tag=5003;
    
    
    //some data for testing
    //    self.galleryImages = [[NSMutableArray alloc] init];
    //    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"png"] atIndex:0];
    //    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"png"] atIndex:1];
    //    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"3" ofType:@"png"] atIndex:2];
    //    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"4" ofType:@"png"] atIndex:3];
    //    [self.galleryImages insertObject:[[NSBundle mainBundle] pathForResource:@"5" ofType:@"png"] atIndex:4];
    [HttpRequestProcessor shareHttpRequest];
    self.currentIndex = 0;
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    recognizer.numberOfTapsRequired = 2;
    recognizer.delegate = self;
    [self.imageHostScrollView addGestureRecognizer:recognizer];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];   
}

#pragma mark -navigation methods

- (IBAction)nextImage:(id)sender {
    [self setRelativeIndex:1];    
}

- (IBAction)prevImage:(id)sender {
   [self setRelativeIndex:-1];
    
//    NSLog(@"Action taken ");
}

#pragma mark - color button actions-    
 #pragma mark -page controller action-

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView;  {
    //incase we are zooming the center image view parent 
    if (self.centerImgView.superview == scrollView){
        return self.centerImgView;
    }
    
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIView *subView = [scrollView.subviews objectAtIndex:0];
    
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    
    subView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                 scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
//    CGFloat pageWidth = sender.frame.size.width;
//    pageNumber_ = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;{
    CGFloat pageWidth = scrollView.frame.size.width;
    previousPage_ = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;

}
- (IBAction)btnDone:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    int page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    //incase we are still in same page, ignore the swipe action
    if(previousPage_ == page) return;
    
    if(sender.contentOffset.x >= sender.frame.size.width) {   
        //swipe left, go to next image
        [self setRelativeIndex:1];
        
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
	}     
	else if(sender.contentOffset.x < sender.frame.size.width) { 
        //swipe right, go to previous image
        [self setRelativeIndex:-1];
        
        // center the scrollview to the center UIImageView
        [self.imageHostScrollView setContentOffset:CGPointMake(CGRectGetWidth(self.imageHostScrollView.frame), 0)  animated:NO];
	}     
    
    UIScrollView *scrollView = (UIScrollView *)self.centerImgView.superview;
    scrollView.zoomScale = 1.0;
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer {
    UIScrollView *scrollView = (UIScrollView*)self.centerImgView.superview;
    float scale = scrollView.zoomScale;
    scale += 1.0;
    if(scale > 2.0) scale = 1.0;
    [scrollView setZoomScale:scale animated:YES];
}

#pragma mark - image loading-

-(UIImage *)imageAtIndex:(NSInteger)inImageIndex;{
    // limit the input to the current number of images, using modulo math
    inImageIndex = safeModulo(inImageIndex, [self totalImages]);
    
//    NSString *filePath = [self.galleryImages objectAtIndex:inImageIndex];

	UIImage *image = nil;
   
     //Otherwise load from the file path
    if (nil == image)
    {
//		NSString *imagePath = filePath;
//		if(imagePath){
//			if([imagePath isAbsolutePath]){
				image =  image= [self.galleryImages objectAtIndex:inImageIndex];
//			}
//			else{
//				image = [UIImage imageNamed:imagePath];
//			}
        
//            if(nil == image){
//				image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imagePath]]];
//				
//			}
//        }
    }
    
	return image;
}

#pragma mark -

- (NSInteger)totalImages {
    return [self.galleryImages count];
}
- (NSInteger)currentIndex {
    
    return safeModulo(currentIndex_, [self totalImages]);
}

- (void)setCurrentIndex:(NSInteger)inIndex {
    currentIndex_ = inIndex;
    
    
    NSString *title = [NSString stringWithFormat:@"%d of %d",self.currentIndex+1,[self.galleryImages count]];
    self.counterTitle.text = title;
    
    if([galleryImages_ count] > 0){
        self.prevImgView.image   = [self imageAtIndex:[self relativeIndex:-1]];
        self.centerImgView.image = [self imageAtIndex:[self relativeIndex: 0]];
        self.nextImgView.image   = [self imageAtIndex:[self relativeIndex: 1]];
    }
}

- (NSInteger)relativeIndex:(NSInteger)inIndex {
    return safeModulo(([self currentIndex] + inIndex), [self totalImages]);
}

- (void)setRelativeIndex:(NSInteger)inIndex {
    [self setCurrentIndex:self.currentIndex + inIndex];
}
#pragma mark fetch images


-(void)doFetchEditionImage:(NSString *)inImageId withIndex:(NSInteger)index
{
    SHRequestSampleImage *aRequest = [[SHRequestSampleImage alloc] initWithURL: nil] ;
    [aRequest setImageId:inImageId];
    [aRequest SetResponseHandler:@selector(handledImage:) ];
    [aRequest SetErrorHandler:@selector(errorHandler:)];
    [aRequest SetResponseHandlerObj:self];
    [aRequest SetRequestType:eRequestType1];
    aRequest.index = index;
    
    [gHttpRequestProcessor ProcessImage: aRequest];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    //ß aRequest = nil;
}

-(void)errorHandler:(SHBaseRequestImage *)inRequest
{
    //  NSLog(@"*** errorHandler ***");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

//For scroll View

-(void)handledImage:(SHBaseRequestImage *)inRequest
{
    NSData *aImageData =  [inRequest GetResponseData];
    
    if (aImageData)
    {
//        NSLog(@"%d",inRequest.index);
       UIImage *img = [UIImage imageWithData: aImageData];
        //  NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
        
        
        if (img)
        {
            countImage++;
             [galleryImages_ addObject:img];
            if (count==countImage) {
                [self initializeScroll];
            }
           
            
//            UIImageView *imageV=(UIImageView *)[self.view viewWithTag:inRequest.index];
//            imageV.image = img;
//            UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[scrllForImage2 viewWithTag:inRequest.index+1000];
//            [indicator stopAnimating];
//            indicator.hidden=YES;
            
        }
        
        
        //
    }
    // [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}


@end
