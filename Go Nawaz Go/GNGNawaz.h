//
//  GNGNawaz.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 30/09/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GNGNawaz : SKSpriteNode

@property (nonatomic) BOOL engineRunning;
@property (nonatomic) BOOL crashed;
@property (nonatomic) BOOL accelerating;


-(void)setRandomColour;
-(void)update;
-(void)collide:(SKPhysicsBody*)body;
-(void)reset;


@end
