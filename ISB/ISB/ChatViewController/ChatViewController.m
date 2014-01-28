//
//  ChatViewController.m
//  ISB
//
//  Created by Neha Saxena on 26/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#define kProfilePicPath @"profile_pic_path"
#define kID @"id"

#import "XMPPPrivacy.h"

#import "ChatViewController.h"
#import "XMPP.h"
#import "AppDelegate.h"
#import "NSString+Utils.h"
#import "NSData+Base64.h"
//#import "XMPPRoom.h"
#import "CXMPPController.h"
#import "SMChatViewController.h"
#import "Request.h"
#import "SHBaseRequestImage.h"
#import "SHRequestSampleImage.h"
#import "HttpRequestProcessor.h"
#import "RequestViewController.h"

@interface ChatViewController ()

- (void) onAcceptBtn:(id) sender;
- (void) onBlockBtn:(id) sender;
- (void) onRejectBtn:(id) sender;

- (void) retreiveListName:(NSString*) listName;
- (void) checkForUserInPrivacyList:(NSString*) privacyList;
- (void) reloadBlockAndRejectList;

- (NSArray*) userNameDictionaryArrayFromArray:(NSArray*)objArray;
- (void) createList:(NSString*)list array:(NSArray*)array;

- (void) fetcheImagesFrom:(NSArray*)userList forSection:(ImageFetchIndex)imageIndex;
-(void)callWebService;

//- (void) saveListInUserDefault:(NSString*) listname listArray:(NSArray*) listArray;
@end

@implementation ChatViewController

@synthesize tView,btnRequest;
- (AppDelegate *)appDelegate {
	return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (XMPPStream *)xmppStream {
	return [gCXMPPController xmppStream];
}
- (id) initWithNibName:(NSString *) nibNameOrNil bundle:(NSBundle *) nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        turnSockets = [[NSMutableArray alloc] init];
        // Custom initialization
    }
    return self;
}

- (void) usersAvailable
{
    NSManagedObjectContext *moc = [gCXMPPController managedObjectContext_roster];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"XMPPUserCoreDataStorageObject"
                                              inManagedObjectContext:moc];
    
    //    NSSortDescriptor *sd1 = [[NSSortDescriptor alloc] initWithKey:@"sectionNum" ascending:YES];
    //    NSSortDescriptor *sd2 = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES];
    
    //    NSArray *sortDescriptors = [NSArray arrayWithObjects:sd1, sd2, nil];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"streamBareJidStr LIKE[c] %@",[[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID1] lowercaseString]];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    //    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setFetchBatchSize:10];
    NSError *error = nil;
    NSArray *array = [moc executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *array1 = [[NSMutableArray alloc]init];
    NSMutableArray *arrayNames = [[NSMutableArray alloc]init];
    
    for (XMPPUserCoreDataStorageObject *user in array) {
        
        [array1 addObject:user.jidStr];
        [arrayNames addObject:[[user.jidStr componentsSeparatedByString:@"@"] objectAtIndex:0]];
        
        [activeJabberIdList addObject:user.jidStr];
        
       // NSLog(@"User available is %@", user.jidStr);
    }
    
    NSArray * uniqueArray = [[NSOrderedSet orderedSetWithArray:array1] array];
//    [messages addObjectsFromArray:uniqueArray];
    NSString *selfUserName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]] ;
    for (id obj in uniqueArray) {
        NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
        [temp setObject:obj forKey:@"UserName"];
        
        if (![[[obj componentsSeparatedByString:@"@"]objectAtIndex:0] isEqualToString:selfUserName])
        {
                [messages addObject:temp];
                [self arrayFromUserDefaultForKey:kActiveList update:(NSString*)obj];
            
            //// Loop to check for case sensitive compare of the jabber ids.
            for (NSString* str in [self arrayFromUserDefaultForKey:kActiveList])
            {
                if ([str caseInsensitiveCompare:(NSString*)obj])
                {
                    if (![str compare:(NSString*)obj])
                    {
                        [Utils removeObject:str fromList:kActiveList];
                    }
                }
            }

        }
       
    }
    for (id obj in arrayNames) {
        if (![[[obj componentsSeparatedByString:@"@"]objectAtIndex:0] isEqualToString:selfUserName]) {
            [userNames addObject:obj];
        }
    }
    
    [self checkForUserInPrivacyList:kBlockList];
    [self checkForUserInPrivacyList:kRejectList];
    [self reloadBlockAndRejectList];

    
   //    NSArray * uniqueArrayNames = [[NSOrderedSet orderedSetWithArray:arrayNames] array];
//    [userNames addObjectsFromArray:uniqueArrayNames];
    
    
    
//    return array;
//    if([array count]>0)
//        return YES;
//    
//    return NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
   // XMPPPrivacy* xmppPrivacy = [[XMPPPrivacy alloc] init];
   // [xmppPrivacy activate:gCXMPPController.xmppStream];
   // [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
   // NSArray* arr = [[NSArray alloc] init];
   // [xmppPrivacy setListWithName:kBlockList items:arr];
    //[xmppPrivacy setActiveListName:kBlockList];
   // [xmppPrivacy setListWithName:kRejectList items:arr];
  //  [xmppPrivacy setActiveListName:kRejectList];

   
    // Do any additional setup after loading the view from its nib.
}
-(void )viewWillAppear:(BOOL)animated
{
    //[super viewWillAppear:animated];
    
    activeJabberIdList = [[NSMutableArray alloc] init];
    imageArray= [[NSMutableArray alloc ] init];
    messages = [[NSMutableArray alloc ] init];
    userNames= [[NSMutableArray alloc ] init];
    //activeLocalList = [[NSMutableArray alloc] init];
    ReleaseObject(previousRejectedList);
    previousRejectedList = [[NSMutableArray alloc] init];
    ReleaseObject(previousBlockList);
    previousBlockList = [[NSMutableArray alloc] init];
    
    ReleaseObject(newActiveUserImageList);
    newActiveUserImageList = [[NSMutableArray alloc] init];
    
    ReleaseObject(rejectedUserImageList);
    rejectedUserImageList = [[NSMutableArray alloc] init];
    
    ReleaseObject(blockUserImageList);
    blockUserImageList = [[NSMutableArray alloc] init];
    
    ReleaseObject(idUserNameDic);
    ReleaseObject(imageUserNameDic);
    
    idUserNameDic = [[NSMutableDictionary alloc] init];
    imageUserNameDic = [[NSMutableDictionary alloc] init];

    [HttpRequestProcessor shareHttpRequest];
    [self retreiveListName:kBlockList];
    [self retreiveListName:kRejectList];
    [self usersAvailable];
    [self callWebService];
 
   // [tView reloadData];
//    [self testMessageArchiving];
    //NSString * result;
    if ([userNames count] > 0)
    {
        sectionForImage = kActiveUser;
        [self fetcheImagesFrom:userNames forSection:kActiveUser];
//        result = [userNames componentsJoinedByString:@","];
//        sectionForImage= kActiveUser;
//        [self callWebService:result];
    }
    else if ([blockList count] > 0)
    {
        sectionForImage = kBlockUser;
        [self fetcheImagesFrom:blockList forSection:kBlockUser];
    }
    else if ([rejectedList count] > 0)
    {
        sectionForImage = kRejectedUser;
        [self fetcheImagesFrom:rejectedList forSection:kRejectedUser];
    }
    
    ReleaseObject(blockList);
    ReleaseObject(rejectedList);
    
    blockList = [[NSMutableArray alloc] initWithArray:[self arrayFromUserDefaultForKey:kBlockList]];
    rejectedList = [[NSMutableArray alloc] initWithArray:[self arrayFromUserDefaultForKey:kRejectList]];
    activeLocalList = [[NSMutableArray alloc] initWithArray:[self arrayFromUserDefaultForKey:kActiveList]];
    [self getUserRequests];
    
    if( [[UIScreen mainScreen] bounds].size.height > 480)
    {
        self.tView.frame = CGRectMake(self.tView.frame.origin.x, self.tView.frame.origin.y, 320, self.view.frame.size.height - 85);
    }
    else
    {
        self.tView.frame = CGRectMake(self.tView.frame.origin.x, self.tView.frame.origin.y, 320, self.view.frame.size.height - 85);
    }

}

