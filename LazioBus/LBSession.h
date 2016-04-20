//
//  LBSession.h
//  LazioBus
//
//  Created by Andrea Cerra on 24/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBResults.h"

@interface LBSession : NSObject {
    
    //oggetti passati dal server
    NSString *departure;
    NSString *arrival;
    NSString *idSession;
    
    //risultato principale del json trovaPercorso
    LBResults *jsonTrovaPercorso;
}

@property (nonatomic, retain) NSString *departure;
@property (nonatomic, retain) NSString *arrival;
@property (nonatomic, retain) NSString *idSession;
@property LBResults *jsonTrovaPercorso;
@property NSInteger rideDetailIndex;

+ (id)sharedSession;

@end
