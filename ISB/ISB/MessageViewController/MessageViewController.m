//
//  MessageViewController.m
//  ISB
//
//  Created by AppRoutes on 28/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MessageViewController.h"

#import "MessageDetailViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController
@synthesize messageTableView,searchBar,messageType;

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
    self.navigationController.navigationBarHidden=YES;
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
//    NSDate *date1 = [NSDate date];;
//    //NSDate *date2 = [NSDate dateWithString:@"2013-07-26 00:00:00 +0000"];
//    
//     NSDate *date2 = [NSDate dateWithString:[NSString stringWithFormat:@"%@",[arrMessageList valueForKey:@"date_sent"]]];
//    
//    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
//    
//    numberOfDays = secondsBetween / 86400;
//    
//    NSLog(@"There are %d days in between the two dates.", numberOfDays);
    
//    [self getdate];
    
    if (!arrMessageList || !arrMessageList.count){
        btnEdit.hidden=YES;
    }
    else
        btnEdit.hidden=NO;
    
    [ItemDetails sharedInstance].isSelected =0;

    messageTableView.editing=NO;
    [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];

    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    switch (messageType) {
//        case 1:
//            [self callWebService];
//            break;
//        case 2:
//            [self callWebService];
//            break;
//        case 3:
//            [self callWebService];
//            break;
//        default:
//            break;
//    }
    [self callWebService];
 
    [super viewWillAppear:YES];
}

-(NSDate*) getLocalTimewithDate :(NSDate *)date{
    NSDate* sourceDate = date;
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate] autorelease];
    return destinationDate;
}


//-(void)getdate{
//    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//    [dateFormat setDateFormat:@"dd/MM/yy"];
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
//    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
//    [timeFormat setDateFormat:@"HH:mm:ss"];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
//    [dateFormatter setDateFormat:@"EEEE"];
//    
//    NSDate *now = [[NSDate alloc] init];
//    NSString *dateString = [format stringFromDate:now];
//    NSString *theDate = [dateFormat stringFromDate:now];
//    NSString *theTime = [timeFormat stringFromDate:now];
//    
//    NSString *week = [dateFormatter stringFromDate:now];
//    NSLog(@"\n"
//          "theDate: |%@| \n"
//          "theTime: |%@| \n"
//          "Now: |%@| \n"
//          "Week: |%@| \n"
//          
//          , theDate, theTime,dateString,week);
//}
#pragma  - mark Call Webservice

-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
//http://chat.eitcl.co.uk/devchat/index.php/msgs/get_all?user_id=41&msg_type=3
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/get_all?user_id=%@&msg_type=%d",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"],messageType] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
//    [objService sendRequestToServer:@"msgs/get_all?user_id=18" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];  
    
}

