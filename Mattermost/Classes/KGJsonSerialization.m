//
//  KGJsonSerialization.m
//  Mattermost
//
//  Created by Maxim Gubin on 21/07/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGJsonSerialization.h"

static NSString * KGTrueStringResponse = @"true";

@implementation KGJsonSerialization

+ (id)objectFromData:(NSData *)data error:(NSError **)error
{
    id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    if (!result) {
        NSString* stringResponse = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if ([stringResponse isEqualToString:KGTrueStringResponse]){
            result = [NSDictionary dictionary];
        }
    }
    return result;
}

+ (NSData *)dataFromObject:(id)object error:(NSError **)error
{
    return [NSJSONSerialization dataWithJSONObject:object options:0 error:error];
}


@end
