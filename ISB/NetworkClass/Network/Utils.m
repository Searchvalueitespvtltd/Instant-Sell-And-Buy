
#import "Utils.h"
#import "GSNSDataExtensions.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "Reachability.h"
#define MOVE_ANIMATION_DURATION_SECONDS_FOR_C1 .5


@implementation ImageOnNavigationBar
double latitude;
double longitude;
- (void) drawRect:(CGRect)rect
{
	UIImage *tabImage=[UIImage imageNamed:@"navBar.png"];
	[tabImage drawAtPoint:CGPointMake(0, 0)];
}
@end


@implementation Utils

@synthesize internetActive;
+(BOOL)isInternetAvailable
{
    BOOL isInternetAvailable = false;
    Reachability *internetReach = [Reachability reachabilityForInternetConnection];
    [internetReach startNotifier];
    NetworkStatus netStatus = [internetReach currentReachabilityStatus];
    switch (netStatus)
    {
        case NotReachable:
            isInternetAvailable = FALSE;
            break;
        case ReachableViaWWAN:
            isInternetAvailable = TRUE;
            break;
        case ReachableViaWiFi:
            isInternetAvailable = TRUE;
            break;
    }
    [internetReach  stopNotifier];
    return isInternetAvailable;
}

#pragma mark -
////----- show a alert massage
+ (void) showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate 
													cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate 
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
	[alert show];
	[alert release];

}
+(BOOL)isIPhone_5{
    
    //[[UIScreen mainScreen] bounds].size.height==568)?YES:NO
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height == 568)
        {
            return YES;
        }
    }
    return NO;
    
}
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate 
      cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:delegate 
										  cancelButtonTitle:CbtnTitle otherButtonTitles:otherBtnTitles, nil];
    alert.tag = tag;
	[alert show];
	[alert release];
}


#pragma mark UIButton

+ (UIButton *)newButtonWithTarget:(id)target  selector:(SEL)selector frame:(CGRect)frame
							image:(UIImage *)image
					selectedImage:(UIImage *)selectedImage
							  tag:(NSInteger)aTag
{	
	//UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
	[button setImage:image forState:UIControlStateNormal];
	[button setImage:selectedImage forState:UIControlStateSelected];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	button.showsTouchWhenHighlighted = YES;
    button.titleLabel.textAlignment=UITextAlignmentCenter;
	button.tag = aTag;
	return button;
}

