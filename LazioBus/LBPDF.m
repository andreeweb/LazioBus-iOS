//
//  LBPDF.m
//  LazioBus
//
//  Created by Andrea Cerra on 30/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBPDF.h"

@implementation LBPDF

+ (NSMutableArray*) getPDFList {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"] ];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT * FROM pdf_times ORDER BY localita ASC"];
    
    NSMutableArray *pdfArray = [[NSMutableArray alloc] init];
    
    while([results next]){
        
        LBPDF* pdf      = [[LBPDF alloc] init];
        pdf.id_table    = [results intForColumn:@"id_table"];
        pdf.localita    = [results stringForColumn:@"localita"];
        pdf.pdf         = [results stringForColumn:@"pdf"];
        
        [pdfArray addObject:pdf];
    }
    
    //NSLog(@"Error getPDFList - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return pdfArray;
}

+ (NSMutableArray*) getPDFSavedList {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    FMResultSet *results = [db executeQuery:@"SELECT DISTINCT localita, pdf FROM pdf_saved ORDER BY localita ASC"];
    
    NSMutableArray *pdfArray = [[NSMutableArray alloc] init];
    
    while([results next]){
        
        LBPDF* pdf      = [[LBPDF alloc] init];
        //pdf.id_table    = [results intForColumn:@"id_table"];
        pdf.localita    = [results stringForColumn:@"localita"];
        pdf.pdf         = [results stringForColumn:@"pdf"];
        
        [pdfArray addObject:pdf];
    }
    
    //NSLog(@"Error getPDFSavedList - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
    
    return pdfArray;
}

- (void) savePDF {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"INSERT INTO pdf_saved (localita,pdf) VALUES (?,?)",self.localita, self.pdf];
    
    //NSLog(@"Error - savePDF Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

- (void) removePDFSaved {
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[NSUserDefaults standardUserDefaults] objectForKey:@"databasePath"]];
    [db open];
    
    [db executeUpdate:@"DELETE FROM pdf_saved WHERE pdf = (?)", self.pdf];
    
    //NSLog(@"Error - removePDFSaved Error 001 - %d: %@", [db lastErrorCode], [db lastErrorMessage]);
    
    [db close];
}

@end
