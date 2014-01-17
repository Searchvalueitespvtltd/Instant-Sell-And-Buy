//
//  AddSellItemViewController.m
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "AddSellItemViewController.h"
#import "ItemDetailsViewController.h"
#import "ItemDetails.h"
#import "Utils.h"
#import "Defines.h"
#import "AppDelegate.h"
@interface AddSellItemViewController ()

@end

@implementation AddSellItemViewController
@synthesize addPhotoView,txtProductTitle,takePhotoView,overlay,AddSellItemView,imgCamera1,dicAddSellItem,imgCamera2,imgCamera3,btnEdit,dicItemDetails;
@synthesize imgBackCamera;

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
    
    btnEdit.hidden = YES;
    if (App.isEdit == YES)
    {
        btnEdit.hidden = NO;
        [self editItem];
    }
    else{
        UIButton *but1=(UIButton *)[self.view viewWithTag:301];
        UIButton *but2=(UIButton *)[self.view viewWithTag:302];
        UIButton *but3=(UIButton *)[self.view viewWithTag:303];
        [but1 setEnabled:NO];
        [but2 setEnabled:NO];
        [but3 setEnabled:NO];
    }

    
    picker = [[UIImagePickerController alloc]init];
    picker.allowsEditing = NO;
    picker.delegate=self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(willKeyBoardHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
//     btnEdit.hidden = YES;
//    if (App.isEdit == YES)
//    {
//        btnEdit.hidden = NO;
//        [self editItem];
//    }
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
	[self.view addGestureRecognizer:gestureRecognizer];
	gestureRecognizer.cancelsTouchesInView = NO;
	[gestureRecognizer release];
}

-(IBAction)btnAddPhotoClicked:(id)sender
{
    instance=sender;
    [self displayActionSheet];
}

- (void)displayActionSheet
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
                                                    cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Picture", @"Choose Library",@"Delete", nil];
//    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self
//                                                    cancelButtonTitle:@"" destructiveButtonTitle:nil otherButtonTitles:@"", @"", @"", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    
    switch (instance.tag) {
        case 101:
            if ([self image:imgCamera1.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]])
            {
                [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setEnabled:NO];
            }
            break;
        case 102:
            if ([self image:imgCamera2.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]])
            {
                [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setEnabled:NO];
            }
			
            break;
        case 103:
            if ([self image:imgCamera3.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]])
            {
                [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setEnabled:NO];
            }
			
            break;
        default:
            [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setEnabled:YES];
            break;
    }
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"btnTakePicture.png"] forState:UIControlStateNormal];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"btnChooseLibrary.png"] forState:UIControlStateNormal];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"btnDeletePhoto.png"] forState:UIControlStateNormal];
//    
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:3] setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateNormal];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"btnTakePicture.png"] forState:UIControlStateHighlighted];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"btnChooseLibrary.png"] forState:UIControlStateHighlighted];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"btnDeletePhoto.png"] forState:UIControlStateNormal];
//    [[[actionSheet valueForKey:@"_buttons"] objectAtIndex:3] setImage:[UIImage imageNamed:@"btnCancel.png"] forState:UIControlStateHighlighted];
    [actionSheet showInView:self.tabBarController.tabBar];
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////

