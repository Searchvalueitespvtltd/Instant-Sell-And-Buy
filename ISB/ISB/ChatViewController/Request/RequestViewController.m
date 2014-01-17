//
//  RequestViewController.m
//  ISB
//
//  Created by Neha Saxena on 16/10/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "RequestViewController.h"
#import "CXMPPController.h"
#import "Request.h"

#define KBlockAlertMsg @"Do you want to Block the Buyer?"
#define kRejectAlertMsg @"Do you want to Reject the Buyer?"

@interface RequestViewController ()

- (void) blockButtonPresseed:(id) sender;

@end

@implementation RequestViewController
@synthesize tView;
@synthesize userNames;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     [self retreiveList:kRejectList];
     [self retreiveList:kBlockList];
    self.userNames = [[NSMutableArray alloc]init];
    [self getUserRequests];
    NSLog(@"%@", self.userNames);
//    xmppprivacy = [[XMPPPrivacy alloc] init];
//    xmppprivacy.delegate = self;
//    
//    [xmppprivacy setListWithName:@"Blocked list" items:self.userNames];
//    [xmppprivacy setActiveListName:@"Blocked list"];
//    NSArray* str = [xmppprivacy activeList];
//    NSArray* arr = [xmppprivacy listNames];
//    
//    NSLog(@"ARR --------------->%@ \n %@",arr, str);
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - Database methods

- (void)getUserRequests
{
    AppDelegate *appDel = APP_DELEGATE;
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
    [self.userNames removeAllObjects];
    for(Request *req in array)
    {
        [self.userNames addObject:req.jid];
    }
    [tView reloadData];
}
- (void)removeObjectfromIndex:(NSUInteger)index
{
    AppDelegate *appDel = APP_DELEGATE;
    NSManagedObjectContext *context = appDel.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Request" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"jid LIKE[c] %@",[self.userNames objectAtIndex:index]];
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
    [self.userNames removeObjectAtIndex:index];
    [self.tView reloadData];
}
//
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table view

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"requestCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    // addded by chetan..
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    // added by chetan ..
    UILabel *label=(UILabel*)[cell.contentView viewWithTag:10];
    label.text=[NSString stringWithFormat:@"%@ wants to be your friend.",[[[[self.userNames objectAtIndex:indexPath.row]componentsSeparatedByString:@"@"] objectAtIndex:0] uppercaseString]];
    //    cell.textLabel.text = [[[messages objectAtIndex:indexPath.row]componentsSeparatedByString:@"@"] objectAtIndex:0];
    label.highlightedTextColor = [UIColor blackColor];
    
    UIButton *acceptBtn = (UIButton*)[cell.contentView viewWithTag:20];
    [acceptBtn addTarget:self action:@selector(Accept:) forControlEvents:UIControlEventTouchUpInside];
    acceptBtn.tag = indexPath.row;
    
    UIButton *declineBtn = (UIButton*)[cell.contentView viewWithTag:30];
    [declineBtn addTarget:self action:@selector(Decline:) forControlEvents:UIControlEventTouchUpInside];
    declineBtn.tag = indexPath.row;
    
    UIButton* blockBtn = (UIButton*)[cell.contentView viewWithTag:40];
    [blockBtn addTarget:self action:@selector(blockButtonPresseed:) forControlEvents:UIControlEventTouchUpInside];
    blockBtn.tag = indexPath.row;
    
	return cell;
	
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [userNames count];
	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	
	return 1;
	
}

- (void) retreiveList:(NSString*)listName
{
    XMPPPrivacy *xmppPrivacy = [[XMPPPrivacy alloc] init];
    
    
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    [xmppPrivacy listWithName:listName];
}

- (void) createListWithName:(NSString*)name jabber:(NSString*) jabberId element:(NSArray*) previousItems
{
    XMPPPrivacy *xmppPrivacy = [[XMPPPrivacy alloc] init];
    
    [xmppPrivacy activate:gCXMPPController.xmppStream];
    
    [xmppPrivacy addDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSXMLElement *privacyElement = [XMPPPrivacy privacyItemWithType:@"jid" value:jabberId action:@"deny" order:1];
    [XMPPPrivacy blockIQs:privacyElement];
    [XMPPPrivacy blockMessages:privacyElement];
    [XMPPPrivacy blockPresenceIn:privacyElement];
    [XMPPPrivacy blockPresenceOut:privacyElement];
    NSLog(@"-------> PRIVACY ELEMENT: %@", privacyElement);
    
    NSMutableArray *arrayPrivacy = [[NSMutableArray alloc] initWithObjects:privacyElement, nil];
    if (previousItems != nil)
    {
        [arrayPrivacy addObjectsFromArray:previousItems];
    }
    [xmppPrivacy setListWithName:name items:arrayPrivacy];
}

- (void)Accept:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSXMLElement *accept = [NSXMLElement elementWithName:@"presence"];
    
    [accept addAttributeWithName:@"to" stringValue:[self.userNames objectAtIndex:button.tag]];
    [accept addAttributeWithName:@"type" stringValue:@"subscribed"];
    
    [gCXMPPController.xmppStream sendElement:accept];
    
    //sending message to user
    NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
    [body setStringValue:@"Hello"];
    NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
    [message addAttributeWithName:@"type" stringValue:@"chat"];
    [message addAttributeWithName:@"to" stringValue:[self.userNames objectAtIndex:button.tag]];
    [message addChild:body];
    
    [gCXMPPController.xmppStream sendElement:message];
    [self removeObjectfromIndex:button.tag];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)Decline:(id)sender
{
    
       UIButton *button = (UIButton*)sender;
   
   [self createListWithName:kRejectList jabber:[self.userNames objectAtIndex:button.tag] element:PreviousRejectList];

    NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
    NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kRejectList]];
    NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
    
    NSMutableArray* BlockArr = [[NSMutableArray alloc]initWithArray:(NSArray*)[BlockDic objectForKey:userid]];
    [BlockArr addObject:[userNames objectAtIndex:button.tag]];
    [BlockDic removeObjectForKey:userid];
    [BlockDic setObject:BlockArr forKey:userid];
    [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kRejectList];
    
    [userDefault release];
    
    NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
    
    [body addAttributeWithName:@"to" stringValue:[self.userNames objectAtIndex:button.tag]];
    [body addAttributeWithName:@"type" stringValue:@"unsubscribed"];
    
    [gCXMPPController.xmppStream sendElement:body];
    
    NetworkService *netowrk = [[NetworkService alloc] init];
    
    NSMutableArray *result = [netowrk sendSynchronusRequest:[NSString stringWithFormat:@"reminders/add?buyer=%@&seller=%@",[[[self.userNames objectAtIndex:button.tag]componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID1]componentsSeparatedByString:@"@"] objectAtIndex:0]] dataToSend:nil delegate:nil requestMethod:@"POST" requestType:nil];
    	[self removeObjectfromIndex:button.tag];
    
}

