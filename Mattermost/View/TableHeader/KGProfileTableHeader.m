//
//  KGProfileTableHeader.m
//  Mattermost
//
//  Created by Tatiana on 17/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGProfileTableHeader.h"
#import "UIColor+KGPreparedColor.h"
#import "UIFont+KGPreparedFont.h"
#import "KGUser.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UIImage+Resize.h"

@interface KGProfileTableHeader ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation KGProfileTableHeader

- (instancetype)init {
    self = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil].firstObject;
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
}

#pragma mark - Setup

- (void)setup {
    self.nameLabel.font = [UIFont kg_semibold30Font];
    self.nameLabel.textColor = [UIColor kg_blackColor];
    self.avatarImageView.layer.cornerRadius = CGRectGetHeight(self.avatarImageView.bounds) / 2;
    self.avatarImageView.clipsToBounds = YES;
    self.avatarImageView.backgroundColor = [UIColor whiteColor];
    self.backgroundColor = [UIColor blueColor];
    self.clipsToBounds = YES;
}

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGUser class]]){
        KGUser *user = object;
        self.nameLabel.text = user.nickname;
        [self.avatarImageView setImageWithURL:user.imageUrl placeholderImage:nil options:SDWebImageHandleCookies
                  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
}


+ (CGFloat)height {
    return 250.f;
}
@end
