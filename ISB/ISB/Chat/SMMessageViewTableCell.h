//
//  SMMessageViewTableCell.h
//  JabberClient
//
//  Created by cesarerocchi on 9/8/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SMMessageViewTableCell : UITableViewCell {

	UILabel	*senderAndTimeLabel;
	UITextView *messageContentView;
	UIImageView *bgImageView;
    UIImageView *userImageView;
	
}

@property (nonatomic,retain) UILabel *senderAndTimeLabel;
@property (nonatomic,retain) UITextView *messageContentView;
@property (nonatomic,retain) UIImageView *bgImageView;
@property (nonatomic,retain) UIImageView *userImageView;

@end
