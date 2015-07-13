//
//  ZMShareModel.h
//  ZMShareModel
//
//  Created by Leo on 15/6/19.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WeiboSDK.h"

#import "WXApi.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>


typedef NS_ENUM(NSUInteger, ZMShareModelType) {
    ZMShareModelType_Sina = 0,              /**< 新浪微博    */
    ZMShareModelType_WXSession,             /**< 微信好友    */
    ZMShareModelType_WXTimeline,            /**< 微信朋友圈    */
    ZMShareModelType_WXFavorite,            /**< 微信收藏    */
    ZMShareModelType_Tencent,               /**< QQ好友    */
};

@interface ZMShareModel : NSObject

+ (instancetype)sharedIntence;

/** 分享的类型数组 */
@property (nonatomic, readonly) NSArray* itemsArray;

/** 注册新浪微博 */
- (void)connectSinaWeiboWithAppKey:(NSString*)appkey appSecret:(NSString*)appsecret redirectURI:(NSString*)redirectURI;

/** 注册微信平台 */
- (void)connectWeixinChatWithAppKey:(NSString*)appkey appSecret:(NSString*)appsecret;

/** 注册腾讯平台 */
- (void)connectTencentWithAppKey:(NSString*)appkey appSecret:(NSString*)appsecret;


/** 分享内容 */
- (void)shareContentWithTitle:(NSString*)title description:(NSString*)description image:(NSString*)imagePath webURL:(NSString*)webURL;

#pragma mark -

- (BOOL)handleOpenURL:(NSURL *)url;

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;

@end
