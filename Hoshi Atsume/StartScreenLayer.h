//
//  StartScreenLayer.h
//  Hoshi Atsume
//
//  Created by T.ONO.
//  Copyright T.ONO 2013. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface StartScreenLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
}

// returns a CCScene that contains the StartScreenLayer as the only child
+(CCScene *) scene;

@end
