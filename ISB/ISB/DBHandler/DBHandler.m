
#import "DBHandler.h"
//#import "CLocation.h"
//#import "CTrip.h"
//#include "CTripInfo.h"
//#import "NSDateFormatter+SH.h"
//#import "CAppController.h"
//#import "CLoginController.h"
//#import "NSString+SH.h"
#import "Product.h"

@implementation DBHandler

+(DBHandler*)sharedDatabase{
	static DBHandler *sharedDatabaseInstance;
	@synchronized(self){
		if(!sharedDatabaseInstance){
			sharedDatabaseInstance = [[DBHandler alloc]init];
		}
	}
	return sharedDatabaseInstance;
}

// Gets the path of the deployed database copy.
+(NSString*)getDBPath
{
NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirPath = [paths objectAtIndex:0];
	NSString *dbPath = [documentsDirPath stringByAppendingPathComponent:@"ISBdb.sqlite"];
    return dbPath;
}

// Returns YES if database if already copied to documents, NO otherwise
+(BOOL)dbAlreadyCopied
{
  return [[NSFileManager defaultManager] fileExistsAtPath:[DBHandler getDBPath]];
}

// Checks if database has already been copied to our working area and copies if didn't

+(void)copyDatabaseIfNeeded{
	BOOL dbExists = [DBHandler dbAlreadyCopied];
	if(!dbExists)
    {
		NSString *dataBasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ISBdb.sqlite"];
		[[NSFileManager defaultManager] copyItemAtPath:dataBasePath toPath:[DBHandler getDBPath] error:NULL];
	}
    else
    {
//        SHLogs(eLLDebugInfo, thisFileA, @"db Already Copied");

    }
}

// Runs the query except SELECT
-(BOOL)runQuery:(NSString*)theQuery
{

	sqlite3 *database;
    NSString *dbPath = [DBHandler getDBPath];
	int result = sqlite3_open([dbPath UTF8String], &database);
	if(result != SQLITE_OK) sqlite3_close(database);
    else{
		int returnValue = sqlite3_exec(database, [theQuery UTF8String],NULL, NULL, NULL);
		if (returnValue != SQLITE_OK) {
            NSLog( @"*** Query %@ failed with returncode= %d ***",theQuery, returnValue);

            sqlite3_close(database);
	        return NO;
		}
		sqlite3_close(database);
		return YES;
    }
    return NO;
}
//////////////////////////////////////////////////////////////////////////
//+(CGFloat)calculateDistanceBetweenSource:(CLLocationCoordinate2D)firstCoords andDestination:(CLLocationCoordinate2D)secondCoords
//{
//    
//    // this radius is in KM => if miles are needed it is calculated during setter of Place.distance
//    
//    double nRadius = 6371;
//    
//    // Get the difference between our two points
//    
//    // then convert the difference into radians
//    
//    double nDLat = (firstCoords.latitude - secondCoords.latitude)* (M_PI/180);
//    double nDLon = (firstCoords.longitude - secondCoords.longitude)* (M_PI/180);
//    
//    double nLat1 =  secondCoords.latitude * (M_PI/180);
//    double nLat2 =  secondCoords.latitude * (M_PI/180);
//    
//    double nA = pow ( sin(nDLat/2), 2 ) + cos(nLat1) * cos(nLat2) * pow ( sin(nDLon/2), 2 );
//    
//    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
//    
//    double nD = nRadius * nC;
//        
//    return nD; // converts to miles or not (if en_) => implicit in method
//}
//////////
#pragma mark -
#pragma mark Company
// Saves Location
-(BOOL)saveCategory:(Category *)ofProduct
{
BOOL toReturn = NO;
    NSString *id = [NSString emptyString];
    NSString *name =[NSString emptyString];
    if (![self getData: ofProduct])
    {
        // double lat = [[inLocationData objectAtIndex:0]];
        NSString *query = [NSString stringWithFormat:@"INSERT INTO Category VALUES (\"%@\",\"%@\")",id,name];
        toReturn =  [self runQuery:query];
    }
    
    return toReturn;


}

