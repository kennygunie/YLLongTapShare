//
//  YLShareButtonView.m
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/18/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLShareButtonView.h"
#import "Evaluate.h"
#import "CAAnimation+Blocks.h"
#import "YLShareAnimationHelper.h"
#import "YLShareItem.h"
#import "CALayer+Utils.h"

@interface YLShareButtonView()

@property (nonatomic) UIImage* shareIcon;
@property (nonatomic) NSString* shareTitle;

@property (nonatomic, copy) void(^doneHandler)();

@end

@implementation YLShareButtonView {
    UIImageView*    _iconView;
    CAShapeLayer*   _iconLayer;
    UILabel*        _titleLabel;
    UILabel*        _doneMarkLabel;
    
    BOOL            _isSelected;
    BOOL            _isDone;
}


- (instancetype)initWithItem:(YLShareItem *)item {
    self = [super initWithFrame:CGRectMake(0, 0, 80, 80)];
    if (self) {
        self.shareIcon = item.icon;
        self.shareTitle = item.title;
        _isSelected = NO;
        _isDone = NO;
        _titleLabel = [[UILabel alloc] init];
        [self _setup];
        self.layer.opacity = 0;
        
    }
    return self;
}

- (void)_setup {
    self.backgroundColor = [UIColor clearColor];
    _iconView = [[UIImageView alloc] initWithImage:_shareIcon];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    _iconView.backgroundColor = [UIColor clearColor];
    [_iconView.layer addShadow];
    
    _doneMarkLabel = [[UILabel alloc] init];
    _doneMarkLabel.font = [UIFont systemFontOfSize:50];
    _doneMarkLabel.text = @"★";
    _doneMarkLabel.textColor = [UIColor grayColor];
    _doneMarkLabel.backgroundColor = [UIColor clearColor];
    _doneMarkLabel.textAlignment = NSTextAlignmentCenter;
    _doneMarkLabel.hidden = YES;
    
    
    _titleLabel.text = _shareTitle;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.600];
    _titleLabel.layer.cornerRadius = 5.0f;
    _titleLabel.layer.masksToBounds = YES;
    _titleLabel.layer.opacity = 0.0f;
    [_titleLabel sizeToFit];
    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,
                                   _titleLabel.frame.origin.y,
                                   _titleLabel.frame.size.width + _titleLabel.layer.cornerRadius + 10,
                                   _titleLabel.frame.size.height + _titleLabel.layer.cornerRadius);
    
    
    [self addSubview:_iconView];
    [self addSubview:_doneMarkLabel];
    [self addSubview:_titleLabel];
    
    _iconLayer = [CAShapeLayer layer];
    _iconLayer.fillColor = [self.tintColor colorWithAlphaComponent:0.0].CGColor;
    //_iconLayer.strokeColor = _tintColor.CGColor;
    _iconLayer.lineWidth = 0;
    _iconLayer.anchorPoint = CGPointMake(0.5, 0.5);
    _iconLayer.opacity = 1.0;
    [self.layer insertSublayer:_iconLayer above:_iconView.layer];
    
}

- (void)layoutSubviews {
    CGRect frame = self.bounds;
    _titleLabel.frame = CGRectIntegral(CGRectMake(0.5*(frame.size.width - _titleLabel.frame.size.width),
                                                  frame.origin.y - _titleLabel.frame.size.height,
                                                  _titleLabel.frame.size.width,
                                                  _titleLabel.frame.size.height));
    
    //frame.size.height -= labelHeight;
    CGFloat wid = MIN(frame.size.width, frame.size.height);
    CGRect square = CGRectMake((frame.size.width-wid)/2,
                               (frame.size.height-wid)/2,
                               wid, wid);
    _iconView.frame = square;
    //    CGFloat wid2 = CGRectGetWidth(square)*1.3f;
    //    _doneMarkLabel.frame = CGRectMake((square.size.width-wid2)/2,
    //                                      (square.size.height-wid2)/2,
    //                                      wid2, wid2);
    _doneMarkLabel.frame = _iconView.frame;
    _iconLayer.bounds = _doneMarkLabel.bounds;
    _iconLayer.position = _doneMarkLabel.center;
    
    _iconLayer.path = [UIBezierPath bezierPathWithRoundedRect:_iconLayer.bounds cornerRadius:_iconLayer.bounds.size.width/2].CGPath;
}

