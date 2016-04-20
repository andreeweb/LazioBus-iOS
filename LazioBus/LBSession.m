//
//  LBSession.m
//  LazioBus
//
//  Created by Andrea Cerra on 24/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBSession.h"

@implementation LBSession
@synthesize idSession, departure, arrival, jsonTrovaPercorso, rideDetailIndex;

#pragma mark Singleton Methods

+ (id)sharedSession {
    static LBSession *sharedSession = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSession = [[self alloc] init];
    });
    return sharedSession;
}

- (id)init {
    if (self = [super init]) {
        idSession = [[NSString alloc] init];
        departure = [[NSString alloc] init];
        arrival = [[NSString alloc] init];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