+ (UIButton *)createButtonWithTarget:(id)target
                            selector:(SEL)selector
                               frame:(CGRect)frame
                         bgimageName:(NSString *)imageName
                                 tag:(NSInteger)aTag{
    UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	button.frame = frame;
	[button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	button.showsTouchWhenHighlighted = YES;
	button.tag = aTag;
	return [button autorelease];
}
+(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
#pragma mark textField
+(UITextField*) createTextFieldWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH placeHolder:(NSString*)aPl keyBoard:(BOOL)isNumber
{
	UITextField *aTextField=[[UITextField alloc] init];
	aTextField.frame = CGRectMake(aX,aY ,aW ,aH);
	aTextField.tag = aTag;
	aTextField.text = aPl;
	aTextField.backgroundColor=[UIColor clearColor];
	aTextField.textColor = [UIColor blackColor];
	aTextField.font = [UIFont fontWithName:@"Verdana" size:16];
	aTextField.borderStyle = UITextBorderStyleNone ;
	if (isNumber)
		aTextField.keyboardType = UIKeyboardTypeNumberPad;
	else
	  aTextField.keyboardType = UIKeyboardTypeDefault;
	aTextField.returnKeyType = UIReturnKeyDone;
	aTextField.contentVerticalAlignment = YES;
	//aTextField.text = aPl;
	aTextField.textAlignment = UITextAlignmentLeft;
    
    //===================
    aTextField.delegate=self;
    aTextField.adjustsFontSizeToFitWidth=YES;
	return [aTextField autorelease];
}
#pragma LoadMethod
-(void)loadProfileViewOnView:(UIScrollView*)settingScrollViewD withDic:(NSMutableDictionary*)dataDic{
    
}
-(void)loadNotificationViewOnView:(UIScrollView*)settingScrollViewD withDic:(NSMutableDictionary*)dataDic{
    
}

#pragma mark label
+(UILabel*) createNewLabelWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH text:(NSString*)aText noOfLines:(NSInteger)noOfLine
{
	UILabel *aLabel = [[UILabel alloc] init];
	aLabel.frame = CGRectMake(aX, aY, aW, aH);
	aLabel.text = aText;
	aLabel.tag = aTag;
	aLabel.font = [UIFont fontWithName:@"Verdana" size:(16.0)];
	aLabel.textColor = [UIColor blackColor];
	aLabel.backgroundColor = [UIColor clearColor];
	aLabel.adjustsFontSizeToFitWidth = YES;
	aLabel.numberOfLines = noOfLine;
	aLabel.textAlignment = UITextAlignmentLeft;
	return [aLabel autorelease];
}

+(UILabel*) createNewBLabelWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH text:(NSString*)aText noOfLines:(NSInteger)noOfLine
{
	UILabel *aLabel = [[UILabel alloc] init];
	aLabel.frame = CGRectMake(aX, aY, aW, aH);
	aLabel.text = aText;
	aLabel.tag = aTag;
	aLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:(16.0)];
	aLabel.textColor = [UIColor blackColor];
	aLabel.backgroundColor = [UIColor clearColor];
	aLabel.adjustsFontSizeToFitWidth = YES;
	aLabel.numberOfLines = noOfLine;
	aLabel.textAlignment = UITextAlignmentLeft;
	return [aLabel autorelease];
}


#pragma mark - Image Resize 
+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight
{
    CGImageRef imgRef = image.CGImage;
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
	
    if (width <= maxWidth && height <= maxHeight)
	{
		return image;
	}
	
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
	
    if (width > maxWidth || height > maxHeight)
	{
		CGFloat ratio = width/height;
		
		if (ratio > 1)
		{
			bounds.size.width = maxWidth;
			bounds.size.height = bounds.size.width / ratio;
		}
		else
		{
			bounds.size.height = maxHeight;
			bounds.size.width = bounds.size.height * ratio;
		}
	}
	
    CGFloat scaleRatio = bounds.size.width / width;
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, scaleRatio, -scaleRatio);
    CGContextTranslateCTM(context, 0, -height);
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef);
	
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	
    return imageCopy;
	
}

#pragma mark Image Conversion
+ (NSString*) stringFromImage:(UIImage*)image
{
	
	NSData* imageData = UIImagePNGRepresentation(image);
	
	//NSData *imageData = UIImageJPEGRepresentation(image, 1);
	
	NSString* str = [imageData base64EncodingWithLineLength:80];
	return str;
	
}

+ (UIImage*) imageFromString:(NSString*)imageString
{
	NSData* imageData = [NSData dataWithBase64EncodedString:imageString];
	return [UIImage imageWithData: imageData];
}

