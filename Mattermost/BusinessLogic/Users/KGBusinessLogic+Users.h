//
//  KGBusinessLogic+Users.h
//  Mattermost
//
//  Created by Igor Vedeneev on 20.07.16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"

@interface KGBusinessLogic (Users)

- (void)loadFullUsersListWithCompletion:(void (^)(KGError* error))completion;

@end
