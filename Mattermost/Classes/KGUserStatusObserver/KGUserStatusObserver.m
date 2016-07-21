//
//  KGUserStatusObserver.m
//  Mattermost
//
//  Created by Igor Vedeneev on 11.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGUserStatusObserver.h"
#import "KGUserStatus.h"

@implementation KGUserStatusObserver

+ (instancetype)sharedObserver {
    static KGUserStatusObserver *observer = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        observer = [[self alloc] init];
    });
    
    return observer;
}


- (void)updateWithArray:(NSArray *)array {
    self.userStatuses = array;
}

- (KGUserStatus *)userStatusForIdentifier:(NSString *)identifier {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    KGUserStatus *userStatus = [self.userStatuses filteredArrayUsingPredicate:predicate].firstObject;
    
    return userStatus;
}

@end
