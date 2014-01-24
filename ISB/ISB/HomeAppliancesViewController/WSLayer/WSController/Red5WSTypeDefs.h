//========================================================================================
//	
//	$HeadURL: https://my.redfive.biz/svn/zabbix-apps/Codebase/Zabbix/Source/WS Classes/Red5WSTypeDefs.h $
//	$Revision: 1 $
//	$Date: 2013-02-08 17:49:04 +0530 (Fri, 08 Feb 2013) $
//	$Author: shakir.husain $
//	
//	Creator: Shakir Husain
//	Created: 01-Nov-2011
//	Copyright: 2011-2012 Redfive. All rights reserved.
//	
//	Description:
//========================================================================================

#ifndef __Red5WSTypeDefs_H__
#define __Red5WSTypeDefs_H__

#pragma once

typedef enum
{	//Note: All numbers must be in sequence, count is used as array bound.
	eNoRequest = 0,
	eReq_Login = 1,
	eReq_RegisterIPhone,
	eReq_RegisterDeviceToken,
    eReq_Statistics,
	eReq_FetchEditionList,
	eReq_FetchAllEditionList,
    eReq_FetchDeArchitectEditionList,
    eReq_FetchR4PEditionList,
	eReq_SetPurchasedEdition,
    eReq_EnrichmentXml,
	eReq_GetImage,
	eReq_FetchArticleList,
	eReq_FetchAllArticleList,
	eReq_ShortenURL,
	eReq_GetDownloadURL,
	eReqCount
} enRequestType;

typedef enum
{
	eRespNone = 0,
	eResp_Login = 1,
	eResp_RegisterIPhone,
	eResp_RegisterDeviceToken,
    eResp_Statistics,
	eResp_FetchEditionList,
	eResp_SetPurchasedEdition,
    eResp_EnrichmentXml,
	eResp_GetImage,
	eResp_FetchArticleList,
	eResp_ShortenURL,
	eResp_GetDownloadURL,
	eRespCount
} enResponseType;

typedef enum
{
	eReqDiscard_None = 0,
	eReqDiscard_Old			= 1 << 0,
	eReqDiscard_New			= 1 << 1,
	eReqDiscard_Any			= eReqDiscard_New | eReqDiscard_Old,
	eReqDiscard_TypeBased	= 1 << 2,	//Mostly single request at a time, faster way to check the list
	eReqDiscard_DataBased	= 1 << 3	//Compare request contents to find duplicacy
} enRequestDiscardType;


typedef enum
{	//Note: All numbers must be in sequence, count is used as array bound.
	eIDTypeNone = 0,
	eIDType_Report = 1,
	eIDType_Video,
	eIDType_Editorial,
	eIDType_News	
} enIDType;

typedef int	RRWSError;

// enum to map error codes
typedef enum
{
	eWSErr_Success = 0,	//SOAP_OK
	// equivalent gSoap error codes, copied from stdsopa2.h line#1080
	//0 to 42 are soap errors
	eSOAP_EOF					=	EOF,
	eSOAP_ERR					=	EOF,
	eSOAP_CLI_FAULT				=	1,
	eSOAP_SVR_FAULT				=	2,
	eSOAP_TAG_MISMATCH			=	3,
	eSOAP_TYPE					=	4,
	eSOAP_SYNTAX_ERROR			=	5,
	eSOAP_NO_TAG				=	6,
	eSOAP_IOB					=	7,
	eSOAP_MUSTUNDERSTAND		=	8,
	eSOAP_NAMESPACE				=	9,
	eSOAP_USER_ERROR			=	10,
	eSOAP_FATAL_ERROR			=	11,
	eSOAP_FAULT					=	12,
	eSOAP_NO_METHOD				=	13,
	eSOAP_NO_DATA				=	14,
	eSOAP_GET_METHOD			=	15,
	eSOAP_EOM					=	16,
	eSOAP_MOE					=	17,
	eSOAP_HDR					=	18,
	eSOAP_NULL					=	19,
	eSOAP_DUPLICATE_ID			=	20,
	eSOAP_MISSING_ID			=	21,
	eSOAP_HREF					=	22,
	eSOAP_UDP_ERROR				=	23,
	eSOAP_TCP_ERROR				=	24,
	eSOAP_HTTP_ERROR			=	25,
	eSOAP_SSL_ERROR				=	26,
	eSOAP_ZLIB_ERROR			=	27,
	eSOAP_DIME_ERROR			=	28,
	eSOAP_DIME_HREF				=	29,
	eSOAP_DIME_MISMATCH			=	30,
	eSOAP_DIME_END				=	31,
	eSOAP_MIME_ERROR			=	32,
	eSOAP_MIME_HREF				=	33,
	eSOAP_MIME_END				=	34,
	eSOAP_VERSIONMISMATCH		=	35,
	eSOAP_PLUGIN_ERROR			=	36,
	eSOAP_DATAENCODINGUNKNOWN	=	37,
	eSOAP_REQUIRED				=	38,
	eSOAP_PROHIBITED			=	39,
	eSOAP_OCCURS				=	40,
	eSOAP_LENGTH				=	41,
	eSOAP_FD_EXCEEDED			=	42,
	
	/* gSOAP HTTP response status codes 100 to 599 are reserved */
	eSOAP_HTTP_AUTH_ERROR		=	401,
	/* Codes 600 to 999 are HTTP user definable */
	/* Exceptional gSOAP HTTP response status codes >= 1000 */
	// these are till 1003	
	// So keeping AutomationGuide Errors above 2000
	eWSErr_Status_WSError			=	3000,
	
	// Soap error categories, as defined in stdsoap2.h
	eWSErr_XMLError = 6000,
	eWSErr_IncompatibleServer,
	eWSErr_NetworkError,
	eWSErr_SecuredNetworkError,	//SSL Error
	eWSErr_CompressionError,
	eWSErr_HTTPError,
	
	//Errors generated from this machine itself, Request is not sent to server.
	eWSErr_UnknownError,
	eWSErr_InvalidRequest,
	eWSErr_InvalidRequestType,
	eWSErr_InvalidResponseObj,
	eWSErr_InvalidRequestParams,
	eWSErr_NoRequestProcessor,
	eWSErr_UserNotLogedIn,	//Will never come as calls are allowed without login
	eWSErr_DuplicateRequest,
	eWSErr_RequestDiscarded, //due to cancel login or logout in progress.
	eWSErr_ObjectAllocError,
	
	//Request specific errors
	eWSErr_InvalidResponseFromServer,
	eWSErr_InvalidLoginResponseFromServer,
	
} enWSControllerErrCode;

// Status values
typedef enum 
{
	STATUS_FALSE = 0,
	STATUS_TRUE = 1,
	eYES = 1,
	eNO = 0
} enBOOL;


#define STRHTTPToken_Accept					@"Accept"
#define STRHTTPToken_RegistrationID			@"RegistrationId"
#define STRHTTPToken_Signature				@"Signature"
#define STRHTTPToken_Timestamp				@"Timestamp"
#define STRHTTPToken_appversion				@"appversion"
#define STRHTTPToken_iosversion				@"iosversion"
#define STRHTTPToken_platform				@"platform"


#endif	//__Red5WSTypeDefs_H__