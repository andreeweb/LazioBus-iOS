//
//  LBLVResult.m
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBLVResult.h"

@implementation LBLVResult

@synthesize route;
@synthesize programTime;
@synthesize lastPosition;
@synthesize state;
@synthesize detailState;
@synthesize journey;
@synthesize direction;

- (id) initWithJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            route = [info objectForKey:@"route"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            route = @"";
        }
        
        @try {
            programTime = [info objectForKey:@"programTime"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            programTime = @"";
        }
        
        @try {
            lastPosition = [info objectForKey:@"lastPosition"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            lastPosition = @"";
        }
        
        @try {
            state = [info objectForKey:@"state"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            state = @"";
        }
        
        @try {
            detailState = [info objectForKey:@"detailState"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            detailState = @"";
        }
        
        @try {
            journey = [info objectForKey:@"journey"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            journey = @"";
        }
        
        @try {
            direction = [info objectForKey:@"direction"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            direction = @"";
        }
    }
    return self;
}

@end
