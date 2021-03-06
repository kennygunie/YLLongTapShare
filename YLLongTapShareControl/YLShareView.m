//
//  YLShareView.m
//  YLLongTapShareControl
//
//  Created by Yong Li on 7/16/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLShareView.h"
#import "Evaluate.h"
#import "YLShareButtonView.h"
#import "OMVector.h"
#import "YLShareAnimationHelper.h"
#import "YLShareItem.h"
#import "CALayer+Utils.h"

typedef NS_ENUM(NSUInteger, YLShareViewPosition) {
    YLShareViewPositionTop = 0,
    YLShareViewPositionRight,
    YLShareViewPositionBottom,
    YLShareViewPositionLeft,
};

@interface YLShareView()

@property (nonatomic, readwrite) YLShareViewState state;
//@property (nonatomic, copy) SelectedHandler completionHandler;
@property (nonatomic) YLShareViewPosition shareViewPosition;

@end

@implementation YLShareView {
    NSArray*            _shareItems;
    NSMutableArray*     _shareBtns;
    YLShareButtonView*  _selectedView;
    CGFloat             _avgAng;
    //NSTimer*            _selectTimer;
    
    BOOL                _isDone;
    BOOL                _isDismissed;
    BOOL                _preventSlide;
    
    CAShapeLayer*       _bgLayer;
    CAShapeLayer*       _layer;
    CAShapeLayer*       _btnLayer;
}

- (instancetype)initWithShareItems:(NSArray*)shareItems {
    self = [self initWithFrame:CGRectMake(0, 0, 70, 70)];
    if (self) {
        _shareBtns = [NSMutableArray array];
        _state = YLShareViewUnopen;
        _selectedView = nil;
        _isDone = NO;
        _preventSlide = NO;
        _isDismissed = NO;
        _shareItems = shareItems;
    }
    
    return self;
}


- (void)createAllShareBtnsWithShareItems:(NSArray*)shareItems at:(CGPoint)point inView:(UIView*)view {
    CGFloat width = CGRectGetWidth(view.frame);
    
    int itemsCount = (int)shareItems.count;
    
    int offset;
    if (point.x < 0.1 * width) {
        offset = -itemsCount;
        self.shareViewPosition = YLShareViewPositionLeft;
    } else if (point.x < 0.3 * width) {
        offset = -itemsCount + 1;
        self.shareViewPosition = YLShareViewPositionLeft;
    } else if (point.x < 0.7 * width) {
        if (point.y < 140.0) {
            offset = 2*itemsCount;
            self.shareViewPosition = YLShareViewPositionTop;
        } else {
            offset = 0;
            self.shareViewPosition = YLShareViewPositionBottom;
        }
    } else if (point.x < 0.9 * width) {
        offset = itemsCount - 1;
        self.shareViewPosition = YLShareViewPositionRight;
    } else {
        offset = itemsCount;
        self.shareViewPosition = YLShareViewPositionRight;
    }
    
    
    const CGFloat shareSize = 70.f;
    CGFloat angle = M_PI/(itemsCount*2); // using the angle of 3 items is best
    _avgAng = angle;
    CGFloat startAngle = M_PI_2 - (itemsCount - 1 + offset)*angle;
    for (int i=0; i<itemsCount; i++) {
        YLShareItem* item = shareItems[i];
        CGFloat fan = startAngle + angle*i*2;
        CGPoint p;
        p.x = roundf(-_distance * cosf(fan) + self.bounds.size.width/2);
        p.y = roundf(-_distance * sinf(fan) + self.bounds.size.height/2);
        
        CGRect frame = CGRectMake(p.x-shareSize/2, p.y-shareSize/2, shareSize, shareSize);
        YLShareButtonView* shareButtonView = [[YLShareButtonView alloc] initWithItem:item];
        shareButtonView.titleFont = self.titleFont;
        shareButtonView.frame = frame;
        [self addSubview:shareButtonView];
        
        switch (self.shareViewPosition) {
            case YLShareViewPositionTop:
                if (i == 0 || i == itemsCount - 1) {
                    [self sendSubviewToBack:shareButtonView];
                }
                break;
            case YLShareViewPositionRight:
                [self sendSubviewToBack:shareButtonView];
                break;
            case YLShareViewPositionBottom:
                if (i > 0 && i < itemsCount - 1) {
                    [self sendSubviewToBack:shareButtonView];
                }
                break;
            default:
                break;
        }
        [_shareBtns addObject:shareButtonView];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _layer = [CAShapeLayer layer];
        _layer.fillColor = [UIColor clearColor].CGColor;
        _layer.strokeColor = self.tintColor.CGColor;
        _layer.lineWidth = 2;
        _layer.lineCap= kCALineCapRound;
        _layer.lineJoin = kCALineJoinRound;
        _layer.opacity = 1.0;
        [self.layer addSublayer:_layer];
        
        _bgLayer = [CAShapeLayer layer];
        //_bgLayer.fillColor = [self.tintColor colorWithAlphaComponent:0.8].CGColor;
        //_bgLayer.strokeColor = self.tintColor.CGColor;
        _bgLayer.lineWidth = 2;
        [self.layer addSublayer:_bgLayer];
        _bgLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _bgLayer.opacity = 0.0;
        _bgLayer.zPosition = -1;
        
        _btnLayer = [CAShapeLayer layer];
        _btnLayer.fillColor = self.tintColor.CGColor;
        _btnLayer.strokeColor = self.tintColor.CGColor;
        _btnLayer.lineWidth = 2;
        [self.layer addSublayer:_btnLayer];
        _btnLayer.anchorPoint = CGPointMake(0.5, 0.5);
        _btnLayer.opacity = 1.0;
        _btnLayer.zPosition = -1;
    }
    return self;
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    for (YLShareButtonView* view in _shareBtns) {
        view.tintColor = self.tintColor;
    }
}

