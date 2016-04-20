//
//  LBStop.m
//  LazioBus
//
//  Created by Andrea Cerra on 12/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBStop.h"

@implementation LBStop

@synthesize name;
@synthesize type;
@synthesize idRow;
@synthesize idTeleatlas;
@synthesize idPal;
@synthesize idItaGc;
@synthesize coordX;
@synthesize coordY;
@synthesize isFavorites;
@synthesize directions;

- (id) initWithJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            name = [info objectForKey:@"name"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
           name = @"";
        }
        
        @try {
            idTeleatlas = [info objectForKey:@"idTeleatlas"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            idTeleatlas = @"";
        }
        
        @try {
            type = [info objectForKey:@"type"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            type = @"";
        }
        
        @try {
            idRow = [info objectForKey:@"idRow"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            idRow = @"";
        }
        
        @try {
            idPal = [info objectForKey:@"idPal"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            idPal = @"";
        }
        
        @try {
            idItaGc = [info objectForKey:@"idItaGc"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            idItaGc = @"";
        }
        
        @try {
            coordX = [info objectForKey:@"coordX"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            coordX = @"";
        }
        
        @try {
            coordY = [info objectForKey:@"coordY"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            coordY = @"";
        }
        
        //isFavorites = [LBStop isTPFavorites:name];
    }
    
    return self;
}

- (id) initWithLVJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            name = [info objectForKey:@"namePalina"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            name = @"";
        }
        
        @try {
            idPal = [info objectForKey:@"palina"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            idPal = @"";
        }
        
        @try {
            directions = [info objectForKey:@"directions"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            directions = @"";
        }
        
        idTeleatlas = NULL;
        type = NULL;
        idRow = NULL;
        idItaGc = NULL;
        coordX = NULL;
        coordY = NULL;
        coordY = NULL;
        
        //isFavorites = [LBStop isLVFavorites:name :directions];
    }
    
    return self;
}

- (void) tpSaveStopToDatabase {
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *verifica = [db executeQuery:@"SELECT COUNT(name) AS conta FROM tp_last_searches WHERE name = (?)",self.name];
        
        BOOL ver = FALSE;
        
        while([verifica next]){
            if ([verifica intForColumn:@"conta"] > 0) {
                ver = TRUE;
            }
        }
        
        FMResultSet *conta = [db executeQuery:@"SELECT COUNT(*) AS conta FROM tp_last_searches"];
        
        BOOL con = FALSE;
        
        NSInteger limit = 5;
        #if defined(IS_LITE)
            limit = 2;
        #endif
        
        while([conta next]){
            if ([conta intForColumn:@"conta"] > limit) {
                con = TRUE;
            }
        }
        
        //NSLog(@"Error 2 saveStopToDatabse - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        
        if (!ver && con)
            [db executeUpdate:@"DELETE FROM tp_last_searches WHERE id_table = (SELECT MIN(id_table) FROM tp_last_searches)"];
        else
            [db executeUpdate:@"DELETE FROM tp_last_searches WHERE name = (?)",self.name];
        
        [db executeUpdate:@"INSERT INTO tp_last_searches (name,type,idRow,idTeleatlas,idPal,idItaGc,coordX,coordY) VALUES (?,?,?,?,?,?,?,?)",self.name,self.type,self.idRow,self.idTeleatlas,self.idPal,self.idItaGc,self.coordX,self.coordY];
        
        //NSLog(@"Error 1 saveStopToDatabse - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }];
}

- (void) lvSaveStopToDatabase {
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *verifica = [db executeQuery:@"SELECT COUNT(name) AS conta FROM lv_last_searches WHERE name = (?)",self.name];
        
        BOOL ver = FALSE;
        
        while([verifica next]){
            if ([verifica intForColumn:@"conta"] > 0) {
                ver = TRUE;
            }
        }
        
        FMResultSet *conta = [db executeQuery:@"SELECT COUNT(*) AS conta FROM lv_last_searches"];
        
        BOOL con = FALSE;
        
        NSInteger limit = 5;
        #if defined(IS_LITE)
            limit = 2;
        #endif
        
        while([conta next]){
            if ([conta intForColumn:@"conta"] > limit) {
                con = TRUE;
            }
        }
        
        //NSLog(@"Error 2 saveStopToDatabse - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        
        if (!ver && con)
            [db executeUpdate:@"DELETE FROM lv_last_searches WHERE id_table = (SELECT MIN(id_table) FROM lv_last_searches)"];
        else
            [db executeUpdate:@"DELETE FROM lv_last_searches WHERE name = (?)",self.name];
        
        [db executeUpdate:@"INSERT INTO lv_last_searches (name,type,idRow,idTeleatlas,idPal,idItaGc,coordX,coordY,directions) VALUES (?,?,?,?,?,?,?,?,?)",self.name,self.type,self.idRow,self.idTeleatlas,self.idPal,self.idItaGc,self.coordX,self.coordY,self.directions];
        
        //NSLog(@"Error 1 lvSaveStopToDatabase - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    }];
}


+ (NSMutableArray*) getTPLastSearches {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    NSInteger limit = 5;
    #if defined(IS_LITE)
        limit = 2;
    #endif
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM tp_last_searches ORDER BY id_table DESC LIMIT (?)",[NSNumber numberWithInteger:limit]];
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    while([results next]){
        
        LBStop* stop        = [[LBStop alloc] init];
        stop.id_table       = [results intForColumn:@"id_table"];
        stop.name           = [results stringForColumn:@"name"];
        stop.type           = [results stringForColumn:@"type"];
        stop.idRow          = [results stringForColumn:@"idRow"];
        stop.idTeleatlas    = [results stringForColumn:@"idTeleatlas"];
        stop.idPal          = [results stringForColumn:@"idPal"];
        stop.idItaGc        = [results stringForColumn:@"idItaGc"];
        stop.coordX         = [results stringForColumn:@"coordX"];
        stop.coordY         = [results stringForColumn:@"coordY"];
                
        [stops addObject:stop];
    }
    
    //NSLog(@"Error getTPLastSearches - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return stops;
}

+ (NSMutableArray*) getTPfavorites {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM tp_favorites"];
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    while([results next]){
        
        LBStop* stop        = [[LBStop alloc] init];
        stop.id_table       = [results intForColumn:@"id_table"];
        stop.name           = [results stringForColumn:@"name"];
        stop.type           = [results stringForColumn:@"type"];
        stop.idRow          = [results stringForColumn:@"idRow"];
        stop.idTeleatlas    = [results stringForColumn:@"idTeleatlas"];
        stop.idPal          = [results stringForColumn:@"idPal"];
        stop.idItaGc        = [results stringForColumn:@"idItaGc"];
        stop.coordX         = [results stringForColumn:@"coordX"];
        stop.coordY         = [results stringForColumn:@"coordY"];
        
        [stops addObject:stop];
    }
    
    //NSLog(@"Error getTPfavorites - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return stops;
}

+ (NSMutableArray*) getLVLastSearches {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    NSInteger limit = 5;
    #if defined(IS_LITE)
        limit = 2;
    #endif
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM lv_last_searches ORDER BY id_table DESC LIMIT (?)",[NSNumber numberWithInteger:limit]];
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    while([results next]){
        
        LBStop* stop        = [[LBStop alloc] init];
        stop.id_table       = [results intForColumn:@"id_table"];
        stop.name           = [results stringForColumn:@"name"];
        stop.type           = [results stringForColumn:@"type"];
        stop.idRow          = [results stringForColumn:@"idRow"];
        stop.idTeleatlas    = [results stringForColumn:@"idTeleatlas"];
        stop.idPal          = [results stringForColumn:@"idPal"];
        stop.idItaGc        = [results stringForColumn:@"idItaGc"];
        stop.coordX         = [results stringForColumn:@"coordX"];
        stop.coordY         = [results stringForColumn:@"coordY"];
        stop.directions     = [results stringForColumn:@"directions"];
        
        [stops addObject:stop];
    }
    
    //NSLog(@"Error getLVLastSearches - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return stops;
}

+ (NSMutableArray*) getLVFavorites {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM lv_favorites"];
    
    NSMutableArray *stops = [[NSMutableArray alloc] init];
    
    while([results next]){
        
        LBStop* stop        = [[LBStop alloc] init];
        stop.id_table       = [results intForColumn:@"id_table"];
        stop.name           = [results stringForColumn:@"name"];
        stop.type           = [results stringForColumn:@"type"];
        stop.idRow          = [results stringForColumn:@"idRow"];
        stop.idTeleatlas    = [results stringForColumn:@"idTeleatlas"];
        stop.idPal          = [results stringForColumn:@"idPal"];
        stop.idItaGc        = [results stringForColumn:@"idItaGc"];
        stop.coordX         = [results stringForColumn:@"coordX"];
        stop.coordY         = [results stringForColumn:@"coordY"];
        stop.directions     = [results stringForColumn:@"directions"];
        
        [stops addObject:stop];
    }
    
    //NSLog(@"Error getLVFavorites - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return stops;
}

/*+ (BOOL) isTPFavorites:(NSString*)name {
    
    BOOL result = FALSE;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM tp_favorites WHERE name = (?)", name];
    
    while([results next]){
        result = TRUE;
    }
    
    //NSLog(@"Error isTPFavorites - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return result;
}

+ (BOOL) isLVFavorites:(NSString*)name :(NSString*)directions {
    
    BOOL result = FALSE;
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM lv_favorites WHERE name = (?) AND directions = (?)", name, directions];
    
    while([results next]){
        result = TRUE;
    }
    
    //NSLog(@"Error isLVFavorites - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return result;
}*/


- (void) saveTPFavorites{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"INSERT INTO tp_favorites (name,type,idRow,idTeleatlas,idPal,idItaGc,coordX,coordY) VALUES (?,?,?,?,?,?,?,?)",self.name,self.type,self.idRow,self.idTeleatlas,self.idPal,self.idItaGc,self.coordX,self.coordY];
    
    //NSLog(@"Error saveTPFavorites Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

- (void) removeTPFavorites{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"DELETE FROM tp_favorites WHERE name = (?)", self.name];
    
    //NSLog(@"Error removeTPFavorites Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

- (void) removeTPSearch{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"DELETE FROM tp_last_searches WHERE name = (?)", self.name];
    
    //NSLog(@"Error removeTPSearch Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

- (void) saveLVFavorites{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"INSERT INTO lv_favorites (name,type,idRow,idTeleatlas,idPal,idItaGc,coordX,coordY,directions) VALUES (?,?,?,?,?,?,?,?,?)",self.name,self.type,self.idRow,self.idTeleatlas,self.idPal,self.idItaGc,self.coordX,self.coordY,self.directions];
    
    //NSLog(@"Error saveLVFavorites Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

- (void) removeLVFavorites{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"DELETE FROM lv_favorites WHERE name = (?)", self.name];
    
    //NSLog(@"Error removeLVFavorites Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

- (void) removeLVSearch{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"DELETE FROM lv_last_searches WHERE name = (?)", self.name];
    
    //NSLog(@"Error removeLVSearch Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

@end