-(void)editItem
{
    //    btnEdit.hidden=YES;
//    NSLog(@"item:%@",App.dictEditItemDetail);
    
    [ItemDetails sharedInstance].isSelected =0;
//    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:500];
//    indicator.hidden=YES;
//    UIActivityIndicatorView *indicator1 = (UIActivityIndicatorView *)[self.view viewWithTag:501];
//    indicator1.hidden=YES;
//    UIActivityIndicatorView *indicator2 = (UIActivityIndicatorView *)[self.view viewWithTag:502];
//    indicator2.hidden=YES;
    for (int i=1; i<4; i++)
    {
        UIImageView *img=(UIImageView *)[self.view viewWithTag:400+i];
        if ([self image:img.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]])
        {
            UIButton * button=(UIButton *)[self.view viewWithTag:img.tag-100];
            // [radioInstance setSelected:NO];
            [button setEnabled:NO];
        }
    }
    if ([ItemDetails sharedInstance].isEditing)
    {    
        btnEdit.hidden=NO;
        btnImageCamera1.userInteractionEnabled=YES;
        btnImageCamera2.userInteractionEnabled=YES;
        btnImageCamera3.userInteractionEnabled=YES;
        btnSaveAndCont.userInteractionEnabled=YES;
        UIButton *but1=(UIButton *)[self.view viewWithTag:301];
        UIButton *but2=(UIButton *)[self.view viewWithTag:302];
        UIButton *but3=(UIButton *)[self.view viewWithTag:303];
        [but1 setUserInteractionEnabled:YES];
        [but2 setUserInteractionEnabled:YES];
        [but3 setUserInteractionEnabled:YES];
        txtProductTitle.userInteractionEnabled=YES;
        UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:500];
        indicator.hidden=NO;
        UIActivityIndicatorView *indicator1 = (UIActivityIndicatorView *)[self.view viewWithTag:501];
        indicator1.hidden=NO;
        UIActivityIndicatorView *indicator2 = (UIActivityIndicatorView *)[self.view viewWithTag:502];
        indicator2.hidden=NO;
        
        
        //         dicItemDetails=[[NSMutableDictionary alloc]initWithDictionary:App.dictEditItemDetail];
        NSString *imagepath1 = [[ItemDetails sharedInstance].dicOtherdetails
                                valueForKey:@"pic_path"];
        NSString *imagepath2 = [[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"pic_path2"];
        NSString *imagepath3 = [[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"pic_path3"];
        
        
        
        NSString* imageUrlstr1 = [kImageURL stringByAppendingString:imagepath1];
        NSString* imageUrlstr2 = [kImageURL stringByAppendingString:imagepath2];
        NSString* imageUrlstr3 = [kImageURL stringByAppendingString:imagepath3];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            if (![imagepath1 length]>0)// && [imagepath1 isEqual:[NSNull null]])
            {
                [but1 setEnabled:NO];
               
                imgCamera1.image =[UIImage imageNamed: @"addPhoto.png"];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:500];
                indicator.hidden=YES;
            }
            else
            {
                [but1 setEnabled:YES];

                NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr1]];
                UIImage *img= [UIImage imageWithData:imageData1];
//                if (img) {
                    imgCamera1.image = [UIImage imageWithData:imageData1];
//                }else
//                  imgCamera1.image =[UIImage imageNamed: @"addPhoto.png"];
                
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:500];
                indicator.hidden=YES;
            }
            if (![imagepath2 length]>0)// && [imagepath2 isEqual:[NSNull null]])
            {
                [but2 setEnabled:NO];

                imgCamera2.image =[UIImage imageNamed: @"addPhoto.png"];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:501];
                indicator.hidden=YES;
            }
            else
            {
                [but2 setEnabled:YES];

                NSData *imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr2]];
                UIImage *img= [UIImage imageWithData:imageData2];
//                if (img) {
                    imgCamera2.image = [UIImage imageWithData:imageData2];
//                }else
//                    imgCamera2.image =[UIImage imageNamed: @"addPhoto.png"];

//                imgCamera2.image = [UIImage imageWithData:imageData2];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:501];
                indicator.hidden=YES;
            }
            
            if (![imagepath3 length]>0)// && [imagepath3 isEqual:[NSNull null]])
            {
                [but3 setEnabled:NO];

                imgCamera3.image =[UIImage imageNamed: @"addPhoto.png"];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:502];
                indicator.hidden=YES;
            }
            else
            {
                
                NSData *imageData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr3]];
                UIImage *img= [UIImage imageWithData:imageData3];
                [but3 setEnabled:YES];
//                if (img) {
                    imgCamera3.image = [UIImage imageWithData:imageData3];
//                }else
//                    imgCamera3.image =[UIImage imageNamed: @"addPhoto.png"];

//                imgCamera3.image = [UIImage imageWithData:imageData3];
                UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:502];
                indicator.hidden=YES;
            }
            
