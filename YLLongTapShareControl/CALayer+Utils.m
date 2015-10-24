//
//  CALayer+Utils.m
//  YLLongTapShareControlDemo
//
//  Created by Kien NGUYEN on 24/10/2015.
//  Copyright © 2015 Yong Li. All rights reserved.
//

#import "CALayer+Utils.h"

@implementation CALayer (Utils)

- (void)addShadow {
    self.shadowColor = [UIColor blackColor].CGColor;
    self.shadowOpacity = .3f;
    self.shadowRadius = 2.f;
    self.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

@end
