//
//  StarSprite.m
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "StarSprite.h"

@implementation StarSprite

@synthesize TilePos = tilePos_;
@synthesize Achieved = achieved_;


-(id) init
{
	if( (self=[super init]) )
    {
        achieved_ = NO;
    }
	
    return self;
}


-(void)runAchievedEffect
{
    CCDelayTime *delay = [CCDelayTime actionWithDuration:0.3];
    CCMoveBy *moveBy = [CCMoveBy actionWithDuration:0.3 position:ccp(0, 60)];
    CCRotateBy *rotateBy = [CCRotateBy actionWithDuration:0.3 angle:360];
    CCScaleBy *scaleBy = [CCScaleBy actionWithDuration:0.3 scale:0.5];
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:0.3];
    CCSpawn *spawn = [CCSpawn actions:moveBy, rotateBy, scaleBy, fadeOut, nil];
    CCCallBlock* block = [CCCallBlock actionWithBlock:^{
        self.visible = NO;
    }];
    CCSequence *seq = [CCSequence actions:delay, spawn, block, nil];
    [self runAction:seq];
}


@end
