//
//  GamePlayLayer.m
//  Hoshi Atsume
//
//  Created by Takeshi Ugajin on 14/11/2013.
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
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        __block id copy_self = self;
        
        CCMenuItem *endLabel = [CCMenuItemImage itemWithNormalImage:@"game_end.png" selectedImage:@"game_end_pressed.png" block:^(id sender){
            [copy_self showGameResult:sender];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:endLabel, nil];
        
        [menu setPosition:ccp( size.width / 2, size.height / 2)];
        
        [self addChild:menu];
    }
    
    return self;
}


-(void) dealloc
{
    [super dealloc];
}


- (void)showGameResult:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ResultLayer scene] withColor:ccWHITE]];
}



@end
