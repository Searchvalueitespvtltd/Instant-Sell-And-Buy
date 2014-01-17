//
//  SHRequestSampleImage.h
//  NSConnectionTest
//
//  Created by Shakir on 25/02/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHBaseRequestImage.h"

@interface SHRequestSampleImage : SHBaseRequestImage
{
    NSString *mEditionId;
    NSString *mImageId;
    UIImage *mImage;
    CGSize mSize;
   
}
@property(retain,nonatomic)NSString *EditionId;
@property(retain,nonatomic)NSString *ImageId;
@property(retain,nonatomic)UIImage  *Image;
@property(assign,nonatomic)CGSize Size;


@end