//            NSData *imageData1 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr1]];
//            NSData *imageData2 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr2]];
//            NSData *imageData3 = [NSData dataWithContentsOfURL:[NSURL URLWithString: imageUrlstr3]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
//                if (![imageData1 isEqual: [NSNull null]])
//                {
//                    imgCamera1.image = [UIImage imageWithData:imageData1];
//                    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:500];
//                    indicator.hidden=YES;
//                    //  btnSaveAndCont.userInteractionEnabled=YES;
//                    
//                }
//                
//                if (![imageData2 isEqual: [NSNull null]])
//                {
//                    imgCamera2.image = [UIImage imageWithData:imageData2];
//                    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:501];
//                    indicator.hidden=YES;
//                    // btnSaveAndCont.userInteractionEnabled=YES;
//                }
//                
//                if (![imageData3 isEqual: [NSNull null]])
//                {
//                    imgCamera3.image = [UIImage imageWithData:imageData3];
//                    
//                    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)[self.view viewWithTag:502];
//                    indicator.hidden=YES;
//                    // btnSaveAndCont.userInteractionEnabled=YES;
//                }
            
            });
       });
        
        
        
        
        
        
        self.txtProductTitle.text =[[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"title"];
        
//        but1=(UIButton *)[self.view viewWithTag:301];
//        but2=(UIButton *)[self.view viewWithTag:302];
//        but3=(UIButton *)[self.view viewWithTag:303];
//        [but1 setEnabled:YES];
//        [but2 setEnabled:YES];
//        [but3 setEnabled:YES];
        stringDefaultPic=[[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"default_pic"];
        
        if (![stringDefaultPic isEqual: [NSNull null]])
        {
            stringDefaultPic=[[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"default_pic"];
            
            if ([stringDefaultPic isEqualToString:@"1"]) {
                [but1 setSelected:YES];
                radioInstance=but1;
            }
            else if ([stringDefaultPic isEqualToString:@"2"]) {
                [but2 setSelected:YES];
                radioInstance=but2;
                
            }
            else
            {
                [but3 setSelected:YES];
                radioInstance=but3;
                
            }
        }
    }
    
    //    if([[UIScreen mainScreen] bounds].size.height>480)
    //    {
    //        [self.takePhotoView setFrame:CGRectMake(0, 598, 320, 250)];
    //
    //    }
    //    else
    //    {
    //        [self.takePhotoView setFrame:CGRectMake(0, 480, 320, 250)];
    //    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    overlay.hidden = YES;
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)dealloc
{
    [addPhotoView release];
    [super dealloc];
}


- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    
    return [data1 isEqual:data2];
}



//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet  // before animation and showing view
//{
//    for (UIView* view in [actionSheet subviews])
//    {
//        if ([[[view class] description] isEqualToString:@"UIThreePartButton"])
//        {
//            if ([view respondsToSelector:@selector(title)])
//            {
//                NSString* title = [view performSelector:@selector(title)];
//                if ([title isEqualToString:@"Button 1"] && [view respondsToSelector:@selector(setEnabled:)])
//                {
//                    [view performSelector:@selector(setEnabled:) withObject:NO];
//                }
//            }
//        }
//    }
//}

#pragma - mark Selecting Image from Camera and Library
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Picking Image from Camera/ Library
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imgBackCamera.hidden = NO;
    switch (instance.tag) {
        case 101:
            self.imgCamera1.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            break;
        case 102:
            self.imgCamera2.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            break;
        case 103:
            self.imgCamera3.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            break;
                default:
//            self.imgCamera3.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
            break;
    }
    if (radioInstance) {
        [radioInstance setSelected:NO];
        radioInstance=nil;
    }
    radioInstance=(UIButton *)[self.view viewWithTag:instance.tag+200];
    [radioInstance setEnabled:YES];
    [radioInstance setSelected:YES];
   //    if (!self.imgCamera)