-(void)setButtonColor:(UIColor *)buttonColor {
    _layer.strokeColor = buttonColor.CGColor;
    //_bgLayer.fillColor = [self.tintColor colorWithAlphaComponent:0.8].CGColor;
    _bgLayer.fillColor = self.tintColor.CGColor;
    _bgLayer.strokeColor = self.tintColor.CGColor;
    [_bgLayer addShadow];
    _btnLayer.fillColor = buttonColor.CGColor;
    _btnLayer.strokeColor = buttonColor.CGColor;
    [_btnLayer addShadow];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    CGFloat edge = MIN(self.bounds.size.width, self.bounds.size.height);
    _layer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, edge, edge) cornerRadius:edge/2].CGPath;
    _layer.bounds = self.bounds;
    _layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    _layer.bounds = self.bounds;
    _layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    _bgLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _bgLayer.bounds = rect;
    _bgLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    rect = CGRectInset(rect, 10, 10);
    _btnLayer.path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2].CGPath;
    _btnLayer.bounds = rect;
    _btnLayer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
}

- (void)showShareViewInView:(UIView*)view at:(CGPoint)point {
    [self createAllShareBtnsWithShareItems:_shareItems at:point inView:view];
    self.center = point;
    [view addSubview:self];
    
    
    static float scaleTime = 0.0;
    static float disappTime = 0.0;
    
    
    CAAnimation* disappear = [YLShareAnimationHelper scaleAnimationFrom:1.0 to:0.01
                                                           withDuration:disappTime andDelay:scaleTime
                                                      andTimingFunction:kCAMediaTimingFunctionEaseOut andIsSpring:NO];
    [_layer addAnimation:disappear forKey:@"showBounceBackground"];
    
    
    CAAnimation* disappear2 = [YLShareAnimationHelper scaleAnimationFrom:0.01 to:1.0
                                                            withDuration:0.8 andDelay:(scaleTime+disappTime)
                                                       andTimingFunction:nil andIsSpring:YES];
    
    CAAnimation* showOpacity = [YLShareAnimationHelper opacityAnimationFrom:1 to:1
                                                               withDuration:0.8 andDelay:(scaleTime+disappTime)
                                                          andTimingFunction:kCAMediaTimingFunctionEaseIn];
    
    CAAnimationGroup *group2 = [YLShareAnimationHelper groupAnimationWithAnimations:@[ disappear2, showOpacity]
                                                                        andDuration:(scaleTime + disappTime + 0.8)];
    [_bgLayer addAnimation:group2 forKey:@"showSlideBackground"];
    
    for (int i=0; i<_shareBtns.count; i++) {
        YLShareButtonView* view = (YLShareButtonView*)_shareBtns[i];
        [view showAnimationWithDelay:(scaleTime + disappTime + 0.1*i)];
        self.state = YLShareViewOpened;
    }
    
}

//-(void)pauseLayer:(CALayer*)layer
//{
//    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    layer.speed = 0.0;
//    layer.timeOffset = pausedTime;
//}
//
//-(void)resumeLayer:(CALayer*)layer
//{
//    CFTimeInterval pausedTime = [layer timeOffset];
//    layer.speed = 1.0;
//    layer.timeOffset = 0.0;
//    layer.beginTime = 0.0;
//    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
//    layer.beginTime = timeSincePause;
//}

