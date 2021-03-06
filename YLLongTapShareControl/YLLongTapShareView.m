//
//  YLLongTapShareView.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "YLLongTapShareView.h"
#import "YLShareView.h"

@interface YLLongTapShareView ()

@property (nonatomic) YLShareView* shareView;
@property (nonatomic) NSMutableArray *shareItems;

@end

@implementation YLLongTapShareView

- (NSMutableArray*)shareItems {
    if (!_shareItems) {
        _shareItems = [NSMutableArray array];
    }
    return _shareItems;
}

- (void)addShareItem:(YLShareItem*)item {
    [self.shareItems addObject:item];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([self.shareView superview]) {
        return;
    }
    
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:self];
            self.shareView = [[YLShareView alloc] initWithShareItems:self.shareItems];
            self.shareView.distance = self.distance ? self.distance : 80.f;
            self.shareView.titleFont = self.titleFont;
            self.shareView.selectedColor = self.selectedColor;
            self.shareView.tintColor = self.tintColor;
            self.shareView.buttonColor = self.buttonColor;
            self.shareView.animatedSelection = self.animatedSelection;
            [self.shareView showShareViewInView:self at:touchPoint];
            if ([self.delegate respondsToSelector:@selector(didShow)]) {
                [self.delegate didShow];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    UITouch* touch = [[touches objectEnumerator] allObjects].firstObject;
    {
        if (touch) {
            CGPoint touchPoint = [touch locationInView:_shareView];
            [self.shareView slideTo:touchPoint];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self.shareView dismissWithCompletion:^(NSUInteger index, YLShareItem *item) {
        if ([self.delegate respondsToSelector:@selector(longTapShareView:didSelectShareTo:withIndex:)]) {
            [self.delegate longTapShareView:self didSelectShareTo:item withIndex:index];
        }
    }];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self.shareView dismissWithCompletion:NULL];
}


@end
