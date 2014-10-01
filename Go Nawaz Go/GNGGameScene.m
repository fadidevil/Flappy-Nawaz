//
//  GNGGameScene.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 30/09/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGGameScene.h"
#import "GNGNawaz.h"

@interface GNGGameScene()

@property (nonatomic) GNGNawaz *player;
@property (nonatomic) SKNode *world;

@end

@implementation GNGGameScene


- (id) initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5);
       
        //World
        _world = [SKNode node];
        [self addChild:_world];
        
        
        //player
        _player = [[GNGNawaz alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        _player.physicsBody.affectedByGravity = NO;
        _player.engineRunning = YES;
        [_world addChild:_player];
        
    }
                return self;
        
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
     _player.physicsBody.affectedByGravity = YES;

        self.player.accelerating = YES;
    }
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        self.player.accelerating = NO;
}
}

- (void) update:(NSTimeInterval)currentTime
{
    [self.player update];
}

    @end
