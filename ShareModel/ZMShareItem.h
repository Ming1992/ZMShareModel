//
//  ZMShareItem.h
//  ZMShareModel
//
//  Created by Leo on 15/6/26.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZMShareItem : NSObject

@property (nonatomic, copy) NSString* identifier;
@property (nonatomic, copy) NSString* appkey;
@property (nonatomic, copy) NSString* appsecret;
@property (nonatomic, copy) NSString* redirectURI;

@property (nonatomic, copy) NSString* itemIcon;
@property (nonatomic, copy) NSString* itemName;

@end
