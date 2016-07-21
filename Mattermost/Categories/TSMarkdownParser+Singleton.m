//
//  TSMarkdownParser+Singleton.m
//  Mattermost
//
//  Created by Maxim Gubin on 04/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "TSMarkdownParser+Singleton.h"
#import "UIFont+KGPreparedFont.h"
#import "UIColor+KGPreparedColor.h"
#import <SDWebImage/SDWebImageManager.h>

@interface TSMarkdownParser()

+ (void)addAttributes:(NSArray<NSDictionary<NSString *, id> *> *)attributesArray atIndex:(NSUInteger)level toString:(NSMutableAttributedString *)attributedString range:(NSRange)range;

@end

@implementation TSMarkdownParser (Singleton)

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [self kg_customParser];
        [sharedInstance setupAttrubutes];
    });
    return sharedInstance;
}

- (void)setupAttrubutes {
    [self setupSettings];
    [self setupDefaultAttrubutes];
    [self setupHeaderAttributes];
    [self setupOtherAttributes];
}

- (void)setupSettings {
    self.skipLinkAttribute = NO;
}

- (void)setupDefaultAttrubutes {
    self.defaultAttributes = @{ NSFontAttributeName            : [UIFont kg_regular15Font],
                                NSForegroundColorAttributeName : [UIColor kg_blackColor] };
}

- (void)setupHeaderAttributes {
    NSMutableArray *headerAttrubutes  = [NSMutableArray array];
    
    for(int i = 0; i < 6; i++) {
        NSDictionary *attr = @{ NSFontAttributeName            : [UIFont kg_semiboldFontOfSize:26 - 2 * i],
                                NSForegroundColorAttributeName : [UIColor kg_blackColor] };
        [headerAttrubutes addObject:attr];
    }
    
    self.headerAttributes = headerAttrubutes.copy;
}

- (void)setupOtherAttributes {
    self.emphasisAttributes = @{ NSFontAttributeName            : [UIFont kg_italic15Font],
                                 NSForegroundColorAttributeName : [UIColor kg_blackColor] };
}


+ (instancetype)kg_customParser {
    TSMarkdownParser *defaultParser = [self new];
    __weak TSMarkdownParser *weakParser = defaultParser;
    
    /* escaping parsing */
    
    [defaultParser addCodeEscapingParsing];
    
    [defaultParser addEscapingParsing];
    
    /* block parsing */
    
    
    [defaultParser addHeaderParsingWithMaxLevel:0 leadFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, __unused NSUInteger level) {
        [attributedString deleteCharactersInRange:range];
    } textFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, NSUInteger level) {
        [TSMarkdownParser addAttributes:weakParser.headerAttributes atIndex:level - 1 toString:attributedString range:range];
        
    }];
    
    [defaultParser addListParsingWithMaxLevel:0 leadFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, NSUInteger level) {
        NSMutableString *listString = [NSMutableString string];
        while (--level)
            [listString appendString:@"\t"];
        [listString appendString:@"•\t"];
        [attributedString replaceCharactersInRange:range withString:listString];
    } textFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, NSUInteger level) {
        [TSMarkdownParser addAttributes:weakParser.listAttributes atIndex:level - 1 toString:attributedString range:range];
    }];
    
    [defaultParser addQuoteParsingWithMaxLevel:0 leadFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, NSUInteger level) {
        NSMutableString *quoteString = [NSMutableString string];
        while (level--)
            [quoteString appendString:@"\t"];
        [attributedString replaceCharactersInRange:range withString:quoteString];
    } textFormattingBlock:^(NSMutableAttributedString * attributedString, NSRange range, NSUInteger level) {
        [TSMarkdownParser addAttributes:weakParser.quoteAttributes atIndex:level - 1 toString:attributedString range:range];
    }];
    

    
    [defaultParser addLinkParsingWithLinkFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, NSString * _Nullable link) {
        if (!weakParser.skipLinkAttribute) {
            NSURL *url = [NSURL URLWithString:link] ?: [NSURL URLWithString:
                                                        [link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            if (url) {
                [attributedString addAttribute:NSLinkAttributeName
                                         value:url
                                         range:range];
            }
        }
        [attributedString addAttributes:weakParser.linkAttributes range:range];
    }];
    
    [defaultParser addLinkDetectionWithLinkFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range, NSString * _Nullable link) {
        if (!weakParser.skipLinkAttribute) {
            //TODO: грязный фикс вылетов на ссылках с русскими буквами
            if ([NSURL URLWithString:link]) {
                [attributedString addAttribute:NSLinkAttributeName
                                         value:[NSURL URLWithString:link]
                                         range:range];
            }
        }
        [attributedString addAttributes:weakParser.linkAttributes range:range];
    }];
    

    /* inline parsing */
    
    [defaultParser addStrongParsingWithFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range) {
        [attributedString addAttributes:weakParser.strongAttributes range:range];
    }];
    
   
    NSRegularExpression *emphasisParsing = [NSRegularExpression regularExpressionWithPattern:@"(?<=\\s)(_)(.*?)(_(?!\\S))" options:kNilOptions error:nil];

    [defaultParser addParsingRuleWithRegularExpression:emphasisParsing block:^(NSTextCheckingResult *match, NSMutableAttributedString *attributedString) {
        [attributedString deleteCharactersInRange:[match rangeAtIndex:3]];
        [attributedString addAttributes:weakParser.emphasisAttributes range:[match rangeAtIndex:2]];
        [attributedString deleteCharactersInRange:[match rangeAtIndex:1]];
    }];
    
    /* unescaping parsing */
    
    [defaultParser addCodeUnescapingParsingWithFormattingBlock:^(NSMutableAttributedString *attributedString, NSRange range) {
        [attributedString addAttributes:weakParser.monospaceAttributes range:range];
    }];
    
    [defaultParser addUnescapingParsing];
    
    return defaultParser;

}

@end