- (IBAction) closeChat
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Block Button Pressed

- (void) blockButtonPresseed:(id) sender
{
    [Utils showAlertView:kAlertTitle message:KBlockAlertMsg delegate:self cancelButtonTitle:@"YES" otherButtonTitles:@"NO"];
    UIButton* btn = (UIButton*) sender;
    blockUserIndex = btn.tag;
    ReleaseObject(blockBtn);
    blockBtn = [[UIButton alloc] init];
    blockBtn = btn;
}

#pragma mark - Alert View Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            NSLog(@"Yes has been selected");
            [self createListWithName:kBlockList jabber:[self.userNames objectAtIndex:blockUserIndex] element:PreviousBlockList];
            NSUserDefaults* userDefault = [[NSUserDefaults alloc]init];
            NSMutableDictionary* BlockDic = [[NSMutableDictionary alloc] initWithDictionary:(NSMutableDictionary*)[userDefault objectForKey:kBlockList]];
            NSString* userid = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"];
            
            NSMutableArray* BlockArr = [[NSMutableArray alloc]initWithArray:(NSArray*)[BlockDic objectForKey:userid]];
            [BlockArr addObject:[userNames objectAtIndex:blockUserIndex]];
            [BlockDic removeObjectForKey:userid];
            [BlockDic setObject:BlockArr forKey:userid];
            [[NSUserDefaults standardUserDefaults] setObject:BlockDic forKey:kBlockList];
            
            [userDefault release];
            NSXMLElement *body = [NSXMLElement elementWithName:@"presence"];
            
            [body addAttributeWithName:@"to" stringValue:[self.userNames objectAtIndex:blockBtn.tag]];
            [body addAttributeWithName:@"type" stringValue:@"unsubscribed"];
            
            [gCXMPPController.xmppStream sendElement:body];
            
            NetworkService *netowrk = [[NetworkService alloc] init];
            
            NSMutableArray *result = [netowrk sendSynchronusRequest:[NSString stringWithFormat:@"reminders/add?buyer=%@&seller=%@",[[[self.userNames objectAtIndex:blockBtn.tag]componentsSeparatedByString:@"@"] objectAtIndex:0],[[[[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID1]componentsSeparatedByString:@"@"] objectAtIndex:0]] dataToSend:nil delegate:nil requestMethod:@"POST" requestType:nil];
            [self removeObjectfromIndex:blockBtn.tag];

            break;
        }
        case 1:
            NSLog(@"No has been selected");
            break;
        default:
            break;
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - XMPPPrivacy class Delegate Methods

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListNames:(NSArray *)listNames
{
    NSLog(@"didReceiveListName method called");
    
    NSLog(@"%@", listNames);
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListNamesDueToError:(id)error
{
    NSLog(@"didNotREceiveListNameDuwto Error method called");
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didReceiveListWithName:(NSString *)name items:(NSArray *)items
{
    NSLog(@"didReceiveListWithName method called");
    
     NSLog(@"%@", items);
    
    if([name isEqualToString:kRejectList])
    {
        ReleaseObject(PreviousRejectList);
        PreviousRejectList = [[NSMutableArray alloc] initWithArray:items];
    }
    else if ([name isEqualToString:kBlockList])
    {
        ReleaseObject(PreviousBlockList);
        PreviousBlockList = [[NSMutableArray alloc] initWithArray:items];
    }
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotReceiveListWithName:(NSString *)name error:(id)error
{
    NSLog(@"didNotReceiveListWithName method called");
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didSetListWithName:(NSString *)name
{
    NSLog(@"didSetListWithName method called");
    
    if (name == kRejectList)
    {
        
        NSLog(@"Reject list has been developed.");
    }
    
  NSArray* Arr = [sender listWithName:kRejectList];
    
    NSLog(@"%@", Arr);
    
    NSArray* arr1 = [sender listWithName:kBlockList];
}

- (void)xmppPrivacy:(XMPPPrivacy *)sender didNotSetListWithName:(NSString *)name error:(id)error
{
    NSLog(@"didNotSetListWithName method called");
}


@end
