//
//  SHRequestSampleImage.m
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "SHRequestSampleImage.h"

@implementation SHRequestSampleImage

@synthesize EditionId = mEditionId;
@synthesize ImageId = mImageId;
@synthesize Image   = mImage;
@synthesize Size = mSize;

-(id)initWithURL:(NSURL *)URL
{
    self = [super initWithURL:URL];
    if (self)
    {
        mEditionId = nil;
        mImage = nil;
        mImageId = nil;
        index = -1;
                
    }
    return self;
}

-(void)dealloc
{
//    ReleaseStrongObject(mEditionId);
//    ReleaseStrongObject(mImage);
//    ReleaseStrongObject(mImageId);

    [super dealloc];
}
@end
