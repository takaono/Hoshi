//
//  StartScreenLayer.m
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright T.ONO 2013. All rights reserved.
//


#import "StartScreenLayer.h"
#import "AppDelegate.h"

#pragma mark - StartScreenLayer

@implementation StartScreenLayer

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
    
	StartScreenLayer *layer = [StartScreenLayer node];
    
	[scene addChild: layer];
    
	return scene;
}


-(id) init
{
    if((self=[super init]))
    {
        CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCLayerColor *bgLayer = [CCLayerColor layerWithColor:ccc4(255, 255, 255, 255)];
        [self addChild:bgLayer];
        
        __block id copy_self = self;
        
        CCMenuItem *startButton = [CCMenuItemImage itemWithNormalImage:@"btn_start.png" selectedImage:@"btn_start_pressed.png" block:^(id sender){
            [copy_self gameStart:sender];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:startButton, nil];
        
        [menu setPosition:ccp( size.width / 2, size.height / 2)];
		
		[self addChild:menu];
    }
    return self;
}


- (void) dealloc
{
    [super dealloc];
}


- (void)gameStart:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[GamePlayLayer scene] withColor:ccWHITE]];
}


#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}
@end
