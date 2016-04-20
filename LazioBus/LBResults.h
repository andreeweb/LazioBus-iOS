//
//  LBRide.h
//  LazioBus
//
//  Created by Andrea Cerra on 13/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LBIndication.h"

@interface LBResults : NSObject

@property NSString *departureStop;
@property NSString *arrivalStop;
@property NSString *palinaDeparture;
@property NSString *palinaArrival;
@property NSString *time;
@property NSString *timeTravel;
@property NSString *travelNumber;
@property NSString *travelRange;
@property NSString *travelBus;
@property NSString *travelMetro;
@property NSString *travelFeet;
@property NSString *dataTravel;

@property NSMutableArray *travelDescription;
@property NSMutableArray *alternatives;

- (id) initWithJsonInfo:(NSMutableDictionary*)info;

@end
