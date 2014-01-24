
//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/WS Classes/Config.h $
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

#import <Foundation/Foundation.h>

@interface Config : NSObject
{

}

+ (Config*)shared;

@property( nonatomic, readonly ) NSString*	MediaUrl;
@property( nonatomic, readonly ) NSString*	BaseUrl;
@property( nonatomic, readonly ) NSString*	LoginApp;
@property( nonatomic, readonly ) NSString*	RegisterDeviceApp;
@property( nonatomic, readonly ) NSString*	FetchDashBoardListApp;

@end
