//
//  MessageDetailViewController.m
//  ISB
//
//  Created by chetan shishodia on 22/07/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "MessageDetailViewController.h"
#import "MessageTextView.h"
#import "Utils.h"
@interface MessageDetailViewController ()

@end

@implementation MessageDetailViewController
@synthesize strMsgId;
@synthesize strSelectedMsgRow,messageType;
@synthesize arrTotalMessageCount;
@synthesize txtviewDetail,sentTextView;
@synthesize lblViewHeading, lblDate, lblSenderName, lblSubject,sendMessageView,overlayImage,countLableValue;

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
    self.navigationController.navigationBarHidden = YES;

    webviewMessageDetail.hidden = YES;
    txtviewDetail.userInteractionEnabled = YES;
    txtviewDetail.editable=NO;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    countLableValue.text =[NSString stringWithFormat:@"%i", 250];
    //    filteredIndexes = 0;
//    strTotalMessages = [[NSString alloc]init];
//    lblViewHeading.text = [NSString stringWithFormat:@"%@ of %d",strSelectedMsgRow , arrTotalMessageCount.count];
    [ItemDetails sharedInstance].isSelected =0;
//    MessageTextView *textv=[[MessageTextView alloc]initWithFrame:CGRectMake(20, 20, 250, 250)];
//    textv.text=@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor ";
//    [self.view addSubview:textv];
    selectedMsgRow = [strSelectedMsgRow intValue];
    overlayImage.hidden=YES;
    filteredIndexes=[strSelectedMsgRow intValue]-1;

    if (selectedMsgRow == 1 ) {
        btnNext.userInteractionEnabled = YES;
        [btnNext setImage:[UIImage imageNamed:@"arrowNextActive.png"]forState:UIControlStateNormal];
        
        
        
        [self.btnReply setEnabled:YES];
        [self.btnTrash setEnabled:YES];
        
        btnPrev.userInteractionEnabled = NO;
        [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
    
    }
    
    if (selectedMsgRow==arrTotalMessageCount.count) {
        btnNext.userInteractionEnabled = NO;
        [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
        
        btnPrev.userInteractionEnabled = YES;
        [btnPrev setImage:[UIImage imageNamed:@"arrowBackActive.png"]forState:UIControlStateNormal];
    }
    if(arrTotalMessageCount.count ==1)
    {
        btnNext.userInteractionEnabled = NO;
        [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
        
        btnPrev.userInteractionEnabled = NO;
        [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
    }
        
        
    index = [arrTotalMessageCount indexOfObject:strMsgId];
    
    if (messageType==3) {
       // [self.btnReply setHidden:YES];
        [self.btnTrash setHidden:YES];
    }    
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
    
    [self callWebService];
    
    [super viewWillAppear:YES];
}


#pragma  - mark Call Webservice

-(void)callWebService
{
    NetworkService *objService = [[NetworkService alloc]init];
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/get_one?msg_id=%@",strMsgId] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
//    [objService sendRequestToServer:@"msgs/get_all?user_id=18" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    //http://it0091.com/ISB/index.php/msgs/get_one?msg_id=4
}
-(void)callWebServiceSendReply:(NSString *)msgID fromUser :(NSString *)fromUserId toUser:(NSString *)toUserId
{
    NetworkService *objService = [[NetworkService alloc]init];
    
    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/send?msg_id=%@&from_user_id=%@&to_user_id=%@&msg_body=%@&msg_title=ISB",strMsgId,fromUserId,toUserId,sentTextView.text] dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    
    //    [objService sendRequestToServer:@"msgs/get_all?user_id=18" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    //http://it0091.com/ISB/index.php/msgs/get_one?msg_id=4
}

-(void)callWebServiceForDelete:(int)index1
{
    
    NSString *messageId=[arrTotalMessageCount objectAtIndex:index1];
    NetworkService *objService = [[NetworkService alloc]init];
//    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/delete?msg_id=%@",messageId ]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
    [objService sendRequestToServer:[NSString stringWithFormat:@"msgs/delete?msg_id=%@&user_id=%@",messageId,[[NSUserDefaults standardUserDefaults] objectForKey:@"USERID"] ]dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];

}
#pragma mark-animating a view
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4]; // if you want to slide up the view
    
    CGRect rect = sendMessageView.frame;
    //   NSLog(@"%f",rect.origin.y);
    if (movedUp)
    {
//        if(rect.origin.y==548 || rect.origin.y == 468)
//        {
            //isKeyBoardDown = NO;
            // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
            // 2. increase the size of the view so that the area behind the keyboard is covered up.
            if([Utils isIPhone_5])
                rect.origin.y -= 548;
            else
                rect.origin.y -= 470;
//        }
        //        rect.size.height += 150;
    }
    else
    {
        
        // revert back to the normal state.
        if([Utils isIPhone_5])
            rect.origin.y += 548;
        else
            rect.origin.y += 470;
        //        rect.size.height -= 150;
        //isKeyBoardDown = YES;
    }
    self.sendMessageView.frame = rect;
    [UIView commitAnimations];
}

-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];

    if ([inReqIdentifier rangeOfString:@"msgs/get_one?"].length>0)
    {
        if([inResponseDic isKindOfClass:[NSArray class]])
        {
            if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
            {
                arrDetailMessage = [[NSArray alloc]initWithArray:inResponseDic];
                    lblViewHeading.text = [NSString stringWithFormat:@"%d of %d",selectedMsgRow , arrTotalMessageCount.count];
//                NSLog(@"lblViewHeading.text==>> %@",lblViewHeading.text);
                lblDate.text = [[arrDetailMessage objectAtIndex:0]valueForKey:@"created_dt"];
                lblSenderName.text = [[arrDetailMessage objectAtIndex:0]valueForKey:@"sender_email"];
//                lblSenderName.text = @"ISB";
                lblSubject.text = [[arrDetailMessage objectAtIndex:0]valueForKey:@"msg_title"];
                txtviewDetail.text = [[arrDetailMessage objectAtIndex:0]valueForKey:@"msg_body"];
            }
            else
            {
            
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
            [Utils showAlertView:kAlertTitle message:@"Unable to get message detail right now. Please try again later." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        }
        [Utils stopActivityIndicatorInView:self.view];
    }
    else if ([inReqIdentifier rangeOfString:@"msgs/send?"].length>0)

    {
        if([inResponseDic isKindOfClass:[NSArray class]])
        {
            if([[inResponseDic objectAtIndex:0]isKindOfClass:[NSDictionary class]])
            {
                [self callWebService];

                [Utils showAlertView:@"" message:@"Message sent successfully!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
            }
        }
        
    
    }else 
        
    {
        
        
        //        strMsgId=[NSString stringWithFormat:@"%@",[]];
        //        [self callWebService];
        [arrTotalMessageCount removeObject:strMsgId];

        
        if ([arrTotalMessageCount count]<=filteredIndexes)
        {
            switch (filteredIndexes)
            {
                case 0:
                    lblViewHeading.text = [NSString stringWithFormat:@"No Messages"];
//            s       NSLog(@"lblViewHeading.text==>> %@",lblViewHeading.text);
                    lblDate.text = @"";
                    lblSenderName.text = @"";
                    //                lblSenderName.text = @"ISB";
                    lblSubject.text = @"";
                    txtviewDetail.text = @"";
                    
                    
                    btnNext.userInteractionEnabled = NO;
                    [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
                    btnPrev.userInteractionEnabled = NO;
                    [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
                    [self.btnReply setEnabled:NO];
                    [self.btnTrash setEnabled:NO];
                    
                    break;
                    
                default:
                    selectedMsgRow=filteredIndexes;
                    if(arrTotalMessageCount.count ==1)
                    {
                        btnNext.userInteractionEnabled = NO;
                        [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
                        
                        btnPrev.userInteractionEnabled = NO;
                        [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
                    }

                    filteredIndexes = filteredIndexes - 1;
                    strMsgId=[arrTotalMessageCount objectAtIndex:filteredIndexes];
                    [self callWebService];
                    
                    break;
            }
        }
        else
        {
            if (filteredIndexes==0)
            {
                btnPrev.userInteractionEnabled = NO;
                [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
            }
            
            if (filteredIndexes+1 == arrTotalMessageCount.count)
            {
                btnNext.userInteractionEnabled = NO;
                [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
            }
//            else if([arrTotalMessageCount count] - filteredIndexes==0)
//            {
//                    btnPrev.userInteractionEnabled = NO;
//                    [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
//            }
//            
//            else///////////////////////////////////////
//            {
//                btnPrev.userInteractionEnabled = NO;
//                [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
//            }///////////////////////////////////////
            
            selectedMsgRow=filteredIndexes+1;
            strMsgId=[arrTotalMessageCount objectAtIndex:filteredIndexes];
            if(arrTotalMessageCount.count ==1)
            {
                btnNext.userInteractionEnabled = NO;
                [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
                
                btnPrev.userInteractionEnabled = NO;
                [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
            }

            [self callWebService];
        }
//        [arrTotalMessageCount removeObject:strMsgId];
    }


}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"Unable to get message detail right now. Please try again later.." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}


#pragma mark - Button Methods
-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnDeleteClicked:(id)sender
{
//    NSString *cellIndex=[NSString stringWithFormat:@"%@",strMsgId];
    
    filteredIndexes=[arrTotalMessageCount indexOfObject:strMsgId];
    
//    filteredIndexes = [arrTotalMessageCount indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop){
//        NSString *ID =[NSString stringWithFormat:@"%@",[obj valueForKey:@"id"]];
//        NSLog(@"ID: %@",[obj valueForKey:@"id"]);
//        return [ID isEqualToString:cellIndex];
//    }];
    
        if (filteredIndexes != NSNotFound)
        {
            [Utils startActivityIndicatorInView:self.view withMessage:nil];
             [self callWebServiceForDelete :filteredIndexes];
//            [arrTotalMessageCount removeObject:strMsgId];
        }
  //  [self callWebServiceForDelete:filteredIndexes];
    
//    if (filteredIndexes != NSNotFound)
//    {
//         [self callWebServiceForDelete :filteredIndexes];
//    }
}

-(IBAction)btnReplyClicked:(id)sender
{
   // [self sendMessage:[NSMutableArray arrayWithObject:@""] Message:@"ISB" Subject:@""];
    [overlayImage setHidden:NO];
    [self setViewMovedUp:YES];
    [sentTextView becomeFirstResponder];
}

-(IBAction)btnPrevClicked:(id)sender
{
    btnNext.userInteractionEnabled = YES;
    [btnNext setImage:[UIImage imageNamed:@"arrowNextActive.png"]forState:UIControlStateNormal];
    if (filteredIndexes>0)
    {
        //    strMsgId = [NSString stringWithFormat:@"%@",[arrTotalMessageCount objectAtIndex:[strSelectedMsgRow intValue]]];
        selectedMsgRow=selectedMsgRow-1;
        filteredIndexes=filteredIndexes-1;
        strMsgId=[arrTotalMessageCount objectAtIndex:filteredIndexes];
        [self callWebService];
        if (filteredIndexes==0) {
            btnNext.userInteractionEnabled = YES;
            [btnNext setImage:[UIImage imageNamed:@"arrowNextActive.png"]forState:UIControlStateNormal];
            
            
            btnPrev.userInteractionEnabled = NO;
            [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];

        }
//        [self callWebService];
    }
    else
    {
        [btnPrev setImage:[UIImage imageNamed:@"arrowBackDeactive.png"]forState:UIControlStateNormal];
        btnPrev.userInteractionEnabled = NO;
    }

}

-(IBAction)btnNextClicked:(id)sender
{
   // index++;
    btnPrev.userInteractionEnabled = YES;
    [btnPrev setImage:[UIImage imageNamed:@"arrowBackActive.png"]forState:UIControlStateNormal];

    if (filteredIndexes < arrTotalMessageCount.count)
    {
//        NSLog(@"filteredIndexes = %d",filteredIndexes);
        selectedMsgRow=selectedMsgRow+1;
        filteredIndexes=filteredIndexes+1;
        strMsgId=[arrTotalMessageCount objectAtIndex:filteredIndexes];
        [self callWebService];
        if (filteredIndexes==arrTotalMessageCount.count-1) {
            btnNext.userInteractionEnabled = NO;
            [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
            
            
            btnPrev.userInteractionEnabled = YES;
            [btnPrev setImage:[UIImage imageNamed:@"arrowBackActive.png"]forState:UIControlStateNormal];
        }

    }
    else
    {
        btnNext.userInteractionEnabled = NO;
        [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];

        
        btnPrev.userInteractionEnabled = YES;
        [btnPrev setImage:[UIImage imageNamed:@"arrowBackActive.png"]forState:UIControlStateNormal];
    }
       
    
//    index = [arrTotalMessageCount indexOfObject:strMsgId];
    
    
    
    
    
    
//    if (arrTotalMessageCount.count >1)
//    {
//        
//    }
//    
// 
//    if (selectedMsgRow<=arrTotalMessageCount.count)
//    {
//        //    strMsgId = [NSString stringWithFormat:@"%@",[arrTotalMessageCount objectAtIndex:[strSelectedMsgRow intValue]]];
//        
//        strMsgId = [NSString stringWithFormat:@"%@",[arrTotalMessageCount objectAtIndex:selectedMsgRow]];
//        
//        //    strSelectedMsgRow = [NSString stringWithFormat:@"%@",[[strSelectedMsgRow intValue]+1]];
//        
//        selectedMsgRow = selectedMsgRow +1;
////        strMsgId = [NSString stringWithFormat:@"%d",selectedMsgRow];
////        [self callWebService];
//
//    }
//    else
//    {
//        [btnNext setImage:[UIImage imageNamed:@"arrowNextDeactive.png"]forState:UIControlStateNormal];
//        btnNext.userInteractionEnabled = NO;
//    }
    
}

- (IBAction)cancelSendMessage:(id)sender {
    overlayImage.hidden=YES;
    [self setViewMovedUp:NO];
    sentTextView.text=@"";
    [self.view endEditing:YES];
}

#pragma mark - Message Api implementation
-(void)sendMessage:(NSMutableArray*)arrayPhoneNumbers Message:(NSString*) msg1 Subject:(NSString*) sub
{
    
    MFMessageComposeViewController *messageView = [[MFMessageComposeViewController alloc]init];
    if ([MFMessageComposeViewController canSendText])
    {
        NSString *messageBody = msg1;
        messageView.body = messageBody;
        
        messageView.recipients = arrayPhoneNumbers;
        messageView.messageComposeDelegate=self;
        [self presentViewController:messageView animated:YES completion:nil];
        
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    //   NSString *msgcancelled;
    switch (result)
    {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            
            break;
        default:
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:Nil];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [overlayImage release];
    [sendMessageView release];
    
    [super dealloc];
}
- (IBAction)sendMessage:(id)sender {
    
    NSLog(@"MY UserID : %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"] );
    if (![sentTextView.text isEqualToString:@""]) {
        [Utils startActivityIndicatorInView:self.view withMessage:@""];
        
        if ([[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"USERID"]] isEqualToString:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"to_user_id"]]]) {
            
            [self callWebServiceSendReply:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"id"]] fromUser:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"to_user_id"]] toUser:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"from_user_id"]]];
            
        }else{
            
        [self callWebServiceSendReply:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"id"]] fromUser:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"from_user_id"]] toUser:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"to_user_id"]]];
            
        }
        overlayImage.hidden=YES;
        [self setViewMovedUp:NO];
        
        [self.view endEditing:YES];
    }else{
        [Utils showAlertView:@"" message:@"Write some message to send" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    }

    
}

