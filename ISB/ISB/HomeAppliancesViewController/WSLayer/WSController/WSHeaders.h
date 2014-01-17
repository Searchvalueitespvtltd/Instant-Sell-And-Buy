//
//  WSHeaders.h
//  NSConnectionTest
//
//  Created by Shakir on 01/03/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//


// Add All Request here

#import "SHBaseRequestImage.h" //Base Class

#import "SHRequestSampleList.h"
#import "SHRequestSampleImage.h"

#import "HttpRequestProcessor.h"
// Web Configuretion

#import "Config.h"

#define ReleaseStrongObject(Object)if(Object){[Object release];Object = nil;}

#define ReleaseWeakObject(Object)if(Object){Object = nil;}
#define SetNilToClassObject(ClassObject)ClassObject = nil;



