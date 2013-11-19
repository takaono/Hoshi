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
        
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:background];
        
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"s c o r e  " fontName:@"Helvetica" fontSize:22];
        
        label.scale = 0.5;
        
        label.color = ccc3(20, 20, 20);
        
		label.position = ccp( size.width /2 , size.height/2 + 30 );
        
		[self addChild: label];
        
        __block id copy_self = self;
        
        CCMenuItem *restartLabel = [CCMenuItemImage itemWithNormalImage:@"btn_restart.png" selectedImage:@"btn_restart_pressed.png" block:^(id sender){
            [copy_self showStartScreen:sender];
        }];
		
		CCMenu *menu = [CCMenu menuWithItems:restartLabel, nil];
        
        [menu setPosition:ccp( size.width / 2, size.height / 2 - 50)];
        
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
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GamePlayLayer scene] withColor:ccWHITE]];
}


-(void)createScoreLabel:(int)score
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d s", score] fontName:@"Helvetica" fontSize:30];
    scoreLabel.scale = 0.5;
    
    scoreLabel.color = ccc3(20, 20, 20);
    
    scoreLabel.position = ccp(size.width / 2, size.height / 2 );
    
    [self addChild:scoreLabel];
}


@end
