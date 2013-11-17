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

enum {
	kTagTileMap = 1,
}GamePlayNodeTags;

@interface GamePlayLayer : CCLayer
{
    CGSize size_;
}

+(CCScene *) scene;

@end
