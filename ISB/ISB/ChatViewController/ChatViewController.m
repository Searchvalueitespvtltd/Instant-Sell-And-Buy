//
//  ChatViewController.m
//  ISB
//
//  Created by Neha Saxena on 26/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

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

- (void) saveListInUserDefault:(NSString*) listname listArray:(NSArray*) listArray;
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
    }
    
    NSArray * uniqueArray = [[NSOrderedSet orderedSetWithArray:array1] array];
//    [messages addObjectsFromArray:uniqueArray];
    NSString *selfUserName=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"email"]] ;
    for (id obj in uniqueArray) {
        NSMutableDictionary *temp=[[NSMutableDictionary alloc]init];
        [temp setObject:obj forKey:@"UserName"];
        
        if (![[[obj componentsSeparatedByString:@"@"]objectAtIndex:0] isEqualToString:selfUserName]) {
             [messages addObject:temp];
        }
       
    }
    for (id obj in arrayNames) {
        if (![[[obj componentsSeparatedByString:@"@"]objectAtIndex:0] isEqualToString:selfUserName]) {
            [userNames addObject:obj];
        }
    }
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
   
    // Do any additional setup after loading the view from its nib.
}
-(void )viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    activeJabberIdList = [[NSMutableArray alloc] init];
    imageArray= [[NSMutableArray alloc ] init];
    messages = [[NSMutableArray alloc ] init];
    userNames= [[NSMutableArray alloc ] init];
    [HttpRequestProcessor shareHttpRequest];
    [self retreiveListName:kBlockList];
    [self retreiveListName:kRejectList];

    [self usersAvailable];
