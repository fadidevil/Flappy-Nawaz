//
//  GNGNawaz.m
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 30/09/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGNawaz.h"
#import "GNGConstants.h"
#import "GNGCollectable.h"
#import "SoundManager.h"

@interface GNGNawaz()
@property (nonatomic) NSMutableArray *nawazAnimations;
@property (nonatomic) SKAction *crashTintAction;
@property (nonatomic) Sound *engineSound;

/*@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthRate; */

@end
static NSString* const kKeyNawazAnimation = @"NawazAnimation";


@implementation GNGNawaz

- (id)init
{
    self = [super initWithImageNamed:@"Nawaz"];
    if (self) {
        
//        Setup Physics body with path
        
        
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 46 - offsetX, 9 - offsetY);
        CGPathAddLineToPoint(path, NULL, 35 - offsetX, 16 - offsetY);
        CGPathAddLineToPoint(path, NULL, 32 - offsetX, 21 - offsetY);
        CGPathAddLineToPoint(path, NULL, 32 - offsetX, 34 - offsetY);
        CGPathAddLineToPoint(path, NULL, 27 - offsetX, 39 - offsetY);
        CGPathAddLineToPoint(path, NULL, 21 - offsetX, 42 - offsetY);
        CGPathAddLineToPoint(path, NULL, 7 - offsetX, 33 - offsetY);
        CGPathAddLineToPoint(path, NULL, 7 - offsetX, 24 - offsetY);
        CGPathAddLineToPoint(path, NULL, 4 - offsetX, 14 - offsetY);
        CGPathAddLineToPoint(path, NULL, 17 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 45 - offsetX, 5 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        self.physicsBody.mass = 0.08;
        
        self.physicsBody.categoryBitMask = kGNGCategoryNawaz;
        self.physicsBody.contactTestBitMask = kGNGCategoryGround | kGNGCategoryCollectable;
        self.physicsBody.collisionBitMask = kGNGCategoryGround;
        
        
        _nawazAnimations = [[NSMutableArray alloc] init];
        
        NSArray *frames = @[[SKTexture textureWithImageNamed:@"Nawaz"]];
        SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:0.133 resize:NO restore:NO];
        [self runAction:[SKAction repeatActionForever:animation]];
        
        NSString *AnimationPlistpath = [[NSBundle mainBundle] pathForResource:@"NawazAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:AnimationPlistpath];
        for (NSString *key in animations) {
            [self.nawazAnimations addObject:[self animationFormArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        //puff trail
        /* NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"nawazPuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, -5);
        [self addChild:self.puffTrailEmitter];
        self.puffTrailBirthRate = _puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0; */
        
        // Setup action to tint plane when it crashes.
        SKAction *tint = [SKAction colorizeWithColor:[SKColor redColor] colorBlendFactor:0.8 duration:0.0];
        SKAction *removeTint = [SKAction colorizeWithColorBlendFactor:0.0 duration:0.2];
        _crashTintAction = [SKAction sequence:@[tint, removeTint]];
        
        // Setup engine sound.
        _engineSound = [Sound soundNamed:@"Engine.caf"];
        _engineSound.looping = YES;
        
        [self setRandomColour];
    }
    return self;
}
- (void)reset
{
    // Set plane's initial values.
    self.crashed = NO;
    self.engineRunning = YES;
    self.physicsBody.velocity = CGVectorMake(0.0, 0.0);
    self.zRotation = 0.0;
    self.physicsBody.angularVelocity = 0.0;
    
}




- (void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning && !self.crashed;
    if (engineRunning) {
        [self.engineSound play];
        [self.engineSound fadeIn:1.0];
        //self.puffTrailEmitter.targetNode = self.parent;
        [self actionForKey:kKeyNawazAnimation].speed = 1;
        //self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    }
    else {
        [self.engineSound fadeOut:0.5];
        [self actionForKey:kKeyNawazAnimation].speed = 0;
        //self.puffTrailEmitter.particleBirthRate = 0;
    }
}



- (void)setCrashed:(BOOL)crashed
{
    _crashed = crashed;
    if (crashed) {
        self.engineRunning = NO;
         self.accelerating = NO;
    
    }
}
- (void)setAccelerating:(BOOL)accelerating
{
    _accelerating = accelerating && !self.crashed;
}
- (void)setRandomColour
{
    [self removeActionForKey:kKeyNawazAnimation];
    SKAction *animation = [self.nawazAnimations objectAtIndex:arc4random_uniform((uint)self.nawazAnimations.count)];

    [self runAction:animation withKey:kKeyNawazAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kKeyNawazAnimation].speed =0;
    }

}

- (void)collide:(SKPhysicsBody *)body
{
    if (!self.crashed) {
        if (body.categoryBitMask == kGNGCategoryGround) {
            
            self.crashed = YES;
            [self runAction:self.crashTintAction];
            [[SoundManager sharedManager] playSound:@"Crunch.caf"];
       }
        if (body.categoryBitMask == kGNGCategoryCollectable) {
            if ([body.node respondsToSelector:@selector(collect)]) {
                [body.node performSelector:@selector(collect)];
            }
        }
    }
}


-(SKAction*)animationFormArray:(NSArray*)textureNames withDuration:(CGFloat)duration
{
    //Create array to hold textures..
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //Get planes atls.
 
    SKTextureAtlas *nawazAtles = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    //Loop through texture
    for (NSString *textureName in textureNames) {
        [frames addObject:[nawazAtles textureNamed:textureName]];
        
    }
 //Frame time
    CGFloat frameTime = duration / frames.count;
    //Action
    return [SKAction repeatActionForever:[SKAction animateWithTextures:frames timePerFrame:frameTime resize:NO restore:NO]];
    
}

- (void)update
{
    if (self.accelerating) {
        [self.physicsBody applyForce:CGVectorMake(0.0, 100)];
    }
    
    if(!self.crashed)
    {
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 400), -400) / 400;
        self.engineSound.volume = 0.25 + fmaxf(fminf(self.physicsBody.velocity.dy, 300), 0) / 300 * 0.75;
    }

}

@end
