//
//  GamePlayLayer.m
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "GamePlayLayer.h"


@implementation GamePlayLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    GamePlayLayer *layer = [GamePlayLayer node];
    
    [scene addChild: layer];
    
    return scene;
}


-(id)init
{
    if((self=[super init]))
    {
        size_ = [[CCDirector sharedDirector] winSize];
        
        CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:@"hoshi_map.tmx"];
		[self addChild:map z:0 tag:kTagTileMap];
        
        metaInfo_ = [map layerNamed:@"Info"];
        metaInfo_.visible = NO;
        
        girl_ = [CCSprite spriteWithFile:@"ortho-test1.png" rect:CGRectMake(ICON_SIZE_W*1+1, ICON_SIZE_H*0, ICON_SIZE_W, ICON_SIZE_H)];
		[map addChild:girl_];
		[girl_ retain];
		[girl_ setAnchorPoint:ccp(0.5f,0.5f)];
        [girl_ setPosition:ccp(51.5 + 51.5/2, 41.5*2 + 25)];
        
        __block id copy_self = self;
        
        CCMenuItem *endLabel = [CCMenuItemImage itemWithNormalImage:@"game_end.png" selectedImage:@"game_end_pressed.png" block:^(id sender){
            [copy_self showGameResult:sender];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:endLabel, nil];
        
        [menu setPosition:ccp( size_.width / 2, size_.height / 2)];
        
        menu.visible = NO;
        
        [self addChild:menu];
    }
    
    return self;
}


-(void) dealloc
{
    [girl_ release];
    [super dealloc];
}


- (void)showGameResult:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ResultLayer scene] withColor:ccWHITE]];
}



@end