//    [self testMessageArchiving];
    NSString * result;
    if ([userNames count]>0) {
        result = [userNames componentsJoinedByString:@","];
        [self callWebService:result];
    }
    
    ReleaseObject(blockList);
    ReleaseObject(rejectedList);
    NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
    NSDictionary* blockDic = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)[userDefault objectForKey:kBlockList]];
    NSDictionary* rejectDic = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:kRejectList]];
    NSString* userid = (NSString*)[userDefault objectForKey:@"USERID"];
    blockList = [[NSMutableArray alloc] initWithArray:(NSArray*)[blockDic objectForKey:userid]];
    rejectedList = [[NSMutableArray alloc] initWithArray:(NSArray*)[rejectDic objectForKey:userid]];
    [userDefault release];
    ReleaseObject(blockDic);
    ReleaseObject(rejectDic);
    [self getUserRequests];
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
    
    UIButton* firstButton = [[UIButton alloc] init];
    firstButton.tag = indexPath.row;
    
    UIButton* secondButton = [[UIButton alloc] init];
    
    secondButton.tag = indexPath.row;
    
    // addded by chetan..
    
    if (indexPath.section == 0)
    {
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        cell.tag = 0;
        
        // added by chetan ..
        UILabel *label=(UILabel*)[cell.contentView viewWithTag:10];
        
        label.text=[[[[messages objectAtIndex:indexPath.row] valueForKey:@"UserName"]componentsSeparatedByString:@"@"] objectAtIndex:0];
        //    cell.textLabel.text = [[[messages objectAtIndex:indexPath.row]componentsSeparatedByString:@"@"] objectAtIndex:0];
        label.highlightedTextColor = [UIColor blackColor];
        
        UIImageView *imgView=(UIImageView *)[cell.contentView viewWithTag:11];
        if ([[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]) {
            imgView.image=[[messages objectAtIndex:indexPath.row] valueForKey:@"Image"];
        }else
            imgView.image=[UIImage imageNamed:@"defaultIconChat2@2x.png"];
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
        label.text = [blockList objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        CGSize labelSize = label.frame.size;
        [firstButton setFrame:CGRectMake(label.frame.origin.x, (label.frame.origin.y + labelSize.height), 73, 37)];
        [firstButton setBackgroundImage:[UIImage imageNamed:@"reject(2).png"] forState:UIControlStateNormal];
        [firstButton addTarget:self action:@selector(onRejectBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:firstButton];
        
        [secondButton setFrame:CGRectMake(firstButton.frame.origin.x + firstButton.frame.size.width + 10, firstButton.frame.origin.y, 73, 37)];
        [secondButton setBackgroundImage:[UIImage imageNamed:@"accept.png"] forState:UIControlStateNormal];
        [secondButton addTarget:self action:@selector(onAcceptBtn:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:secondButton];;

    }
    else if(indexPath.section == 2)
    {
        cell.tag = 2;
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        cell.selectedBackgroundView = selectionColor;
        
        // added by chetan ..
        UILabel *label=(UILabel*)[cell.contentView viewWithTag:10];
        label.text = [rejectedList objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        chat.strUsername = [NSString stringWithFormat:@"%@",[[[[messages objectAtIndex:indexPath.row] valueForKey:@"UserName" ]componentsSeparatedByString:@"@"] objectAtIndex:0]];
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
            return [userNames count];
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
    
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        responseArray=[[NSMutableArray alloc]initWithArray:inResponseDic];
        
        [self performSelector:@selector(bringImages:) withObject:inResponseDic afterDelay:0];
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
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
            
            NSMutableDictionary *aTemp=[[NSMutableDictionary alloc]init];
            aTemp=[messages objectAtIndex:filteredIndexes];
//            [[messages objectAtIndex:indexPath.row] valueForKey:@"Image"]
            [aTemp setObject:img forKey:@"Image"];
            [messages replaceObjectAtIndex:filteredIndexes withObject:aTemp];
                               }
                 }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

#pragma mark - Private Methods

- (NSArray*) arrayFromUserDefaultForKey:(NSString*) key
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
    [arr addObject:object];
    [dic1 removeObjectForKey:userid];
    [dic1 setObject:arr forKey:userid];
    [userDefault setObject:dic1 forKey:key];
    [userDefault release];
}


- (void) retreiveListName:(NSString *)listName
{
    XMPPPrivacy* xmppPrivacy = [[XMPPPrivacy alloc] init];
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppPrivacy listWithName:listName];
}

- (void) privacyListName:(NSString*)listName previousList:(NSArray*)previousList update:(NSArray*) option:(NSInteger) option
{
    XMPPPrivacy* xmppPrivacy = [[XMPPPrivacy alloc] init];
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSMutableArray *arrayPrivacy = [[NSMutableArray alloc] init];
    if (previousList != nil)
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
            
            if (![str1 isEqualToString:@""])
            {
                NSXMLElement* newElement = [XMPPPrivacy privacyItemWithType:@"jid" value:str1 action:@"deny" order:oredrNumber];
                [XMPPPrivacy blockIQs:newElement];
                [XMPPPrivacy blockMessages:newElement];
                [XMPPPrivacy blockPresenceIn:newElement];
                [XMPPPrivacy blockPresenceOut:newElement];
                [arrayPrivacy addObject:newElement];
            }
            //ReleaseObject(previousElement);
        }
    }
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
            //ReleaseObject(previousElement);
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
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        UIView *contentView = (UIView *)[btn superview];
        cell = (UITableViewCell *)[contentView superview];
        tv = (UITableView *)cell.superview.superview;
        }
    else {
        cell = (UITableViewCell*)[btn superview];
        tv=(UITableView *)[cell superview];
    }
    
    
    NSIndexPath *indexPath = [(UITableView *)tv indexPathForCell:(UITableViewCell *)cell];
    NSLog(@"indexpath  %d",indexPath.section);
    
    
    NSInteger section=[[tView indexPathForCell:(UITableViewCell *)cell] section];