- (void)getUserRequests
{
    AppDelegate *appDel = APP_DELEGATE;
    NSMutableArray *aryRequest = [[NSMutableArray alloc]init];
    NSManagedObjectContext *context = appDel.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userid LIKE[c] %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]];
    [fetchRequest setPredicate:predicate];
    predicate=nil;
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    fetchRequest = nil;
    [aryRequest removeAllObjects];
    
    for(Request *req in array)
    {
        if (![blockList containsObject:req.jid])
            [aryRequest addObject:req.jid];
    }
    
    [tView reloadData];
    
    if (aryRequest.count < 1) {
        btnRequest.hidden =YES;
    }
    else
    {
        btnRequest.hidden= NO;
    }
}
-(void)testMessageArchiving{
    //    XMPPMessageArchivingCoreDataStorage *storage = [XMPPMessageArchivingCoreDataStorage sharedInstance];
    NSManagedObjectContext *moc = [gCXMPPController messagesStoreMainThreadManagedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"XMPPMessageArchiving_Message_CoreDataObject"
                                                         inManagedObjectContext:moc];
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"sender != 'you'"];
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
  //  [request setPredicate:[NSPredicate predicateWithFormat:@"jidStr != %@", kXMPPmyJID1]];

    [request setEntity:entityDescription];
