//
//  KGFileCell.h
//  Mattermost
//
//  Created by Tatiana on 22/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"

@interface KGFileCell : KGTableViewCell

@property (nonatomic, strong) KGFile* file;

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *sizeLabel;
@end
