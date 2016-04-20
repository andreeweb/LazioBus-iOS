//
//  LBPDF.h
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "FMResultSet.h"

@interface LBPDF : NSObject

@property NSInteger id_table;
@property NSString *localita;
@property NSString *pdf;

//recupero dal db la lista dei pdf
+ (NSMutableArray*) getPDFList;

//salva pdf su database
- (void) savePDF;

//recupero dal db la lista dei pdf salvati
+ (NSMutableArray*) getPDFSavedList;

//rimuovo dal db
- (void) removePDFSaved;

@end
