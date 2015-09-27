//
//  YLShareItem.m
//  YLLongTapShareControlDemo
//
//  Created by Kien NGUYEN on 27/09/2015.
//  Copyright © 2015 Yong Li. All rights reserved.
//

#import "YLShareItem.h"

@interface YLShareItem ()

@property (nonatomic) UIImage *icon;
@property (nonatomic) NSString *title;

@end

@implementation YLShareItem

+ (YLShareItem*)itemWithImageNamed:(NSString *)imageName
                          andTitle:(NSString *)title {
    return [self itemWithImageNamed:imageName
                           andTitle:title
                         shouldTint:NO];
}

+ (YLShareItem*)itemWithImageNamed:(NSString *)imageName
                          andTitle:(NSString *)title
                        shouldTint:(BOOL)shouldTint {
    YLShareItem* item = [[YLShareItem alloc] init];
    UIImage *image;
    if (shouldTint) {
        image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    } else {
        image = [UIImage imageNamed:imageName];
    }
    item.icon = image;
    item.title = title;
    
    return item;
}

@end
