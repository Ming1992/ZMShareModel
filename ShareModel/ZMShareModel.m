//
//  ZMShareModel.m
//  ZMShareModel
//
//  Created by Leo on 15/6/19.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "ZMShareModel.h"

#import "ZMShareItem.h"
#import "ZMSharePannelView.h"
#import "ZMShareResponseModel.h"

static NSString* ZMShareModelItemSina = @"com.sina.weibo";
static NSString* ZMShareModelItemWeiXinFriends = @"ZMShareModelItemWeiXinFriends";
static NSString* ZMShareModelItemWeiXinMessage = @"ZMShareModelItemWeiXinMessage";
static NSString* ZMShareModelItemWeiXinFavorite = @"ZMShareModelItemWeiXinFavorite";
static NSString* ZMShareModelItemTencent = @"com.tencent.mqq";
static NSString* ZMShareModelItemQZone = @"com.tencent.QZone";

#pragma mark -
#pragma mark - ZMShareModel methods

@interface ZMShareModel() <ZMSharePannelViewDelegate> {
    
    NSMutableArray* _itemArray;
    ZMSharePannelView* _pannelView;
    
    // 分享的内容
    NSString* _contentTitle;
    NSString* _contentDescription;
    NSData* _imageData;
    NSString* _imageFilePath;
    NSString* _webURL;
    
    NSString* _shareItemType;
    
    //  分享反馈
    ZMShareResponseModel* _responseModel;
}

- (NSInteger)itemCount;

@end

@implementation ZMShareModel

+ (instancetype)sharedIntence {
    
    static ZMShareModel* shareModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareModel = [ZMShareModel new];
    });
    return shareModel;
}

- (id)init {
    self = [super init];
    if (self) {
        _itemArray = [NSMutableArray array];
        _responseModel = [ZMShareResponseModel new];
    }
    return self;
}

#pragma mark - Public methods

- (BOOL)handleOpenURL:(NSURL *)url {
    
    NSLog(@"url = %@", url);
    return YES;
}

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    if ([sourceApplication isEqualToString: ZMShareModelItemSina]) {
        
        return  [WeiboSDK handleOpenURL:url delegate: _responseModel];
    }
    else if([sourceApplication isEqualToString: ZMShareModelItemTencent]) {
        
        return [QQApiInterface handleOpenURL: url delegate: _responseModel];
    }
    else if ([sourceApplication isEqualToString: @"com.tencent.xin"]) {
        
        return  [WXApi handleOpenURL:url delegate: _responseModel];
    }
    
    return YES;
}

#pragma mark - Private methods

- (NSInteger)itemCount {
    return _itemArray.count;
}

- (NSArray*)itemsArray {
    return [NSArray arrayWithArray: _itemArray];
}

