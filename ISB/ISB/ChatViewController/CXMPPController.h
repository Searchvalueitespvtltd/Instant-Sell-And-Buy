//
//  CXMPPController.h
//  iPhoneXMPP
//
//  Created by AppRoutes on 19/03/13.
//
//

#ifndef __CXMPPController_H__
#define __CXMPPController_H__

#pragma once

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SMChatDelegate.h"
#import "SMMessageDelegate.h"
#import "XMPPFramework.h"
#import "XMPPRoster.h"
#import "XMPPReconnect.h"
#import "XMPPRosterCoreDataStorage.h"
#import "XMPPvCardCoreDataStorage.h"
#import "XMPPCapabilities.h"
#import "XMPPCapabilitiesCoreDataStorage.h"
#import "XMPPMessageArchivingCoreDataStorage.h"
#import "XMPPMessageArchiving.h"

@interface CXMPPController : NSObject <XMPPRosterDelegate>
{
    XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPvCardCoreDataStorage *xmppvCardStorage;
	XMPPvCardTempModule *xmppvCardTempModule;
	XMPPvCardAvatarModule *xmppvCardAvatarModule;
	XMPPCapabilities *xmppCapabilities;
	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
    XMPPMessageArchiving *xmppMessageArchivingModule;
    XMPPMessageArchivingCoreDataStorage *xmppMessageArchivingStorage;
    
	NSString *password;
	
	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;
	
	BOOL isXmppConnected;
    __weak NSObject <SMChatDelegate> *_chatDelegate;
	__weak NSObject <SMMessageDelegate> *_messageDelegate;

}
+(void)sharedXMPPController;


@property (nonatomic, readonly) NSManagedObjectContext *messagesStoreMainThreadManagedObjectContext;
@property (nonatomic, assign) id  _chatDelegate;
@property (nonatomic, retain) id  _messageDelegate;
@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;
- (NSManagedObjectContext *)managedObjectContext_roster;
- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;
@end
extern CXMPPController* gCXMPPController;

#endif //__CXMPPController_H__