- (void)animateToDoneWithHandler:(void(^)())doneBlock {
    if (_isDone)
        return;
    _isDone = YES;
    
    CABasicAnimation* animation2 = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation2.duration = 2.0;
    animation2.fromValue = @(0);
    animation2.toValue = @(1);
    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    
    CAAnimation* fillAnimation = [YLShareAnimationHelper fillColorAnimationFrom:[self.tintColor colorWithAlphaComponent:0.0]
                                                                             to:self.tintColor
                                                                   withDuration:0.5 andDelay:0
                                                              andTimingFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup *group = [YLShareAnimationHelper groupAnimationWithAnimations:@[ animation2, fillAnimation ]
                                                                       andDuration:2.0];
    
    
    [_iconLayer addAnimation:group forKey:@"fillToWhite"];
    
    
    CAAnimation* disappear = [YLShareAnimationHelper opacityAnimationFrom:1 to:0
                                                             withDuration:0.2 andDelay:0
                                                        andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimation* moveUp = [YLShareAnimationHelper positionYAnimationFrom:_titleLabel.layer.position.y
                                                                      to:_titleLabel.layer.position.y-_titleLabel.frame.size.height
                                                            withDuration:0.2 andDelay:0
                                                       andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup* titleAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[disappear,moveUp]
                                                                                andDuration:0.5];
    [_iconView.layer addAnimation:disappear forKey:@"iconViewMoveOut"];
    [_titleLabel.layer addAnimation:titleAnimation forKey:@"titleMoveOut"];
    
    _doneMarkLabel.hidden = NO;
    _doneMarkLabel.layer.opacity = 0;
    CAAnimation* doneappear = [YLShareAnimationHelper opacityAnimationFrom:0 to:1
                                                              withDuration:0.5 andDelay:0
                                                         andTimingFunction:kCAMediaTimingFunctionEaseIn];
    CAAnimation* moveUp3 = [YLShareAnimationHelper scaleAnimationFrom:1.2 to:1
                                                         withDuration:0.5 andDelay:0
                                                    andTimingFunction:kCAMediaTimingFunctionEaseIn andIsSpring:NO];
    
    CAAnimationGroup* doneMarkAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[ doneappear, moveUp3 ]
                                                                                   andDuration:0.5];
    
    doneMarkAnimation.completion = ^(BOOL finished) {
        doneBlock();
    };
    [_doneMarkLabel.layer addAnimation:doneMarkAnimation forKey:@"showDoneMark"];
    
}

- (void)showAnimationWithDelay:(CGFloat)delay {
    
    CAAnimation* animation = [YLShareAnimationHelper scaleAnimationFrom:0.0 to:1.0
                                                           withDuration:0.8 andDelay:delay
                                                      andTimingFunction:nil andIsSpring:YES];
    CAAnimation* opacity = [YLShareAnimationHelper opacityAnimationFrom:0.0 to:1.0
                                                           withDuration:0.001 andDelay:delay
                                                      andTimingFunction:kCAMediaTimingFunctionLinear];
    CAAnimation* group = [YLShareAnimationHelper groupAnimationWithAnimations:@[animation, opacity] andDuration:0.8+delay];
    [self.layer addAnimation:group forKey:@"showAnimation"];
}


- (void)selectAnimation {
    if (_isDone)
        return;
    
    _isSelected = YES;
    //    CAAnimation* enlarge = [YLShareAnimationHelper scaleAnimationFrom:1.0f to:1.3f
    //                                                         withDuration:0.25f andDelay:0.0f
    //                                                    andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    
    CAAnimation* moveUp = [YLShareAnimationHelper positionYAnimationFrom:self.layer.position.y
                                                                      to:self.layer.position.y-10
                                                            withDuration:0.3 andDelay:0
                                                       andTimingFunction:kCAMediaTimingFunctionEaseOut];
    
    //    CAAnimationGroup* selectAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[enlarge, moveUp]
    //                                                                                 andDuration:0.25];
    
    
    [self.layer addAnimation:moveUp forKey:@"selectAnimation"];
    
    //    CAAnimation* blend = [YLShareAnimationHelper fillColorAnimationFrom:[self.tintColor colorWithAlphaComponent:0]
    //                                                                     to:[self.tintColor colorWithAlphaComponent:0.5]
    //                                                           withDuration:0.25 andDelay:0
    //                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut];
    //    [_iconLayer addAnimation:blend forKey:@"blend"];
    
    CAAnimation* titleOpacity = [YLShareAnimationHelper opacityAnimationFrom:0 to:1
                                                                withDuration:0.25 andDelay:0
                                                           andTimingFunction:kCAMediaTimingFunctionEaseOut];
    CAAnimation* titleZoom = [YLShareAnimationHelper scaleAnimationFrom:0.0f to:1.0f
                                                           withDuration:0.25f andDelay:0.0f
                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    CAAnimationGroup* titleAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[titleOpacity, titleZoom]
                                                                                andDuration:0.25];
    [_titleLabel.layer addAnimation:titleAnimation forKey:@"showTitle"];
    
}

- (void)resetAnimation {
    if (!_isSelected || _isDone)
        return;
    
    _isSelected = NO;
    
    CAAnimation* shrink = [YLShareAnimationHelper scaleAnimationFrom:1.1 to:1.0
                                                        withDuration:0.25 andDelay:0
                                                   andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    
    CAAnimation* moveDown = [YLShareAnimationHelper positionYAnimationFrom:self.layer.position.y-10
                                                                        to:self.layer.position.y
                                                              withDuration:0.3 andDelay:0
                                                         andTimingFunction:kCAMediaTimingFunctionEaseOut];
    
    CAAnimationGroup* unSelectAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[shrink, moveDown]
                                                                                   andDuration:0.25];
    
    [self.layer addAnimation:unSelectAnimation forKey:@"unSelectAnimation"];
    
    //    CAAnimation* blend = [YLShareAnimationHelper fillColorAnimationFrom:[self.tintColor colorWithAlphaComponent:0.5]
    //                                                                     to:[self.tintColor colorWithAlphaComponent:0]
    //                                                           withDuration:0.25 andDelay:0
    //                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut];
    //    [_iconLayer addAnimation:blend forKey:@"blend"];
    
    
    CAAnimation* titleOpacity = [YLShareAnimationHelper opacityAnimationFrom:1 to:0
                                                                withDuration:0.25 andDelay:0
                                                           andTimingFunction:kCAMediaTimingFunctionEaseOut];
    CAAnimation* titleZoom = [YLShareAnimationHelper scaleAnimationFrom:1.0f to:0.0f
                                                           withDuration:0.25f andDelay:0.0f
                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    CAAnimationGroup* titleAnimation = [YLShareAnimationHelper groupAnimationWithAnimations:@[titleOpacity, titleZoom]
                                                                                andDuration:0.25];
    
    [_titleLabel.layer addAnimation:titleAnimation forKey:@"hideTitle"];
}

@end
