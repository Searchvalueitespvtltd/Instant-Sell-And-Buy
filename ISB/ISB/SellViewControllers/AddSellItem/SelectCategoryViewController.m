//
//  SelectCategoryViewController.m
//  ISB
//
//  Created by chetan shishodia on 27/06/13.
//  Copyright (c) 2013 PARNEET CHUGH. All rights reserved.
//

#import "SelectCategoryViewController.h"
#import "ItemDetailsViewController.h"
#import "ItemDetails.h"
#import "Category.h"
#import "AppDelegate.h"
@interface SelectCategoryViewController ()

@end

@implementation SelectCategoryViewController
@synthesize tblSelectCategory;
@synthesize arrCategory,dicSelectCategory;
@synthesize idCategory;
@synthesize btnDone;


int indexpathrow= -1;
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
    arrCategory = [[NSMutableArray alloc]init];
    self.navigationController.navigationBarHidden=YES;
    [Utils startActivityIndicatorInView:self.view withMessage:nil];
//    self.dicSelectCategory = [[NSMutableDictionary alloc]init];
 self.dicSelectCategory = [[NSMutableDictionary alloc]initWithDictionary:[ItemDetails sharedInstance].dicCategoryDetail];
    indexpathrow= -1;
    [self callWebService];
    if ([ItemDetails sharedInstance].isEditing){
        
        category_id = [[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"category_id"];
    }
    [ItemDetails sharedInstance].isSelected =0;

    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
//    if([[ItemDetails sharedInstance].dicCategoryDetail count]>0)
//    {
//        indexpathrow= [[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"category_id"]intValue] +1;
//        
//        //        [self configureCell:cell atIndexPath:indexPath.row];
//    }
    
//    dicEditItemDetail=[[NSMutableDictionary alloc]init ];
//    dicEditItemDetail=App.dictEditItemDetail;
    
//    if ([ItemDetails sharedInstance].isEditing){
//
//        category_id = [[ItemDetails sharedInstance].dicOtherdetails valueForKey:@"category_id"];
//    }
//    [ItemDetails sharedInstance].isSelected =0;

    [super viewWillAppear:YES];
}

#pragma mark - Save Data From Core Data
//-(void)saveToDatabase{
//    Category  *event = (Category *)[NSEntityDescription insertNewObjectForEntityForName:@"Category" inManagedObjectContext:context];
//    [event setId::id.text];
//    [event setFname:firstNameTxtField.text];
//  
//    NSError *error;
//    if (![context save:&error])
//    {
//        //NSLog(@"ERROR--%@",error);
//        abort();
//    }
//    
//}

#pragma mark - Delete Data In Core Data
//-(void)delete{
//    //EMPTY GROUP TABLE
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Users" inManagedObjectContext:context];
//    
//    // Optionally add an NSPredicate if you only want to delete some of the objects.
//    
//    [fetchRequest setEntity:entity];
//    
//    NSArray *myObjectsToDelete = [context executeFetchRequest:fetchRequest error:nil];
//    NSError *error=nil;
//    for (Users *objectToDelete in myObjectsToDelete) {
//        [context deleteObject:objectToDelete];
//        
//        if (![context save:&error])
//        {
//            //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
//        }
//    }
//    userData=myObjectsToDelete;
//}



#pragma mark - Call Webservice

-(void)callWebService
{
    
    NetworkService *objService = [[NetworkService alloc]init];
    [objService sendRequestToServer:@"categories/get" dataToSend:nil delegate:self requestMethod:@"GET" requestType:@"Normal"];
}


-(void)responseHandler :(id)inResponseDic andRequestIdentifier :(NSString*)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];

    if([inResponseDic isKindOfClass:[NSArray class]])
    {
        self.arrCategory = [NSMutableArray arrayWithArray:inResponseDic];
   // [self.arrCategory addObjectsFromArray:inResponseDic];
//    NSLog(@"Response is = %@",arrCategory);
        if([[ItemDetails sharedInstance].dicCategoryDetail count]>0)
        {
            for (int i = 0 ; i < [arrCategory count]; i++) {
           
                //        indexpathrow= [[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"category_id"]intValue] +1;
//                NSLog(@"dic value : %d",[[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"id"]intValue]);
                if(![arrCategory count] == 0){
//                    NSLog(@"%@",[[arrCategory objectAtIndex:i]valueForKey:@"id"]);
                    if ([ItemDetails sharedInstance].isEditing && [[[ItemDetails sharedInstance].dicOtherdetails objectForKey:@"category_id"]intValue]==[[[arrCategory objectAtIndex:i]valueForKey:@"id"] intValue]){

                        indexpathrow = i;
                        

                    }else if([[[ItemDetails sharedInstance].dicCategoryDetail objectForKey:@"id"]intValue]==[[[arrCategory objectAtIndex:i]valueForKey:@"id"] intValue])
                    {
                        indexpathrow = i;
                    }
                }
                //        [self configureCell:cell atIndexPath:indexPath.row];
            }
        }
    [tblSelectCategory reloadData];
        
    }
    else
    {
        [Utils showAlertView:kAlertTitle message:@"Unable to get details right now. Please try again later." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    }
    
    
}

-(void)requestErrorHandler :(NSError *)inError andRequestIdentifier :(NSString *)inReqIdentifier
{
    [Utils stopActivityIndicatorInView:self.view];
    [Utils showAlertView:kAlertTitle message:@"The Internet connection appears to be offline." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    ;
}


#pragma mark - TableView Delegates

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *customview = [[UIView alloc]init]; //autorelease];
//    
//    //    NSArray* nibcell  = [[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil];
//    //
//    //    [customview addSubview:[nibcell objectAtIndex:0]];
//    
//    return customview;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (![arrCategory count] == 0)
    {
        return [arrCategory count];
    }
    else
    {
        return 10;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:nil];
    
    if (cell == nil)
    {
        NSArray* nib  = [[NSBundle mainBundle] loadNibNamed:@"CellSelectCategory" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    
    // addded by chetan..
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(240/255.0) green:(238/255.0) blue:(233/255.0) alpha:1];
    cell.selectedBackgroundView = selectionColor;
    
    // added by chetan ..
    
    
//    NSLog(@"Response is = %@",arrCategory);

    if (![arrCategory count] == 0)
    {
        cell.textLabel.text =  [[arrCategory objectAtIndex:indexPath.row]valueForKey:@"name"];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Avenir Next Condensed" size:15.0];
    cell.textLabel.highlightedTextColor = [UIColor blackColor];
   
    if (indexpathrow==indexPath.row)
    {
        [self configureCell:cell atIndexPath:indexPath.row];
    }
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 80;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.dicSelectCategory = [arrCategory objectAtIndex:indexPath.row];
    indexpathrow = indexPath.row;
    [self.tblSelectCategory reloadData];
    
    [ItemDetails sharedInstance].dicCategoryDetail = self.dicSelectCategory;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSUInteger)indexPath
{
    
        UIImageView *imgv= (UIImageView *)[cell.contentView viewWithTag:200];
        imgv.image = [UIImage imageNamed:@"iconTickRed@2x.png"];
}



#pragma  - mark Button Methods

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnAddClicked:(id)sender
{
    
}

-(IBAction)btnDoneClicked:(id)sender
{
//    ItemDetailsViewController *item = [[ItemDetailsViewController alloc]init];
    [ItemDetails sharedInstance].dicCategoryDetail = self.dicSelectCategory;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [super dealloc];
}

@end
