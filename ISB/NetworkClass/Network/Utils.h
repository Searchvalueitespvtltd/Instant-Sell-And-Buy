
#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
@class AppDelegate;

@interface ImageOnNavigationBar : UINavigationBar 
{
	
}

@end


@interface Utils : NSObject 
{
   Reachability* internetReachable;
    AppDelegate *appDelegate;
}


@property(assign,nonatomic)BOOL internetActive;
+(BOOL)isInternetAvailable;
+(NSString*)formateDate:(NSString*)date oldFromate:(NSString*)oldFormate newFormate:(NSString*)newFormate;
+(BOOL) checkNetworkStatus;
-(BOOL) checkNetworkStatus1;
+(NSString*)blankFromNULL:(NSString*)str;
//===============NewProjectMethods==========
+(BOOL)IsiPhone3G;
+(BOOL)isIPhone_5;
+(void)SetLatitudeLongitude:(double)latUser :(double)longUser;
+(double)GetLatitude;
+(double)GetLongitude;
+(BOOL)CheckInternetConnection:(char*)host_name;
+(NSString*)GetLatLong:(NSString*)zip;
//=======================================
+ (void) showAlertView :(NSString*)title message:(NSString*)msg delegate:(id)delegate cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;
+ (void) showAlertViewWithTag:(NSInteger)tag title:(NSString*)title message:(NSString*)msg delegate:(id)delegate 
			cancelButtonTitle:(NSString*)CbtnTitle otherButtonTitles:(NSString*)otherBtnTitles;

+ (UIButton *)newButtonWithTarget:(id)target
						 selector:(SEL)selector
							frame:(CGRect)frame
							image:(UIImage *)image
					selectedImage:(UIImage *)selectedImage
							  tag:(NSInteger)aTag;
+(UITextField*) createTextFieldWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH placeHolder:(NSString*)aPl keyBoard:(BOOL)isNumber;
+(UILabel*) createNewLabelWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH text:(NSString*)aText noOfLines:(NSInteger)noOfLine;

+ (UIImage *)scaleImage:(UIImage *)image maxWidth:(int) maxWidth maxHeight:(int) maxHeight;
+ (NSString*) stringFromImage:(UIImage*)image;
+ (UIImage*) imageFromString:(NSString*)imageString;
+ (UIImage *)generatePhotoThumbnail:(UIImage *)image ;
//+ (void) addLabelOnNavigationBarWithTitle:(NSString*)aTitle OnNavigation:(UINavigationController*)naviController;

+(BOOL)emailValidate:(NSString *)email;

// -----------------------------------------------------------------------------------------------


+(NSString *)USERID;
+(NSString *)readFromFile;

+(NSString*)readFromFile:(NSString*)fileName;

+(void)writeToFile:(NSString *)text;

+(void) writeToFile1:(NSString*)text;

+(void)writeToFile:(NSString *)fileName withString:(NSString*)str;

-(void)loadProfileViewOnView:(UIScrollView*)settingScrollViewD withDic:(NSMutableDictionary*)dataDic;
-(void)loadNotificationViewOnView:(UIScrollView*)settingScrollViewD withDic:(NSMutableDictionary*)dataDic;

+(UILabel*) createNewBLabelWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH text:(NSString*)aText noOfLines:(NSInteger)noOfLine;
+(UIImageView*) createImageViewWithTag:(NSInteger)aTag startX:(CGFloat)aX startY:(CGFloat)aY width:(CGFloat)aW height:(CGFloat)aH image:(NSString*)aText;
+ (UIButton *)createButtonWithTarget:(id)target
						 selector:(SEL)selector
							frame:(CGRect)frame
							bgimageName:(NSString *)imageName
												  tag:(NSInteger)aTag;

//-----------------------------------------------------------------------------------------------
+(void) startActivityIndicatorInView:(UIView*)aView withMessage:(NSString*)aMessage;
+(void) stopActivityIndicatorInView:(UIView*)aView;
+ (NSDate*) dateFromString:(NSString*)aStr;
+ (NSString *)stringFromDate:(NSDate*)date;
+(NSString *)timefromstring:(NSString *)string;
+ (NSString *)stringWithInterval:(NSTimeInterval)interval;
//-----------------------------------------------------------------------------------
+(UIColor*)colorWithHexString:(NSString*)hex;


//-------------------------------------------------------------------------------------
+ (int) getRandomNumberBetween:(int)from to:(int)to;

@end