//    [request setPredicate:predicate];
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
        NSMutableArray *array = [[NSMutableArray alloc]init];
         NSMutableArray *arrayNames = [[NSMutableArray alloc]init];
        for (XMPPMessageArchiving_Message_CoreDataObject *message in messagess) {
            
            NSString *m = message.body;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            NSString *time = [self stringForDate:message.timestamp];
//            NSLog(@"%@ %@",time,message.body);
            [array addObject:message.bareJidStr];
            [arrayNames addObject:[[message.bareJidStr componentsSeparatedByString:@"@"] objectAtIndex:0]];
            
//            if(m !=NULL)
//            {
//                [dic setObject:[m substituteEmoticons] forKey:@"msg"];
//            }
//            else
//            {
//                [dic setObject:@" " forKey:@"msg"];
//            }
//            [dic setObject:time forKey:@"time"];
//            if([message.outgoing boolValue]==YES)
//            {
//                [dic setObject:@"you" forKey:@"sender"];
//            }
//            else
//            {
//                [dic setObject:chatWithUser forKey:@"sender"];
//            }
//            [messages addObject:dic];
            
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
        NSArray * uniqueArray = [[NSOrderedSet orderedSetWithArray:array] array];
        [messages addObjectsFromArray:uniqueArray];
        
        NSArray * uniqueArrayNames = [[NSOrderedSet orderedSetWithArray:arrayNames] array];
        [userNames addObjectsFromArray:uniqueArrayNames];
        [self.tView reloadData];
    }
}
#pragma mark - table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    NSInteger rowNumber = indexPath.row;
    UIButton* firstButton = [[UIButton alloc] init];
    firstButton.tag = rowNumber;
    
    UIButton* secondButton = [[UIButton alloc] init];
    
    secondButton.tag = rowNumber;
    
    // addded by chetan..
    
    if (indexPath.section == 0)/// Sect
    {
        NSString* userID = [idUserNameDic objectForKey:[activeLocalList objectAtIndex:indexPath.row]];
        UIImage* img = (UIImage*)[imageUserNameDic objectForKey:userID];
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        cell.tag = 0;
        
        // added by chetan ..
        UILabel *label=(UILabel*)[cell.contentView viewWithTag:10];
        
        label.text=[[[activeLocalList objectAtIndex:indexPath.row] componentsSeparatedByString:@"@"] objectAtIndex:0];
        //label.text =[[[[messages objectAtIndex:indexPath.row] valueForKey:@"UserName"]componentsSeparatedByString:@"@"] objectAtIndex:0];
        UIImageView *imgView=(UIImageView *)[cell.contentView viewWithTag:11];
        if (img)
        {
            imgView.image = img;
        }
        else
        {
            imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
            
        }

        if (![userNames containsObject:label.text])
        {
            cell.userInteractionEnabled = NO;
            cell.contentView.alpha = 0.2;
            firstButton.alpha = 0.3;
            secondButton.alpha = 0.3;
            
            
//            if ([newActiveUserImageList count] > rowNumber)
//            {
//                if (![[[newActiveUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath] isKindOfClass:[NSNull class]])
//                {
//                    if ([[newActiveUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath])
//                    {
//                        imgView.image=[[newActiveUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath];
//                    }
//                    else
//                    {
//                        imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//                    }
//                }
//                else
//                {
//                    imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//                }
//            }
//            else
//            {
//                imgView.image = [UIImage imageNamed:@"defaultIconChat2@2x.png"];
//            }
        }
        else if ([userNames count] > rowNumber)
        {
            cell.userInteractionEnabled = YES;
            cell.contentView.alpha = 1;
            firstButton.alpha = 1;
            secondButton.alpha = 1;
            //    cell.textLabel.text = [[[messages objectAtIndex:indexPath.row]componentsSeparatedByString:@"@"] objectAtIndex:0];
          //  label.highlightedTextColor = [UIColor blackColor];
            
            //UIImageView *imgView=(UIImageView *)[cell.contentView viewWithTag:11];
            //NSInteger userIndex = [userNames indexOfObject:label.text];
            
//            if ([[messages objectAtIndex:userIndex] valueForKey:@"Image"])
//            {
//                imgView.image=[[messages objectAtIndex:userIndex] valueForKey:@"Image"];
//            }
//            else
//            {
//                imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//            }
            
            if ([[self arrayFromUserDefaultForKey:kNewMsgUserJID] containsObject:[activeLocalList objectAtIndex:rowNumber]])
            {
               // NSLog(@"New message found from the user ---------------------------------------------------> %@", label.text);

                cell.backgroundColor = [UIColor cyanColor];
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }
        else
        {
            cell.userInteractionEnabled = YES;
            cell.contentView.alpha = 1;
            firstButton.alpha = 1;
            secondButton.alpha = 1;
            
            if ([[self arrayFromUserDefaultForKey:kNewMsgUserJID] containsObject:[activeLocalList objectAtIndex:rowNumber]])
            {
                
                NSLog(@"New message found from the user ---------------------------------------------------> %@", label.text);
                cell.backgroundColor = [UIColor cyanColor];
            }
            else
            {
                cell.backgroundColor = [UIColor whiteColor];
            }
        }

        CGSize labelSize = label.frame.size;
        
        [firstButton setFrame:CGRectMake(label.frame.origin.x, (label.frame.origin.y + labelSize.height), 73, 37)];
        [firstButton setBackgroundImage:[UIImage imageNamed:@"reject(2).png"] forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(onRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:firstButton];
        
        [secondButton setFrame:CGRectMake(firstButton.frame.origin.x + firstButton.frame.size.width + 10, firstButton.frame.origin.y, 73, 37)];
        [secondButton setBackgroundImage:[UIImage imageNamed:@"block(2).png"] forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(onBlockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:secondButton];
    }
    else if (indexPath.section == 1)
    {
        cell.tag = 1;
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        
        // added by chetan ..
        UILabel *label=(UILabel*)[cell.contentView viewWithTag:10];
        NSString* name = [[[blockList objectAtIndex:rowNumber] componentsSeparatedByString:@"@"] objectAtIndex:0];
        label.text = name;
        if ([[self arrayFromUserDefaultForKey:kNewBlockEntry] containsObject:[blockList objectAtIndex:rowNumber]])
        {
            cell.userInteractionEnabled = NO;
            cell.contentView.alpha = 0.2;
            firstButton.alpha =0.3;
            secondButton.alpha = 0.3;
        }
        else
        {
            cell.userInteractionEnabled = YES;
            cell.contentView.alpha = 1;
            firstButton.alpha = 1;
            secondButton.alpha = 1;
        }
        
        NSString* userID = [idUserNameDic objectForKey:[blockList objectAtIndex:indexPath.row]];
        UIImage* img = (UIImage*)[imageUserNameDic objectForKey:userID];
        UIImageView *imgView=(UIImageView *)[cell.contentView viewWithTag:11];
        if (img)
        {
            imgView.image = img;
        }
        else
        {
            imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
        }
//        if ([blockUserImageList count] > rowNumber)
//        {
//            if (![[[blockUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath] isKindOfClass:[NSNull class]])
//            {
//                if ([[blockUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath])
//                {
//                    imgView.image=[[blockUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath];
//                }
//                else
//                    imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//            }
//            else
//                 imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//        }
//        else
//        {
//            imgView.image = [UIImage imageNamed:@"defaultIconChat2@2x.png"];
//        }

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize labelSize = label.frame.size;
        [firstButton setFrame:CGRectMake(label.frame.origin.x, (label.frame.origin.y + labelSize.height), 73, 37)];
        [firstButton setBackgroundImage:[UIImage imageNamed:@"reject(2).png"] forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(onRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:firstButton];
        
        [secondButton setFrame:CGRectMake(firstButton.frame.origin.x + firstButton.frame.size.width + 10, firstButton.frame.origin.y, 73, 37)];
        [secondButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(onAcceptBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:secondButton];
        
           }
    else if(indexPath.section == 2)
    {
        NSLog(@" new user added to rejected list are    ----------------------------%@",[self arrayFromUserDefaultForKey:kNewRejectEntry]);
        cell.tag = 2;
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        
        UILabel *label=(UILabel*)[cell.contentView viewWithTag:10];
        NSString* name = [[[rejectedList objectAtIndex:rowNumber] componentsSeparatedByString:@"@"] objectAtIndex:0];
        
        label.text = name;
        if ([[self arrayFromUserDefaultForKey:kNewRejectEntry] containsObject:[rejectedList objectAtIndex:rowNumber]])
        {
            cell.userInteractionEnabled = NO;
            cell.contentView.alpha = 0.2;
            secondButton.alpha = 0.3;
            firstButton.alpha = 0.3;
        }
        else
        {
            cell.userInteractionEnabled = YES;
            cell.contentView.alpha = 1;
            firstButton.alpha = 1;
            secondButton.alpha = 1;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString* userID = [idUserNameDic objectForKey:[rejectedList objectAtIndex:indexPath.row]];
        UIImage* img = (UIImage*)[imageUserNameDic objectForKey:userID];
        UIImageView *imgView=(UIImageView *)[cell.contentView viewWithTag:11];
        if (img)
        {
            imgView.image = img;
        }
        else
        {
            imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
        }
//        if ([rejectedUserImageList count] > rowNumber)
//        {
//            if (![[[rejectedUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath] isKindOfClass:[NSNull class]])
//            {
//                
//                if ([[rejectedUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath])
//                {
//                    imgView.image=[[rejectedUserImageList objectAtIndex:rowNumber] valueForKey:kProfilePicPath];
//                }
//                else
//                {
//                    imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//                }
//            }
//            else
//                imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
//        }
//        else
//        {
//            imgView.image = [UIImage imageNamed:@"defaultIconChat2@2x.png"];
//        }
        
        CGSize labelSize = label.frame.size;
        [firstButton setFrame:CGRectMake(label.frame.origin.x, (label.frame.origin.y + labelSize.height), 73, 37)];
        [firstButton setBackgroundImage:[UIImage imageNamed:@"block(2).png"] forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(onBlockBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:firstButton];
        
        [secondButton setFrame:CGRectMake(firstButton.frame.origin.x + firstButton.frame.size.width + 10, firstButton.frame.origin.y, 73, 37)];
        [secondButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(onAcceptBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:secondButton];
        
       
    }
    [firstButton release];
    [secondButton release];
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
        SMChatViewController *chat = nil;
        
        if([[UIScreen mainScreen] bounds].size.height>480)
        {
            chat=[[SMChatViewController alloc] initWithNibName:@"SMChatViewController" bundle:nil];
            
        }
        else
        {
            chat=[[SMChatViewController alloc] initWithNibName:@"SMChatViewControlleriphone4" bundle:nil];
        }
        chat.isFromHome=YES;
        chat.strUsername = [[[activeLocalList objectAtIndex:indexPath.row] componentsSeparatedByString:@"@"] objectAtIndex:0];
        [Utils removeObject:[activeLocalList objectAtIndex:indexPath.row] fromList:kNewMsgUserJID];
        //chat.strUsername = [NSString stringWithFormat:@"%@",[[[[messages objectAtIndex:indexPath.row] valueForKey:@"UserName" ]componentsSeparatedByString:@"@"] objectAtIndex:0]];
        chat.isFromItemView=NO;
        UIImageView *img=(UIImageView *)[cell.contentView viewWithTag:11];
        chat.imageU=img.image;
        [self.navigationController pushViewController:chat animated:YES ];
        [chat release];
    }

}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//	
//	return 44;
//	
//}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return [activeLocalList count];////
            break;
        case 1:
            return [blockList count];
            break;
        case 2:
            return [rejectedList count];
        default:
            return 0;
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Active users";
            break;
        case 1:
            return @"Blocked users";
            break;
        case 2:
            return @"Rejected users";
            break;
        default:
            return nil;
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction) closeChat
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnPendingRequest:(id)sender
{
    RequestViewController *request = nil;
    if([UIScreen mainScreen].bounds.size.height>480)
    {
        request = [[RequestViewController alloc]initWithNibName:@"RequestViewController" bundle:nil];
    }
    else
    {
        request = [[RequestViewController alloc]initWithNibName:@"RequestViewControlleriphone4" bundle:nil];
    }
    [self.navigationController pushViewController:request animated:YES];
}
#pragma  - mark Call Webservice



-(void)callWebService:(NSString *)usernames
{
   // http://chat.eitcl.co.uk/devchat/index.php/sb,ojal15,scoobydoo,ps,chetan,nr,shiv,cs,rm,sh,ns,sm,ssharma
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:[NSString stringWithFormat:@"users/get_prof_pics?usernames=%@",usernames] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    
    BOOL isForReminder = [Utils checkIfString:inReqIdentifier contains:@"reminders"];
    
    if (!isForReminder)
    {
        
        if([inResponseDic isKindOfClass:[NSArray class]])
        {
            //if (sectionForImage == kActiveUser)
           // {
                responseArray=[[NSMutableArray alloc]initWithArray:inResponseDic];
            if (sectionForImage == kActiveUser)
            {
                for (int i = 0; i < [responseArray count]; i++)
                {
                    if ([activeJabberIdList count] > i)
                        [idUserNameDic setObject:[(NSDictionary*)[responseArray objectAtIndex:i]objectForKey:@"id"] forKey:[activeJabberIdList objectAtIndex:i]];
                }
            }
            if (sectionForImage == kRejectedUser)
            {
                for (int i = 0; i < [responseArray count]; i++)
                {
                    if ([rejectedList count] > i)
                        [idUserNameDic setObject:[(NSDictionary*)[responseArray objectAtIndex:i]objectForKey:@"id"] forKey:[rejectedList objectAtIndex:i]];
                }
            }
            if (sectionForImage == kBlockUser)
            {
                for (int i = 0; i < [responseArray count]; i++)
                {
                    if ([blockList count] > i)
                        [idUserNameDic setObject:[(NSDictionary*)[responseArray objectAtIndex:i]objectForKey:@"id"] forKey:[blockList objectAtIndex:i]];
                }
            }
            if (sectionForImage == kNewActiveuser)
            {
                for (int i = 0; i < [responseArray count]; i++)
                {
                    if ([activeLocalList count] > i)
                        [idUserNameDic setObject:[(NSDictionary*)[responseArray objectAtIndex:i]objectForKey:@"id"] forKey:[activeLocalList objectAtIndex:i]];
                }
            }



         //   }
//            else if (sectionForImage == kBlockUser)
//            {
//                ReleaseObject(blockUserImageList);
//                blockUserImageList = [[NSMutableArray alloc]initWithArray:inResponseDic];
//                //// save block image dic list
//            }
//            else if (sectionForImage == kRejectedUser)
//            {
//                ReleaseObject(rejectedUserImageList);
//                rejectedUserImageList = [[NSMutableArray alloc]initWithArray:inResponseDic];
//                ///// save reject image dic list.
//            }
//            else if (sectionForImage == kNewActiveuser)
//            {
//                ReleaseObject(newActiveUserImageList);
//                newActiveUserImageList = [[NSMutableArray alloc]initWithArray:inResponseDic];
//            }
//            
            [self performSelector:@selector(bringImages:) withObject:inResponseDic afterDelay:0];
        }
        else
        {
            [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
    }
    else
    {
        if([inResponseDic isKindOfClass:[NSDictionary class]])
        {
         NSArray*   notificationArray = [[NSMutableArray alloc]initWithArray:[inResponseDic valueForKey:@"Notification"]];
            
            // for removing the rejected by or blocked by list from local active list.
            for (NSDictionary* str in notificationArray)
            {
                NSMutableString* name = [[ (NSString*)[str objectForKey:@"msg" ] componentsSeparatedByString:@" "] objectAtIndex:4];
                name = (NSMutableString*)[name substringFromIndex:1];
                name = (NSMutableString*)[name substringToIndex:[name length] - 2];
                [Utils arrayFromUserDefaultForKey:kBlockedRejectedBy update:name];
                NSArray* arr = [Utils arrayFromUserDefaultForKey:kActiveList];
                
                for (NSString* str2 in arr)
                {
                    NSString* str3 = [[ str2 componentsSeparatedByString:@"@"] objectAtIndex:0];
                    if ([str3 isEqualToString:name])
                    {
                        [Utils removeObject:str2 fromList:kActiveList];
                    }
                }
            }
        }
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}

#pragma mark fetch images

-(void)bringImages:(NSArray *)inResponseDic
{
    for (int i=0;i<[inResponseDic count];i++)
    {
        int index=[[[inResponseDic objectAtIndex:i] valueForKey:@"id"] integerValue];
            [self doFetchEditionImage:[[inResponseDic objectAtIndex:i] valueForKey:@"profile_pic_path"]withIndex:index];
    }
    
    if (sectionForImage == kActiveUser)
    {
        if ([blockList count] > 0)
        {
            sectionForImage = kBlockUser;
            [self fetcheImagesFrom:blockList forSection:kBlockUser];
        }
    }
    else if (sectionForImage == kBlockUser)
    {
        if ([rejectedList count] > 0)
        {
            sectionForImage = kRejectedUser;
            [self fetcheImagesFrom:rejectedList forSection:kRejectedUser];
        }
    }
    else if (sectionForImage == kRejectedUser)
    {
        sectionForImage = kNewActiveuser;
        [self fetcheImagesFrom:activeLocalList forSection:kNewActiveuser];
    }
}

-(void)doFetchEditionImage:(NSString *)inImageId withIndex:(NSInteger)index
{
    SHRequestSampleImage *aRequest = [[SHRequestSampleImage alloc] initWithURL: nil] ;
    [aRequest setImageId:inImageId];
    [aRequest SetResponseHandler:@selector(handledImage:) ];
    [aRequest SetErrorHandler:@selector(errorHandler:)];
    [aRequest SetResponseHandlerObj:self];
    [aRequest SetRequestType:eRequestType1];
    aRequest.index = index;
    
    [gHttpRequestProcessor ProcessImage: aRequest];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    //ß aRequest = nil;
    
}

-(void)errorHandler:(SHBaseRequestImage *)inRequest
{
    //  NSLog(@"*** errorHandler ***");
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
}

//For scroll View
-(void)handledImage:(SHBaseRequestImage *)inRequest
{
    NSData *aImageData =  [inRequest GetResponseData];
    SHRequestSampleImage * aCurrReq = (SHRequestSampleImage *)inRequest;
    if (aImageData)
    {
//        NSLog(@"%d",inRequest.index);
        UIImage * img = [UIImage imageWithData: aImageData];
        NSString* ID ;
        if (img) {
            
            NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
            NSInteger filteredIndexes = [responseArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
                NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
                //            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
                return [ID isEqualToString:cellIndex];
            }];
            //        NSLog(@"filteredIndexes %d",filteredIndexes);
            if (filteredIndexes != NSNotFound) {
                NSIndexPath *indexpath=[NSIndexPath indexPathForRow:filteredIndexes inSection:0];
                UITableViewCell *cell=[self.tView cellForRowAtIndexPath:indexpath];
                UIImageView *imageVw=(UIImageView *)[cell.contentView viewWithTag:11];
                imageVw.image=img;
                
               // NSMutableDictionary *aTemp=[[NSMutableDictionary alloc]init];
                [imageUserNameDic setObject:img forKey:cellIndex];
                NSLog(@"%@", imageUserNameDic);
//                if ([messages count] > filteredIndexes)
//                {
//                    aTemp=[messages objectAtIndex:filteredIndexes];
//                    //            [[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]
//                    [aTemp setObject:img forKey:@"Image"];
//                    [messages replaceObjectAtIndex:filteredIndexes withObject:aTemp];
//                }
            }

//        
//        switch (sectionForImage)
//        {
//            case kActiveUser:
//            {
//                if (img) {
//                    
//                    NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
//                    NSInteger filteredIndexes = [responseArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
//                        NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
//                        //            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
//                        return [ID isEqualToString:cellIndex];
//                    }];
//                    //        NSLog(@"filteredIndexes %d",filteredIndexes);
//                    if (filteredIndexes != NSNotFound) {
//                        NSIndexPath *indexpath=[NSIndexPath indexPathForRow:filteredIndexes inSection:0];
//                        UITableViewCell *cell=[self.tView cellForRowAtIndexPath:indexpath];
//                        UIImageView *imageVw=(UIImageView *)[cell.contentView viewWithTag:11];
//                        imageVw.image=img;
//                        
//                        NSMutableDictionary *aTemp=[[NSMutableDictionary alloc]init];
//                        if ([messages count] > filteredIndexes)
//                        {
//                            aTemp=[messages objectAtIndex:filteredIndexes];
//                        //            [[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]
//                            [aTemp setObject:img forKey:@"Image"];
//                            [messages replaceObjectAtIndex:filteredIndexes withObject:aTemp];
//                        }
//                    }
//                }
//                break;
//            }
//            case kBlockUser:
//            {
//                if (img) {
//
//                NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
//                NSInteger filteredIndexes = [responseArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
//                    NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
//                    //            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
//                    return [ID isEqualToString:cellIndex];
//                }];
//                //        NSLog(@"filteredIndexes %d",filteredIndexes);
//                if (filteredIndexes != NSNotFound) {
//                    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:filteredIndexes inSection:1];
//                    UITableViewCell *cell=[self.tView cellForRowAtIndexPath:indexpath];
//                    UIImageView *imageVw=(UIImageView *)[cell.contentView viewWithTag:11];
//                    imageVw.image=img;
//                    
//                    NSMutableDictionary *aTemp=[[NSMutableDictionary alloc] init];
//                    
//                    if ([blockUserImageList count] > filteredIndexes)
//                    {
//                        aTemp=[blockUserImageList objectAtIndex:filteredIndexes];
//                    //            [[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]
//                        [aTemp setObject:img forKey:kProfilePicPath];
//                        [blockUserImageList replaceObjectAtIndex:filteredIndexes withObject:aTemp];
//                    }
//                }
//                }
//                break;
//            }
//            case kRejectedUser:
//                {
//                    if (img)
//                    {
//
//                        NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
//                        NSInteger filteredIndexes = [responseArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
//                            NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
//                        //            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
//                            return [ID isEqualToString:cellIndex];
//                        }];
//                    //        NSLog(@"filteredIndexes %d",filteredIndexes);
//                        if (filteredIndexes != NSNotFound)
//                        {
//                            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:filteredIndexes inSection:2];
//                            UITableViewCell *cell=[self.tView cellForRowAtIndexPath:indexpath];
//                            UIImageView *imageVw=(UIImageView *)[cell.contentView viewWithTag:11];
//                            imageVw.image=img;
//                        
//                            NSMutableDictionary *aTemp=[[NSMutableDictionary alloc]init];
//                            if ([rejectedUserImageList count] > filteredIndexes)
//                            {
//                                aTemp=[rejectedUserImageList objectAtIndex:filteredIndexes];
//                        //            [[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]
//                                [aTemp setObject:img forKey:kProfilePicPath];
//                                [rejectedUserImageList replaceObjectAtIndex:filteredIndexes withObject:aTemp];
//                            }
//                        }
//                    }
//
//                    break;
//                }
//                    case kNewActiveuser:
//                    {
//                        if (img) {
//
//                        NSString *cellIndex=[NSString stringWithFormat:@"%d",inRequest.index];
//                        NSInteger filteredIndexes = [responseArray indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
//                            NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
//                            //            NSLog(@"ID: %@",[obj valueForKey:@"id"]);
//                            return [ID isEqualToString:cellIndex];
//                        }];
//                        //        NSLog(@"filteredIndexes %d",filteredIndexes);
//                        if (filteredIndexes != NSNotFound) {
//                            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:filteredIndexes inSection:0];
//                            UITableViewCell *cell=[self.tView cellForRowAtIndexPath:indexpath];
//                            UIImageView *imageVw=(UIImageView *)[cell.contentView viewWithTag:11];
//                            imageVw.image=img;
//                            
//                            NSMutableDictionary *aTemp=[[NSMutableDictionary alloc]init];
//                            if ([newActiveUserImageList count] > filteredIndexes)
//                            {
//                                aTemp=[newActiveUserImageList objectAtIndex:filteredIndexes];
//                            //            [[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]
//                                [aTemp setObject:img forKey:kProfilePicPath];
//                                [newActiveUserImageList replaceObjectAtIndex:filteredIndexes withObject:aTemp];
//                            }
//                        }
//
//                    }
//            default:
//                break;
//        }
    }
           [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}

#pragma mark - Private Methods

-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"reminders/get?user_id=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    //    [objService sendRequestToServer:@"msgs/get_all?user_id=18" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
}

-(NSArray*) arrayFromUserDefaultForKey:(NSString*) key
{
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
    NSMutableDictionary* dic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:key]];
    NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
    NSArray* arr = [NSArray arrayWithArray:(NSArray*)[dic objectForKey:userid]];
    return arr;
}
- (void) arrayFromUserDefaultForKey:(NSString*)key update:(NSString*)object
{
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
    NSMutableDictionary* dic1 = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:key]];
    NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];

    NSMutableArray* arr = [[NSMutableArray alloc ]initWithArray:(NSArray*)[dic1 objectForKey:userid]];
    
    if (![arr containsObject:object])
        [arr addObject:object];
    
    [dic1 removeObjectForKey:userid];
    [dic1 setObject:arr forKey:userid];
    [userDefault setObject:dic1 forKey:key];
    [userDefault release];
    
   // NSLog(@"Array to update in list ----------------------------------- %@", arr);
   // NSLog(@"List to be updated----------------------------------------------- %@",key);
}


- (void) retreiveListName:(NSString *)listName
{
    XMPPPrivacy* xmppPrivacy = [[XMPPPrivacy alloc] init];
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppPrivacy listWithName:listName];
}

- (void) checkForUserInPrivacyList:(NSString*) privacyList
{
    NSArray* privacyListArray = [[NSArray alloc]initWithArray:[self arrayFromUserDefaultForKey:privacyList]];
    NSMutableArray* toDelete = [[NSMutableArray alloc] init];

    if (privacyListArray)
    {
        for (NSString* str in privacyListArray)
        {
            if ([activeJabberIdList containsObject:str])
            {
                [activeJabberIdList removeObject:str];
                [Utils removeObject:str fromList:kActiveList];
            }
            
            NSString* userString = [[str componentsSeparatedByString:@"@"] objectAtIndex:0];
            if ([userNames containsObject:userString])
            {
                [userNames removeObject:userString];
                [Utils removeObject:str fromList:kActiveList];
            }
            
           for (id dic in messages)
           {
               if ([dic isKindOfClass:[NSMutableDictionary class]])
               {
                   dic = (NSMutableDictionary*)dic;
                   
                    if ([(NSString*)[dic objectForKey:@"UserName"] isEqualToString:str])
                    {
                        [toDelete addObject:dic];
                    }
               }
           }
            
        }
    }
    
    for (id obj in toDelete)
    {
        if ([messages containsObject:obj])
        {
            [messages removeObject:obj];
        }
    }
}

- (void) reloadBlockAndRejectList
{
    ReleaseObject(blockList);
    blockList = [[NSMutableArray alloc] initWithArray:[self arrayFromUserDefaultForKey:kBlockList]];
    if ([blockList count] > 0)
    {
        ReleaseObject(blockUserImageList);
        blockUserImageList = [[NSMutableArray alloc] initWithArray:[self userNameDictionaryArrayFromArray:blockList]];
    }
    ReleaseObject(rejectedList);
    rejectedList = [[NSMutableArray alloc] initWithArray:[self arrayFromUserDefaultForKey:kRejectList]];
    
    if ([rejectedList count] > 0)
    {
        ReleaseObject(rejectedUserImageList);
        rejectedUserImageList = [[NSMutableArray alloc] initWithArray:[self userNameDictionaryArrayFromArray:rejectedList]];
    }
    ReleaseObject(activeLocalList);
    activeLocalList = [[NSMutableArray alloc] initWithArray:[self arrayFromUserDefaultForKey:kActiveList]];
    
    if ([activeLocalList count] > 0)
    {
        ReleaseObject(newActiveUserImageList);
        newActiveUserImageList = [[NSMutableArray alloc] initWithArray:[self userNameDictionaryArrayFromArray:activeLocalList]];
    }
}

- (NSArray*) userNameDictionaryArrayFromArray:(NSArray*)objArray
{
    NSMutableArray* arr =[[NSMutableArray alloc] init];
    for (int i = 0; i < [objArray count]; i++)
    {
        NSMutableDictionary* dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[objArray objectAtIndex:i] forKey:@"UserName"];
        [arr addObject:dic];
        ReleaseObject(dic);
    }
    
    return arr;
}

- (void) createList:(NSString*)list array:(NSArray*)array
{
    XMPPPrivacy* xmppPrivacy = [[XMPPPrivacy alloc] init];
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSMutableArray *arrayPrivacy = [[NSMutableArray alloc] init];
    for (int i = 0; i<[array count];i++)
    {
        NSInteger RandomOredr = [Utils getRandomNumberBetween:1 to:100000];
        [arrayPrivacy addObject:(NSXMLElement*)[self elementWithJabber:[array objectAtIndex:i] order:RandomOredr]];
        
    }
    [xmppPrivacy setListWithName:list items:arrayPrivacy];
    [xmppPrivacy setActiveListName:list];
}

- (void) fetcheImagesFrom:(NSArray*)userList forSection:(ImageFetchIndex)imageIndex
{
    NSMutableArray* userNameArray = [[NSMutableArray alloc] init];
    
    if (imageIndex != kActiveUser)
    {
        for (int i = 0; i < [userList count]; i++)
        {
            [userNameArray addObject:[[[userList objectAtIndex:i]componentsSeparatedByString:@"@"]objectAtIndex:0]];
        }

    }
    else
    {
        userNameArray = [NSMutableArray arrayWithArray:userList];
    }
    NSString* userNameString = [userNameArray componentsJoinedByString:@","];
    sectionForImage = imageIndex;
    [self callWebService:userNameString];
}

- (NSXMLElement*) elementWithJabber:(NSString*)jabberId order:(NSInteger) order
{
    NSXMLElement* newElement = [XMPPPrivacy privacyItemWithType:@"jid" value:jabberId action:@"deny" order:order];
    [XMPPPrivacy blockIQs:newElement];
    [XMPPPrivacy blockMessages:newElement];
    [XMPPPrivacy blockPresenceIn:newElement];
    [XMPPPrivacy blockPresenceOut:newElement];
    
    return newElement;
}

- (void) privacyListName:(NSString*)listName previousList:(NSArray*)previousList update:(NSArray*)updateArray option:(NSInteger) option
{
    XMPPPrivacy* xmppPrivacy = [[XMPPPrivacy alloc] init];
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSMutableArray *arrayPrivacy = [[NSMutableArray alloc] init];
    NSString* currentuserJabberID = [[NSUserDefaults standardUserDefaults] objectForKey:kXMPPmyJID1];
    
    if ([previousList count] > 0)
    {
        for (int i = 0; i < [previousList count]; i++)
        {
            NSXMLElement* previousElement = [[NSXMLElement alloc] init];
            previousElement = (NSXMLElement*)[previousList objectAtIndex:i];
            NSXMLElement* value = (NSXMLElement*)[previousElement attributeForName:@"value"];
            NSXMLElement* oredr = (NSXMLElement*)[previousElement attributeForName:@"order"];
            NSString* str1 = [value stringValue];
            NSString* str2 = [oredr stringValue];
            NSInteger oredrNumber = [str2 integerValue];
            
            switch (option)
            {
                case 1:///// Adding the jabber id to the list
                {
                    if (![str1 isEqualToString:currentuserJabberID] && ![updateArray containsObject:str1])
                        [arrayPrivacy addObject:(NSXMLElement*) [self elementWithJabber:str1 order:oredrNumber]];
                    
                  //  if (![updateArray containsObject:str1])
                    //{
                    //    [arrayPrivacy addObject:(NSXMLElement*) [self elementWithJabber:str1 order:oredrNumber]];
                    //}
                    
                    for(int i = 0; i < [updateArray count]; i++)
                    {
                        NSString* jabberID = [updateArray objectAtIndex:i];
                        
                        if (![jabberID isEqualToString:currentuserJabberID] && ![jabberID isEqualToString:str1])
                        {
                            NSInteger RandomOredr = [Utils getRandomNumberBetween:1 to:100000];
                            [arrayPrivacy addObject:(NSXMLElement*)[self elementWithJabber:jabberID order:RandomOredr]];
                        }
                        
                    }
                    break;
                }
                case 2:////// Removing the jabber id to the list
                {
                    if (![updateArray containsObject:str1] && ![str1 isEqualToString:currentuserJabberID])
                    {
                        [arrayPrivacy addObject:(NSXMLElement*)[self elementWithJabber:str1 order:oredrNumber]];
                    }
                    break;
                }
                default:
                    break;
            }
        }
    }
    else if (option == 1)
    {
        for(int i = 0; i < [updateArray count]; i++)
        {
            NSString* jabberID = [updateArray objectAtIndex:i];
            
            if(![jabberID isEqualToString:currentuserJabberID])
            {
                NSInteger RandomOredr = [Utils getRandomNumberBetween:1 to:100000];
                [arrayPrivacy addObject:(NSXMLElement*)[self elementWithJabber:[updateArray objectAtIndex:i] order:RandomOredr]];
            }
        }
    }
    
    [xmppPrivacy setListWithName:listName items:arrayPrivacy];
    [xmppPrivacy setActiveListName:listName];
}

- (void) createListWithName:(NSString*)name jabber:(NSString*) jabberId previous:(NSArray*) previousItems
{
    XMPPPrivacy *xmppPrivacy = [[XMPPPrivacy alloc] init];
    
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSInteger randonOrder = (NSInteger)[Utils getRandomNumberBetween:1 to:100000];

    
    NSXMLElement *privacyElement = [XMPPPrivacy privacyItemWithType:@"jid" value:jabberId action:@"deny" order:randonOrder];
    [XMPPPrivacy blockIQs:privacyElement];
    [XMPPPrivacy blockMessages:privacyElement];
    [XMPPPrivacy blockPresenceIn:privacyElement];
    [XMPPPrivacy blockPresenceOut:privacyElement];
    NSLog(@"-------> PRIVACY ELEMENT: %@", privacyElement);
    
    NSMutableArray *arrayPrivacy = [[NSMutableArray alloc] initWithObjects:privacyElement, nil];
    if (previousItems != nil)
   {
       for (int i = 0; i < [previousItems count]; i++)
        {
            NSXMLElement* previousElement = [[NSXMLElement alloc] init];
           previousElement = (NSXMLElement*)[previousItems objectAtIndex:i];
            NSXMLElement* value = (NSXMLElement*)[previousElement attributeForName:@"value"];
            NSXMLElement* oredr = (NSXMLElement*)[previousElement attributeForName:@"order"];
            NSString* str1 = [value stringValue];
            NSString* str2 = [oredr stringValue];
            NSInteger oredrNumber = [str2 integerValue];
            
            if (![str1 isEqualToString:jabberId])
            {
                NSXMLElement* newElement = [XMPPPrivacy privacyItemWithType:@"jid" value:str1 action:@"deny" order:oredrNumber];
                [XMPPPrivacy blockIQs:newElement];
                [XMPPPrivacy blockMessages:newElement];
                [XMPPPrivacy blockPresenceIn:newElement];
                [XMPPPrivacy blockPresenceOut:newElement];
                [arrayPrivacy addObject:newElement];
            }
        }
    }
    
    [xmppPrivacy setListWithName:name items:arrayPrivacy];
    [xmppPrivacy setActiveListName:name];
}


- (void) onAcceptBtn:(id) sender
{
    UIButton* btn = (UIButton*)sender;
    NSXMLElement *accept = [NSXMLElement elementWithName:@"presence"];
    UITableViewCell* cell;
    UITableView *tv;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *contentView = (UIView *)[btn superview];
        cell = (UITableViewCell *)[contentView superview];
        tv = (UITableView *)cell.superview.superview;
    }
    else
    {
        cell = (UITableViewCell*)[btn superview];
        tv=(UITableView *)[cell superview];
    }
    
    
    NSIndexPath *indexPath = [(UITableView *)tv indexPathForCell:(UITableViewCell *)cell];
    NSLog(@"indexpath  %d",indexPath.section);
    
    
    NSInteger section=[[tView indexPathForCell:(UITableViewCell *)cell] section];
    
    NSString* acceptedUserId = nil;
    
    if (section == 1)
    {
        acceptedUserId = [blockList objectAtIndex:btn.tag];
        [accept addAttributeWithName:@"to" stringValue:[blockList objectAtIndex:btn.tag]];
        [accept addAttributeWithName:@"type" stringValue:@"subscribe"];
        
        [gCXMPPController.xmppStream sendElement:accept];
        
        //sending message to user
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"Hello"];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[blockList objectAtIndex:btn.tag]];
        [message addChild:body];
        
        [gCXMPPController.xmppStream sendElement:message];
        
        AppDelegate *appDel = APP_DELEGATE;
        NSManagedObjectContext *context = appDel.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid LIKE[c] %@",[blockList objectAtIndex:btn.tag]];
        [fetchRequest setPredicate:predicate];
        predicate=nil;
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
        fetchRequest = nil;
        for(Request *req in array)
        {
            [appDel.managedObjectContext deleteObject:req];
            if(![appDel.managedObjectContext save:&error])
            {
                //
            }
        }
        [self arrayFromUserDefaultForKey:kBlockListToRemove update:[blockList objectAtIndex:btn.tag]];
        [self arrayFromUserDefaultForKey:kRejectListToremove update:[blockList objectAtIndex:btn.tag]];
        [self arrayFromUserDefaultForKey:kActiveList update:[blockList objectAtIndex:btn.tag]];
        [Utils removeObject:[blockList objectAtIndex:btn.tag] fromList:kRejectList];
        [Utils removeObject:[blockList objectAtIndex:btn.tag] fromList:kBlockList];
        
        [Utils removeObject:[[[blockList objectAtIndex:btn.tag] componentsSeparatedByString:@"@"] objectAtIndex:0] fromList:kBlockedRejectedBy];
        //[self retreiveListName:kBlockList];
      //  [self retreiveListName:kRejectList];
        [activeJabberIdList removeAllObjects];
        [userNames removeAllObjects];
        [messages removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    else if (section == 2)
    {
        acceptedUserId = [rejectedList objectAtIndex:btn.tag];
        [accept addAttributeWithName:@"to" stringValue:[rejectedList objectAtIndex:btn.tag]];
        [accept addAttributeWithName:@"type" stringValue:@"subscribe"];
        
        [gCXMPPController.xmppStream sendElement:accept];
        
        //sending message to user
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:@"Hello"];
        NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
        [message addAttributeWithName:@"type" stringValue:@"chat"];
        [message addAttributeWithName:@"to" stringValue:[rejectedList objectAtIndex:btn.tag]];
        [message addChild:body];
        
        [gCXMPPController.xmppStream sendElement:message];
        AppDelegate *appDel = APP_DELEGATE;
        NSManagedObjectContext *context = appDel.managedObjectContext;
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
        
        [fetchRequest setEntity:entity];
        
        // Set the batch size to a suitable number.
        [fetchRequest setFetchBatchSize:20];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid LIKE[c] %@",[rejectedList objectAtIndex:btn.tag]];
        [fetchRequest setPredicate:predicate];
        predicate=nil;
        NSError *error = nil;
        NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
        fetchRequest = nil;
        for(Request *req in array)
        {
            [appDel.managedObjectContext deleteObject:req];
            if(![appDel.managedObjectContext save:&error])
            {
                //
            }
        }
        [self arrayFromUserDefaultForKey:kRejectListToremove update:[rejectedList objectAtIndex:btn.tag]];
        [self arrayFromUserDefaultForKey:kBlockListToRemove update:[rejectedList objectAtIndex:btn.tag]];
        [self arrayFromUserDefaultForKey:kActiveList update:[rejectedList objectAtIndex:btn.tag]];
        [Utils removeObject:[rejectedList objectAtIndex:btn.tag] fromList:kRejectList];
        [Utils removeObject:[rejectedList objectAtIndex:btn.tag] fromList:kBlockList];

        //[self retreiveListName:kRejectList];
      //  [self retreiveListName:kBlockList];
        [activeJabberIdList removeAllObjects];
        [messages removeAllObjects];
        [userNames removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    
    if (![activeJabberIdList containsObject:acceptedUserId])
        [Utils showAlertView:kAlertTitle message:kErrMsgToListUpdate delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else
        [Utils showAlertView:kAlertTitle message:kAlertMsgOnListUpdationDone delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

- (void) unsubscribeUserFrom:(NSArray*) userArray index:(NSInteger)index
{
    NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
    
    [body addAttributeWithName:@"to" stringValue:[userArray objectAtIndex:index]];
    [body addAttributeWithName:@"type" stringValue:@"unsubscribed"];
    
    [gCXMPPController.xmppStream sendElement:body];
    
    NetworkService *netowrk = [[NetworkService alloc] init];
    
    NSMutableArray *result = [netowrk sendSynchronusRequest:[NSString stringWithFormat:@"reminders/add?buyer=%@&seller=%@",[[[userArray objectAtIndex:index]componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID1]componentsSeparatedByString:@"@"] objectAtIndex:0]] dataToSend:nil delegate:nil requestMethod:@"POST" requestType:nil];
    AppDelegate *appDel = APP_DELEGATE;
    NSManagedObjectContext *context = appDel.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid LIKE[c] %@",[userArray objectAtIndex:index]];
    [fetchRequest setPredicate:predicate];
    predicate=nil;
    NSError *error = nil;
    NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
    fetchRequest = nil;
    for(Request *req in array)
    {
        [appDel.managedObjectContext deleteObject:req];
        if(![appDel.managedObjectContext save:&error])
        {
            //
        }
    }

}

- (void) onBlockBtn:(id) sender
{
    UIButton* btn = (UIButton*)sender;
    UITableViewCell* cell;
    UITableView* tv;

    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *contentView = (UIView *)[btn superview];
        cell = (UITableViewCell *)[contentView superview];
        tv = (UITableView *)cell.superview.superview;
    }
    else
    {
        cell = (UITableViewCell*)[btn superview];
        tv = (UITableView* )[cell superview];
    }
    NSIndexPath *indexPath = [(UITableView *)tv indexPathForCell:(UITableViewCell *)cell];
    //NSLog(@"indexpath  %d",indexPath.section);
    NSInteger section = indexPath.section;
    //NSString* selcteduser = [[messages objectAtIndex:btn.tag] valueForKey:@"UserName"];
    
    if (section == 0)
    {
        [self arrayFromUserDefaultForKey:kBlockListToAdd update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils removeObject:[activeLocalList objectAtIndex:btn.tag] fromList:kBlockListToRemove];
        [self arrayFromUserDefaultForKey:kRejectListToremove update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils removeObject:[activeLocalList objectAtIndex:btn.tag] fromList:kRejectList];
        [Utils arrayFromUserDefaultForKey:kBlockList update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils arrayFromUserDefaultForKey:kNewBlockEntry update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils removeObject:[activeLocalList objectAtIndex:btn.tag] fromList:kNewRejectEntry];
        [self retreiveListName:kBlockList];
        [self retreiveListName:kRejectList];
        [self unsubscribeUserFrom:activeLocalList index:btn.tag];
        [activeLocalList removeObjectAtIndex:btn.tag];

        //[userNames removeObjectAtIndex:btn.tag];
       // [activeJabberIdList removeObjectAtIndex:btn.tag];
        [userNames removeAllObjects];
        [activeJabberIdList removeAllObjects];
        [messages removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    else if (section == 2)
    {
        [self arrayFromUserDefaultForKey:kBlockListToAdd update:[rejectedList objectAtIndex:btn.tag]];
        [Utils removeObject:[rejectedList objectAtIndex:btn.tag] fromList:kBlockListToRemove];

        [self arrayFromUserDefaultForKey:kRejectListToremove update:[rejectedList objectAtIndex:btn.tag]];
        [Utils removeObject:[rejectedList objectAtIndex:btn.tag] fromList:kRejectList];
        [Utils arrayFromUserDefaultForKey:kBlockList update:[rejectedList objectAtIndex:btn.tag]];
        [Utils arrayFromUserDefaultForKey:kNewBlockEntry update:[rejectedList objectAtIndex:btn.tag]];
        [Utils removeObject:[rejectedList objectAtIndex:btn.tag] fromList:kNewRejectEntry];
        [self retreiveListName:kBlockList];
        [self retreiveListName:kRejectList];
        [self unsubscribeUserFrom:rejectedList index:btn.tag];
        [messages removeAllObjects];
        [userNames removeAllObjects];
        [activeJabberIdList removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    
    [Utils showAlertView:kAlertTitle message:kErrMsgToListUpdate delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}

- (void) onRejectBtn:(id) sender
{
    UIButton* btn = (UIButton*)sender;
    UITableViewCell* cell;
    UITableView* tv;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0"))
    {
        UIView *contentView = (UIView *)[btn superview];
        cell = (UITableViewCell *)[contentView superview];
        tv = (UITableView *)cell.superview.superview;
    }
    else
    {
        cell = (UITableViewCell*)[btn superview];
        tv = (UITableView* )[cell superview];
    }
    NSIndexPath *indexPath = [(UITableView *)tv indexPathForCell:(UITableViewCell *)cell];
   // NSLog(@"indexpath  %d",indexPath.section);
    NSInteger section = indexPath.section;
    //NSString* selcteduser = [[messages objectAtIndex:btn.tag] valueForKey:@"UserName"];
   // NSArray* selecteduserArray = [[[[messages objectAtIndex:btn.tag] valueForKey:@"UserName"]componentsSeparatedByString:@"@"];

    if (section == 0)
    {
        [self arrayFromUserDefaultForKey:kRejectListToAdd update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils removeObject:[activeLocalList objectAtIndex:btn.tag] fromList:kRejectListToremove];

        [self arrayFromUserDefaultForKey:kBlockListToRemove update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils removeObject:[activeLocalList objectAtIndex:btn.tag] fromList:kBlockList];
        [self arrayFromUserDefaultForKey:kRejectList update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils arrayFromUserDefaultForKey:kNewRejectEntry update:[activeLocalList objectAtIndex:btn.tag]];
        [Utils removeObject:[activeLocalList objectAtIndex:btn.tag] fromList:kNewBlockEntry];
        [self unsubscribeUserFrom:activeLocalList index:btn.tag];
        [self retreiveListName:kRejectList];
        [self retreiveListName:kBlockList];
        [rejectedList addObject:[activeLocalList objectAtIndex:btn.tag]];
        [blockList removeObject:[activeLocalList objectAtIndex:btn.tag]];
       // [activeLocalList removeObjectAtIndex:btn.tag];
        [userNames removeAllObjects];
        [messages removeAllObjects];
        [activeJabberIdList removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    else if (section == 1)
    {
        [self arrayFromUserDefaultForKey:kRejectListToAdd update:[blockList objectAtIndex:btn.tag]];
        [Utils removeObject:[blockList objectAtIndex:btn.tag] fromList:kRejectListToremove];

        [self arrayFromUserDefaultForKey:kBlockListToRemove update:[blockList objectAtIndex:btn.tag]];
        [self retreiveListName:kRejectList];
        [self retreiveListName:kBlockList];
        [Utils removeObject:[blockList objectAtIndex:btn.tag] fromList:kBlockList];
        [self arrayFromUserDefaultForKey:kRejectList update:[blockList objectAtIndex:btn.tag]];
        [self unsubscribeUserFrom:blockList index:btn.tag];
        [Utils arrayFromUserDefaultForKey:kNewRejectEntry update:[blockList objectAtIndex:btn.tag]];
        [Utils removeObject:[blockList objectAtIndex:btn.tag] fromList:kNewBlockEntry];
        [rejectedList addObject:[blockList objectAtIndex:btn.tag]];
        [blockList removeObjectAtIndex:btn.tag];
        [userNames removeAllObjects];
        [activeJabberIdList removeAllObjects];
        [messages removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    
    [Utils showAlertView:kAlertTitle message:kErrMsgToListUpdate delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
}


//+ (void) saveListInUserDefault:(NSString*) listname listArray:(NSArray*) listArray
//{
 //   NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
 //   NSMutableDictionary* listDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:listname]];
//    NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
 //   [listDic removeObjectForKey:userid];
//    [listDic setObject:listArray forKey:userid];
//    [[NSUserDefaults standardUserDefaults] setObject:listDic forKey:listname];
 //   [userDefault release];
//    [listDic release];

//}

#pragma mark - XMPPPrivacy class Delegate Methods

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListNames:(NSArray *)listNames
{
   // NSLog(@"didReceiveListName method called");
    
   // NSLog(@"%@", listNames);
    
    if (![listNames containsObject:kRejectList])
    {
       // [Utils removeListInUserDefault:kRejectList];
      //  NSLog(@"Reject list was not found------------------------------------");
        NSMutableArray* listToAdd = [[NSMutableArray alloc] initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kRejectListToAdd]];
        [self createList:kRejectList array:[self arrayFromUserDefaultForKey:kRejectList]];
        
        if ([listToAdd count] != 0)
        {
            //NSArray* arr = [[NSArray alloc] init];
           // [self privacyListName:kRejectList previousList:arr update:listToAdd option:1];
            [Utils removeListInUserDefault:kRejectListToAdd];
           // ReleaseObject(arr);
          //  [self retreiveListName:kRejectList];
        }
       // [self retreiveListName:kBlockList];
        ReleaseObject(listToAdd);
    }
    
    if (![listNames containsObject:kBlockList])
    {
       // [Utils removeListInUserDefault:kBlockList];
        //NSLog(@"Block list was not found.----------------------------");
        NSMutableArray* listToAdd = [[NSMutableArray alloc] initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kBlockListToAdd]];
        
        [self createList:kBlockList array:[self arrayFromUserDefaultForKey:kBlockList]];
        
        if ([listToAdd count] != 0)
        {
            //NSArray* arr = [[NSArray alloc] init];
            
           // [self privacyListName:kBlockList previousList:arr update:listToAdd option:1];
            [Utils removeListInUserDefault:kBlockListToAdd];
          //  ReleaseObject(arr);
           // [self retreiveListName:kBlockList];
        }
        ReleaseObject(listToAdd);
       // [self retreiveListName:kRejectList];
    }
     [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListNamesDueToError:(id)error
{
    //NSLog(@"didNotREceiveListNameDuwto Error method called");

 [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListWithName:(NSString *)name items:(NSArray *)items
{
    //NSLog(@"didReceiveListWithName method called");
    
    
   // NSLog(@"%@", items);
    
    if ([name isEqualToString: kRejectList])
    {
                //NSLog(@"Reject list was found------------------------------------");
        
        NSMutableArray* listToAdd = [[NSMutableArray alloc] initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kRejectListToAdd]];
        NSMutableArray* listToRemove = [[NSMutableArray alloc] initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kRejectListToremove]];
        
        if ([listToAdd count] != 0)
        {
          //  [self privacyListName:kRejectList previousList:items update:listToAdd option:1];
            [Utils removeListInUserDefault:kRejectListToAdd];
        }
        
        if ([listToRemove count] !=0)
        {
            //[self privacyListName:kRejectList previousList:items update:listToRemove option:2];
           // [Utils removeListInUserDefault:kRejectListToremove];
        }
        
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [items count]; i++)
        {
            NSXMLElement* previousElement = [[NSXMLElement alloc] init];
            previousElement = (NSXMLElement*) [items objectAtIndex:i];
            NSXMLElement* value = (NSXMLElement*)[previousElement attributeForName:@"value"];
            NSString* str = [value stringValue];
            [tempArray addObject:str];
            [previousRejectedList addObject:str];
            //NSLog(@"Previous Rejected List updated with -----------------------------------%@",str);
            [Utils removeObject:str fromList:kNewRejectEntry];
            if (![listToRemove containsObject:str])
            {
                [Utils arrayFromUserDefaultForKey:kRejectList update:str];
                [Utils removeObject:str fromList:kBlockList];
               // [previousRejectedList removeObject:str];
            }
        }
        
        //[Utils saveListInUserDefault:kRejectList listArray:tempArray];
        ReleaseObject(tempArray);
        
        ReleaseObject(rejectedList);
        NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
        NSDictionary* rejectDic = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:kRejectList]];
        NSString* userid = (NSString*)[userDefault objectForKey:@"USERID"];
        rejectedList = [[NSMutableArray alloc] initWithArray:(NSArray*)[rejectDic objectForKey:userid]];
        [self createList:kRejectList array:[self arrayFromUserDefaultForKey:kRejectList]];

        [self reloadBlockAndRejectList];
        [activeJabberIdList removeAllObjects];
        [userNames removeAllObjects];
        [messages removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
        ReleaseObject(listToAdd);
        ReleaseObject(listToRemove);
    }
    else if ([name isEqualToString: kBlockList])
    {
        //NSLog(@"Blcok List was found --------------------------------------");
        
        NSMutableArray* listToAdd = [[NSMutableArray alloc]initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kBlockListToAdd]];
        NSMutableArray* listToRemove = [[NSMutableArray alloc] initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kBlockListToRemove]];
        
        if ([listToAdd count] != 0)
        {
            //[self createList:kBlockList array:<#(NSArray *)#>]
            //[self privacyListName:kBlockList previousList:items update:listToAdd option:1];
            [Utils removeListInUserDefault:kBlockListToAdd];
        }
        
        if ([listToRemove count] != 0)
        {
           // [self privacyListName:kBlockList previousList:items update:listToRemove option:2];
           // [Utils removeListInUserDefault:kBlockListToRemove];
        }
        
        
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [items count]; i++)
        {
            NSXMLElement* previousElement = [[NSXMLElement alloc] init];
            previousElement = (NSXMLElement*)[items objectAtIndex:i];
            NSXMLElement* value = (NSXMLElement*)[previousElement attributeForName:@"value"];
            NSString* str1 = [value stringValue];
            [tempArray addObject:str1];
            [previousBlockList addObject:str1];
            [Utils removeObject:str1 fromList:kNewBlockEntry];
          //  NSLog(@"Previous block list updated with ---------------------------------------------------------%@",str1);
            
            if (![listToRemove containsObject:str1])
            {
                [Utils arrayFromUserDefaultForKey:kBlockList update:str1];
                [Utils removeObject:str1 fromList:kRejectList];
                //[previousBlockList removeObject:str1];
            }
        }
        //[Utils arrayFromUserDefaultForKey:tempArray update:kBlockList];
       // [Utils saveListInUserDefault:kBlockList listArray:tempArray];
        ReleaseObject(tempArray);
        ReleaseObject(blockList);
        NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
        NSDictionary* blockDic = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)[userDefault objectForKey:kBlockList]];
        NSString* userid = (NSString*)[userDefault objectForKey:@"USERID"];
        blockList = [[NSMutableArray alloc] initWithArray:(NSArray*)[blockDic objectForKey:userid]];
        [self createList:kBlockList array:[self arrayFromUserDefaultForKey:kBlockList]];

        [self reloadBlockAndRejectList];
        [userNames removeAllObjects];
        [messages removeAllObjects];
        [activeJabberIdList removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
        ReleaseObject(listToAdd);
        ReleaseObject(listToRemove);
    }
    [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListWithName:(NSString *)name error:(id)error
{
    //NSLog(@"didNotReceiveListWithName method called");
    
    if ([name isEqualToString:kRejectList] && [rejectedList count] != 0)
    {
        [self createList:kRejectList array:rejectedList];
    }
    
    if ([name isEqualToString:kBlockList] && [blockList count] != 0)
    {
        [self createList:kBlockList array:blockList];
    }
  //  [Utils removeListInUserDefault:name];
     [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetListWithName:(NSString *)name
{
    //NSLog(@"didSetListWithName method called");
    
    if ([name isEqualToString: kRejectList])
    {
        [self retreiveListName:kRejectList];

       // NSLog(@"Reject list has been developed.");
    }
    else if ([name isEqualToString:kBlockList])
    {
        [self retreiveListName:kBlockList];
    }
    [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetListWithName:(NSString *)name error:(id)error
{
  //  NSLog(@"didNotSetListWithName method called");
    [sender addDelegate:nil delegateQueue:nil];
}


- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetActiveListName:(NSString *)name
{
//NSLog(@"didSetActiveListName method called");
     [sender addDelegate:nil delegateQueue:nil];
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetActiveListName:(NSString *)name error:(id)error
{
   // NSLog(@"didNotSetActiveListName method called.");
     [sender addDelegate:nil delegateQueue:nil];
}

@end
