//
//  SMChatViewController.m
//  jabberClient
//
//  Created by cesarerocchi on 7/16/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import "SMChatViewController.h"
#import "XMPP.h"
#import "AppDelegate.h"
#import "NSString+Utils.h"
#import "NSData+Base64.h"
//#import "XMPPRoom.h"
@implementation SMChatViewController

@synthesize messageField, chatWithUser, tView,imageString;


- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [[self appDelegate] xmppStream];
}

- (id) initWithUser:(NSString *) userName {

	if (self = [super init]) {
		
		chatWithUser = userName; // @ missing
		turnSockets = [[NSMutableArray alloc] init];
	}
	
	return self;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
   // [self.view endEditing:YES];
    [self.messageField resignFirstResponder];
    return YES;
}
- (void)viewDidLoad {
	
    [super viewDidLoad];
    picker= [[UIImagePickerController alloc] init];
	picker.delegate = self;

	self.tView.delegate = self;
	self.tView.dataSource = self;
	[self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	messages = [[NSMutableArray alloc ] init];
	[self testMessageArchiving];
	AppDelegate *del = [self appDelegate];
	del._messageDelegate = self;
	[self.messageField becomeFirstResponder];
   
       if (self.isRoom)
       {
//           
//           xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:del jid:[XMPPJID jidWithString:chatWithUser] dispatchQueue:dispatch_get_main_queue()];
//    [xmppRoom addDelegate:del delegateQueue:dispatch_get_main_queue()];
//    
//    [xmppRoom activate:del.xmppStream];
//    
//    [xmppRoom joinRoomUsingNickname:@"pankaj" history:nil];
           
     
    }

//	XMPPJID *jid = [XMPPJID jidWithString:@"talk.google.com"];
//	
//	NSLog(@"Attempting TURN connection to %@", jid);
//	
//	TURNSocket *turnSocket = [[TURNSocket alloc] initWithStream:[self xmppStream] toJID:jid];
//	
//	[turnSockets addObject:turnSocket];
//	
//	[turnSocket startWithDelegate:self delegateQueue:dispatch_get_main_queue()];
	
}
-(void)testMessageArchiving{
    //    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [[self appDelegate] messagesStoreMainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"bareJidStr == %@",chatWithUser];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDescription];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *message = [moc executeFetchRequest:request error:&error];
    
    [self print:[[NSMutableArray alloc]initWithArray:message]];
}
-(void)print:(NSMutableArray*)messagess{
    @autoreleasepool {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messagess) {
            
            NSString *m = message.body;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            
            [dic setObject:[m substituteEmoticons] forKey:@"msg"];
            [dic setObject:message.timestamp forKey:@"time"];
            if([message.outgoing boolValue]==YES)
            {
                [dic setObject:@"you" forKey:@"sender"];
            }
            else
            {
                [dic setObject:chatWithUser forKey:@"sender"];
            }
            [messages addObject:dic];
            
            NSLog(@"messageStr param is %@",message.messageStr);
            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
            NSLog(@"NSCore object id param is %@",message.objectID);
            NSLog(@"bareJid param is %@",message.bareJid);
            NSLog(@"bareJidStr param is %@",message.bareJidStr);
            NSLog(@"body param is %@",message.body);
            NSLog(@"timestamp param is %@",message.timestamp);
            NSLog(@"outgoing param is %d",[message.outgoing intValue]);
            
        }
        [self.tView reloadData];
    }
}
- (void)turnSocket:(TURNSocket *)sender didSucceed:(GCDAsyncSocket *)socket {
	
	NSLog(@"TURN Connection succeeded!");
	NSLog(@"You now have a socket that you can use to send/receive data to/from the other person.");
		
	[turnSockets removeObject:sender];
}

- (void)turnSocketDidFail:(TURNSocket *)sender {
	
	NSLog(@"TURN Connection failed!");
	[turnSockets removeObject:sender];
	
}



#pragma mark -
#pragma mark Actions

- (IBAction) closeChat {

	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendMessage {
    if (isKeyBoard) {
        
        [tView setFrame:CGRectMake(0,49, 320, 220)];
    }

    NSString *messageStr = self.messageField.text;
	
    if([messageStr length] > 0 || [self.imageString length]>0) {
		
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:messageStr];
		
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        if([self.imageString length]>0)
        {
            [message addAttributeWithName:@"attachment" stringValue:self.imageString];
        }
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:chatWithUser];
        [message addChild:body];
		
        [self.xmppStream sendElement:message];
		
		self.messageField.text = @"";
		
        
		NSMutableDictionary *m = [[NSMutableDictionary alloc] init];
		[m setObject:[messageStr substituteEmoticons] forKey:@"msg"];
		[m setObject:@"you" forKey:@"sender"];
		[m setObject:[NSString getCurrentTime] forKey:@"time"];
		
		[messages addObject:m];
		[self.tView reloadData];
		
    }

	
	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath 
					  atScrollPosition:UITableViewScrollPositionMiddle 
							  animated:YES];
}


#pragma mark - image picker methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 0:
            picker.sourceType =UIImagePickerControllerSourceTypeCamera ;
            [self presentViewController:picker animated:YES completion:nil];
         	break;
		case 1:
			picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            [self presentViewController:picker animated:YES completion:nil];
			break;
		default:
			break;
	}
}

