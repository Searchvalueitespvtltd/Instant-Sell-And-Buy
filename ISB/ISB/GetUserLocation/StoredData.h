
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface StoredData : NSObject
{
    NSString *latitude;
    NSString *longitude;
}
        
+ (StoredData*) sharedData;

@property (nonatomic,retain) NSString *latitude;
@property (nonatomic,retain) NSString *longitude;
@property (nonatomic,retain) CLLocation *currLocation;


@end;
