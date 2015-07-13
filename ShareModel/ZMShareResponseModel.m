//
//  ZMShareResponseModel.m
//  ZMShareModel
//
//  Created by Leo on 15/7/13.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "ZMShareResponseModel.h"

@implementation ZMShareResponseModel

#pragma mark -
#pragma mark - WXApiDelegate || QQApiInterfaceDelegate methods

- (void)onResp:(BaseResp*)resp {
    NSString* alertMessage = nil;
    if ([resp isKindOfClass: [SendMessageToWXResp class]]) {
        
        NSInteger errorCode = resp.errCode;
        
        if (errorCode == 0) {
            alertMessage = @"分享成功";
        }
        else if (errorCode == -2) {
            alertMessage = @"取消分享";
        }
        else {
            alertMessage = @"分享失败";
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"微信分享" message: alertMessage delegate: nil cancelButtonTitle: nil otherButtonTitles: @"关闭", nil];
        [alertView show];
    }
    else if([resp isKindOfClass: [SendMessageToQQResp class]]){
        
        SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
        
        if (sendResp.type == ESENDMESSAGETOQQRESPTYPE) {
            
            NSString* resultCode = sendResp.result;
            if ([resultCode isEqualToString: @"0"]) {
                alertMessage = @"分享成功";
            }
            else if ([resultCode isEqualToString: @"-4"]) {
                alertMessage = @"取消分享";
            }
            else {
                alertMessage = @"分享失败";
            }
            
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"QQ分享" message: alertMessage delegate: nil cancelButtonTitle: nil otherButtonTitles: @"关闭", nil];
            [alertView show];
        }
    }
}

#pragma mark -
#pragma mark - WeiboSDKDelegate methods

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
    //  do nothing
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    
    if ([response isKindOfClass: [WBSendMessageToWeiboResponse class]]) {
        
        NSInteger statusCode = response.statusCode;
        NSString* alertMessage = @"";
        
        if (statusCode == 0) {
            alertMessage = @"分享成功";
        }
        else if (statusCode == -1) {
            alertMessage = @"取消分享";
        }
        else {
            alertMessage = @"分享失败";
        }
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle: @"微博分享" message: alertMessage delegate: nil cancelButtonTitle: nil otherButtonTitles: @"关闭", nil];
        [alertView show];
    }
}

#pragma mark - 
#pragma mark - QQApiInterfaceDelegate methods

- (void)onReq:(QQBaseReq *)req {
    
    // do nothing
}

- (void)isOnlineResponse:(NSDictionary *)response {
    
    NSLog(@"response = %@", response);
}

@end
