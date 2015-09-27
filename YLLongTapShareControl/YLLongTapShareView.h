//
//  YLLongTapShareView.h
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YLShareView.h"

@interface YLLongTapShareView : UIView

@property (nonatomic, weak) id<YLLongTapShareDelegate> delegate;
@property (nonatomic) CGFloat distance;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *selectedColor;
@property (nonatomic) UIColor *buttonColor;

- (void)addShareItem:(YLShareItem*)item;

@end

