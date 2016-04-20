//
//  UILabel+Boldify.m
//  LazioBus
//
//  Created by Andrea Cerra on 29/03/14.
//  Copyright (c) 2014 Andrea Cerra. All rights reserved.
//

#import "UILabel+Boldify.h"

@implementation UILabel (Boldify)

- (void) boldRange: (NSRange) range {
    
    if (![self respondsToSelector:@selector(setAttributedText:)]) {
        return;
    }
    
    //NSLog(@"%@",self.text);
    //NSLog(@"start %d lenght %d",range.location, range.length);
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:self.font.pointSize]} range:range];
    
    self.attributedText = attributedText;
}

- (void) boldSubstring: (NSString*) substring {
   
    NSRange range = [self.text rangeOfString:substring];
    [self boldRange:range];
}

- (void) boldSubstringInRange: (NSString*) delimiter {
    
    NSRange rangeFirst = [self.text rangeOfString:delimiter];
    self.text = [self.text stringByReplacingCharactersInRange:rangeFirst withString:@""];

    NSRange rangeSecond = [self.text rangeOfString:delimiter];
    self.text = [self.text stringByReplacingCharactersInRange:rangeSecond withString:@""];
    
    NSUInteger start = rangeFirst.location;
    NSUInteger lenght = rangeSecond.location - rangeFirst.location;
    
    [self boldRange:NSMakeRange(start, lenght)];
}

@end
