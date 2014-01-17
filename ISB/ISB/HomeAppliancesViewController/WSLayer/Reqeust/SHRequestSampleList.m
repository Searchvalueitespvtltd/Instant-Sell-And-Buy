//
//  SHRequestSampleList.m
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SHRequestSampleList.h"

@implementation SHRequestSampleList

@synthesize EditionId = mEditionId;

-(id)initWithURL:(NSURL *)URL
{
    self = [super initWithURL:URL];
    if (self)
    {
        mEditionId = nil;
               
    }
    return self;
}

-(void)dealloc
{
  //  ReleaseStrongObject(mEditionId);
    [super dealloc];
}

@end