//    {
//        return;
//    }
//    
//    // Adjusting Image Orientation
//    NSData *data = UIImagePNGRepresentation(imgCamera);
//    UIImage *tmp = [UIImage imageWithData:data];
//    UIImage *fixed = [UIImage imageWithCGImage:tmp.CGImage
//                                         scale:imgCamera.scale orientation:self.imgCamera.imageOrientation];
//    self.imgCamera = fixed;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
        {
            if ([UIImagePickerController isSourceTypeAvailable:SOURCETYPE])
            {
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:picker animated:YES completion:nil];
            }
            else
            {
                [Utils showAlertView:kAlertTitle message:@"This device has no camera." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            }

        }
            break;
        case 1:
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:YES completion:nil];
            
        }
         break;    
        case 2:
        {
            UIButton *def_button=(UIButton *)[self.view viewWithTag:instance.tag+200];
            [def_button setEnabled:NO];
            if ([def_button isSelected]) {
                [def_button setSelected:NO];
            }
            self.imgBackCamera.hidden = YES;
            switch (instance.tag) {
                case 101:
                    self.imgCamera1.image = [UIImage imageNamed: @"addPhoto.png"];
                        break;
                case 102:
                    self.imgCamera2.image = [UIImage imageNamed: @"addPhoto.png"];
                    break;
                case 103:
                    self.imgCamera3.image = [UIImage imageNamed: @"addPhoto.png"];
                    break;
                default:
                    //            self.imgCamera3.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
                    break;
            }
//            if (radioInstance) {
//                [radioInstance setSelected:NO];
//                radioInstance=nil;
//            }

        }
        default:
            // Do Nothing.........
            break;
    }
}

#pragma mark - Button Methods

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(IBAction)btnSaveClicked:(id)sender
{
//    for (int i=1; i<4; i++) {
//        UIImageView *img=(UIImageView *)[self.view viewWithTag:400+i];
//        if ([self image:img.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]]) {
//            UIButton * button=(UIButton *)[self.view viewWithTag:img.tag-100];
//            // [radioInstance setSelected:NO];
//            [button setEnabled:NO];
//            [Utils showAlertView:kAlertTitle message:@"Please take a photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            
//        }
//    }
    UIButton *but1=(UIButton *)[self.view viewWithTag:301];
    UIButton *but2=(UIButton *)[self.view viewWithTag:302];
    UIButton *but3=(UIButton *)[self.view viewWithTag:303];
    if (![but1 isSelected] && ![but2 isSelected] && ![but3 isSelected]) {
        
        [Utils showAlertView:kAlertTitle message:@"Please select a default photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    
    else if ([self image:imgCamera1.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]]&&[self image:imgCamera2.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]]&&[self image:imgCamera3.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]])
    {
        [Utils showAlertView:kAlertTitle message:@"Please take a photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    
  else if ([self.txtProductTitle text].length==0)

    {
        [Utils showAlertView:kAlertTitle message:@"Please enter title for photo." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        return;
    }
    else
    {
    
    UIImageView *imageN=(UIImageView *)[self.view viewWithTag:radioInstance.tag+100];
    UIImage *image;

    if(imageN.frame.size.height>imageN.frame.size.width)
    {
        image = [Utils scaleImage:imageN.image maxWidth:320 maxHeight:568];
    }
    else
    {
        image = [Utils scaleImage:imageN.image maxWidth:568 maxHeight:320];
    }

    
    //    if(self.imgCamera1.image.size.height>self.imgCamera1.image.size.width)
//    {
//        image = [Utils scaleImage:self.imgCamera1.image maxWidth:320 maxHeight:568];
//    }
//    else
//    {
//        image = [Utils scaleImage:self.imgCamera1.image maxWidth:568 maxHeight:320];
//    }
    ItemDetailsViewController  *itemDetail;
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        itemDetail=[[ItemDetailsViewController alloc] initWithNibName:@"ItemDetailsViewController_iPhone5" bundle:nil];
        
    }
    else{
        itemDetail=[[ItemDetailsViewController alloc] initWithNibName:@"ItemDetailsViewController" bundle:nil]; }
        
        NSMutableArray *arr=[[NSMutableArray alloc]init];
        
            
      int j=0;
        
        for (int i=0; i<3; i++) {
            
            UIImageView *img=(UIImageView *)[self.view viewWithTag:401+i];
            UIImage *image;
   if (![self image:img.image isEqualTo:[UIImage imageNamed: @"addPhoto.png"]]) {
            if(img.frame.size.height>img.frame.size.width)
            {
                image = [Utils scaleImage:img.image maxWidth:320 maxHeight:568];
            }
            else
            {
                image = [Utils scaleImage:img.image maxWidth:568 maxHeight:320];
            }
            NSMutableDictionary *temp=[NSMutableDictionary new];
            [temp setObject:UIImagePNGRepresentation(image)  forKey:@"image"];
            [temp setObject:[NSString stringWithFormat:@"%d",i+1] forKey:@"image_no"];
            [arr addObject:temp];
       
       UIButton *but=(UIButton*)[self.view viewWithTag:301+i];
       if ([but isSelected]) {
           j=i+1;
       }
        }
        
        }
        
        itemDetail.dicItemDetail = [NSMutableDictionary dictionaryWithObjectsAndKeys:arr,@"imageArray",self.txtProductTitle.text,@"title",[NSString stringWithFormat:@"%d",j],@"default_pic",nil];
    [self.navigationController pushViewController:itemDetail animated:YES ];
    
    }
}

-(IBAction)btnRadioClicked:(id)sender
{
    if (radioInstance) {
        [radioInstance setSelected:NO];
        radioInstance=nil;
    }
    radioInstance=sender;
    [radioInstance setSelected:YES];
//    if ([sender tag] ==300)
//    {
//        
//               
//        
//    }
//    else if ([sender tag] ==200)
//    {
//      
//    }
//        else if ([sender tag] ==300)
//        {
//            
//            }
}

//-(IBAction)btnTakePicClicked:(id)sender
//{
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
//}
//-(IBAction)btnChoosePicClicked:(id)sender
//{
//    
//}
//-(IBAction)btnCancelClicked:(id)sender
//{
////    [self.view sendSubviewToBack:self.takePhotoView];
////    self.overlay.hidden=YES;
////    [self setViewMovedUp:NO];
//}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
      //self.imgBackCamera.hidden = YES;
}


