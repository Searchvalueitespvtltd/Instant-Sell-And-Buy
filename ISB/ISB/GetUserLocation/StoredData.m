
#import "StoredData.h"

@implementation StoredData

@synthesize latitude;
@synthesize longitude;

static StoredData*	singleton;
+(StoredData*) sharedData
{
	if (!singleton) 
	{
		singleton = [[StoredData alloc] init];
	}
	return singleton;
}

#pragma mark init method
- (id)init 
{
	if (self = [super init]) 
	{
        latitude=[[NSString alloc]init];
        longitude=[[NSString alloc]init];
    }
	return self;
}

-(void) dealloc;
{    
	[super dealloc];
    [latitude release];
    [longitude release];
    
}

@end