- (void)shareContentWithItem:(ZMShareItem*)item {
    
    _shareItemType = item.identifier;
    
    if ([_shareItemType isEqualToString: ZMShareModelItemSina]) {
        
        //新浪
        WBMessageObject *message = [WBMessageObject message];
        
        NSString* content = @"";
        if (_contentTitle) {
            content = [NSString stringWithFormat: @"【%@】\n", _contentTitle];
        }
        if (_contentDescription) {
            content = [content stringByAppendingString: _contentDescription];
        }
        if (_webURL) {
            
            if (![_webURL hasPrefix: @"http://"] && ![_webURL hasPrefix: @"https://"]) {
                _webURL = [NSString stringWithFormat: @"http://%@", _webURL];
            }
            
            content = [content stringByAppendingString: [NSString stringWithFormat: @"  \n%@\n", _webURL]];
        }
        message.text = content;
        
        if (_imageData) {
            
            WBImageObject *image = [WBImageObject object];
            image.imageData = _imageData;
            message.imageObject = image;
        }
        
        WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
        authRequest.redirectURI = item.redirectURI;
        authRequest.scope = @"all";
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage: message authInfo:authRequest access_token: nil];
        BOOL successful = [WeiboSDK sendRequest:request];
        if (!successful) {
            NSLog(@"分享失败");
        }
        return;
    }
    if ([_shareItemType isEqualToString: ZMShareModelItemTencent]) {
        
        //腾讯
        SendMessageToQQReq* reqquest = nil;
        
        if (_imageFilePath.length) {
            
            if ([_imageFilePath hasPrefix: @"http://"] || [_imageFilePath hasPrefix: @"https://"]) {
                QQApiNewsObject* img = [QQApiNewsObject objectWithURL: [NSURL URLWithString: _webURL] title: _contentTitle description: _contentDescription previewImageURL: [NSURL URLWithString: _imageFilePath]];
                
                reqquest = [SendMessageToQQReq reqWithContent: img];
            }
            else {
                QQApiNewsObject* img = [QQApiNewsObject objectWithURL: [NSURL URLWithString: _webURL] title: _contentTitle description: _contentDescription previewImageData: _imageData];
                
                reqquest = [SendMessageToQQReq reqWithContent: img];
            }
        }
        
        [QQApiInterface sendReq: reqquest];
        
        return;
    }
    if ([_shareItemType isEqualToString: ZMShareModelItemQZone]) {
        
        //腾讯
        SendMessageToQQReq* reqquest = nil;
        
        if (_imageFilePath.length) {
            
            if ([_imageFilePath hasPrefix: @"http://"] || [_imageFilePath hasPrefix: @"https://"]) {
                QQApiNewsObject* img = [QQApiNewsObject objectWithURL: [NSURL URLWithString: _webURL] title: _contentTitle description: _contentDescription previewImageURL: [NSURL URLWithString: _imageFilePath]];
                
                reqquest = [SendMessageToQQReq reqWithContent: img];
            }
            else {
                QQApiNewsObject* img = [QQApiNewsObject objectWithURL: [NSURL URLWithString: _webURL] title: _contentTitle description: _contentDescription previewImageData: _imageData];
                
                reqquest = [SendMessageToQQReq reqWithContent: img];
            }
        }
        
        [QQApiInterface SendReqToQZone: reqquest];
        
        return;
    }
    if ([_shareItemType isEqualToString: ZMShareModelItemWeiXinFavorite] || [_shareItemType isEqualToString: ZMShareModelItemWeiXinFriends] || [_shareItemType isEqualToString: ZMShareModelItemWeiXinMessage]) {
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = _contentTitle;
        message.description = _contentDescription;
        
        if (_imageData) {
            [message setThumbImage:[UIImage imageWithData: _imageData]];
        }
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = _webURL;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.message = message;
        
        if ([_shareItemType isEqualToString: ZMShareModelItemWeiXinFavorite]) {
            req.scene = WXSceneFavorite;
        }
        if ([_shareItemType isEqualToString: ZMShareModelItemWeiXinMessage]) {
            req.scene = WXSceneTimeline;
        }
        if ([_shareItemType isEqualToString: ZMShareModelItemWeiXinFriends]) {
            req.scene = WXSceneSession;
        }

        [WXApi sendReq:req];
    }
}

#pragma mark - 注册平台

- (void)connectSinaWeiboWithAppKey:(NSString*)appkey appSecret:(NSString*)appsecret redirectURI:(NSString*)redirectURI {
    
    if (appkey != nil && appsecret != nil && redirectURI != nil) {

        for (ZMShareItem* item in _itemArray) {
            if ([item.identifier isEqualToString: ZMShareModelItemSina]) {
                return;
            }
        }
        
        BOOL isRegister = [WeiboSDK registerApp: appkey];
    
        if (isRegister) {
            
            ZMShareItem* shareItem = [ZMShareItem new];
            shareItem.identifier = ZMShareModelItemSina;
            shareItem.appkey = [appkey copy];
            shareItem.appsecret = [appsecret copy];
            shareItem.redirectURI = [redirectURI copy];
            
            shareItem.itemIcon = @"sns_icon_1";
            shareItem.itemName = @"新浪微博";
            
            [_itemArray addObject: shareItem];
        }
    }
}

