//
//  ViewController.m
//  ZMShareModel
//
//  Created by Leo on 15/6/19.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "ViewController.h"

#import "WeiboSDK.h"

#import "ZMShareModel.h"

#import "AppDelegate.h"

#define kRedirectURI    @"http://www.sina.com"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[ZMShareModel sharedIntence] connectSinaWeiboWithAppKey: @"378925775" appSecret: @"ab8e38dac7510381969a9e8134dc9b85" redirectURI: @"http://www.meihua.info"];
    [[ZMShareModel sharedIntence] connectWeixinChatWithAppKey: @"wx06d0ddd96c9b9c8a" appSecret: @"e72c563407d95ea977ac58e8d32f56ea"];

    [[ZMShareModel sharedIntence] connectTencentWithAppKey: @"1104683804" appSecret: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)share:(id)sender {
    
    NSString* imagePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: @"test.png"];
    
    [[ZMShareModel sharedIntence] shareContentWithTitle: @"ZMShareModel测试" description: @"一个简单的测试" image: imagePath webURL: @"www.baidu.com"];
}

@end
