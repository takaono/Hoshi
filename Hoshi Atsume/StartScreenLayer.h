//
//  StartScreenLayer.h
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright T.ONO 2013. All rights reserved.
//


#import <GameKit/GameKit.h>
#import "cocos2d.h"
#import "GamePlayLayer.h"

@interface StartScreenLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

+(CCScene *) scene;

@end
