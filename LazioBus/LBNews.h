//
//  LBNews.h
//  LazioBus
//
//  Created by Andrea Cerra on 28/05/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBNews : NSObject

@property NSString *newsDate;
@property NSString *newsTitle;
@property NSString *newsNumber;
@property NSString *newsText;

- (id) initWithJsonInfo:(NSMutableDictionary*)info;

@end
