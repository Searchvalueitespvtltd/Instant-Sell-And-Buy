//
//  SMMessageViewTableCell.m
//  JabberClient
//
//  Created by cesarerocchi on 9/8/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMMessageViewTableCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation SMMessageViewTableCell

@synthesize senderAndTimeLabel, messageContentView, bgImageView,userImageView;

//- (void)dealloc {
//	
//	[senderAndTimeLabel release];
//	[messageContentView release];
//	[bgImageView release];
//    [super dealloc];
//	
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

		senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
		senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
		senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
		senderAndTimeLabel.textColor = [UIColor blackColor];
        senderAndTimeLabel.backgroundColor = [UIColor clearColor];
		[self.contentView addSubview:senderAndTimeLabel];
		
		bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        userImageView=[[UIImageView alloc]initWithFrame:CGRectZero];
        
        userImageView.layer.cornerRadius = 30.0;
        userImageView.clipsToBounds = YES;
        userImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
        
        
		[self.contentView addSubview:bgImageView];
        [self.contentView addSubview:userImageView];

		
		messageContentView = [[UITextView alloc] init];
		messageContentView.backgroundColor = [UIColor clearColor];
		messageContentView.editable = NO;
		messageContentView.scrollEnabled = NO;
		[messageContentView sizeToFit];
		[self.contentView addSubview:messageContentView];

    }
	
    return self;
	
}








@end
