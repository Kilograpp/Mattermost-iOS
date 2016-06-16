//
//  KGImageCell.h
//  Mattermost
//
//  Created by Igor Vedeneev on 13.06.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGTableViewCell.h"
@class ASNetworkImageNode;

@interface KGImageCell : KGTableViewCell
//@property (nonatomic, strong) ASNetworkImageNode *kg_imageView;
@property (nonatomic, strong) UIImageView *kg_imageView;
@end
