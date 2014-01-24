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
#import "CXMPPController.h"

@interface SMChatViewController ()

- (void) onLongPressGesture:(UILongPressGestureRecognizer*)gesture;

@end

@implementation SMChatViewController

@synthesize messageField, chatWithUser, tView,imageString,strUsername,isFromItemView;


- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [gCXMPPController xmppStream];
}

- (id) initWithUser:(NSString *) userName {

	if (self = [super init]) {
		
//		chatWithUser = @"sb@chat.eitcl.co.uk"; // @ missing

//        chatWithUser = @"love422w@api.yaab.ossclients.com";
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
#pragma mark pankaj edit
    
    if(!self.isFromHome){
        if([self userAvailable])
        {
            self.requestView.hidden=YES;
            [self.viewMessage setUserInteractionEnabled:YES];
        }
        else
        {
            NSLog(@"---------------------------------->%@",[NSString stringWithFormat:@"%@",chatWithUser]);
            NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
        
            [body addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",strUsername,STRChatServerURL]];
            [body addAttributeWithName:@"type" stringValue:@"subscribe"];
        
            [gCXMPPController.xmppStream sendElement:body];
            self.labelRequestMessage.text=[NSString stringWithFormat:@"Connecting to %@",strUsername];
            [self.viewMessage setUserInteractionEnabled:NO];
            [self performSelector:@selector(hideView) withObject:nil afterDelay:120.0];
        }
    }
    else
    {
        self.requestView.hidden=YES;
        [self.viewMessage setUserInteractionEnabled:YES];
    }
    
#pragma mark pankaj end
   
    context=[App managedObjectContext];
  
    [self fetchUserData:@"Users"];
    chatWithUser = [strUsername stringByAppendingString:@"@chat.eitcl.co.uk"];
    if (isFromItemView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self getUserImage];
            NSURL *url = [NSURL URLWithString:[kImageURL stringByAppendingString:self.pic_path]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                userImageN =  [Utils scaleImage:[UIImage imageWithData:data] maxWidth:77 maxHeight:77];
                [self.tView reloadData];
            });
        });
    }else
        userImageN=self.imageU;
    picker= [[UIImagePickerController alloc] init];
	picker.delegate = self;

	self.tView.delegate = self;
	self.tView.dataSource = self;
	[self.tView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	
	messages = [[NSMutableArray alloc ] init];
	[self testMessageArchiving];
//	AppDelegate *del = [self appDelegate];
//	del._messageDelegate = self;
    gCXMPPController._messageDelegate = self;
	[self.messageField becomeFirstResponder];
   
//       if (self.isRoom)
//       {
//
//           xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:del jid:[XMPPJID jidWithString:chatWithUser] dispatchQueue:dispatch_get_main_queue()];
//    [xmppRoom addDelegate:del delegateQueue:dispatch_get_main_queue()];
//    
//    [xmppRoom activate:del.xmppStream];
//    
//    [xmppRoom joinRoomUsingNickname:@"pankaj" history:nil];
           
     
//    }

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
//- (void)hideView
//{
//    [Utils showAlertView:@"ISB" message:@"User is not available right now." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(BOOL)userAvailable
{
    NSManagedObjectContext *moc = [gCXMPPController managedObjectContext_roster];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
//    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
//    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
    
//    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr LIKE[c] %@ and displayName LIKE[c] %@",[[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID1] lowercaseString],[strUsername stringByAppendingString:@"@chat.eitcl.co.uk"]];
    
    NSLog(@"JABBER ID :------>   %@",[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID1]);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
//    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:10];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    if([array count]>0)
        return YES;
    
    return NO;
}
- (void)hideView
{
    if(![self.requestView isHidden])
    {
        [Utils showAlertView:@"ISB" message:[NSString stringWithFormat:@"%@ is not available please send sms or email",strUsername] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
}
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
////    [self.navigationController popViewControllerAnimated:YES];
//}
-(void)getUserImage{
        NSURL *url = [NSURL URLWithString:@""];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"POST"];
        
        NSURLResponse *response;
        NSError *err;
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
        
        NSString* s = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        NSDictionary *result = [s JSONValue];
    
}


-(void)fetchUserData:(NSString *)tableName
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
	// Setup the fetch request
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	[request setEntity:entity];
    
    ////////////////////////////////////////////////////////////////////////////////
    //    NSFetchedResultsController *fetchedResultsController = nil;
    //
    //    [fetchedResultsController.fetchedObjects count];
    //    NSLog(@"total rows=%i",[fetchedResultsController.fetchedObjects count]);
    ////////////////////////////////////////////////////////////////////////////////
    
    NSPredicate *pred =
    [NSPredicate predicateWithFormat:@"(userid LIKE[c] %@)",
     [[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [request setPredicate:pred];
    
    
	// Fetch the records and handle an error
	NSError *error;
	NSMutableArray *mutableFetchResults = [[context executeFetchRequest:request error:&error] mutableCopy];
    ////NSLog(@"Fetched:%@",mutableFetchResults);
    
	if (!mutableFetchResults)
	{
        //		NSLog(@"Cant Fetch");
	}
    
    if (mutableFetchResults.count>0)
    {
        if([tableName isEqualToString:@"Users"])
        {
                            NSData *imageData = [[mutableFetchResults objectAtIndex:0]valueForKey:@"image"];
            myImage=[UIImage imageWithData:imageData];
            }
        }
    
}
-(void)testMessageArchiving{
    //    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
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
- (NSString *) stringForDate:(NSDate *)date {
	NSDate *nowUTC = date;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	[dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
	return [dateFormatter stringFromDate:nowUTC];
}
-(void)print:(NSMutableArray*)messagess{
    @autoreleasepool {
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messagess) {
            
            NSString *m = message.body;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSString *time = [self stringForDate:message.timestamp];
    //        NSLog(@"%@ %@",time,message.body);
            if(m !=NULL)
            {
                [dic setObject:[m substituteEmoticons] forKey:@"msg"];
            }
            else
            {
                [dic setObject:@" " forKey:@"msg"];
            }
            [dic setObject:time forKey:@"time"];
            if([message.outgoing boolValue]==YES)
            {
                [dic setObject:@"you" forKey:@"sender"];
            }
            else
            {
                [dic setObject:chatWithUser forKey:@"sender"];
            }
            [messages addObject:dic];
            
//            NSLog(@"messageStr param is %@",message.messageStr);
//            NSXMLElement *element = [[NSXMLElement alloc] initWithXMLString:message.messageStr error:nil];
//            NSLog(@"to param is %@",[element attributeStringValueForName:@"to"]);
//            NSLog(@"NSCore object id param is %@",message.objectID);
//            NSLog(@"bareJid param is %@",message.bareJid);
//            NSLog(@"bareJidStr param is %@",message.bareJidStr);
//            NSLog(@"body param is %@",message.body);
//            NSLog(@"timestamp param is %@",message.timestamp);
//            NSLog(@"outgoing param is %d",[message.outgoing intValue]);
            
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

//	[self dismissModalViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)sendMessage
{
    if (isKeyBoard)
    {
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            [tView setFrame:CGRectMake(0,46, 320, 220)];
        }
        else
        {
            [tView setFrame:CGRectMake(0,46, 320, 165)];
        }
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
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//		UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:@"Images" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library",nil];
//		[action setActionSheetStyle:UIActionSheetStyleBlackOpaque];
//		[action setTag:99];
//        [action showInView:self.view];
//		return;
//	}
//    picker.sourceType= UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//    [self presentModalViewController:picker animated:YES];
//    return;
    
//    XMPPRoomMemoryStorage *rosterstorage = [[XMPPRoomMemoryStorage alloc] init];
//    XMPPRoom *xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:rosterstorage jid:[XMPPJID jidWithString:@"test@mycompany.com/room"] dispatchQueue:dispatch_get_main_queue()];
//    [xmppRoom configureRoomUsingOptions:nil];
//    [xmppRoom activate:[UIAppDelegate xmppStream]];
//    [xmppRoom addDelegate:UIAppDelegate
//            delegateQueue:dispatch_get_main_queue()];
//    [xmppRoom inviteUser:[XMPPJID jidWithString:jabberID] withMessage:@"Hi join room"];
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
						  lineBreakMode:NSLineBreakByWordWrapping];

	size.width += (padding/2);
	size.height +=(padding/2);
	
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
		
	if ([sender isEqualToString:@"you"])
    { // left aligned
//        userImage.image=[UIImage imageNamed:@"userIconSmall@2x.png"];
//        if (myImage) {
//            userImage.image=myImage;
//        }else{
//        userImage.image=[UIImage imageNamed:@"defaultIconChat@2x.png"];
//        }
        //  userImage.frame=CGRectMake(10, 10, 40, 40);
      //  [cell.userImageView addSubview:userImage];
		bgImage = [[UIImage imageNamed:@"orange.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            
            [cell.messageContentView setFrame:CGRectMake(padding+70, padding*2, size.width, size.height+10)];

            [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
                                                  cell.messageContentView.frame.origin.y ,
                                                  size.width+padding,
                                                  size.height+padding)];
            
        }
        else
        {
            
            [cell.messageContentView setFrame:CGRectMake(padding+70, padding*2, size.width, size.height)];

            [cell.bgImageView setFrame:CGRectMake( cell.messageContentView.frame.origin.x - padding/2,
                                                  cell.messageContentView.frame.origin.y - padding/2,
                                                  size.width+padding,
                                                  size.height+padding)];
            
        }

		
        
        [cell.userImageView setFrame:CGRectMake(10, 30, 60, 60)];
//        [cell.userImageView setFrame:CGRectMake(10, 30, 60, 60)];
//        cell.userImageView.image=[UIImage imageNamed:@"userIconSmall@2x.png"];
//        cell.userImageView.image=[UIImage imageNamed:@"defaultIconChat@2x.png"];
        if (myImage) {
            cell.userImageView.image=myImage;
        }else{
            cell.userImageView.image=[UIImage imageNamed:@"defaultIconChat@2x.png"];
        }
				
	}
    else
    {
    if(self.img != nil)
    {
        userImage.image = self.img;
    }
    else
    {
//        userImage.image=[UIImage imageNamed:@"userIconSmall@2x.png"];
        userImage.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
    }
		bgImage = [[UIImage imageNamed:@"aqua.png"] stretchableImageWithLeftCapWidth:24  topCapHeight:15];
		
		
		if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
            [cell.messageContentView setFrame:CGRectMake(320 - size.width - padding -60,
                                                         padding*2,
                                                         size.width,
                                                         size.height+10)];
            [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                                  cell.messageContentView.frame.origin.y ,
                                                  size.width+padding,
                                                  size.height+padding)];
            
        }
        else
        {
            
            [cell.messageContentView setFrame:CGRectMake(320 - size.width - padding -60,
                                                         padding*2,
                                                         size.width,
                                                         size.height)];
            
            [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2,
                                                  cell.messageContentView.frame.origin.y - padding/2,
                                                  size.width+padding,
                                                  size.height+padding)];
            
        }
        
		[cell.userImageView setFrame:CGRectMake(250, 30, 60, 60)];
//        cell.userImageView.image=[UIImage imageNamed:@"userIconSmall@2x.png"];
        
      //  cell.userImageView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
        if (userImageN) {
            cell.userImageView.image=userImageN;
        }else{
            cell.userImageView.image=[UIImage imageNamed:@"defaultIconChat@2x.png"];
        }
	}
	
	cell.bgImageView.image = bgImage;
   // cell.userImageView.image=[UIImage imageNamed:@"image3"];
	cell.senderAndTimeLabel.text = [NSString stringWithFormat:@"%@", time];
	
	return cell;
	
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary *dict = (NSDictionary *)[messages objectAtIndex:indexPath.row];
	NSString *msg = [dict objectForKey:@"msg"];
	
	CGSize  textSize = { 260.0, 10000.0 };
	CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13]
				  constrainedToSize:textSize 
					  lineBreakMode:NSLineBreakByWordWrapping];
	
	size.height += padding*2;
	CGFloat height;
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
//    {
//         height = size.height < 65 ? size.height+(padding*2) : size.height+(padding*2);
//    }
//    else
//    {
         height = size.height < 65 ? size.height+(padding*2) : size.height+(padding*2);
   // }
	
    if([dict objectForKey:@"attachment"])
    {
        height =size.height+(padding*2);
    }
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
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            rect.origin.y -= 180;
        }
        else
        {
            rect.origin.y -= 165;
        }
        //        rect.size.height += 150;
    }
    else
    {
        
        // revert back to the normal state.
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            rect.origin.y += 180;
        }
        else
        {
            rect.origin.y += 165;
        }
        
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
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            [tView setFrame:CGRectMake(0,46, 320, 230)];
        }
        else
        {
            [tView setFrame:CGRectMake(0,46, 320, 135)];
        }
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
        if([UIScreen mainScreen].bounds.size.height>480)
        {
            [tView setFrame:CGRectMake(0,46, 320, 400)];
        }
        else
        {
            [tView setFrame:CGRectMake(0,46, 320, 300)];
        }
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
	self.labelRequestMessage.text=[NSString stringWithFormat:@"Connected to %@",[messageContent objectForKey:@"sender"]];
    [self.viewMessage setUserInteractionEnabled:YES];


NSString *str=@"1";
    [self performSelector:@selector(requestViewHidden:) withObject:str afterDelay:0.5];
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
-(void)requestViewHidden:(NSString *)makeHidden{
    if ([makeHidden isEqualToString:@"1"]) {
        self.requestView.hidden=YES;
    }else
        self.requestView.hidden=NO;


}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [self setLabelRequestMessage:nil];
    [self setRequestView:nil];
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


//- (void)dealloc {
//    [_labelRequestMessage release];
//    [_requestView release];
//    [super dealloc];
//}
@end
