//
//  LBFare.m
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBFare.h"

@implementation LBFare
@synthesize departure, arrival, price, departureZone, arrivalZone;

- (id) initWithJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            departure = [info objectForKey:@"departure"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            departure = @"";
        }
        
        @try {
            arrival = [info objectForKey:@"arrival"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            arrival = @"";
        }
        
        @try {
            price = [info objectForKey:@"price"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            price = @"";
        }
        
        @try {
            departureZone = [info objectForKey:@"departureZone"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            departureZone = @"";
        }
        
        @try {
            arrivalZone = [info objectForKey:@"arrivalZone"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            arrivalZone = @"";
        }
    }
    
    return self;
}

@end