#pragma mark - Use it when pickup an image from imagepicker
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image 
{
	//int kMaxResolution = 320; 
	
	CGImageRef imgRef = image.CGImage; 
	
	CGFloat width = CGImageGetWidth(imgRef); 
	CGFloat height = CGImageGetHeight(imgRef); 
	
	CGAffineTransform transform = CGAffineTransformIdentity; 
	CGRect bounds = CGRectMake(0, 0, width, height); 
	/*if (width > kMaxResolution || height > kMaxResolution) 
	 { 
	 CGFloat ratio = width/height; 
	 if (ratio > 1)
	 { 
	 bounds.size.width = kMaxResolution; 
	 bounds.size.height = bounds.size.width / ratio; 
	 } 
	 else
	 { 
	 bounds.size.height = kMaxResolution; 
	 bounds.size.width = bounds.size.height * ratio; 
	 } 
	 } */
	
	CGFloat scaleRatio = bounds.size.width / width; 
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));  
	CGFloat boundHeight;                       
	UIImageOrientation orient = image.imageOrientation;                         
	switch(orient)
	{ 
		case UIImageOrientationUp: //EXIF = 1 
			transform = CGAffineTransformIdentity; 
			break;
			
		case UIImageOrientationUpMirrored: //EXIF = 2  
			transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0); 
			transform = CGAffineTransformScale(transform, -1.0, 1.0); 
			break; 
			
		case UIImageOrientationDown: //EXIF = 3 
			transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height); 
			transform = CGAffineTransformRotate(transform, M_PI); 
			break; 
			
		case UIImageOrientationDownMirrored: //EXIF = 4 
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.height); 
			transform = CGAffineTransformScale(transform, 1.0, -1.0); 
			break; 
			
		case UIImageOrientationLeftMirrored: //EXIF = 5 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width); 
			transform = CGAffineTransformScale(transform, -1.0, 1.0); 
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); 
			break; 
			
		case UIImageOrientationLeft: //EXIF = 6 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(0.0, imageSize.width); 
			transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0); 
			break; 
			
		case UIImageOrientationRightMirrored: //EXIF = 7 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeScale(-1.0, 1.0); 
			transform = CGAffineTransformRotate(transform, M_PI / 2.0); 
			break; 
			
		case UIImageOrientationRight: //EXIF = 8 
			boundHeight = bounds.size.height; 
			bounds.size.height = bounds.size.width; 
			bounds.size.width = boundHeight; 
			transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0); 
			transform = CGAffineTransformRotate(transform, M_PI / 2.0); 
			break; 
		default: 
			[NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"]; 
			break;
	} 
	
	UIGraphicsBeginImageContext(bounds.size); 
	
	CGContextRef context = UIGraphicsGetCurrentContext(); 
	
	if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft)
	{ 
		CGContextScaleCTM(context, -scaleRatio, scaleRatio); 
		CGContextTranslateCTM(context, -height, 0); 
	} 
	else
	{ 
		CGContextScaleCTM(context, scaleRatio, -scaleRatio); 
		CGContextTranslateCTM(context, 0, -height); 
	} 
	
	CGContextConcatCTM(context, transform); 
	
	CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imgRef); 
	UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext(); 
	UIGraphicsEndImageContext(); 
	
	return imageCopy;
	
}

//+ (void) addLabelOnNavigationBarWithTitle:(NSString*)aTitle OnNavigation:(UINavigationController*)naviController
//{
//    // Add Title on NavigationBar
//    UILabel *titleLabel = [[self createNewLabelWithTag:1 startX:0 startY:0 width:140 height:44 text:aTitle noOfLines:1] retain];
//    titleLabel.textAlignment = UITextAlignmentCenter;
//    titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:(20.0)];
//    naviController.navigationBar.topItem.titleView = titleLabel;
//    ReleaseObject(titleLabel);
//}



#pragma mark - Activity Indicator
+(void) startActivityIndicatorInView:(UIView*)aView withMessage:(NSString*)aMessage
{
    MBProgressHUD *_hud = [MBProgressHUD showHUDAddedTo:aView animated:YES];
    _hud.dimBackground  = YES;
    _hud.labelText      = aMessage;
}

+(void) stopActivityIndicatorInView:(UIView*)aView
{
    [MBProgressHUD hideHUDForView:aView animated:YES];
}
/////#pragma mark Image Conversion



#pragma mark - ImageView

+(UIImageView*) createImageViewWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH image:(NSString*)aImageName{
    UIImageView *aImgView = [[UIImageView alloc] init];
	aImgView.frame = CGRectMake(aX, aY, aW, aH);
	aImgView.tag = aTag;
    aImgView.image=[UIImage imageNamed:aImageName];
	return [aImgView autorelease];
}