//    
//    NSInteger tagVal = cell.tag;
    
    if (section == 1)
    {
    
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
        [blockList removeObjectAtIndex:btn.tag];
//    
//NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
//    NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kBlockList]];
//    NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
  //  [BlockDic removeObjectForKey:userid];
  //  [BlockDic setObject:blockList forKey:userid];
   // [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kBlockList];
    //[userDefault release];
       // [BlockDic release];
        [self usersAvailable];
        [tView reloadData];
    }
    else if (section == 2)
    {
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
        [rejectedList removeObjectAtIndex:btn.tag];
//        NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
//        NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kRejectList]];
//        NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
//        
//        [BlockDic removeObjectForKey:userid];
//        [BlockDic setObject:rejectedList forKey:userid];
//        [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kRejectList];
//        [userDefault release];
//        [BlockDic release];
        [self usersAvailable];
        [tView reloadData];

    }

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
    NSLog(@"indexpath  %d",indexPath.section);
    NSInteger section = indexPath.section;
    
    if (section == 0)
    {
        [self arrayFromUserDefaultForKey:kBlockListToAdd update:[activeJabberIdList objectAtIndex:btn.tag]];
        [self createListWithName:kBlockList jabber:[activeJabberIdList objectAtIndex:btn.tag] previous:previousBlockList];
        [self unsubscribeUserFrom:activeJabberIdList index:btn.tag];
//
//        NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
//        
//        [body addAttributeWithName:@"to" stringValue:[activeJabberIdList objectAtIndex:btn.tag]];
//        [body addAttributeWithName:@"type" stringValue:@"unsubscribed"];
//        
//        [gCXMPPController.xmppStream sendElement:body];
//        
//        NetworkService *netowrk = [[NetworkService alloc] init];
//        
//        NSMutableArray *result = [netowrk sendSynchronusRequest:[NSString stringWithFormat:@"reminders/add?buyer=%@&seller=%@",[[[activeJabberIdList objectAtIndex:btn.tag]componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID1]componentsSeparatedByString:@"@"] objectAtIndex:0]] dataToSend:nil delegate:nil requestMethod:@"POST" requestType:nil];
//        AppDelegate *appDel = APP_DELEGATE;
//        NSManagedObjectContext *context = appDel.managedObjectContext;
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
//        
//        [fetchRequest setEntity:entity];
//        
//        // Set the batch size to a suitable number.
//        [fetchRequest setFetchBatchSize:20];
//        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid LIKE[c] %@",[activeJabberIdList objectAtIndex:btn.tag]];
//        [fetchRequest setPredicate:predicate];
//        predicate=nil;
//        NSError *error = nil;
//        NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
//        fetchRequest = nil;
//        for(Request *req in array)
//        {
//            [appDel.managedObjectContext deleteObject:req];
//            if(![appDel.managedObjectContext save:&error])
//            {
//                //
//            }
//        }
        [blockList addObject:[activeJabberIdList objectAtIndex:btn.tag]];
//        NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
//        NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kBlockList]];
//        NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
//        
//        [BlockDic removeObjectForKey:userid];
//        [BlockDic setObject:blockList forKey:userid];
//        [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kBlockList];
//        [userDefault release];
//        [BlockDic release];

        [userNames removeObjectAtIndex:btn.tag];
        [activeJabberIdList removeObjectAtIndex:btn.tag];
        [userNames removeAllObjects];
        [activeJabberIdList removeAllObjects];
        [self usersAvailable];
        [tView reloadData];
    }
    else if (section == 2)
    {
        [self arrayFromUserDefaultForKey:kBlockListToAdd update:[rejectedList objectAtIndex:btn.tag]];
        [self createListWithName:kBlockList jabber:[rejectedList objectAtIndex:btn.tag] previous:previousBlockList];
        [self arrayFromUserDefaultForKey:kRejectListToremove update:[rejectedList objectAtIndex:btn.tag]];
        
        [self unsubscribeUserFrom:rejectedList index:btn.tag];
        
        //NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
        
       // [body addAttributeWithName:@"to" stringValue:[rejectedList objectAtIndex:btn.tag]];
       // [body addAttributeWithName:@"type" stringValue:@"unsubscribed"];
        //
        //[gCXMPPController.xmppStream sendElement:body];
//        
//        NetworkService *netowrk = [[NetworkService alloc] init];
//        
//        NSMutableArray *result = [netowrk sendSynchronusRequest:[NSString stringWithFormat:@"reminders/add?buyer=%@&seller=%@",[[[rejectedList objectAtIndex:btn.tag] componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID1]componentsSeparatedByString:@"@"] objectAtIndex:0]] dataToSend: nil delegate:nil requestMethod:@"POST" requestType:nil];
//        AppDelegate *appDel = APP_DELEGATE;
//        NSManagedObjectContext *context = appDel.managedObjectContext;
//        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//        
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
//        
//        [fetchRequest setEntity:entity];
//        
//        // Set the batch size to a suitable number.
//        [fetchRequest setFetchBatchSize:20];
        
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid LIKE[c] %@",[rejectedList objectAtIndex:btn.tag]];
//        [fetchRequest setPredicate:predicate];
//        predicate=nil;
//        NSError *error = nil;
//        NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
//        fetchRequest = nil;
//        for(Request *req in array)
//        {
//            [appDel.managedObjectContext deleteObject:req];
//            if(![appDel.managedObjectContext save:&error])
//            {
//                //
//            }
//        }
        [blockList addObject:[rejectedList objectAtIndex:btn.tag]];
//        NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
//        NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kBlockList]];
//        NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
//        
//        [BlockDic removeObjectForKey:userid];
//        [BlockDic setObject:blockList forKey:userid];
//        [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kBlockList];
        [rejectedList removeObjectAtIndex:btn.tag];
//        NSMutableDictionary* rejectDic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:kRejectList]];
//        [rejectDic removeObjectForKey:userid];
//        [rejectDic setObject:rejectedList forKey:userid];
//        [[NSUserDefaults standardUserDefaults] setObject:rejectDic forKey:kRejectList];
//        [userDefault release];
//        [BlockDic release];
//        
//        [rejectDic release];
        [tView reloadData];
    }
}

