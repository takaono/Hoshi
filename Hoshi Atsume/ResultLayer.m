//
//  ResultLayer.m
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "ResultLayer.h"


@implementation ResultLayer

+(CCScene *) scene
{
    CCScene *scene = [CCScene node];
    
    ResultLayer *layer = [ResultLayer node];
    
    [scene addChild: layer];
    
    return scene;
}


-(id)init
{
    if((self=[super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        __block id copy_self = self;
        
        CCMenuItem *restartLabel = [CCMenuItemImage itemWithNormalImage:@"btn_restart.png" selectedImage:@"btn_restart_pressed.png" block:^(id sender){
            [copy_self showStartScreen:sender];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:restartLabel, nil];
        
        [menu setPosition:ccp( size.width / 2, size.height / 2)];
        
        [self addChild:menu];
    }
    
    return self;
}


-(void) dealloc
{
    [super dealloc];
}


- (void)showStartScreen:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[StartScreenLayer scene] withColor:ccWHITE]];
}

@end
