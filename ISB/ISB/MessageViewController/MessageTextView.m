//
//  MessageTextView.m
//  ISB
//
//  Created by AppRoutes on 25/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MessageTextView.h"
@interface UITextView ()
- (id)styleString; // make compiler happy
@end


@implementation MessageTextView
- (id)styleString {
    return [[super styleString] stringByAppendingString:@"; line-height: 1.6em"];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
