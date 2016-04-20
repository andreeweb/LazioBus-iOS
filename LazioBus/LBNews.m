//
//  LBNews.m
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "LBNews.h"

@implementation LBNews
@synthesize newsDate, newsTitle, newsNumber, newsText;

- (id) initWithJsonInfo:(NSMutableDictionary*)info {
    
    self = [super init];
    
    if (self) {
        
        @try {
            newsDate = [info objectForKey:@"newsDate"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            newsDate = @"";
        }
        
        @try {
            newsTitle = [info objectForKey:@"newsTitle"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            newsTitle = @"";
        }
        
        @try {
            newsNumber = [info objectForKey:@"newsNumber"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            newsNumber = @"";
        }
        
        @try {
            newsText = [info objectForKey:@"newsText"];
        }
        @catch (NSException *exception) {
            //NSLog(@"%@",exception);
            newsText = @"";
        }
    }
    
    return self;
}

@end
