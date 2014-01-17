//
//  SHRequestSampleList.h
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHBaseRequestImage.h"

@interface SHRequestSampleList : SHBaseRequestImage
{
    NSString *mEditionId;
}
@property(retain,nonatomic)NSString *EditionId;
@end
