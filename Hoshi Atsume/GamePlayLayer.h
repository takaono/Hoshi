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


#define ICON_SIZE_W 51.5
#define ICON_SIZE_H 87


enum {
	kTagTileMap = 1,
}GamePlayNodeTags;

@interface GamePlayLayer : CCLayer
{
    CGSize size_;
    CCTMXLayer *metaInfo_;
    CCSprite *girl_;
}

+(CCScene *) scene;

@end
