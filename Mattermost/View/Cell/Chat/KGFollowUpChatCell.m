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
#import "KGUser.h"

@interface KGFollowUpChatCell ()
@end

@implementation KGFollowUpChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setup];
        [self setupMessageLabel];
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
    self.messageLabel.textColor = [UIColor kg_blackColor];
    [self addSubview:self.messageLabel];
    
    [self.messageLabel setURLColor:[UIColor kg_blueColor]];
    [self.messageLabel setURLSelectedColor:[UIColor blueColor]];
    [self.messageLabel setMentionSelectedColor:[UIColor blueColor]];
    [self.messageLabel setHashtagColor:[UIColor kg_greenColorForAlert]];
    [self.messageLabel setMentionColor:[UIColor kg_blueColor]];
    
    self.messageLabel.layer.shouldRasterize = YES;
    self.messageLabel.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    self.messageLabel.layer.drawsAsynchronously = YES;
    
    self.messageLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.messageLabel.preferredMaxLayoutWidth = 200.f;
    
    [self.messageLabel handleMentionTap:^(NSString *string) {
        self.mentionTapHandler(string);
    }];
    [self.messageLabel handleURLTap:^(NSURL *url) {
        [[UIApplication sharedApplication] openURL:url];
    }];
}


+ (void)load {
    messageQueue = [[NSOperationQueue alloc] init];
    [messageQueue setMaxConcurrentOperationCount:1];
}

- (void)configureWithObject:(KGPost*)post {
    self.messageLabel.text = post.message;
    
    if ([post isKindOfClass:[KGPost class]]) {
        self.post = post;
        
        __weak typeof(self) wSelf = self;
        
        self.messageOperation = [[NSBlockOperation alloc] init];
        [self.messageOperation addExecutionBlock:^{
            if (!wSelf.messageOperation.isCancelled) {
                dispatch_sync(dispatch_get_main_queue(), ^(void){
                    wSelf.messageLabel.text = wSelf.post.message;
                });
            }
        }];
        [messageQueue addOperation:self.messageOperation];
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat textWidth = KGScreenWidth() - 61.f;
    self.backgroundColor = [UIColor kg_whiteColor];
    
    _msgRect = [self.post.message boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{ NSFontAttributeName : [UIFont kg_regular15Font] }
                                               context:nil];
    self.messageLabel.frame = CGRectMake(53, 8, ceilf(_msgRect.size.width), ceilf(_msgRect.size.height));
}

+ (CGFloat)heightWithObject:(id)object {
    KGPost *adapter = object;
    CGFloat textWidth = KGScreenWidth() - 61.f;
    CGRect msg = [adapter.message boundingRectWithSize:CGSizeMake(textWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{ NSFontAttributeName : [UIFont kg_regular15Font] }
                                               context:nil];
    
    
    return ceilf(msg.size.height) + 16;
}

- (void)prepareForReuse {
    _messageLabel.text = nil;
    [_messageOperation cancel];
}

@end