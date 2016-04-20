//
//  LBRouteStop.h
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBRouteStop : NSObject

@property NSString *stopName;
@property NSString *stopColor;
@property NSString *hitHour;

- (id) initWithJsonInfo:(NSMutableDictionary*)info;

@end