#pragma - mark TextView Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [txtProductTitle resignFirstResponder];
    return YES;
}

-(void)willKeyBoardShow
{
    CGRect selfFrame = AddSellItemView.frame;
//    NSLog(@"willKeyBoardShow");
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        [AddSellItemView setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 103, selfFrame.size.width, selfFrame.size.height)];
    }
    else
    {
        [AddSellItemView setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y - 110, selfFrame.size.width, selfFrame.size.height)];
    }
    
    [UIView commitAnimations];
}

-(void)willKeyBoardHide
{
    CGRect selfFrame = AddSellItemView.frame;
    
//    NSLog(@"willKeyBoardHide");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    
    if([[UIScreen mainScreen] bounds].size.height>480)
    {
        [AddSellItemView setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 103, selfFrame.size.width, selfFrame.size.height)];
    }
    else
    {
        [AddSellItemView setFrame:CGRectMake(selfFrame.origin.x, selfFrame.origin.y + 110, selfFrame.size.width, selfFrame.size.height)];
    }
    
    [UIView commitAnimations];
    
}
-(void)hideKeyboard
{
    [txtProductTitle resignFirstResponder];
}
-(IBAction)editClick:(id)sender
{
//    App.isEdit=YES;
    btnImageCamera1.userInteractionEnabled=YES;
    btnImageCamera2.userInteractionEnabled=YES;
    btnImageCamera3.userInteractionEnabled=YES;
    btnSaveAndCont.userInteractionEnabled=YES;
    UIButton *but1=(UIButton *)[self.view viewWithTag:301];
    UIButton *but2=(UIButton *)[self.view viewWithTag:302];
    UIButton *but3=(UIButton *)[self.view viewWithTag:303];
    [but1 setUserInteractionEnabled:YES];
    [but2 setUserInteractionEnabled:YES];
    [but3 setUserInteractionEnabled:YES];
    txtProductTitle.userInteractionEnabled=YES;
    btnEdit.hidden=YES;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