//-(BOOL)saveProduct:(Product *)inProductData
//{
//    BOOL toReturn = NO;
//    
//    NSString *dateStr = [NSString emptyString];
//    NSString *aAddress =[NSString emptyString];
//    NSString * aTripId = [NSString emptyString];
//    NSString *aUserId = [NSString emptyString];
//    
//    
//    double  lat =  inLocationData.CurrLocation.coordinate.latitude;
//    double  longt =  inLocationData.CurrLocation.coordinate.longitude;
//    if (inLocationData.DateString && [inLocationData.DateString length] > 0)
//    {
//        dateStr = [NSString stringWithString: inLocationData.DateString];
//
//    }
//    if (inLocationData.CurrAddress && [inLocationData.CurrAddress length] > 0)
//    {
//        aAddress  = [NSString stringWithString: inLocationData.CurrAddress];
//        
//    }
//    if (inLocationData.TripId && [inLocationData.TripId length] > 0)
//    {
//        aTripId = inLocationData.TripId;
//        
//    }
//    if (inLocationData.UserId && [inLocationData.UserId length] > 0)
//    {
//        aUserId = inLocationData.UserId;
//        
//    }
//
//    
//    double distance = inLocationData.Distance;
//    
//    if ([aAddress  length] <= 0)
//        return toReturn;
//    if (![self getLocation: inLocationData])
//    {
//        // double lat = [[inLocationData objectAtIndex:0]];
//        NSString *query = [NSString stringWithFormat:@"INSERT INTO TLocations VALUES (%f, %f,\"%@\",\"%@\",%f,%d,\"%@\",\"%@\",\"%@\")",lat,longt,dateStr,aAddress,distance,inLocationData.SaveFalg,aTripId,aUserId,inLocationData.ServerTripId];
//        toReturn =  [self runQuery:query];
//    }
//    
//    return toReturn;
//}
////changed21-6
//-(BOOL)saveTripInfo:(CTripInfo*)inTripInfoData
//{
//    BOOL toReturn = NO;
//    
//    if (!inTripInfoData)
//        return toReturn;
//   
//    
//    if (![self getTripInfo : inTripInfoData])
//    {
//        // double lat = [[inLocationData objectAtIndex:0]];
//        NSString *query = [NSString stringWithFormat:@"INSERT INTO TTripInfo VALUES (\"%@\", %d,\"%@\",\"%@\",%f,\"%@\",%f,%f,\"%@\",\"%@\",%f,%f,\"%@\",\"%@\")"
//                           ,inTripInfoData.TripId,inTripInfoData.SaveFalg,inTripInfoData.UserId,inTripInfoData.SubscriptionId,inTripInfoData.Distance,inTripInfoData.StartDateTime,inTripInfoData.StartLocation.coordinate.latitude,inTripInfoData.StartLocation.coordinate.longitude,inTripInfoData.StartAddress,inTripInfoData.EndDateTime,inTripInfoData.EndLocation.coordinate.latitude,inTripInfoData.EndLocation.coordinate.longitude,inTripInfoData.EndAddress,inTripInfoData.ServerTripId];
//        toReturn =  [self runQuery:query];
//    }
//    
//    
//    if (toReturn)
//    {
//        // delete the oldest TripInfo
//        NSArray *aAllTripInfo =  [gAppController sortGivenTripInfoByStartDateInAscending :[self getLastTenTripInfo]];
//        
//        int coun  = [aAllTripInfo  count];
//        if (coun == 11)
//        {
//            CTripInfo * aTripInfo = [aAllTripInfo objectAtIndex: 0];//[[aAllTripInfo objectAtIndex: 0] TripId];
//            
//            [self deleteTripInfo: aTripInfo];
//        }
//
//        
//        //delete the oldest trip
//        NSArray *aAllTripIds = [gAppController sortGivenTripsByStartDateInAscending:[self getAllTrips]];
//        //[self getAllTripsSortedByAscendingByRowId];
//        
//        coun  = [aAllTripIds  count];
//        if (coun == 11)
//        {
//            CTrip *aTrip = [aAllTripIds objectAtIndex:0];//[NSString stringWithString:[[aAllTripIds objectAtIndex:0] TripId]];
//            
//            [self deleteTrip: aTrip];
//            
//            [self deleteAllLocationByTrip : aTrip];
//            
//        }
//
//    }
//    else
//    {
//        NSLog(@"*** trip info is not saved ****");
//    }
//    
//    return toReturn;
//
//}
////end
//
//-(BOOL)updateSaveFlagAndLocalTripIdInTripInfo:(NSString *)inLocalTripId andSeverTripId: (NSString*)inServerTripId userid:(NSString *)inUserId andSaveFlag :(BOOL)inSaveFlag
//{
//    BOOL toReturn = NO;
//    
//    if ([inLocalTripId length] <= 0)
//        return toReturn;
//    
//    // double lat = [[inLocationData objectAtIndex:0]];
//    NSString *query = [NSString stringWithFormat:@"UPDATE TTripInfo SET saveFlag=%d , serverTripId =\"%@\" WHERE userId = \"%@\" and tripId = \"%@\" ",inSaveFlag,inServerTripId,inUserId,inLocalTripId];
//    toReturn =  [self runQuery:query];
//    
//    return toReturn;
//}
//
//-(BOOL)updateSaveFlagAndLocalTripIdInLocations:(NSString *)inLocalTripId andSeverTripId: (NSString *)inServerTripId userid:(NSString *)inUserId andSaveFlag :(BOOL)inSaveFlag
//{
//    BOOL toReturn = NO;
//    
//    if ([inLocalTripId length] <= 0)
//        return toReturn;
//    
//    // double lat = [[inLocationData objectAtIndex:0]];
//    NSString *query = [NSString stringWithFormat:@"UPDATE TLocations SET saveFlag=%d , serverTripId =\"%@\" WHERE userId = \"%@\" and tripId = \"%@\" ",inSaveFlag,inServerTripId,inUserId,inLocalTripId];
//    toReturn =  [self runQuery:query];
//    
//    return toReturn;
//
//}
//
//-(BOOL)updateSaveFlagAndLocalTripIdInTrips:(NSString *)inLocalTripId andSeverTripId: (NSString *)inServerTripId andSaveFlag :(BOOL)inSaveFlag
//{
//    BOOL toReturn = NO;
//    
//    if ([inLocalTripId length] <= 0)
//        return toReturn;
//    
//    // double lat = [[inLocationData objectAtIndex:0]];
//    NSString *query = [NSString stringWithFormat:@"UPDATE TTrips SET saveFlag=%d , serverTripId =\"%@\" WHERE tripId = \"%@\" AND userId = %d ",inSaveFlag,inServerTripId,inLocalTripId,[gLoginController GetUserId]];
//    toReturn =  [self runQuery:query];
//    
//    return toReturn;
//
//}
//
//-(BOOL)IsTripAvailableByTrip :(CTrip *)inTrip
//{
//    BOOL toReturn = NO;
//    
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//		NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTrips WHERE tripId = \"%@\" AND userId = \"%@\"",inTrip.TripId,inTrip.UserId];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            toReturn = YES;
//            break;
//            
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return toReturn;
//
//}
//
//-(BOOL)createTrip:(CTrip*)inTrip
//{
//    BOOL toReturn = NO;
//    
//    if (!inTrip)
//    {
//        SHLogs(eLLErrors, thisFileA, @"*** CTripInfo = nil *** ");
//
//        return toReturn;
//    }
//    //  NSDateFormatter *dateformat = [NSDateFormatter RRUIDateFormatter];
//    
//    if (![self IsTripAvailableByTrip: inTrip])
//    {
//        NSString *dateStr =[NSString emptyString] ;
//        NSString *aServerId = [NSString emptyString];
//        NSString *aUserId =[NSString emptyString];
//        NSString *aSubscriptionId = [NSString emptyString];
//        NSString *aServerTripId = [NSString emptyString];
//
//        if (inTrip.StartTime)
//        {
//            dateStr = [NSString stringWithString: inTrip.StartTime];
//            
//        }
//        if (inTrip.ServerId)
//        {
//            aServerId  = [NSString stringWithString: inTrip.ServerId];
//            
//        }
//        NSString * aTripId  = [NSString stringWithFormat:@"%@",inTrip.TripId]; ;
//        if (inTrip.UserId)
//        {
//            aUserId  = [NSString stringWithString: inTrip.UserId];
//            
//        }
//        if (inTrip.SubscriptionId)
//        {
//            aSubscriptionId  = [NSString stringWithString: inTrip.SubscriptionId];
//            
//        }
//        if (inTrip.ServerTripId)
//        {
//            aServerTripId  = [NSString stringWithString: inTrip.ServerTripId];
//            
//        }
//
//        
//        BOOL aSaveFlag  = inTrip.SaveFalg;
//        
//        
//        NSString *query = [NSString stringWithFormat:@"INSERT INTO TTrips VALUES (\"%@\",\"%@\",%d,\"%@\",\"%@\",\"%@\",\"%@\")",aTripId,aUserId,aSaveFlag,dateStr,aServerId,aSubscriptionId,aServerTripId];
//       
//        toReturn =  [self runQuery:query];
//
//    }
//    else
//    {
//        SHLogs(eLLErrors, thisFileA, @"*** This trip Id already exist *** ");
//
//        
//    }
//    
//    return toReturn;
//}
//
//
//#pragma mark -
//// Delete all records of the table
//-(void)emptyTable:(NSString*)tableName{
//	NSString *query = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
//	[self runQuery:query];
//}
//
//-(BOOL) deleteTrip :(CTrip *)inTrip
//{
//    BOOL toReturn = NO;
//    
//    {
//        NSString *query = [NSString stringWithFormat:@"DELETE FROM TTrips Where tripId=\"%@\" AND userId = \"%@\"",inTrip.TripId,inTrip.UserId];
//        toReturn =  [self runQuery:query];
//    }
//    
//    return toReturn;
//}
//
//-(BOOL)deleteAllLocationByTrip:(CTrip *)inTrip
//{
//    BOOL toReturn = NO;
//        
//    {
//        NSString *query = [NSString stringWithFormat:@"DELETE FROM TLocations Where tripId=\"%@\" AND userId = \"%@\"",inTrip.TripId ,inTrip.UserId];
//        toReturn =  [self runQuery:query];
//    }
//    
//    return toReturn;
//}


