
//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/WS Classes/Config.m $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Shakir Husain
//	Created: 08-Feb-2013
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================
#import "Config.h"

@implementation Config

+ (Config *) shared {
	static Config *_singleton = nil;
	@synchronized(self) {
		if (_singleton == nil) {
			_singleton = [[Config alloc] init];
		}
	}
	return _singleton;
}

-(NSString*) BaseUrl
{
    return @"http://autovisie.area5.nl/";
}

-(NSString*) MediaUrl // For image with image id 
{
   return @"http://";
}

-(NSString*) LoginApp
{
    return @"applications/8u08t7rmpm";
}

-(NSString*) RegisterDeviceApp
{
    return @"applications/vme4dyi5e6";
}

-(NSString*) FetchDashBoardListApp
{
   return @"applications/tckoc9pf5o";
}
@end
