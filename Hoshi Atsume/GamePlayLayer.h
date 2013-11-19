//
//  GamePlayLayer.h
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ResultLayer.h"
#import "AlphaTestSprite.h"
#import "StarSprite.h"


#define ICON_SIZE_W 51.5
#define ICON_SIZE_H 87
#define MAX_STAR_NUM 5


enum
{
	kTagTileMap = 1,
}GamePlayNodeTags;


enum
{
    moveUp = 1,
    moveDown,
    moveLeft,
    moveRight
} moveDirection;


@interface GamePlayLayer : CCLayer
{
    CGSize size_;
    BOOL onMove_;
    CCTMXLayer *metaInfo_;
    AlphaTestSprite *girl_;
    CCArray *starSet_;
}

+(CCScene *) scene;

@end