-(void)callWebServiceForDelete:(NSString *)msgID
{
    NetworkService *objService = [[NetworkService alloc]init];
//    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/delete?msg_id=%@",msgID]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/delete?msg_id=%@&user_id=%@",msgID,[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"] ]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    
//   ? NSLog(@"res:%@",inResponseDic);
    [Utils stopActivityIndicatorInView:self.view];
    if ([inReqIdentifier rangeOfString:@"msgs/get_all"].length>0) 
    {
    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
        {
            
            //NSMutableArray *arrTemp = [[NSMutableArray alloc]initWithArray:inResponseDic];
//            arrMessageList= [[[arrTemp reverseObjectEnumerator] allObjects] mutableCopy];
            arrMessageList = [[NSMutableArray alloc]initWithArray:inResponseDic];
            arrMessageListCopy = [[NSMutableArray alloc]initWithArray:arrMessageList];
            btnEdit.hidden = NO;
            arrMessageId = [[NSMutableArray alloc]init];
            for(id obj in arrMessageList)
            {
                [arrMessageId addObject:[obj valueForKey:@"id"]];
            }
            [messageTableView reloadData];
        }
        else
        {            
            arrMessageList=nil;
            arrMessageListCopy=nil;
            [messageTableView reloadData];
//            if(self.alertShowing==NO)
//            {
//                [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                
//                self.alertShowing = YES;
//            }
        }
    }
    else
    {
//        [Utils showAlertView:kAlertTitle message:@"Unable to get messages right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Utils showAlertView:kAlertTitle message:@"Network problem.\nPlease try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    }else
    {
        [arrMessageList removeObjectAtIndex: DeleteIndex];
        if (!arrMessageList || !arrMessageList.count){
            btnEdit.hidden=YES;
        }
        else
            btnEdit.hidden=NO;
        [messageTableView reloadData];
    }
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
//    [Utils showAlertView:kAlertTitle message:@"Unable to get messages right now. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [Utils showAlertView:kAlertTitle message:@"Network problem.\nPlease try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
}

#pragma  - mark TableView Delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   return 70;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrMessageList count];
//    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
        
        if (cell == nil)
        {
            NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        // addded by chetan..
        UIView *selectionColor = [[UIView alloc] init];
        selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
        
        UILabel *senderName = (UILabel *)[cell.contentView viewWithTag:200];
        senderName.font = [UIFont fontWithName:@"Avenir Next Condensed - Bold" size:15.0];
        //        senderName.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"sender_name"];
        senderName.highlightedTextColor = [UIColor blackColor];
        
        
        UIImageView *couponImage = (UIImageView *)[cell.contentView viewWithTag:100];
        UILabel *msgDate = (UILabel *)[cell.contentView viewWithTag:300];
        if ([[[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"is_read"]integerValue] == 0)
        {
           
            if ([[[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"sender_id"] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]]])
            {
                senderName.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"receiver_name"];
                couponImage.image = [UIImage imageNamed:@"iconReply.png"];
            }
            else
            {
                senderName.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"sender_name"];
                couponImage.image = [UIImage imageNamed:@"iconMessageUnread.png"];
            }

//            couponImage.image = [UIImage imageNamed:@"iconMessageUnread.png"];
            
             cell.contentView.backgroundColor=[UIColor colorWithRed:(251/255.0) green:(248/255.0) blue:(234/255.0) alpha:1];
            
//            msgDate.textColor = [UIColor colorWithRed:(251/255.0) green:(248/255.0) blue:(234/255.0) alpha:1];
//R-251 G-248 B-234
        }
        else if ([[[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"is_read"]integerValue] == 1)
        {
            if ([[[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"sender_id"] isEqualToString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"]]])
            {
                senderName.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"receiver_name"];
                couponImage.image = [UIImage imageNamed:@"iconReplyWhite.png"];
            }
            else
            {
                senderName.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"sender_name"];
                couponImage.image = [UIImage imageNamed:@"iconMessageRead.png"];
            }

//            couponImage.image = [UIImage imageNamed:@"iconMessageRead.png"];
//            msgDate.textColor = [UIColor colorWithRed:(36/255.0) green:(112/255.0) blue:(216/255.0) alpha:1];
        }
        
        
//        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",kImageURL,[[self.arrSearchItem objectAtIndex:indexPath.row]valueForKey:@"pic_path"]];
        
        
        cell.selectedBackgroundView = selectionColor;
        //  cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        UILabel *senderName = (UILabel *)[cell.contentView viewWithTag:200];
//        senderName.font = [UIFont fontWithName:@"Avenir Next Condensed - Bold" size:15.0];
//        senderName.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"sender_name"];
//        senderName.highlightedTextColor = [UIColor blackColor];
        
        NSDate *date1 = [NSDate date];;
        //NSDate *date2 = [NSDate dateWithString:@"2013-07-26 00:00:00 +0000"];
        //NSString *dateStr = @"2013-08-15 12:49:51";
        NSString *dateStr;
        if (![[[arrMessageList objectAtIndex:indexPath.row] valueForKey:@"date_sent"] isEqual:[NSNull null]]) {
           dateStr  =[[arrMessageList objectAtIndex:indexPath.row] valueForKey:@"date_sent"];
        }else
            dateStr  =@"2013-08-15 12:49:51";

//        NSLog(@" %@ dates.", dateStr);
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *date2 = [dateFormat dateFromString:dateStr];
        [dateFormat release];
        NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
        
        numberOfDays = secondsBetween / 86400;
        
//        NSLog(@"There are %d days in between the two dates.", numberOfDays);

        if (numberOfDays==0) {
           // NSString *dateStr = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"date_sent"];
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:dateStr];
            
            // Convert date to string object
            NSDate *localTime=[self getLocalTimewithDate:date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"hh:mm a"];
            NSString *week = [dateFormatter stringFromDate:localTime];
            
//            UILabel *msgDate = (UILabel *)[cell.contentView viewWithTag:300];
            msgDate.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
            msgDate.text = [NSString stringWithFormat:@"%@",week];
          //  msgDate.highlightedTextColor = [UIColor blueColor];
        }
        else if (numberOfDays==-1)
        {
//            UILabel *msgDate = (UILabel *)[cell.contentView viewWithTag:300];
            msgDate.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
            msgDate.text = @"Yesterday";
                  }
        else if(numberOfDays==-2||numberOfDays==-3||numberOfDays==-4||numberOfDays==-5||numberOfDays==-6)
        {
           // NSString *dateStr = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"date_sent"];
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:dateStr];
            
            // Convert date to string object
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"EEEE"];
            NSString *week = [dateFormatter stringFromDate:date];
            