#pragma mark - File Handling Methods

//---write content into a specified file path---

+(NSString *)USERID{
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0]; 
    
    NSString *filePath =[documentsDir stringByAppendingPathComponent:@"login.txt"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *array =
        [[NSArray alloc] initWithContentsOfFile: filePath];
        NSString *data =
        [NSString stringWithFormat:@"%@",
         [array objectAtIndex:0]]; 
        [array release];
        return data;
    }
    else
        return nil;

}
+(void) writeToFile:(NSString*)text{
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0]; 
    
    NSString *filePath =[documentsDir stringByAppendingPathComponent:@"data.txt"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:text];
    [array writeToFile:filePath atomically:YES];
    [array release];
}

+(void) writeToFile1:(NSString*)text{
    
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0]; 
    
    NSString *filePath =[documentsDir stringByAppendingPathComponent:@"licence.txt"];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:text];
    [array writeToFile:filePath atomically:YES];
    [array release];
}



+(void)writeToFile:(NSString *)fileName withString:(NSString*)str{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0]; 
    
    NSString *filePath =[documentsDir stringByAppendingPathComponent:fileName];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:str];
    [array writeToFile:filePath atomically:YES];
    [array release];
}

//---read content from a specified file path---

+(NSString *)readFromFile {
    //---check if file exists---
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0]; 
    
    NSString *filePath =[documentsDir stringByAppendingPathComponent:@"data.txt"];

    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *array =
        [[NSArray alloc] initWithContentsOfFile: filePath];
        NSString *data =
        [NSString stringWithFormat:@"%@",
         [array objectAtIndex:0]]; 
        [array release];
        return data;
    }
    else
        return nil;
}

+(NSString*)readFromFile:(NSString*)fileName{
    NSArray *paths =
    NSSearchPathForDirectoriesInDomains(
                                        NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0]; 
    
    NSString *filePath =[documentsDir stringByAppendingPathComponent:fileName];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSArray *array =
        [[NSArray alloc] initWithContentsOfFile: filePath];
        NSString *data =
        [NSString stringWithFormat:@"%@",
         [array objectAtIndex:0]]; 
        [array release];
        return data;
    }
    else
        return nil;
}

#pragma mark-Check Email Formate

+(BOOL)emailValidate:(NSString *)email
{

//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
//    return [emailTest evaluateWithObject:email];
    //Based on the string below
    //NSString *strEmailMatchstring=@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    
    //Quick return if @ Or . not in the string
    if([email rangeOfString:@"@"].location==NSNotFound || [email rangeOfString:@"."].location==NSNotFound)
       
        return YES;
    
    //Break email address into its components
    NSString *accountName=[email substringToIndex: [email rangeOfString:@"@"].location];
   // NSLog(@"%@",accountName);
    email=[email substringFromIndex:[email rangeOfString:@"@"].location+1];
   // NSLog(@"%@",email);
    //'.' not present in substring
    if([email rangeOfString:@"."].location==NSNotFound)
        return YES;
    NSString *domainName=[email substringToIndex:[email rangeOfString:@"."].location];
   // NSLog(@"%@",domainName);
    
    NSString *subDomain=[email substringFromIndex:[email rangeOfString:@"."].location+1];
   // NSLog(@"%@",subDomain);
    
    //username, domainname and subdomain name should not contain the following charters below
    //filter for user name
    NSString *unWantedInUName = @" ~!@#$^&*()={}[]|;':\"<>,?/`";
    //filter for domain
    NSString *unWantedInDomain = @" ~!@#$%^&*()={}[]|;':\"<>,+?/`";
    //filter for subdomain
    NSString *unWantedInSub = @" `~!@#$%^&*()={}[]:\";'<>,?/1234567890";
    
    //subdomain should not be less that 2 and not greater 6
    if(!(subDomain.length>=2 && subDomain.length<=6)) 
        return YES;
    
    if([accountName isEqualToString:@""] || [accountName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInUName]].location!=NSNotFound || [domainName isEqualToString:@""] || [domainName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInDomain]].location!=NSNotFound || [subDomain isEqualToString:@""] || [subDomain rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:unWantedInSub]].location!=NSNotFound)
        return YES;
    
    return NO;

}


