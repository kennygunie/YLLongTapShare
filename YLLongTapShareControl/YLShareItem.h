//
//  YLShareItem.h
//  YLLongTapShareControlDemo
//
//  Created by Kien NGUYEN on 27/09/2015.
//  Copyright © 2015 Yong Li. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLShareItem : NSObject

@property (nonatomic, readonly) UIImage *icon;
@property (nonatomic, readonly) NSString *title;

+ (YLShareItem*)itemWithImageNamed:(NSString *)imageName
                          andTitle:(NSString *)title;

+ (YLShareItem*)itemWithImageNamed:(NSString *)imageName
                          andTitle:(NSString *)title
                        shouldTint:(BOOL)shouldTint;

@end
