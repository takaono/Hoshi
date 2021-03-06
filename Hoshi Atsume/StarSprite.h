//
//  StarSprite.h
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "AlphaTestSprite.h"

@interface StarSprite : AlphaTestSprite
{
    CGPoint tilePos_;
    BOOL achieved_;
}

@property (nonatomic, readwrite) CGPoint TilePos;
@property (nonatomic, readwrite) BOOL Achieved;

-(void)runAchievedEffect;

@end
