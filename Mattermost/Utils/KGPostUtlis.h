//
//  KGPostUtlis.h
//  Mattermost
//
//  Created by Igor Vedeneev on 19.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KGFile, UIImage, KGError, KGChannel, KGPost, NSManagedObjectContext;

@interface KGPostUtlis : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *pendingMessagesContext;

+ (instancetype)sharedInstance;

- (void)sendPostInChannel:(KGChannel *)channel
                  message:(NSString *)message
              attachments:(NSArray<UIImage *> *)attachments
               completion:(void(^)(KGPost *post, KGError *error))completion
                 progress:(void(^)(NSUInteger persentValue))progress;

@end
