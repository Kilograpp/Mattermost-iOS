//
//  KGCommandTableViewCell.m
//  Mattermost
//
//  Created by Igor Vedeneev on 05.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGCommandTableViewCell.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import "KGCommand.h"

@interface KGCommandTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *commandLabel;
@property (weak, nonatomic) IBOutlet UILabel *promtLabel;
@property (weak, nonatomic) IBOutlet UIView *underlyingView;

@end

@implementation KGCommandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setup];
    [self setupCommandLabel];
    [self setupPromtLabel];
}


#pragma mark - Setup

- (void)setup {
    self.underlyingView.backgroundColor = [UIColor kg_whiteColor];
    self.backgroundColor = [UIColor kg_autocompletionViewBackgroundColor];
    self.underlyingView.layer.cornerRadius = 3;
}

- (void)setupCommandLabel {
    self.commandLabel.textColor = [UIColor kg_blackColor];
    self.commandLabel.font = [UIFont kg_regular15Font];
}

- (void)setupPromtLabel {
    self.promtLabel.textColor = [UIColor kg_grayColor];
    self.promtLabel.font = [UIFont kg_regular13Font];
}


#pragma mark - Configuration

- (void)configureWithObject:(id)object {
    if ([object isKindOfClass:[KGCommand class]]) {
        KGCommand *command = object;
        self.commandLabel.text = [[[@"/" stringByAppendingString:command.trigger] stringByAppendingString:@" "]  stringByAppendingString:command.hint];
        self.promtLabel.text = command.message;
    }
}


#pragma mark - Height

+ (CGFloat)heightWithObject:(id)object {
    return 73;
}

@end
