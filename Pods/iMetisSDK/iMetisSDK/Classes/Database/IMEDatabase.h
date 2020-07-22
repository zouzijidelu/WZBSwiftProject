//
//  IMEDatabase.h
//  iMetisSDK
//
//  Created by Michael Wu on 2019/6/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 iMetis Database
 */
@interface IMEDatabase : NSObject

@property (nonatomic, assign) NSTimeInterval maxBusyRetryTimeInterval;//!< database retry time interval

@property (nonatomic, assign, readonly) BOOL isOpen;//!< databse whether opened

@property (nonatomic, copy, readonly) NSString *databasePath;//!< database file path

#pragma mark - Api

+ (instancetype)databaseWithPath:(NSString * _Nullable)path;
- (instancetype)initWithPath:(NSString *)path NS_DESIGNATED_INITIALIZER;

- (BOOL)open;
- (BOOL)close;
- (BOOL)interrupt;
- (BOOL)clean;

/**
 Update sqlite

 @param sql sql-string
 @return whether-yes
 */
- (BOOL)executeUpdate:(NSString *)sql;

/**
 Query sqlite

 @param sql sql-string
 @return result-array
 */
- (NSArray<NSDictionary*> *)executeQuery:(NSString *)sql;

#pragma mark - Sqlite information

/**
 Whether sqlite in safe thread
 */
+ (BOOL)isSqliteThreadSafe;

/**
 Get sqlite lib version

 @return lib-version
 */
+ (NSString *)sqliteLibVersion;

/**
 Return sqlite3 void* instance

 @return sqlite3
 */
- (void *)sqliteHandler;

/**
 Sqlite file path

 @return sqlite-file-path
 */
- (const char *)sqlitePath;

@end

NS_ASSUME_NONNULL_END
