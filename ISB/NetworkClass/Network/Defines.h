

typedef enum TheRequestTypes
{   
    kLoginRequest=1,
    kBannerIDRequest,
    kPageIDRequest,
    kSprintButtonRequest,
    kGmcButtonRequest,
    kDellButtonRequest,
    kTurbotaxButtonRequest,
    kInvestAmericaButtonRequest,
    kShopAmericaBUttonRequest,
    kSprintDataRequest

}ServerRequestType;

BOOL sprint_data;

//NSString const *DEVICE_TOKEN;
int USERID;
int CATEGORYID;
int COURSEID;
int LESSONID;
int totalItemSell;


//#ifdef DEBUG
//#   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define DLog(...)
//#endif

#define kRequestType	@"RequestType"

#define SOURCETYPE UIImagePickerControllerSourceTypeCamera

#define kAlertTitle     @"Instant Sell/Buy"
#define kSubjectTitle     @"Instant Sell/Buy"


#define	ReleaseObject(obj)					if (obj) { [obj release]; obj = nil; }

#define NULLVALUE(m)                        (m ==[NSNull null]) ? @"" : m
#define kDevicetoken    @"DEVICETOKEN"
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kXMPPmyJID1                     @"kXMPPmyJID"
#define kXMPPmyPassword1                @"kXMPPmyPassword"
#define STRChatServerURL                @"chat.eitcl.co.uk"

#define kMessageCount                     @"0"


#define KNavigationTintColor [UIColor colorWithRed:((float)4 / 255.0f) green:((float)150 / 255.0f) blue:((float)159 / 255.0f) alpha:1]

//http://it0091.com/isb/index.php/categories/get
//#define kBaseURL                       @"http://it0091.com/ISB/index.php/"

//http://chat.eitcl.co.uk/devchat/index.php/
//#define kBaseURL                        @"http://it0091.com/isb/index.php/"


#define kBaseURL                        @"http://chat.eitcl.co.uk/devchat/index.php/"
//#define kImageURL                       @"http://it0091.com/isb/"

#define kImageURL                       @"http://chat.eitcl.co.uk/devchat/"

#define kRequestParameters              @"RequestParameters"
#define SUCCESS                         @"success"
#define DATA                            @"data"
//--------------Sprint_Data---------------

#define  kBaseURL2                       @"https://lovemycu.secure.cu-village.com/client/WebServiceIIA/sprint_data.php"

#define ksprinthash             @"sprinthash"
#define kfirstname              @"firstname"
#define klastname               @"lastname"
#define kstate                  @"state"
#define kdayphone               @"dayphone"
#define kemail                  @"email"
#define ksprintwirelessno       @"sprintwirelessno"
#define ksprintaccno            @"sprintaccno"
#define kscanimg                @"scanimg"
#define kcuname                 @"cuname"
#define kzipcode                @"zipcode"
#define ksignatureimg           @"signatureimg"
#define koptin                  @"optin"


//------------------CUCreditUnion------------------------

#define kCreditUnionName                @"CreditUnionName"
#define kformat                         @"format"
#define kmembertype                     @"membertype"
#define kostype                         @"ostype"

//-------------------BannerID----------------------------

#define kBannerID        @"BannerID"

//-----------------------PageID--------------------------

#define kPageID         @"PageID"


//---------------------Block List name--------------------

#define kBlockList      @"BlockedUsers"
#define kBlockListToAdd @"AddBlockUser"
#define kBlockListToRemove @"RemoveBlockUser"
#define kNewBlockEntry @"NewBlockUserEntry"

//----------------------Rejected List name-------------

#define kRejectList     @"RejectedUsers"
#define kRejectListToAdd @"AddRejectList"
#define kRejectListToremove @"RemoveRejectList"
#define kNewRejectEntry @"NewRejectUserEntry"


//----------------------Active List name------------------

#define kActiveList @"ActiveUsers"


//----------------------NewMessageUserList-----------

#define kNewMsgUserJID @"NewMessageUserId"

#define kBlockedRejectedBy @"BlockRejectedBy"


//----------------------CustomCellViewIdentifier-----------

#define kBlockCellIdentifier @"BlockUserCell"
#define kRejectCellIdentifier @"RejectUserCell"


//-----------------------User Id-----------------------

#define kUserIdKey @"USERID"


//-----------------------------------Error Message while List updating----------------

#define kErrMsgToListUpdate @"Your request is under process. List will be updated soon."


//----------------------------------ErrorMsgOnListRequestPrecessed-----------------

#define kAlertMsgOnListUpdationDone @"Your request has been processed."