- (void)connectWeixinChatWithAppKey:(NSString*)appkey appSecret:(NSString*)appsecret {
    
    if (appkey != nil && appsecret != nil) {
        
        for (ZMShareItem* item in _itemArray) {
            if ([item.identifier isEqualToString: ZMShareModelItemWeiXinFriends]) {
                return;
            }
        }
        
        if ([WXApi isWXAppInstalled] || [WXApi isWXAppSupportApi]) {
            
            BOOL isRegister = [WXApi registerApp: appkey];
            if (isRegister) {
                
                ZMShareItem* friendsItem = [ZMShareItem new];
                friendsItem.identifier = ZMShareModelItemWeiXinFriends;
                friendsItem.appkey = [appkey copy];
                friendsItem.appsecret = [appsecret copy];
                friendsItem.redirectURI = nil;
                friendsItem.itemIcon = @"sns_icon_2";
                friendsItem.itemName = @"微信好友";
                
                [_itemArray addObject: friendsItem];
                
                ZMShareItem* messageItem = [ZMShareItem new];
                messageItem.identifier = ZMShareModelItemWeiXinMessage;
                messageItem.appkey = [appkey copy];
                messageItem.appsecret = [appsecret copy];
                messageItem.redirectURI = nil;
                messageItem.itemIcon = @"sns_icon_3";
                messageItem.itemName = @"朋友圈";
                
                [_itemArray addObject: messageItem];
                
                ZMShareItem* favoriteItem = [ZMShareItem new];
                favoriteItem.identifier = ZMShareModelItemWeiXinFavorite;
                favoriteItem.appkey = [appkey copy];
                favoriteItem.appsecret = [appsecret copy];
                favoriteItem.redirectURI = nil;
                favoriteItem.itemIcon = @"sns_icon_4";
                favoriteItem.itemName = @"微信收藏";
                
                [_itemArray addObject: favoriteItem];
            }
        }
    }
}

- (void)connectTencentWithAppKey:(NSString*)appkey appSecret:(NSString*)appsecret {
    
    if (appkey != nil) {
        
        for (ZMShareItem* item in _itemArray) {
            if ([item.identifier isEqualToString: ZMShareModelItemTencent]) {
                return;
            }
        }
        
        TencentOAuth* oAuth = [[TencentOAuth alloc] initWithAppId: appkey andDelegate: nil];
        
        if (([QQApiInterface isQQInstalled] || [QQApiInterface isQQSupportApi]) && oAuth) {
            
            ZMShareItem* qqItem = [ZMShareItem new];
            qqItem.identifier = ZMShareModelItemTencent;
            qqItem.appkey = [appkey copy];
            qqItem.itemIcon = @"sns_icon_5";
            qqItem.itemName = @"QQ";
            
            [_itemArray addObject: qqItem];
            
            ZMShareItem* QZoneItem = [ZMShareItem new];
            QZoneItem.identifier = ZMShareModelItemQZone;
            QZoneItem.appkey = [appkey copy];
            QZoneItem.itemIcon = @"sns_icon_6";
            QZoneItem.itemName = @"QQ空间";
            
            [_itemArray addObject: QZoneItem];
        }
    }
}

#pragma mark - 分享信息

- (void)shareContentWithTitle:(NSString*)title description:(NSString*)description image:(NSString*)imagePath webURL:(NSString*)webURL {
    
    _contentTitle = title;
    _contentDescription = description;
    _webURL = webURL;
    
    if (imagePath.length) {
        _imageData = [NSData dataWithContentsOfFile: imagePath];
        _imageFilePath = imagePath;
    }
    
    if (_pannelView == nil) {
        _pannelView = [[ZMSharePannelView alloc] initWithShareModel: self andWithDelegate: self];
    }
    [_pannelView appear];
}

#pragma mark -
#pragma mark - ZMSharePannelViewDelegate methods

- (void)sharePannelView:(ZMSharePannelView *)pannelView didSelectedIndex:(NSInteger)index {
    
    if (index >= _itemArray.count) {
        return;
    }
    
    ZMShareItem* shareItem = _itemArray[index];
    
    [self shareContentWithItem: shareItem];
}

@end