// Fetches MenuIds w.r.t. a location id
-(BOOL)getData:(Category *)ofProduct
{
    BOOL toReturn = NO;
    sqlite3 *database;
	NSString *dbPath = [DBHandler getDBPath];
	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
		sqlite3_stmt *statement;
		NSString *query = [NSString stringWithFormat:@"SELECT * FROM Category"];
       NSLog(@"Select Query is generated %@", query);

		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
		while(sqlite3_step(statement) == SQLITE_ROW)
        {
            toReturn = YES;
            break;
            
		}
		sqlite3_finalize(statement);
		sqlite3_close(database);
	}
	return toReturn;
}

//-(BOOL)getTripInfo:(CTripInfo *)inTripInfoData
//{
//    BOOL toReturn = NO;
//    if (!inTripInfoData)
//        return toReturn = YES;
//    
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//		NSString *query = [NSString stringWithFormat:@"SELECT * FROM TripInfo WHERE tripId = \"%@\" AND userId = \"%@\" ",inTripInfoData.TripId,inTripInfoData.UserId];
//                
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            toReturn = YES;
//            break;
//            
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return toReturn;
//}


//-(NSArray *)getAllTripInfoIds
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTripInfo ORDER BY rowid ASC "];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            [resultSet addObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//		}
//		
//        sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//
//}
//
//-(NSArray *)getTripInfoByTripId:(NSString *)inTripId andUserId:(NSString *)inUserId
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTripInfo WHERE tripId=\"%@\" AND userId=\"%@\"",inTripId,inUserId];
//    sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CTripInfo *aTripInfo = [[CTripInfo alloc] init];
//            aTripInfo.TripId  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aTripInfo.SaveFalg = (int)sqlite3_column_int(statement,1);
//            aTripInfo.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            
//            aTripInfo.SubscriptionId =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aTripInfo.Distance = (double)sqlite3_column_double(statement,4);
//            aTripInfo.StartDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//            
//            CLLocationCoordinate2D aStartCoordinate;
//            aStartCoordinate.latitude = (double)sqlite3_column_double(statement,6);
//            aStartCoordinate.longitude = (double)sqlite3_column_double(statement,7);
//            
//            CLLocation *aStartlocation = [[CLLocation alloc] initWithLatitude:aStartCoordinate.latitude longitude:aStartCoordinate.longitude];
//            
//            aTripInfo.StartLocation = aStartlocation;
//            [aStartlocation release]; aStartlocation = nil;
//            
//            aTripInfo.StartAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//            aTripInfo.EndDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//            
//            CLLocationCoordinate2D aEndCoordinate;
//            aEndCoordinate.latitude = (double)sqlite3_column_double(statement,10);
//            aEndCoordinate.longitude = (double)sqlite3_column_double(statement,11);
//            
//            CLLocation *aEndlocation = [[CLLocation alloc] initWithLatitude:aEndCoordinate.latitude longitude:aEndCoordinate.longitude];
//            
//            aTripInfo.EndLocation = aEndlocation;
//            [aEndlocation release]; aEndlocation = nil;
//            
//            aTripInfo.EndAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
//            
//            
//			[resultSet addObject: aTripInfo];
//            [aTripInfo release]; aTripInfo = nil;
//		}
//		
//        sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//
//}
//
//-(BOOL) deleteTripInfo :(CTripInfo *)inTripInfo
//{
//    BOOL toReturn = NO;
//    
//    {
//        NSString *query = [NSString stringWithFormat:@"DELETE FROM TTripInfo Where tripId=\"%@\" AND userId = \"%@\"",inTripInfo.TripId,inTripInfo.UserId];
//        toReturn =  [self runQuery:query];
//    }
//    
//    return toReturn;
//
//}
//
//-(BOOL) deleteTripInfoTripId :(NSString *)inTripId andUserId:(NSString*)inUserId
//{
//    BOOL toReturn = NO;
//    
//    {
//        NSString *query = [NSString stringWithFormat:@"DELETE FROM TTripInfo Where tripId=\"%@\" AND userId=\"%@\"",inTripId,inUserId];
//        toReturn =  [self runQuery:query];
//    }
//    
//    return toReturn;
//
//}
//
//// This is used in Test View controller only
//-(NSArray *)getLastTenLocations
//{
//	NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//		NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations"];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CLocation *aLocation = [[CLocation alloc] init];
//            CLLocationCoordinate2D aCoordinate;
//            aCoordinate.latitude  = (double)sqlite3_column_double(statement,0);
//            aCoordinate.longitude = (double)sqlite3_column_double(statement,1);
//            
//            CLLocation *aCurrLocation = [[CLLocation alloc] initWithLatitude:aCoordinate.latitude longitude:aCoordinate.longitude];
//            
//            aLocation.CurrLocation = aCurrLocation;
//            aLocation.DateString =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            aLocation.CurrAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aLocation.Distance = (double)sqlite3_column_double(statement,4);
//            aLocation.SaveFalg = (double)sqlite3_column_double(statement,5);
//
//            
//			[resultSet addObject: aLocation];
//            
//            [aCurrLocation release]; aCurrLocation = nil;
//            
//            [aLocation release]; aLocation = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}
//
//// getfirstRecord
//-(NSArray *)getFirstRecord:(NSString *)inTripId
//{
//	NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//        
//        // First record
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations WHERE tripId=\"%@\" AND userId = %d ORDER BY rowid ASC LIMIT 1 ",inTripId,[gLoginController GetUserId]];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//
//        // Last record
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CLocation *aLocation = [[CLocation alloc] init];
//            CLLocationCoordinate2D aCoordinate;
//            aCoordinate.latitude  = (double)sqlite3_column_double(statement,0);
//            aCoordinate.longitude = (double)sqlite3_column_double(statement,1);
//            
//            aLocation.DateString =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            aLocation.CurrAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            
//            aLocation.Distance = (double)sqlite3_column_double(statement,4);
//            aLocation.SaveFalg = (double)sqlite3_column_double(statement,5);
//            
//            // custome current location
//            CLLocation *aCurrlocation = [[CLLocation alloc] initWithLatitude:aCoordinate.latitude longitude:aCoordinate.longitude];
//            aLocation.CurrLocation = aCurrlocation;
//            
//            [aCurrlocation release]; aCurrlocation = nil;
//
//			[resultSet addObject: aLocation];
//            [aLocation release]; aLocation = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}
//
//// getlastRecord
//
//-(NSArray *)getLastRecord:(NSString *)inTripId
//{
//	NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//		  // First record
//        
//        // Last record
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations WHERE tripId=\"%@\" AND userId = %d ORDER BY rowid DESC LIMIT 1",inTripId,[gLoginController GetUserId]];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CLocation *aLocation = [[CLocation alloc] init];
//            CLLocationCoordinate2D aCoordinate;
//            aCoordinate.latitude  = (double)sqlite3_column_double(statement,0);
//            aCoordinate.longitude = (double)sqlite3_column_double(statement,1);
//            
//            aLocation.DateString =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            aLocation.CurrAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            
//            aLocation.Distance = (double)sqlite3_column_double(statement,4);
//            aLocation.SaveFalg = (double)sqlite3_column_double(statement,5);
//            
//            // custome current location 
//            CLLocation *aCurrlocation = [[CLLocation alloc] initWithLatitude:aCoordinate.latitude longitude:aCoordinate.longitude];
//            aLocation.CurrLocation = aCurrlocation;
//            
//            [aCurrlocation release]; aCurrlocation = nil;
//            
//			[resultSet addObject: aLocation];
//            [aLocation release]; aLocation = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}
//
///// Not in used
//-(int)getTotalRecordCount :(NSString *)inTable;
//{
//    int toReturn = 0;
//    
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//		  
//        NSString *query = [NSString stringWithFormat:@"SELECT COUNT(rowid) FROM \"%@\"",inTable];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            toReturn  = (int)sqlite3_column_int(statement,0);
//           
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//    
//    return toReturn;
//}
//
//
////*** not in used ***
//-(NSArray *)getCurrentTrip
//{
//	NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//		//NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations"];
//        
//        // First record
//        // NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations ORDER BY rowid ASC LIMIT 1"];
//        
//        // Last record
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTrips ORDER BY rowid DESC LIMIT 1"];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CTrip *aLastTrip = [[CTrip alloc] init];
//            
//            
//            aLastTrip.TripId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aLastTrip.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//            
//           // aLastTrip.SaveFalg = (int)sqlite3_column_int(statement,2);
//            aLastTrip.StartTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aLastTrip.ServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//            aLastTrip.SubscriptionId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//
//            
//			[resultSet addObject: aLastTrip];
//            [aLastTrip release]; aLastTrip = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}
//
//-(NSArray *)getAllTripsSortedByDescendingByRowId
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//		//NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations"];
//        
//        // First record
//        // NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations ORDER BY rowid ASC LIMIT 1"];
//        
//        // Last record
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTrips ORDER BY rowid Desc"];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CTrip *aLastTrip = [[CTrip alloc] init];
//            
//            
//            aLastTrip.TripId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aLastTrip.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//            
//            aLastTrip.SaveFalg = (int)sqlite3_column_int(statement,2);
//            aLastTrip.StartTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aLastTrip.ServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//            aLastTrip.SubscriptionId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//            
//            
//			[resultSet addObject: aLastTrip];
//            [aLastTrip release]; aLastTrip = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//    
//}

