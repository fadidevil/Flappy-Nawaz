//
//  GNGGameOverMenu.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGGameOverMenu.h"

@implementation GNGGameOverMenu

-(instancetype)initWithSize:(CGSize)size
{
    if (self = [super init]) {
        _size = size;
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
        SKSpriteNode *panelBackground = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"UIbg"]];
        panelBackground.position = CGPointMake(size.width * 0.5, size.height - 150.0);
        panelBackground.centerRect = CGRectMake(10 / panelBackground.size.width,
                                                10 / panelBackground.size.height,
                                                (panelBackground.size.width - 20) / panelBackground.size.width,
                                                (panelBackground.size.height - 20) / panelBackground.size.height);
        panelBackground.xScale = 175.0 / panelBackground.size.width;
        panelBackground.yScale = 155.0 / panelBackground.size.height;
        [self addChild:panelBackground];
        
    }
    return self;
}

@end
