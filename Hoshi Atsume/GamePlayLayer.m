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
        onMove_ = NO;
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
        
        [map runAction:[CCFollow actionWithTarget:girl_ worldBoundary:CGRectMake(0, 0, map.contentSize.width, map.contentSize.height)]];
        
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


-(void) onEnter
{
	[super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) onExit
{
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	return YES;
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCTMXTiledMap *map = (CCTMXTiledMap*)[self getChildByTag:kTagTileMap];
    
    CGPoint touchPos = [touch locationInView:touch.view];
    touchPos = [[CCDirector sharedDirector] convertToGL:touchPos];
    touchPos = [map convertToNodeSpace:touchPos];
    
    CGPoint vec = ccpSub(touchPos, girl_.position);
    
    int direction = [self moveDirection:vec];
    
    CGPoint nextPos;
    
    float moveDuration = 0.3;
    
    switch (direction)
    {
        case 1:
            nextPos = ccpAdd(girl_.position, ccp(0, map.tileSize.height / 2));
            break;
            
        case 2:
            nextPos = ccpAdd(girl_.position, ccp(0, -map.tileSize.height / 2));
            break;
            
        case 3:
            nextPos = ccpAdd(girl_.position, ccp(-map.tileSize.width / 2, 0));
            break;
            
        case 4:
            nextPos = ccpAdd(girl_.position, ccp(map.tileSize.width / 2, 0));
            break;
            
        default:
            break;
    }
    
    if(!onMove_)
    {
        onMove_ = YES;
        id move = [CCMoveTo actionWithDuration:moveDuration position:nextPos];
        CCEaseInOut *ease = [CCEaseInOut actionWithAction:move rate:1];
        CCCallBlock* block = [CCCallBlock actionWithBlock:^{
            onMove_ = NO;
        }];
        
        CCSequence* seq = [CCSequence actions:ease, block, nil];
        
        [girl_ runAction: seq];
    }
}


-(int) moveDirection:(CGPoint)vec
{
    int direction;
    float angle = ccpToAngle(vec)*180/M_PI;
    
    if(45.0f <= angle && angle < 135.0f) //up
    {
        direction = moveUp;
    }
    else if(-135.0f <= angle && angle < -45.0f) //down
    {
        direction = moveDown;
    }
    else if((135.0f <= angle && angle < 180.0f) || (-180.0f <= angle && angle < -135.0f)) //left
    {
        direction = moveLeft;
    }
    else if((0 <= angle && angle < 45.0f) || (-45.0f <= angle && angle < 0) ) //right
    {
        direction = moveRight;
    }
    else
    {
        direction = nil;
    }
    
    return direction;
}


- (void)showGameResult:(id)sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5 scene:[ResultLayer scene] withColor:ccWHITE]];
}



@end
