//
//  LBStop.h
//  LazioBus
//
//  Created by Andrea Cerra on 12/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

@interface LBStop : NSObject

@property NSInteger id_table;
@property NSString *name;
@property NSString *type;
@property NSString *idRow;
@property NSString *idTeleatlas;
@property NSString *idPal;
@property NSString *idItaGc;
@property NSString *coordX;
@property NSString *coordY;
@property NSString *directions;

//usato nelle tabelle dove si mostra la star per i preferiti
@property BOOL isFavorites;

//costruttore a partire dal json
- (id) initWithJsonInfo:(NSMutableDictionary*)info;
- (id) initWithLVJsonInfo:(NSMutableDictionary*)info;

//salva la fermata *_last_searches
- (void) tpSaveStopToDatabase;
- (void) lvSaveStopToDatabase;

//recupera dal db l'array delle ultime ricerche per trova percorso
+ (NSMutableArray*) getTPLastSearches;
+ (NSMutableArray*) getLVLastSearches;

//recupera dal db l'array dei preferiti salvati
+ (NSMutableArray*) getLVFavorites;
+ (NSMutableArray*) getTPfavorites;

//controlla se la fermata è presente nei preferiti
/*+ (BOOL) isTPFavorites:(NSString*)name;
+ (BOOL) isLVFavorites:(NSString*)name :(NSString*)directions;*/

//salva per trova percorso un preferito
- (void) saveTPFavorites;
- (void) saveLVFavorites;

//rimuove dal db un preferito
- (void) removeTPFavorites;
- (void) removeLVFavorites;

//rimuovo l'oggetto dalla tabella ultime ricerche
- (void) removeTPSearch;
- (void) removeLVSearch;

@end
