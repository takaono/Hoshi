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
        srandom(time(NULL));
        
        onMove_ = NO;
        size_ = [[CCDirector sharedDirector] winSize];
        
        CCTMXTiledMap *map = [CCTMXTiledMap tiledMapWithTMXFile:@"hoshi_map.tmx"];
		[self addChild:map z:0 tag:kTagTileMap];
        
        metaInfo_ = [map layerNamed:@"Info"];
        metaInfo_.visible = NO;
        
        girl_ = [AlphaTestSprite spriteWithFile:@"ortho-test1.png" rect:CGRectMake(ICON_SIZE_W*1+1, ICON_SIZE_H*0, ICON_SIZE_W, ICON_SIZE_H)];
		[map addChild:girl_];
		[girl_ retain];
		[girl_ setAnchorPoint:ccp(0.5f,0.5f)];
        [girl_ setPosition:ccp(51.5 + 51.5/2, 41.5*2 + 25)];
        
        [map runAction:[CCFollow actionWithTarget:girl_ worldBoundary:CGRectMake(0, 0, map.contentSize.width, map.contentSize.height)]];
        
        starSet_ = [[CCArray alloc] initWithCapacity:10];
        
        for(int i = 0; i < MAX_STAR_NUM; i++)
        {
            StarSprite *star = [StarSprite spriteWithFile:@"ortho-test1.png" rect:CGRectMake(ICON_SIZE_W*7, ICON_SIZE_H*3, ICON_SIZE_W, ICON_SIZE_H)];
            [map addChild:star];
            
            CGPoint coord = [self generateTileCoord];
            
            [star setPosition:[self centerOfTileAtX:(int)coord.x y:(int)coord.y]];
            star.TilePos = coord;
            
            [star setVertexZ:[self zIndexAtPosition:star.position]];
            [starSet_ addObject:star];
            [star setShaderProgram:[[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColorAlphaTest]];
        }
        
        __block id copy_self = self;
        
        CCMenuItem *endLabel = [CCMenuItemImage itemWithNormalImage:@"game_end.png" selectedImage:@"game_end_pressed.png" block:^(id sender){
            [copy_self showGameResult:sender];
        }];
        
        CCMenu *menu = [CCMenu menuWithItems:endLabel, nil];
        
        [menu setPosition:ccp( size_.width / 2, size_.height / 2)];
        
        menu.visible = NO;
        
        [self addChild:menu];
        
        [self schedule:@selector(reorderZIndex:)];
    }
    
    return self;
}


-(void) dealloc
{
    [girl_ release];
    [starSet_ release];
    [super dealloc];
}


-(void) onEnter
{
	[super onEnter];
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
    
    [[CCDirector sharedDirector] setProjection:kCCDirectorProjection2D];
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
    
    switch(direction)
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
        if([self checkCollidable:nextPos])
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
        
        if([self hitStar:nextPos])
        {
            BOOL achievedAll = YES;
            for(StarSprite* star in starSet_)
            {
                if(!star.Achieved)
                {
                    achievedAll = NO;
                }
            }
            
            if(achievedAll)
            {
                NSLog(@"Collected all.");
            }
        }
    }
}


-(int)moveDirection:(CGPoint)vec
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


-(void)reorderZIndex:(ccTime)dt
{
	CGPoint p = [girl_ position];
    
    float newZ = [self zIndexAtPosition:p];
    
	[girl_ setVertexZ: newZ];
}


-(float)zIndexAtPosition:(CGPoint)position
{
    position = CC_POINT_POINTS_TO_PIXELS(position);
    
    float z = -(position.y - 77) / 87;
    
    return z;
}


-(BOOL)checkCollidable:(CGPoint)position
{
    CCTMXTiledMap *map = (CCTMXTiledMap*)[self getChildByTag:kTagTileMap];
    
    CGPoint tileCoord = [self tileCoordForPosition:position];
    
    int tileGid = [metaInfo_ tileGIDAt:tileCoord];
    
    if (tileGid)
    {
        NSDictionary *properties = [map propertiesForGID:tileGid];
        
        if (properties)
        {
            NSString *collision = properties[@"Collidable"];
            
            if (collision && [collision isEqualToString:@"True"])
            {
                return NO;
            }
        }
    }
    
    return YES;
}


- (CGPoint)tileCoordForPosition:(CGPoint)position
{
    CCTMXTiledMap *map = (CCTMXTiledMap*)[self getChildByTag:kTagTileMap];
    
    int x = position.x / map.tileSize.width * 2;
    int y = (((map.mapSize.height * map.tileSize.height / 2) - position.y) / map.tileSize.height * 2)+1;
    
    return ccp(x, y);
}


-(CGPoint)generateTileCoord
{
    CCTMXTiledMap *map = (CCTMXTiledMap*)[self getChildByTag:kTagTileMap];
    
    while (YES)
    {
        int col = CCRANDOM_0_1()*map.mapSize.width;
        int row = CCRANDOM_0_1()*map.mapSize.height;
        
        CGPoint coord = ccp(col, row);
        
        BOOL foundSame = NO;
        for(StarSprite* star in starSet_)
		{
			if((int)star.TilePos.x == (int)coord.x && (int)star.TilePos.y == (int)coord.y)
			{
				foundSame = YES;
			}
            
		}
        
        if ([self checkCollidableWithTileCoord:coord] && !foundSame)
        {
            return coord;
        }
    }
}


-(BOOL)checkCollidableWithTileCoord:(CGPoint)coord
{
    CCTMXTiledMap *map = (CCTMXTiledMap*)[self getChildByTag:kTagTileMap];
    
    int tileGid = [metaInfo_ tileGIDAt:coord];
    
    if (tileGid)
    {
        NSDictionary *properties = [map propertiesForGID:tileGid];
        
        if (properties)
        {
            NSString *collision = properties[@"Collidable"];
            
            if (collision && [collision isEqualToString:@"True"])
            {
                return NO;
            }
        }
    }
    return YES;
    
}


-(CGPoint)centerOfTileAtX:(int)x y:(int)y
{
    CCTMXTiledMap *map = (CCTMXTiledMap*)[self getChildByTag:kTagTileMap];
    
    float posX = (x + 1) * map.tileSize.width / 2 - map.tileSize.width / 4;
    float posY = map.mapSize.height * map.tileSize.height / 2 - map.tileSize.height / 2 * y + 20;
    
    return ccp(posX, posY);
}


-(BOOL) hitStar:(CGPoint)pos
{
    CGPoint coord = [self tileCoordForPosition:pos];
    
    for(StarSprite* star in starSet_)
    {
        if((int)star.TilePos.x == (int)coord.x && (int)star.TilePos.y == (int)coord.y && star.visible == YES)
        {
            //star.visible = NO;
            [star runAchievedEffect];
            star.Achieved = YES;
            return YES;
        }
    }
    
    return NO;
}


@end
