//
//  TSMarkdownParser+Singleton.h
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <TSMarkdownParser/TSMarkdownParser.h>

@interface TSMarkdownParser (Singleton)

+ (instancetype)sharedInstance;

@end
