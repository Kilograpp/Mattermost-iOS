//
// Created by Maxim Gubin on 10/06/16.
// Copyright (c) 2016 Kilograpp. All rights reserved.
//

#import "KGFollowUpChatCell.h"
#import "UIFont+KGPreparedFont.h"
#import "KGPost.h"
#import <ActiveLabel/ActiveLabel-Swift.h>
#import "UIColor+KGPreparedColor.h"
#import "NSString+HeightCalculation.h"
#import "KGPreferences.h"
#import <TSMarkdownParser/TSMarkdownParser.h>
#import "KGUser.h"
#import "UIView+Align.h"
#import <DGActivityIndicatorView.h>

static CGFloat const kLoadingViewSize = 22.f;
static CGFloat const kErrorViewSize = 34.f;

@interface KGFollowUpChatCell ()

@end

@implementation KGFollowUpChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        [self setupMessageLabel];
        [self setupLoadingView];
        [self setupErrorView];
    }
    
    return self;
}

#pragma mark - Setup

- (void)setup {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setupMessageLabel {
    self.messageLabel = [[ActiveLabel alloc] init];
    self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.backgroundColor = [UIColor whiteColor];
    self.messageLabel.font = [UIFont kg_regular15Font];
    self.messageLabel.textColor = [UIColor kg_grayColor];
    [self addSubview:self.messageLabel];
    
    [self.messageLabel setURLColor:[UIColor kg_blueColor]];
    [self.messageLabel setURLSelectedColor:[UIColor blueColor]];
    [self.messageLabel setMentionSelectedColor:[UIColor blueColor]];
    [self.messageLabel setHashtagColor:[UIColor kg_greenColorForAlert]];
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
    
    self.messageLabel.preferredMaxLayoutWidth = 200.f - kLoadingViewSize;
    
    [self.messageLabel handleMentionTap:^(NSString *string) {
        self.mentionTapHandler(string);
    }];
    [self.messageLabel handleURLTap:^(NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];
}

- (void)setupLoadingView {
    self.loadingView = [[DGActivityIndicatorView alloc]initWithType:DGActivityIndicatorAnimationTypeBallPulse
                                                          tintColor:[UIColor kg_blueColor]
                                                               size:kLoadingViewSize - 5];
    self.loadingView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:self.loadingView];
    self.loadingView.hidden = YES;
}

- (void)setupErrorView {
    self.errorView = [[UIButton alloc] init];
    [self.errorView setImage:[UIImage imageNamed:@"message_fail_button"] forState:UIControlStateNormal];
    [self.errorView addTarget:self action:@selector(errorAction) forControlEvents:
     UIControlEventTouchUpInside];
    self.errorView.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [self addSubview:self.errorView];
    self.errorView.hidden = YES;
}

+ (void)load {
    messageQueue = [[NSOperationQueue alloc] init];
    [messageQueue setMaxConcurrentOperationCount:1];
}

- (void)configureWithObject:(KGPost*)post {
    if ([post isKindOfClass:[KGPost class]]) {
        self.post = post;
        
        __weak typeof(self) wSelf = self;
        
        self.messageOperation = [[NSBlockOperation alloc] init];
        [self.messageOperation addExecutionBlock:^{
            if (!wSelf.messageOperation.isCancelled) {
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    wSelf.messageLabel.attributedText = wSelf.post.attributedMessage;
                });
            }
        }];
        [messageQueue addOperation:self.messageOperation];

        if (self.post.error) {
            [self showError];
        } else {
            [self reloadSendingState];
        }
    }
}

- (void)showError {
    self.errorView.hidden = NO;
    self.loadingView.hidden = YES;
}

- (void)reloadSendingState {
    if (!self.post.identifier) {
        [self startAnimation];
    } else {
        [self finishAnimation];
    }
    
    self.messageLabel.alpha = self.post.identifier ? 1 : 0.5;
}

- (void)hideError {
    self.errorView.hidden = YES;
}

- (void)startAnimation {
    [self.loadingView startAnimating];
    self.loadingView.hidden = NO;
}

- (void)finishAnimation {
    [self.loadingView stopAnimating];
    self.loadingView.hidden = YES;
    self.messageLabel.alpha = 1;
}


- (void)layoutSubviews {
    [super layoutSubviews];

    self.backgroundColor = [UIColor kg_whiteColor];
    CGFloat textWidth = KGScreenWidth() - 61.f;
    
    self.messageLabel.frame = CGRectMake(53, 8, ceilf(textWidth) - kLoadingViewSize, self.post.heightValue);
    self.loadingView.frame = CGRectMake(KGScreenWidth() - kLoadingViewSize - 8, 10, kLoadingViewSize, 20);
    self.errorView.frame = CGRectMake(KGScreenWidth() - kErrorViewSize ,(self.frame.size.height - kErrorViewSize)/2 ,kErrorViewSize ,kErrorViewSize);
    
    [self alignSubviews];
}

+ (CGFloat)heightWithObject:(id)object {
    KGPost *adapter = object;
    return adapter.heightValue + 16;
}

- (void)prepareForReuse {
    _messageLabel.text = nil;
    [_messageOperation cancel];

    self.errorView.hidden = YES;
    self.loadingView.hidden = YES;
    
}

- (void)errorAction {
    if (self.errorTapHandler) {
//        self.photoTapHandler(indexPath.row, ((KGImageCell *)[self.tableView cellForRowAtIndexPath:indexPath]).kg_imageView);
        self.errorTapHandler(self.post);
    }

}
@end