
#import <Foundation/Foundation.h>
#import "SQlite3.h"
@class Product;
@class Category;
@interface DBHandler : NSObject

+(DBHandler*)sharedDatabase;
// Checks if database has already been copied to our working area and copies if didn't
+(void)copyDatabaseIfNeeded;


// Saves Company
-(BOOL)saveProduct:(Product*)inProductData;

-(BOOL)saveCategory:(Category*)ofProduct;
////changed21-6
//-(BOOL)saveTripInfo:(CTripInfo*)inTripInfoData;
//-(BOOL)updateSaveFlagAndLocalTripIdInTripInfo:(NSString *)inLocalTripId andSeverTripId: (NSString *)inServerTripId userid:(NSString *)inUserId andSaveFlag :(BOOL)inSaveFlag;
-(NSArray *)getAllProductByUserId:(NSString *)inUserId;
-(NSArray *)getAllProductName;
////-(NSArray *)getAllTripInfoIds;
//-(NSArray *)getTripInfoByTripId:(NSString *)inTripId andUserId:(NSString *)inUserId;
//
//-(BOOL)IsTripAvailableByTrip :(CTrip *)inTrip;
//
//-(BOOL) deleteTripInfo :(CTripInfo *)inTripInfo;
//-(BOOL) deleteTripInfoTripId :(NSString *)inTripId andUserId:(NSString*)inUserId;
//-(NSArray *)getAllUnsavedTripInfoByUserId:(NSString *)inUserId;
//-(NSArray *)getAllUnsavedLocationsByUserId:(NSString *)inUserId;
//
//
////end
//-(NSArray *)getLastTenLocations;
//-(void)emptyTable:(NSString*)tableName;
//-(NSArray *)getFirstRecord:(NSString*)inTripId;
//-(NSArray *)getLastRecord:(NSString *)inTripId;
//-(NSArray *)getAllLocationsRecord:(NSString*)inTripId;
//-(BOOL)updateSaveFlagAndLocalTripIdInLocations:(NSString *)inLocalTripId andSeverTripId: (NSString *)inServerTripId userid:(NSString *)inUserId andSaveFlag :(BOOL)inSaveFlag;
//-(BOOL)updateSaveFlagAndLocalTripIdInTrips:(NSString *)inLocalTripId andSeverTripId: (NSString *)inServerTripId andSaveFlag :(BOOL)inSaveFlag;
//
//
//-(int)getTotalRecordCount :(NSString *)inTable;
//-(BOOL)createTrip:(CTrip*)inTrip;
//-(NSArray *)getAllTripsSortedByDescendingByRowId;
//-(NSArray *)getAllTripsSortedByAscendingByRowId;
//-(NSArray *)getCurrentTrip;
//-(NSArray *)getAllTrips;
//
//-(NSArray *)getAllTripIds;
//-(BOOL) deleteTrip :(CTrip *)inTrip;
//-(BOOL)deleteAllLocationByTrip:(CTrip *)inTrip;

@end
