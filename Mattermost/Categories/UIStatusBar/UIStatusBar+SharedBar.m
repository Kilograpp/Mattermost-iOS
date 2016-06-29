//
// Created by Maxim Gubin on 23/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import <objc/runtime.h>
#import "UIStatusBar+SharedBar.h"
#import "ObjectiveSugar.h"

static NSInteger kSnapshotViewTag = 1231230;
static UIStatusBar* sharedStatusBar;

@interface UIStatusBar (SharedBarProperties)
@property (strong, nonatomic) NSMutableArray* previousViews;
@end

@implementation UIStatusBar (SharedBar)

+ (instancetype)sharedStatusBar {
    return sharedStatusBar;
}

- (void) drawRect:(CGRect)rect {
    if (!sharedStatusBar) {
        @synchronized (sharedStatusBar) {
            sharedStatusBar = self;
        }
    }
}

- (void)restoreState {
    [self moveTemporaryToRootView];
    [self.previousViews removeAllObjects];
}

- (void)moveToView:(UIView*)view {
    if (!self.previousViews) {
        [self setPreviousViews:[NSMutableArray array]];
    }

    [self.previousViews addObject:self.superview];
    [self removeFromSuperview];
    [view addSubview:self];
}

- (void)moveToViewWithSnapshot:(UIView*)view {
    [self makeSnapshot];
    [self moveToView:view];
}

- (void)moveTemporaryToRootView {
    __block UIView* superView = self.superview;
    [self moveToViewWithSnapshot:self.previousViews.firstObject];

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        //Background Thread
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [[superView viewWithTag:kSnapshotViewTag] removeFromSuperview];
        });
    });


}

- (void)makeSnapshot {
    UIView* snapshot = [self snapshotViewAfterScreenUpdates:NO];
    [snapshot setTag:kSnapshotViewTag];
    [self.superview addSubview:snapshot];
}

- (void)moveToPreviousView {
    UIView* lastView = self.previousViews.lastObject;
    [self removeFromSuperview];
    [lastView addSubview:self];
    [[lastView viewWithTag:kSnapshotViewTag] removeFromSuperview];
    [self.previousViews removeObject:lastView];
}


- (NSMutableArray *)previousViews {
    return objc_getAssociatedObject(self, @selector(previousViews));
}

- (void)setPreviousViews:(NSMutableArray *)previousViews {
    objc_setAssociatedObject(self, @selector(previousViews), previousViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end