//            UILabel *msgDate = (UILabel *)[cell.contentView viewWithTag:300];
            msgDate.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
            msgDate.text = [NSString stringWithFormat:@"%@",week];
                 }
        else
        {
         //   NSString *dateStr = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"date_sent"];
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *date = [dateFormat dateFromString:dateStr];
            
            // Convert date to string object
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
            [dateFormatter setDateFormat:@"dd/MM/yy"];
            NSString *week = [dateFormatter stringFromDate:date];
            
//            UILabel *msgDate = (UILabel *)[cell.contentView viewWithTag:300];
            msgDate.font = [UIFont fontWithName:@"Avenir Next Condensed" size:14.0];
            msgDate.text = [NSString stringWithFormat:@"%@",week];
            
        }
        UILabel *msgTitle = (UILabel *)[cell.contentView viewWithTag:400];
        msgTitle.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
        msgTitle.text = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"msg_title"];
       msgTitle.highlightedTextColor = [UIColor blackColor];
               
        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MessageDetailViewController *messageDetail;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        messageDetail=[[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController_iPhone5" bundle:nil];
    }
    else
    {
        messageDetail=[[MessageDetailViewController alloc] initWithNibName:@"MessageDetailViewController" bundle:nil];
    }
    
    messageDetail.strSelectedMsgRow = [NSString stringWithFormat:@"%d",indexPath.row+1];

    messageDetail.strMsgId = [[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"id"];
    messageDetail.arrTotalMessageCount = [NSMutableArray arrayWithArray:arrMessageId];
    [self.navigationController pushViewController:messageDetail animated:YES ];
    [messageDetail release];

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
      //  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            //    [Utils stopActivityIndicatorInView:self.view];
            DeleteIndex=indexPath.row;
            [self callWebServiceForDelete:[[arrMessageList objectAtIndex:indexPath.row]valueForKey:@"id"]];

     //       dispatch_async(dispatch_get_main_queue(), ^{
        
               
//            });
//        });
    }
}



#pragma - mark Button Methods

-(IBAction)btnAddORDeleteRowsClicked:(id)sender
{
    if(self.editing)
    {
        [super setEditing:NO animated:NO];
        [messageTableView setEditing:NO animated:NO];
        [messageTableView reloadData];
        [btnEdit setTitle:@"Edit" forState:UIControlStateNormal];
    }
    else
    {
        [super setEditing:YES animated:YES];
        [messageTableView setEditing:YES animated:YES];
        [messageTableView reloadData];
        [btnEdit setTitle:@"Done" forState:UIControlStateNormal];
    }
}


