//
//  LBFare.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBFare : NSObject

@property NSString *departure;
@property NSString *arrival;
@property NSString *price;
@property NSString *departureZone;
@property NSString *arrivalZone;

- (id) initWithJsonInfo:(NSMutableDictionary*)info;

@end