- (void)textViewDidChange:(UITextView *)textView{
    int textMaxcount=250;
    //    NSInteger newTextLength = [aTextView.text length] - range.length;
    NSInteger newTextLength = textMaxcount-[textView.text length];
    countLableValue.text =[NSString stringWithFormat:@"%i", newTextLength];
}

- (BOOL)textView:(UITextView *)aTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    //    aTextView.text = [NSString stringWithFormat:@"%i", 250];
    // "Length of existing text" - "Length of replaced text" + "Length of replacement text"
    //    int textMaxcount=250;
    
    //    NSInteger newTextLength = [aTextView.text length] - range.length;
    //     NSInteger newTextLength = textMaxcount-[aTextView.text length];
    if ([countLableValue.text integerValue]<1) {
        if (range.location==249 && range.length==1) {
            return YES;
        }
        return NO;
    }
    //    countLableValue.text =[NSString stringWithFormat:@"%i", newTextLength];
    return YES;
}
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if ([text isEqualToString:@"\n"]) {
//        [textView resignFirstResponder];
//        if (![sentTextView.text isEqualToString:@""]) {
//            [self callWebServiceSendReply:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"id"]] fromUser:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"to_user_id"]] toUser:[NSString stringWithFormat:@"%@",[[arrDetailMessage objectAtIndex:0] valueForKey:@"from_user_id"]]];
//            overlayImage.hidden=YES;
//            [self setViewMovedUp:NO];
//            
//            [self.view endEditing:YES];
//        }else{
//            [Utils showAlertView:@"" message:@"Write some message to send" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
//        }
//        
//        return NO;
//    }
//    else
//        return YES;
//}


@end