#pragma mark-Network Method

+(BOOL) checkNetworkStatus
{
    Reachability *aReachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [aReachability currentReachabilityStatus];
    
    if (internetStatus == NotReachable)
    {
        return NO;
    }

    return YES;
    // called after network status changes
//    // if Device is not connected with internet	
//	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//	NetworkStatus internetStatus = [r currentReachabilityStatus];
//	if ((internetStatus != ReachableViaWiFi) && (internetStatus != ReachableViaWWAN))
//	{
//        self.internetActive=NO;
//		//[Utils showOKAlertWithTitle:@"Error" message:@"No Internet Connection Available"];
//	}else{
//        self.internetActive=YES;
//    }
//    /*
//    NetworkStatus internetStatus = [internetReachable currentReachabilityStatus];
//    switch (internetStatus)
//    {
//        case NotReachable:
//        {
//            NSLog(@"The internet is down.");
//            self.internetActive = NO;
//            
//            break;
//        }
//        case ReachableViaWiFi:
//        {
//            NSLog(@"The internet is working via WIFI.");
//            self.internetActive = YES;
//            
//            break;
//        }
//        case ReachableViaWWAN:
//        {
//            NSLog(@"The internet is working via WWAN.");
//            self.internetActive = YES;
//            
//            break;
//        }
//    }*/
//    return internetActive;
}

