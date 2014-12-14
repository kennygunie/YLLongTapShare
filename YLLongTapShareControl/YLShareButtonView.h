//
//  YLShareButtonView.h
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLShareButtonView : UIView

@property (nonatomic, readonly) UIImage* shareIcon;
@property (nonatomic, readonly) NSString* shareTitle;
@property (nonatomic, readonly) NSString *doneTitle;
- (id)initWithIcon:(UIImage*)icon
             title:(NSString*)title
         doneTitle:(NSString*)doneTitle;

- (void)showAnimationWithDelay:(CGFloat)delay;
- (void)animateToDoneWithHandler:(void(^)())doneBlock;
- (void)selectAnimation;
- (void)resetAnimation;

@end
