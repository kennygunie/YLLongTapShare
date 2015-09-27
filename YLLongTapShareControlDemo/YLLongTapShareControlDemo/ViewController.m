//
//  ViewController.m
//  YLLongTapShareControlDemo
//
//  Created by Yong Li on 7/22/14.
//  Copyright (c) 2014 Yong Li. All rights reserved.
//

#import "ViewController.h"
#import "YLLongTapShareView.h"
#import "UIButton+LongTapShare.h"
#import "YLShareItem.h"

@interface ViewController ()<YLLongTapShareDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    if ([self.view isKindOfClass:[YLLongTapShareView class]]) {
        
        YLLongTapShareView *shareView = (YLLongTapShareView *)self.view;
        
        shareView.delegate = self;
        shareView.distance = 100.0f;
        shareView.titleFont = [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:24.f];
        shareView.selectedColor = [UIColor redColor];
        shareView.tintColor = [UIColor greenColor];
        [shareView addShareItem:[YLShareItem itemWithImageNamed:@"facebook" andTitle:@"Facebook" shouldTint:YES]];
        [shareView addShareItem:[YLShareItem itemWithImageNamed:@"instagram" andTitle:@"Instagram" shouldTint:YES]];
        [shareView addShareItem:[YLShareItem itemWithImageNamed:@"pinterest" andTitle:@"Pinterest" shouldTint:YES]];
        [shareView addShareItem:[YLShareItem itemWithImageNamed:@"facebook" andTitle:@"Facebook" shouldTint:YES]];
        [shareView addShareItem:[YLShareItem itemWithImageNamed:@"instagram" andTitle:@"Instagram" shouldTint:YES]];
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