-(IBAction)btnBackClicked:(id)sender
{
    [searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UISearchBar method

// End search
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar1

{
	searchBar1.showsCancelButton = YES;
	searchBar1.autocorrectionType = UITextAutocorrectionTypeNo;
	[messageTableView reloadData];
    
}


- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar1

{
    //	CGRect make=searchBar1.frame;
    //    make.size.width=290;
    //    searchBar1.frame=make;
    //    [searchBarView addSubview:remainingSearchSpace];
	searchBar1.showsCancelButton = YES;
}

- (void)searchBar:(UISearchBar *)searchBar1 textDidChange:(NSString *)searchText
{
    
    //[searchText isEqualToString:@""];
    
	if([searchBar1.text isEqualToString:@""]||searchBar1.text==nil){
		arrMessageList=[[NSMutableArray alloc]initWithArray:arrMessageListCopy];
        
        
        //		tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
        [messageTableView reloadData];
	}
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar1
{
    [searchBar1 setShowsCancelButton:YES];
    for (UIView *subview in searchBar1.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            int64_t delayInSeconds = .001;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                
                UIButton * cancelButton = (UIButton *)subview;
                [cancelButton setHidden:NO];
                [cancelButton setEnabled:YES];
                
            });
        }
    }
    [searchBar1 resignFirstResponder];
    
}
- (BOOL)searchBar:(UISearchBar *)searchBar1 shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    
    NSString *searchText = [searchBar1.text stringByReplacingCharactersInRange:range withString:text];
    NSMutableArray *searchWordsArr = [[NSMutableArray alloc] init];
    NSString *newStr1= [searchText stringByReplacingOccurrencesOfString:@"," withString:@" "];
    NSMutableArray *tempArray = (NSMutableArray*)[newStr1 componentsSeparatedByString:@" "];
    for (NSString *str in tempArray) {
        NSString *tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if([tempStr length])
        {
            [searchWordsArr addObject:tempStr];
        }
    }
    
    NSMutableArray *subpredicates = [NSMutableArray array];
    for(NSString *term in searchWordsArr)
    {
        NSPredicate *p = [NSPredicate predicateWithFormat:@"sender_name contains[cd] %@", term];
        [subpredicates addObject:p];
    }
    
    // //NSLog(@"all array %@",SharedAppDelegate.arrContacts);
    NSMutableArray *tempArry = [[NSMutableArray alloc] initWithArray:arrMessageListCopy];
    
    NSPredicate *filter = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    NSMutableArray *finalArray = [[NSMutableArray alloc] initWithArray:[tempArry filteredArrayUsingPredicate:filter]];
    //NSLog(@"finalarray is %@",finalArray);
    arrMessageList=[[NSMutableArray alloc]initWithArray:finalArray];
    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:[contactsPage contactsGrouping:finalArray]];
    [messageTableView reloadData];
    
    
    if(searchText.length==0)
    {
        ////NSLog(@"hello");
        //  ReleaseObject(namesList)
        arrMessageList=[[NSMutableArray alloc]initWithArray:arrMessageListCopy];
        //        tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
        [messageTableView reloadData];
        
        
        return YES;
    }
    
    return YES;
}



// Cancel search
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar1
{
    searchBar1.text=@"";
    //    tableData = [[NSMutableDictionary alloc] initWithDictionary:tableData2];
    arrMessageList=[[NSMutableArray alloc]initWithArray:arrMessageListCopy];
    [self.view endEditing:YES];
    [messageTableView reloadData];
    [searchBar1 setShowsCancelButton:NO];
	//_mySearchBar.text = @"";
	
}



#pragma - mark TextView Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [searchBar release];
    [_cancelBtn release];
    [_editBtn release];
    [_cancelBtn release];
    [messageTableView release];
    [super dealloc];
}





@end