- (void) onRejectBtn:(id) sender
{
    UIButton* btn = (UIButton*)sender;
    NSInteger section = 0;
    
    if (section == 0)
    {
        [self arrayFromUserDefaultForKey:kRejectListToAdd update:[activeJabberIdList objectAtIndex:btn.tag]];
        [self createListWithName:kRejectList jabber:[activeJabberIdList objectAtIndex:btn.tag] previous:previousRejectedList];
        [self unsubscribeUserFrom:activeJabberIdList index:btn.tag];
        [rejectedList addObject:[activeJabberIdList objectAtIndex:btn.tag]];
    }
    else if (section == 1)
    {
        [self arrayFromUserDefaultForKey:kRejectListToAdd update:[blockList objectAtIndex:btn.tag]];
        [self arrayFromUserDefaultForKey:kBlockListToRemove update:[blockList objectAtIndex:btn.tag]];
        [self createListWithName:kRejectList jabber:[blockList objectAtIndex:btn.tag] previous:previousRejectedList];
        [self unsubscribeUserFrom:blockList index:btn.tag];
        [rejectedList addObject:[blockList objectAtIndex:btn.tag]];
        [blockList removeObjectAtIndex:btn.tag];
//        NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
//        NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kBlockList]];
//        NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
//        
//        [BlockDic removeObjectForKey:userid];
//        [BlockDic setObject:blockList forKey:userid];
//        [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kBlockList];
//        NSMutableDictionary* rejectDic = [[NSMutableDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:kRejectList]];
//        [rejectDic removeObjectForKey:userid];
//        [rejectDic setObject:rejectedList forKey:userid];
//        [[NSUserDefaults standardUserDefaults] setObject:rejectDic forKey:kRejectList];
//        [userDefault release];
//        [BlockDic release];
        
    }
}


- (void) saveListInUserDefault:(NSString*) listname listArray:(NSArray*) listArray
{
    NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
    NSMutableDictionary* listDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:listname]];
    NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
    [listDic removeObjectForKey:userid];
    [listDic setObject:listArray forKey:userid];
    [[NSUserDefaults standardUserDefaults] setObject:listDic forKey:listname];
    [userDefault release];
    [listDic release];

}

