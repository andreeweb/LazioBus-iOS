//
//  LBLVResult.h
//  LazioBus
//
//  Created by Andrea Cerra on 14/04/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBLVResult : NSObject

@property NSString *route;
@property NSString *programTime;
@property NSString *lastPosition;
@property NSString *state;
@property NSString *detailState;
@property NSString *journey;
@property NSString *direction;

- (id) initWithJsonInfo:(NSMutableDictionary*)info;

@end
