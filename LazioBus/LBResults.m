//
//  LBRide.m
//  LazioBus
//
//  Created by Andrea Cerra on 13/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBResults.h"

@implementation LBResults

@synthesize departureStop;
@synthesize arrivalStop;
@synthesize palinaDeparture;
@synthesize palinaArrival;
@synthesize time;
@synthesize timeTravel;
@synthesize travelNumber;
@synthesize travelRange;
@synthesize travelBus;
@synthesize travelMetro;
@synthesize travelFeet;
@synthesize travelDescription;
@synthesize alternatives;

- (id) initWithJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            departureStop = [info objectForKey:@"departureStop"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            departureStop = @"";
        }
        
        @try {
            arrivalStop = [info objectForKey:@"arrivalStop"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            arrivalStop = @"";
        }
        
        @try {
            palinaDeparture = [info objectForKey:@"palinaDeparture"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            palinaDeparture = @"";
        }
        
        @try {
            palinaArrival = [info objectForKey:@"palinaArrival"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            palinaArrival = @"";
        }
        
        @try {
            time = [info objectForKey:@"time"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            time = @"";
        }
        
        @try {
            timeTravel = [info objectForKey:@"timeTravel"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            timeTravel = @"";
        }
        
        @try {
            travelNumber = [info objectForKey:@"travelNumber"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            travelNumber = @"";
        }
        
        @try {
            travelRange = [info objectForKey:@"travelRange"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            travelRange = @"";
        }
        
        @try {
            travelBus = [info objectForKey:@"travelBus"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            travelBus = @"";
        }
        
        @try {
            travelMetro = [info objectForKey:@"travelMetro"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            travelMetro = @"";
        }
        
        @try {
            travelFeet = [info objectForKey:@"travelFeet"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            travelFeet = @"";
        }
        
        @try {
            alternatives = [[NSMutableArray alloc] init];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
        }
        
        @try {
            
            travelDescription = [[NSMutableArray alloc] init];
            
            NSMutableArray *append = [[NSMutableArray alloc] init];
            append = [info objectForKey:@"travelDescription"];
            
            //splitto il travel number in un array per poi distribuire i numeri di corsa
            NSMutableArray *travelNum = [[NSMutableArray alloc] initWithArray:[self.travelNumber componentsSeparatedByString:@"^"]];
            NSMutableArray *palinaDep = [[NSMutableArray alloc] initWithArray:[self.palinaDeparture componentsSeparatedByString:@"^"]];
            NSMutableArray *palinaArr = [[NSMutableArray alloc] initWithArray: [self.palinaArrival componentsSeparatedByString:@"^"]];
            
            for (int i = 0; i < [append count]; i++) {
                
                LBIndication *indication = [[LBIndication alloc] init];
                indication.type = [[append objectAtIndex:i] objectForKey:@"type"];
                
                //se bus o metro inserisco il numero della corsa
                if ([indication.type isEqualToString:@"bus"] || [indication.type isEqualToString:@"metro"]) {
                    
                    indication.raceNumber = [travelNum objectAtIndex:0];
                    [travelNum removeObjectAtIndex:0];
                    
                    indication.palinaDeparture = [palinaDep objectAtIndex:0];
                    [palinaDep removeObjectAtIndex:0];
                    
                    indication.palinaArrival = [palinaArr objectAtIndex:0];
                    [palinaArr removeObjectAtIndex:0];
                }
                
                indication.text = [[append objectAtIndex:i] objectForKey:@"text"];
                [travelDescription addObject:indication];
            }
            
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            travelDescription = [[NSMutableArray alloc] init];
        }
    }
    
    return self;
}

@end
