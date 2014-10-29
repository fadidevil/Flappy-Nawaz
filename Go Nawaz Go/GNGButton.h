//
//  GNGButton.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SoundManager.h"

@interface GNGButton : SKSpriteNode

@property (nonatomic, readonly, weak) id pressedTarget;
@property (nonatomic, readonly) SEL pressedAction;
@property (nonatomic) CGFloat pressedScale;
@property (nonatomic) Sound *pressedSound;

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction;

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture;

@end
