//
//  KGBusinessLogic+Team.h
//  Mattermost
//
//  Created by Maxim Gubin on 07/06/16.
//  Copyright © 2016 Kilograpp. All rights reserved.
//

#import "KGBusinessLogic.h"

@class KGTeam;

@interface KGBusinessLogic (Team)

- (void)loadTeamsWithCompletion:(void(^)(BOOL userShouldSelectTeam, KGError *error))completion;
- (KGTeam *)currentTeam;
@end