#pragma mark - XMPPPrivacy class Delegate Methods

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListNames:(NSArray *)listNames
{
    NSLog(@"didReceiveListName method called");
    
    NSLog(@"%@", listNames);
     [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListNamesDueToError:(id)error
{
    NSLog(@"didNotREceiveListNameDuwto Error method called");

 [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListWithName:(NSString *)name items:(NSArray *)items
{
    NSLog(@"didReceiveListWithName method called");
    
    
    NSLog(@"%@", items);
    
    if ([name isEqualToString: kRejectList])
    {
        
        NSMutableArray* listToAdd = [[NSMutableArray alloc]initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kRejectListToAdd]];
        NSMutableArray* listToRemove = [[NSMutableArray alloc] initWithArray:(NSArray*)[self arrayFromUserDefaultForKey:kRejectListToremove]];
        
        
        
        
        
        ReleaseObject(previousRejectedList);
        previousRejectedList = [[NSMutableArray alloc] initWithArray:items];
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [previousRejectedList count]; i++)
        {
            NSXMLElement* previousElement = [[NSXMLElement alloc] init];
            previousElement = (NSXMLElement*) [previousRejectedList objectAtIndex:i];
            NSXMLElement* value = (NSXMLElement*)[previousElement attributeForName:@"value"];
            NSString* str = [value stringValue];
            [tempArray addObject:str];
           // ReleaseObject(previousElement);
          //  [previousElement release];
            
        }
        [self saveListInUserDefault:kRejectList listArray:tempArray];
        ReleaseObject(tempArray);
        
        ReleaseObject(rejectedList);
        NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
        NSDictionary* rejectDic = [[NSDictionary alloc] initWithDictionary:(NSDictionary*)[userDefault objectForKey:kRejectList]];
        NSString* userid = (NSString*)[userDefault objectForKey:@"USERID"];
        rejectedList = [[NSMutableArray alloc] initWithArray:(NSArray*)[rejectDic objectForKey:userid]];
        [tView reloadData];
        // [self retreiveListName:kBlockList];
    }
    else if ([name isEqualToString: kBlockList])
    {
        
        ReleaseObject(previousBlockList);
        previousBlockList = [[NSMutableArray alloc] initWithArray:items];
        NSMutableArray* tempArray = [[NSMutableArray alloc] init];
        for (int i = 0; i < [previousBlockList count]; i++)
        {
            NSXMLElement* previousElement = [[NSXMLElement alloc] init];
            previousElement = (NSXMLElement*)[previousBlockList objectAtIndex:i];
            NSXMLElement* value = (NSXMLElement*)[previousElement attributeForName:@"value"];
            NSString* str1 = [value stringValue];
            [tempArray addObject:str1];
            //ReleaseObject(previousElement);
           // [previousElement release];
            
        }
        [self createListWithName:kBlockList jabber:nil previous:previousBlockList];

        [self saveListInUserDefault:kBlockList listArray:tempArray];
        ReleaseObject(tempArray);
        ReleaseObject(blockList);
        NSUserDefaults* userDefault = [[NSUserDefaults alloc] init];
        NSDictionary* blockDic = [[NSDictionary alloc]initWithDictionary:(NSDictionary*)[userDefault objectForKey:kBlockList]];
        NSString* userid = (NSString*)[userDefault objectForKey:@"USERID"];
        blockList = [[NSMutableArray alloc] initWithArray:(NSArray*)[blockDic objectForKey:userid]];
        [tView reloadData];
    }
    [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListWithName:(NSString *)name error:(id)error
{
    NSLog(@"didNotReceiveListWithName method called");
     [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetListWithName:(NSString *)name
{
    NSLog(@"didSetListWithName method called");
    
    if ([name isEqualToString: kRejectList])
    {
        
        NSLog(@"Reject list has been developed.");
    }
    
    NSArray* Arr = [sender listWithName:kRejectList];
    
    NSLog(@"%@", Arr);
    
    NSArray* arr1 = [sender listWithName:kBlockList];
    NSLog(@"%@", arr1);
     [sender addDelegate:nil delegateQueue:nil];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetListWithName:(NSString *)name error:(id)error
{
    NSLog(@"didNotSetListWithName method called");
 [sender addDelegate:nil delegateQueue:nil];
}


- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetActiveListName:(NSString *)name
{
    NSLog(@"didSetActiveListName method called");
     [sender addDelegate:nil delegateQueue:nil];
}
- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetActiveListName:(NSString *)name error:(id)error
{
    NSLog(@"didNotSetActiveListName method called.");
     [sender addDelegate:nil delegateQueue:nil];
}

@end
