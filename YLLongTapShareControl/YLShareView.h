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

@interface YLShareItem : NSObject

@property (nonatomic) UIImage* icon;
@property (nonatomic) NSString* title;

+ (YLShareItem*)itemWithImageNamed:(NSString *)imageName
                          andTitle:(NSString *)title;

+ (YLShareItem*)itemWithImageNamed:(NSString *)imageName
                          andTitle:(NSString *)title
                        shouldTint:(BOOL)shouldTint;

@end

typedef void (^SelectedHandler)(NSUInteger index, YLShareItem* item);

@interface YLShareView : UIView

@property (nonatomic, readonly) YLShareViewState state;
@property (nonatomic, readonly) NSString *doneTitle;

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