- (float)angleForCenterPoint:(CGPoint)center andPoint1:(CGPoint)p1 andPoint2:(CGPoint)p2 {
    if (CGPointEqualToPoint(center, p1) || CGPointEqualToPoint(center, p2))
        return 0.0f;
    CGPoint v1 = CGPointMake(p1.x-center.x, p1.y-center.y);
    CGPoint v2 = CGPointMake(p2.x-center.x, p2.y-center.y);
    CGFloat dot = v1.x*v2.x + v1.y*v2.y;
    CGFloat arccos = dot/(sqrt((v1.x*v1.x+v1.y*v1.y)*(v2.x*v2.x+v2.y*v2.y)));
    CGFloat result = acosf(arccos);
    return result;
}

- (void)resetButtonColors {
    for (int i=0; i<_shareBtns.count; i++) {
        YLShareButtonView* view = (YLShareButtonView*)_shareBtns[i];
         view.tintColor = self.tintColor;
    }
}

- (void)slideTo:(CGPoint)point {
    if (_preventSlide) {
        return;
    }
    
    CGFloat radius = 20;
    CGPoint center = {self.bounds.size.width/2, self.bounds.size.height/2};
    CGVector v = CGVectorMakeWithPoints(center, point);
    if (CGPointEqualToPoint(center, point)) {
        return;
    }
    CGFloat dis = CGVectorLength(v);
    if (dis >= radius) {
        dis = radius;
        
        YLShareButtonView* selectedView;
        CGFloat minAng = M_PI;
        for (int i=0; i<_shareBtns.count; i++) {
            YLShareButtonView* view = (YLShareButtonView*)_shareBtns[i];
            CGPoint vP = view.center;
            CGFloat ang = [self angleForCenterPoint:center andPoint1:point andPoint2:vP];
            
            //NSLog(@"%i, ang = %f, vP(%f,%f), point(%f,%f)",i, ang, vP.x, vP.y, point.x, point.y);
            
            if (minAng > ang) {
                selectedView = view;
                minAng = ang;
                view.tintColor = self.selectedColor;
            }
            else {
                view.tintColor = self.tintColor;
            }
        }
        if (minAng <= _avgAng && !_isDone) {
            if (_selectedView != selectedView) {
                if (_selectedView) {
                    if (self.animatedSelection) {
                        [_selectedView resetAnimation];
                    }
                    //[self resetButtonColors];
                    _selectedView = nil;
                }
                _selectedView = selectedView;
                if (self.animatedSelection) {
                    [_selectedView selectAnimation];
                }
                
                
                //[_selectTimer invalidate];
                //_selectTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(doneSelected) userInfo:nil repeats:NO];
            }
        } else {
            if (self.animatedSelection) {
                [_selectedView resetAnimation];
            }
            _selectedView = nil;
            [self resetButtonColors];
            //[_selectTimer invalidate];
            //_selectTimer = nil;
        }
    } else {
        if (self.animatedSelection) {
            [_selectedView resetAnimation];
        }
        _selectedView = nil;
        //[self resetButtonColors];
        //[_selectTimer invalidate];
        //_selectTimer = nil;
    }
    CGVector vNorm = CGVectorNormalize(v);
    CGVector newV = CGVectorMultiply(vNorm, dis);
    CGPoint btnPos = CGPointFromStartAndVector(center, newV);
    
    if (!_isDismissed) {
        [CATransaction begin];
        [CATransaction setAnimationDuration:0];
        _btnLayer.position = btnPos;
        [CATransaction commit];
    }
}

//- (void)doneSelected {
//    _isDone = YES;
//    NSUInteger i = [_shareBtns indexOfObject:_selectedView];
//    __weak typeof(self) weakSelf = self;
//    __weak typeof(_shareItems) weakShareItems = _shareItems;
//    [_selectedView animateToDoneWithHandler:^{
//        if (weakSelf.completionHandler) {
//            weakSelf.completionHandler(i, weakShareItems[i]);
//            weakSelf.completionHandler = nil;
//        }
//        [weakSelf dismissShareView];
//    }];
//    [_selectTimer invalidate];
//    _selectTimer = nil;
//}

- (void)dismissShareView {
    _isDismissed = YES;
    //[self pauseLayer:_layer];
    //[self pauseLayer:_btnLayer];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)dismissWithCompletion:(SelectedHandler)handler {
    _preventSlide = YES;
    if (_selectedView) {
        NSUInteger i = [_shareBtns indexOfObject:_selectedView];
        [_selectedView animateToDoneWithHandler:^{
            [self dismissShareView];
            if (handler) {
                handler(i, _shareItems[i]);
            }
        }];
    } else {
        [self dismissShareView];
    }
    
    //[_selectTimer invalidate];
    //_selectTimer = nil;
}

@end
