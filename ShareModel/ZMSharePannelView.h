//
//  ZMSharePannelView.h
//  ZMShareModel
//
//  Created by Leo on 15/6/26.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMShareModel.h"

@protocol ZMSharePannelViewDelegate;

@interface ZMSharePannelView : UIView

@property (nonatomic, weak) ZMShareModel* shareModel;

@property (nonatomic, weak) id<ZMSharePannelViewDelegate> delegate;

- (id)initWithShareModel:(ZMShareModel*)shareModel andWithDelegate:(__weak id<ZMSharePannelViewDelegate>)delegate;

- (void)appear;
- (void)disAppear;

@end


@protocol ZMSharePannelViewDelegate <NSObject>

@optional
- (void)sharePannelView:(ZMSharePannelView*)pannelView didSelectedIndex:(NSInteger)index;

@end