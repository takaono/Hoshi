//
//  AlphaTestSprite.m
//  Hoshi Atsume
//
//  Created by Takeshi Ugajin on 17/11/2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import "AlphaTestSprite.h"


@implementation AlphaTestSprite

-(void) draw
{
    [self setShaderProgram:[[CCShaderCache sharedShaderCache] programForKey:kCCShader_PositionTextureColorAlphaTest]];
    [super draw];
}

@end