- (void)imagePickerController:(UIImagePickerController *)picker1 didFinishPickingMediaWithInfo:(NSDictionary *)info {
	[picker1 dismissViewControllerAnimated:YES completion:nil];
    UIImage *image      =   [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //    image               =   [Utils generatePhotoThumbnail:image];
    //    image               =   [Utils resizeImage:image width:320 height:460];
    self.imageString    =   [UIImagePNGRepresentation(image) base64Encoding];
    //    self.imgViewProfile.image=image;
}

#pragma mark - button clicked methods
- (IBAction)btnImageChangeClicked:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
		UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Images" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library",nil];
		[action setActionSheetStyle:UIActionSheetStyleBlackOpaque];
		[action setTag:99];
        [action showInView:self.view];
		return;
	}
    picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentModalViewController:picker animated:YES];
    return;
}

#pragma mark Table view delegates

static CGFloat padding = 20.0;


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	
	NSDictionary *s = (NSDictionary *) [messages objectAtIndex:indexPath.row];
	
	static NSString *CellIdentifier = @"MessageCellIdentifier";
	
	SMMessageViewTableCell *cell = (SMMessageViewTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
//        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		cell = [[SMMessageViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
	}

	NSString *sender = [s objectForKey:@"sender"];
	NSString *message = [s objectForKey:@"msg"];
	NSString *time = [s objectForKey:@"time"];
	
	CGSize  textSize = { 200.0, 10000.0 };
	CGSize size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13]
					  constrainedToSize:textSize 
						  lineBreakMode:UILineBreakModeWordWrap];

	
	size.width += (padding/2);
	//size.height +=(padding/2);
	
	cell.messageContentView.text = message;
	cell.accessoryType = UITableViewCellAccessoryNone;
	cell.userInteractionEnabled = NO;
	

	UIImage *bgImage = nil;
	UIImageView *userImage=nil;
    if (size.width<100) {
        size.width=100;
       // size.height=15;
    }else if (size.width>100 && size.width <150)
    {
        size.width=150;
    }
		
	if ([sender isEqualToString:@"you"]) { // left aligned
        userImage.image=[UIImage imageNamed:@"image3"];
      //  userImage.frame=CGRectMake(10, 10, 40, 40);
      //  [cell.userImageView addSubview:userImage];
		bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(padding+70, padding*2, size.width, size.height)];
		
		[cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
        [cell.userImageView setFrame:CGRectMake(10, 30, 60, 60)];
//        [cell.userImageView setFrame:CGRectMake(10, 30, 60, 60)];
        cell.userImageView.image=[UIImage imageNamed:@"image3"];
				
	} else {
	userImage.image=[UIImage imageNamed:@"image4"];
		bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		[cell.messageContentView setFrame:CGRectMake(320 - size.width - padding -60,
													 padding*2,
													 size.width, 
													 size.height)];
		
		[cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2-10,
											  cell.messageContentView.frame.origin.y - padding/2,
											  size.width+padding,
											  size.height+padding)];
        [cell.userImageView setFrame:CGRectMake(250, 30, 60, 60)];
        cell.userImageView.image=[UIImage imageNamed:@"image4"];

		
	}
	
	cell.bgImageView.image = bgImage;
   // cell.userImageView.image=[UIImage imageNamed:@"image3"];
	cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@ %@", sender, time];
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dict = (NSDictionary *)[messages objectAtIndex:indexPath.row];
	NSString *msg = [dict objectForKey:@"msg"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
				  constrainedToSize:textSize 
					  lineBreakMode:UILineBreakModeWordWrap];
	
	size.height += padding*2;
	
	CGFloat height = size.height < 65 ? 80 : size.height;
	return height;
	
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [messages count];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}


#pragma mark -text field methods

- (void)keyboardDidShow: (NSNotification *) notif{
    // Do something here
    isKeyBoard=YES;
}
- (void)keyboardDidHide: (NSNotification *) notif{
    // Do something here
    isKeyBoard=NO;
}
#pragma mark-animating a view
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5]; // if you want to slide up the view
    
    CGRect rect = self.viewMessage.frame;
    
    if (movedUp)
    {
        
        //isKeyBoardDown = NO;
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= 215;
        //        rect.size.height += 150;
    }
    else
    {
        
        // revert back to the normal state.
        rect.origin.y += 215;
        //        rect.size.height -= 150;
        //isKeyBoardDown = YES;
    }
    self.viewMessage.frame = rect;
    [UIView commitAnimations];
}
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (isMovedUp==YES)
    {
        
    }
    else
    {
        
        [self setViewMovedUp:YES];
        [tView setFrame:CGRectMake(0, 49, 320, 223)];
        if (![messages count]==0) {
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1
                                                           inSection:0];
            
            [self.tView scrollToRowAtIndexPath:topIndexPath
                              atScrollPosition:UITableViewScrollPositionNone
                                      animated:YES];
        }
        isMovedUp=YES;
    }
}

-(void)keyboardWillHide {
    if (isMovedUp==YES)
    {
        [self setViewMovedUp:NO];
        [tView setFrame:CGRectMake(0,49, 320, 318)];
        
        isMovedUp=NO;
        
    }
    
}
#pragma mark-text field delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

#pragma mark Chat delegates


- (void)newMessageReceived:(NSDictionary *)messageContent {
	
	NSString *m = [messageContent objectForKey:@"msg"];
	NSMutableDictionary *dic = [[NSMutableDictionary alloc]initWithDictionary:messageContent];
    
	[dic setObject:[m substituteEmoticons] forKey:@"msg"];
	[dic setObject:[NSString getCurrentTime] forKey:@"time"];
    
	[messages addObject:dic];
	[self.tView reloadData];

	NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:messages.count-1 
												   inSection:0];
	
	[self.tView scrollToRowAtIndexPath:topIndexPath 
					  atScrollPosition:UITableViewScrollPositionMiddle 
							  animated:YES];
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


//- (void)dealloc {
//	
//	[messageField dealloc];
//	[chatWithUser dealloc];
//	[tView dealloc];
//    [super dealloc];
//}


@end
