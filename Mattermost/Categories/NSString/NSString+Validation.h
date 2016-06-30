//
//  NSString+Validation.h
//  Mattermost
//
//  Created by Tatiana on 08/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

- (BOOL)kg_isValidEmail;
- (BOOL)kg_isValidUrl;

@end
