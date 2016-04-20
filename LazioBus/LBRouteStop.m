//
//  LBRouteStop.m
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBRouteStop.h"

@implementation LBRouteStop
@synthesize stopColor, stopName, hitHour;

- (id) initWithJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            stopColor = [info objectForKey:@"stopColor"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            stopColor = @"";
        }
        
        @try {
            stopName = [info objectForKey:@"stopName"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            stopName = @"";
        }
        
        @try {
            hitHour = [info objectForKey:@"hitHour"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            hitHour = @"";
        }
    }
    
    return self;
}

@end