-(BOOL) checkNetworkStatus1{
    
    NSURL *url=[NSURL URLWithString:@"http://www.google.co.in/"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLConnection *connection=[NSURLConnection connectionWithRequest:request delegate:self];
    if(connection){
        self.internetActive=YES;
        
//        DLog(@"Connection is success");
    }else{
        self.internetActive=NO;
        
//        DLog(@"Connection is fail");
    }
    return self.internetActive;
}


+(NSString*)blankFromNULL:(NSString *)str{
    NSString *_str;
    if([str isEqualToString:@"NULL"]){
        _str=@"";
    }else{
        _str=str;
    }
    return _str;
}
#pragma mark -DATE FORMATTER
+(NSString*)formateDate:(NSString*)date oldFromate:(NSString*)oldFormate newFormate:(NSString*)newFormate
{
    NSString *_date;
_date=date;
NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
[dateFormat setDateFormat:oldFormate];
NSDate *nsdate = [dateFormat dateFromString:_date];
[dateFormat setDateFormat:newFormate];
_date = [dateFormat stringFromDate:nsdate]; 
    [dateFormat release];
return _date;

}

+ (NSDate*) dateFromString:(NSString*)aStr
{
	
	NSArray *array = [aStr componentsSeparatedByString:@" "];
    aStr = [array objectAtIndex:0];
    array = [aStr componentsSeparatedByString:@"-"];
    aStr=[NSString stringWithFormat:@"%@-%@-%@",[array objectAtIndex:2],[array objectAtIndex:0],[array objectAtIndex:1]];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss a"];
	//NSLog(@"%@", aStr);
    NSDate   *aDate = [dateFormatter dateFromString:aStr];
	return aDate;
}

+(void)SetLatitudeLongitude:(double)latUser :(double)longUser
{
	latitude=latUser;
	longitude=longUser;
	
}
+(double)GetLatitude
{
	return latitude;
}
+(double)GetLongitude
{
	return longitude;
}


+(BOOL)IsiPhone3G
{
	BOOL returnType=NO;
	size_t size;
	sysctlbyname("hw.machine", nil,&size, nil, 0);
	char *machine = malloc(size);
	sysctlbyname("hw.machine", machine,&size, nil, 0);
	NSString *platform = [NSString stringWithCString:machine encoding: NSUTF8StringEncoding];
	free(machine);
	
	if([platform  compare:@"iPhone1,2"] == NSOrderedSame)
	{
		returnType = YES;
	}
	if([platform  compare:@"iPhone2,1"] == NSOrderedSame)
	{
		returnType = YES;
	}
	return returnType;
}

+(BOOL)CheckInternetConnection:(char*)host_name
{
	BOOL _isDataSourceAvailable = NO;
    Boolean success;    
    //Creates a reachability reference to the specified 
    //network host or node name.
    SCNetworkReachabilityRef reachability = 
	SCNetworkReachabilityCreateWithName(NULL, host_name);
	
    //Determines if the specified network target is reachable 
    //using the current network configuration.
    SCNetworkReachabilityFlags flags;
	
    success = SCNetworkReachabilityGetFlags(reachability, &flags);
    _isDataSourceAvailable = success &&
	(flags & kSCNetworkFlagsReachable) &&
	!(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
	
    return _isDataSourceAvailable;
}


//+(NSString*)GetLatLong:(NSString*)zip
//{
//	//NSURL *url =[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=xml&oe=utf8&sensor=true_or_false&key=ABQIAAAAtPRVrSzcgi-1QDHfjA7RtxT-FyPSuXEFB16F17K6V-LEY6TDvBQiyvuBq5Brm0F1pHEmz0VakwsC3A",zip]];
//	NSURL *url =[ [NSURL alloc] initWithString:[NSString stringWithFormat:@"http://maps.google.com/maps/geo?output=xml&oe=utf8&sensor=true_or_false&q=%@&key=ABQIAAAAtPRVrSzcgi-1QDHfjA7RtxT-FyPSuXEFB16F17K6V-LEY6TDvBQiyvuBq5Brm0F1pHEmz0VakwsC3A",zip]];
//    
//	
//	NSMutableData *myMutableData;
//	myMutableData=[[NSMutableData data] retain]; 
//	myMutableData = [[NSMutableData alloc]initWithContentsOfURL:url];
//	NSError *parseError;
//
//	
//	return returnValue; 
//	
//}
//NSDateFormatter *format = [[NSDateFormatter alloc] init];
//[format setDateStyle:NSDateFormatterFullStyle];
//NSDate *now = date;
//[format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//NSString *nsstr = [format stringFromDate:now];
//return nsstr;
+(NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateStyle:NSDateFormatterFullStyle];
    NSDate *now = date;
//    [format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    NSString *nsstr = [format stringFromDate:now];
    return nsstr;
}
+(NSString *)timefromstring:(NSString *)string
{
    NSArray *array = [string componentsSeparatedByString:@":"];
    NSString *hour = [array objectAtIndex:0];
    BOOL isPM = NO;
    if([hour intValue]>12)
    {
        int h = ([hour intValue]-10)-2;
        hour = [NSString stringWithFormat:@"%d",h];
        isPM=YES;
    }
    if(isPM==YES)
    {
        string = [NSString stringWithFormat:@"%@:%@ PM",hour,[array objectAtIndex:1]];
    }
    else
    {
        string = [NSString stringWithFormat:@"%@:%@ AM",hour,[array objectAtIndex:1]];
    }
return string;
}
//NSDateFormatter *format = [[NSDateFormatter alloc] init];
//[format setDateFormat:@"HH:mm"];
//NSDate *now = date;
//[format setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//NSString *nsstr = [format stringFromDate:now];
//return nsstr;
+ (NSString *)stringWithInterval:(NSTimeInterval)interval {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyy-MM-dd hh:mm:ss.SSS"];
    NSString *string = [formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:interval]];
    [formatter release];
    return string;
}



#pragma mark - Randon number generator function


+ (int)getRandomNumberBetween:(int)from to:(int)to
{
    
    return (int)from + arc4random() % (to-from+1);
}
@end
