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

@interface ViewController ()<YLLongTapShareDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    if ([self.view isKindOfClass:[YLLongTapShareView class]]) {
        ((YLLongTapShareView*)self.view).doneTitle = @"OK !";
        ((YLLongTapShareView*)self.view).delegate = self;
        ((YLLongTapShareView*)self.view).tintColor = [UIColor colorWithRed:1.000 green:0.966 blue:0.091 alpha:1.000];
        [(YLLongTapShareView*)self.view addShareItem:[YLShareItem itemWithImageNamed:@"facebook" andTitle:@"Facebook"]];
        [(YLLongTapShareView*)self.view addShareItem:[YLShareItem itemWithImageNamed:@"instagram" andTitle:@"Instagram"]];
        [(YLLongTapShareView*)self.view addShareItem:[YLShareItem itemWithImageNamed:@"pinterest" andTitle:@"Pinterest"]];
        [(YLLongTapShareView*)self.view addShareItem:[YLShareItem itemWithImageNamed:@"instagram" andTitle:@"Instagram"]];
        [(YLLongTapShareView*)self.view addShareItem:[YLShareItem itemWithImageNamed:@"pinterest" andTitle:@"Pinterest"]];
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
