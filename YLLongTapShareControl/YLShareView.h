//
//  YLShareView.h
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, YLShareViewState) {
    YLShareViewUnopen = 0,
    YLShareViewOpened,
};

@class YLShareItem;

typedef void (^SelectedHandler)(NSUInteger index, YLShareItem* item);

@interface YLShareView : UIView

@property (nonatomic, readonly) YLShareViewState state;
@property (nonatomic) CGFloat distance;
@property (nonatomic) UIFont *titleFont;
@property (nonatomic) UIColor *selectedColor;

- (instancetype)initWithShareItems:(NSArray*)shareItems;
- (void)showShareViewInView:(UIView*)view at:(CGPoint)point;
- (void)dismissWithCompletion:(SelectedHandler)handler;
/*
 *  point should be in the coordinate of current view
 */
- (void)slideTo:(CGPoint)point;

@end

@protocol YLLongTapShareDelegate <NSObject>

@optional

//- (UIColor*)colorOfShareView;

- (void)longTapShareView:(UIView*)view didSelectShareTo:(YLShareItem*)item withIndex:(NSUInteger)index;

@end
