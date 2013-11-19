//
//  ResultLayer.h
//  Hoshi Atsume
//
//  Created by T.ONO on 2013.
//  Copyright 2013 T.ONO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GamePlayLayer.h"

@interface ResultLayer : CCLayer {
    
}

+(CCScene *) scene;
-(void)createScoreLabel:(int)score;

@end
