//
//  ZMSharePannelView.m
//  ZMShareModel
//
//  Created by Leo on 15/6/26.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "ZMSharePannelView.h"
#import "ZMShareModel.h"
#import "ZMShareItem.h"

@interface ZMSharePannelView() {
    
    UIView* _functionView;
    
    UIView* _scrollBackgroundView;
    UIScrollView* _itemScrollView;
    
    UIButton* _cancelButton;
    
    NSInteger _itemCount;
}

@end

@implementation ZMSharePannelView

- (id)initWithShareModel:(ZMShareModel*)shareModel andWithDelegate:(id<ZMSharePannelViewDelegate>)delegate {
    
    CGFloat width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    
    self = [super initWithFrame: CGRectMake(0, 0, width, CGRectGetHeight([[UIScreen mainScreen] bounds]))];
    if (self) {
        
        _delegate = delegate;
        _shareModel = shareModel;
        NSInteger itemCount = [shareModel itemsArray].count;
        
        _itemCount = 4;
        
        
        _itemCount = itemCount;
        
        _functionView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, width, _itemCount < 4 ? 210 : 320)];
        [self addSubview: _functionView];
        
        _scrollBackgroundView = [[UIView alloc] initWithFrame: CGRectMake(10, 10, width - 20, CGRectGetHeight(_functionView.bounds) - 70)];
        
        _scrollBackgroundView.backgroundColor = [UIColor whiteColor];
        _scrollBackgroundView.layer.cornerRadius = 20.0f;
        
        _itemScrollView = [[UIScrollView alloc] initWithFrame: CGRectMake(10, 10, CGRectGetWidth(_scrollBackgroundView.bounds) - 20, CGRectGetHeight(_scrollBackgroundView.bounds) - 20)];
        _itemScrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _itemScrollView.backgroundColor = [UIColor clearColor];
        _itemScrollView.pagingEnabled = YES;
        [_scrollBackgroundView addSubview: _itemScrollView];
        [_functionView addSubview: _scrollBackgroundView];
        
        _cancelButton = [UIButton buttonWithType: UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(15, CGRectGetHeight(_functionView.bounds) - 50, width - 30, 40);
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle: @"取消" forState: UIControlStateNormal];
        [_cancelButton setTitleColor: [UIColor blueColor] forState: UIControlStateNormal];
        [_cancelButton addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onTap:)]];
        _cancelButton.layer.cornerRadius = 10.0f;
        [_functionView addSubview: _cancelButton];
        
        [self updateItemsView];
    }
    return self;
}

#pragma mark - Private methods

- (void)onTap:(UITapGestureRecognizer*)tapper {
    
    UIView* target = [tapper view];
    if (target == _cancelButton) {
        
        [self disAppear];
        return;
    }
}

- (void)onChoosed:(UITapGestureRecognizer*)tapper {
    UIView* target = [tapper view];
    
    [self disAppear];
    
    if (_delegate && [_delegate respondsToSelector: @selector(sharePannelView:didSelectedIndex:)]) {
        [_delegate sharePannelView: self didSelectedIndex: target.tag];
    }
}

- (void)updateItemsView {
    
    NSInteger itemCount = [_shareModel itemsArray].count;
    itemCount = _itemCount;
    
    CGFloat itemScrollViewWidth = CGRectGetWidth(_itemScrollView.bounds);
    CGFloat itemScrollViewHeight = CGRectGetHeight(_itemScrollView.bounds);
    
    CGFloat itemViewWidth = 60;
    CGFloat itemViewHeight = 80;
    
    CGFloat itemViewOffsetX;
    
    NSInteger numberLine = itemCount / 3 > 0 ? 2 : 1;
    if (numberLine == 2) {
        itemViewOffsetX = (itemScrollViewWidth - itemViewWidth * 3) / 4;
    }
    else {
        itemViewOffsetX = (itemScrollViewWidth - itemViewWidth * itemCount) / (itemCount + 1);
    }
    
    CGFloat itemViewOffsetY = (itemScrollViewHeight - itemViewHeight * numberLine) / (numberLine + 1);
    
    for (NSInteger index = 0; index < itemCount; index++) {
        
        NSInteger pageIndex = index / 6;
        
        NSInteger coverIndex = index - (pageIndex * 6);
        NSInteger coverLine = coverIndex / 3;
        
        CGFloat pointX = itemViewOffsetX * (coverIndex % 3 + 1) + itemViewWidth * (coverIndex % 3) + itemScrollViewWidth * pageIndex;
        CGFloat pointY = itemViewOffsetY * (coverLine + 1) + itemViewHeight * coverLine;
        
        UIButton* itemButton = [UIButton buttonWithType: UIButtonTypeCustom];
        itemButton.frame = CGRectMake(pointX, pointY, itemViewWidth, itemViewHeight);
        itemButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        ZMShareItem* shareItem = [_shareModel.itemsArray objectAtIndex: index];
        
        UIImage* image = [UIImage imageNamed: shareItem.itemIcon];
        NSString* name = shareItem.itemName;
        
        itemButton.titleLabel.font = [UIFont systemFontOfSize: 12];
        [itemButton setImage: image forState: UIControlStateNormal];
        [itemButton setImageEdgeInsets: UIEdgeInsetsMake(-20, 1, 0, 0)];
        [itemButton setTitle: name forState: UIControlStateNormal];
        [itemButton setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [itemButton setTitleEdgeInsets: UIEdgeInsetsMake(60, -59, 0, 0)];
        [itemButton addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onChoosed:)]];
        itemButton.tag = index;
        [_itemScrollView addSubview: itemButton];
    }
    
    NSInteger page = itemCount % 6 == 0 ? itemCount / 6 : itemCount / 6 + 1;
    
    _itemScrollView.contentSize = CGSizeMake(itemScrollViewWidth * page,  itemScrollViewHeight);
}

#pragma mark - Public methods
- (void)appear {
    
    UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat width = CGRectGetWidth(keywindow.bounds);
    CGFloat height = CGRectGetHeight(keywindow.bounds);
    
    [keywindow addSubview: self];
    
    _functionView.center = CGPointMake(width/2, height + CGRectGetHeight(_functionView.bounds)/2);
    
    __weak UIView* weakFunctionView = _functionView;
    __weak UIView* weakSelf = self;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration: 0.25 animations:^{
        
        weakSelf.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.3];
        
        weakFunctionView.center = CGPointMake(width/2, height - CGRectGetHeight(weakFunctionView.bounds)/2);
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    }];
}


- (void)disAppear {
    
    UIWindow* keywindow = [[UIApplication sharedApplication] keyWindow];
    
    CGFloat width = CGRectGetWidth(keywindow.bounds);
    CGFloat height = CGRectGetHeight(keywindow.bounds);
    
    __weak UIView* weakFunctionView = _functionView;
    __weak UIView* weakSelf = self;
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration: 0.25 animations:^{
        
        weakSelf.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.01];
        
        weakFunctionView.center = CGPointMake(width/2, height + CGRectGetHeight(weakFunctionView.bounds)/2);
    }completion:^(BOOL finished) {
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        [weakSelf removeFromSuperview];
    }];
}

@end