//-(NSArray *)getAllProductName
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//		
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM Category WHERE userId = %@",[LoginViewController GetUserId]];
//        SHLogs(@"Select Query is generated %@");
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            Category *aData = [[Category alloc] init];
//            
//            
//            aData.name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aLastTrip.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//			[resultSet addObject: aLastTrip];
//            [aLastTrip release]; aLastTrip = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}

////*****This is not in used *****
//-(NSArray *)getAllTripsSortedByAscendingByRowId
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//		//NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations"];
//        
//        // First record
//        // NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations ORDER BY rowid ASC LIMIT 1"];
//        
//        // Last record
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTrips ORDER BY rowid Asc"];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CTrip *aLastTrip = [[CTrip alloc] init];
//            
//            
//            aLastTrip.TripId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aLastTrip.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
//            
//            aLastTrip.SaveFalg = (int)sqlite3_column_int(statement,2);
//            aLastTrip.StartTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aLastTrip.ServerId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
//            aLastTrip.SubscriptionId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//            
//            
//			[resultSet addObject: aLastTrip];
//            [aLastTrip release]; aLastTrip = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//    
//}
//
//
////*****This is not in used *****
//
//-(NSArray *)getAllTripIds
//{
//	NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTrips ORDER BY rowid ASC"];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {                        
//            [resultSet addObject: [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]];
//		}
//		
//        sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}
//
//-(NSArray *)getLastTenTripInfo
//{
//	NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTripInfo WHERE userId = %d ",[gLoginController GetUserId]];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CTripInfo *aTripInfo = [[CTripInfo alloc] init];
//            aTripInfo.TripId  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aTripInfo.SaveFalg = (int)sqlite3_column_int(statement,1);
//            aTripInfo.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//
//            aTripInfo.SubscriptionId =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aTripInfo.Distance = (double)sqlite3_column_double(statement,4);            
//            aTripInfo.StartDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//           
//            CLLocationCoordinate2D aStartCoordinate;
//            aStartCoordinate.latitude = (double)sqlite3_column_double(statement,6);
//            aStartCoordinate.longitude = (double)sqlite3_column_double(statement,7);
//           
//            CLLocation *aStartlocation = [[CLLocation alloc] initWithLatitude:aStartCoordinate.latitude longitude:aStartCoordinate.longitude];
//           
//            aTripInfo.StartLocation = aStartlocation;
//            [aStartlocation release]; aStartlocation = nil;
//            
//            aTripInfo.StartAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//            aTripInfo.EndDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//            
//            CLLocationCoordinate2D aEndCoordinate;
//            aEndCoordinate.latitude = (double)sqlite3_column_double(statement,10);
//            aEndCoordinate.longitude = (double)sqlite3_column_double(statement,11);
//            
//            CLLocation *aEndlocation = [[CLLocation alloc] initWithLatitude:aEndCoordinate.latitude longitude:aEndCoordinate.longitude];
//            
//            aTripInfo.EndLocation = aEndlocation;
//            [aEndlocation release]; aEndlocation = nil;
//            
//            aTripInfo.EndAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
//
//            
//			[resultSet addObject: aTripInfo];
//            [aTripInfo release]; aTripInfo = nil;
//		}
//		
//        sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//}
//
//
//-(NSArray *)getAllUnsavedTripInfoByUserId:(NSString *)inUserId
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
//    {
//		sqlite3_stmt *statement;
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TTripInfo WHERE userId = \"%@\" AND saveFlag = 0",inUserId];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//        
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		
//        while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CTripInfo *aTripInfo = [[CTripInfo alloc] init];
//            aTripInfo.TripId  = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
//            aTripInfo.SaveFalg = (int)sqlite3_column_int(statement,1);
//            aTripInfo.UserId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            
//            aTripInfo.SubscriptionId =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            aTripInfo.Distance = (double)sqlite3_column_double(statement,4);
//            aTripInfo.StartDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
//            
//            CLLocationCoordinate2D aStartCoordinate;
//            aStartCoordinate.latitude = (double)sqlite3_column_double(statement,6);
//            aStartCoordinate.longitude = (double)sqlite3_column_double(statement,7);
//            
//            CLLocation *aStartlocation = [[CLLocation alloc] initWithLatitude:aStartCoordinate.latitude longitude:aStartCoordinate.longitude];
//            
//            aTripInfo.StartLocation = aStartlocation;
//            [aStartlocation release]; aStartlocation = nil;
//            
//            aTripInfo.StartAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//            aTripInfo.EndDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
//            
//            CLLocationCoordinate2D aEndCoordinate;
//            aEndCoordinate.latitude = (double)sqlite3_column_double(statement,10);
//            aEndCoordinate.longitude = (double)sqlite3_column_double(statement,11);
//            
//            CLLocation *aEndlocation = [[CLLocation alloc] initWithLatitude:aEndCoordinate.latitude longitude:aEndCoordinate.longitude];
//            
//            aTripInfo.EndLocation = aEndlocation;
//            [aEndlocation release]; aEndlocation = nil;
//            
//            aTripInfo.EndAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
//            
//            
//			[resultSet addObject: aTripInfo];
//            [aTripInfo release]; aTripInfo = nil;
//		}
//		
//        sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//
//    
//}
//-(NSArray *)getAllUnsavedLocationsByUserId:(NSString *)inUserId
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//        
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations WHERE saveFlag = 0 AND userId = \"%@\" ",inUserId];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CLocation *aLocation = [[CLocation alloc] init];
//            CLLocationCoordinate2D aCoordinate;
//            aCoordinate.latitude  = (double)sqlite3_column_double(statement,0);
//            aCoordinate.longitude = (double)sqlite3_column_double(statement,1);
//            
//            aLocation.DateString =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            aLocation.CurrAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            
//            aLocation.Distance = (double)sqlite3_column_double(statement,4);
//            aLocation.SaveFalg = (double)sqlite3_column_double(statement,5);
//            aLocation.TripId    = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
//            aLocation.UserId     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
//            aLocation.ServerTripId     = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
//
//            // custome current location
//            CLLocation *aCurrlocation = [[CLLocation alloc] initWithLatitude:aCoordinate.latitude longitude:aCoordinate.longitude];
//            aLocation.CurrLocation = aCurrlocation;
//            
//            [aCurrlocation release]; aCurrlocation = nil;
//            
//			[resultSet addObject: aLocation];
//            [aLocation release]; aLocation = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//
//}
//
//-(NSArray *)getAllLocationsRecord:(NSString *)inTripId
//{
//    NSMutableArray *resultSet = [[[NSMutableArray alloc]init] autorelease];
//	sqlite3 *database;
//	NSString *dbPath = [DBHandler getDBPath];
//	if(sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK){
//		sqlite3_stmt *statement;
//        // First record
//        
//        // Last record
//        NSString *query = [NSString stringWithFormat:@"SELECT * FROM TLocations WHERE tripId=\"%@\" AND userId = %d ORDER BY rowid ASC",inTripId,[gLoginController GetUserId]];
//        SHLogs(eLLDebugInfo, thisFileA, @"Select Query is generated %@", query);
//		sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil);
//		while(sqlite3_step(statement) == SQLITE_ROW)
//        {
//            CLocation *aLocation = [[CLocation alloc] init];
//            CLLocationCoordinate2D aCoordinate;
//            aCoordinate.latitude  = (double)sqlite3_column_double(statement,0);
//            aCoordinate.longitude = (double)sqlite3_column_double(statement,1);
//            
//            aLocation.DateString =  [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
//            aLocation.CurrAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
//            
//            aLocation.Distance = (double)sqlite3_column_double(statement,4);
//            aLocation.SaveFalg = (double)sqlite3_column_double(statement,5);
//            
//            // custome current location
//            CLLocation *aCurrlocation = [[CLLocation alloc] initWithLatitude:aCoordinate.latitude longitude:aCoordinate.longitude];
//            aLocation.CurrLocation = aCurrlocation;
//            
//            [aCurrlocation release]; aCurrlocation = nil;
//            
//			[resultSet addObject: aLocation];
//            [aLocation release]; aLocation = nil;
//		}
//		sqlite3_finalize(statement);
//		sqlite3_close(database);
//	}
//	return resultSet;
//
//}




-(void)dealloc
{
	
	[super dealloc];
}
@end
