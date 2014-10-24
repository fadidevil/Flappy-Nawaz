//
//  GNGNawaz.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 30/09/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGNawaz.h"
#import "GNGConstants.h"

@interface GNGNawaz()
@property (nonatomic) NSMutableArray *nawazAnimations;
//@property (nonatomic) SKEmitterNode *puffTrailEmitter;
//@property (nonatomic) CGFloat puffTrailBirthRate;

@end
static NSString* const kGNGKeyNawazAnimation = @"NawazAnimation";
static const CGFloat kGNGMaxAltitude = 300.0;


@implementation GNGNawaz

- (id)init
{
    self = [super initWithImageNamed:@"Nawaz"];
    if (self) {
        
//        Setup Physics body with path
        
        
        CGFloat offsetX = self.frame.size.width * self.anchorPoint.x;
        CGFloat offsetY = self.frame.size.height * self.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 20 - offsetX, 2 - offsetY);
        CGPathAddLineToPoint(path, NULL, 22 - offsetX, 3 - offsetY);
        CGPathAddLineToPoint(path, NULL, 21 - offsetX, 4 - offsetY);
        CGPathAddLineToPoint(path, NULL, 17 - offsetX, 7 - offsetY);
        CGPathAddLineToPoint(path, NULL, 16 - offsetX, 10 - offsetY);
        CGPathAddLineToPoint(path, NULL, 15 - offsetX, 17 - offsetY);
        CGPathAddLineToPoint(path, NULL, 11 - offsetX, 20 - offsetY);
        CGPathAddLineToPoint(path, NULL, 8 - offsetX, 21 - offsetY);
        CGPathAddLineToPoint(path, NULL, 3 - offsetX, 16 - offsetY);
        CGPathAddLineToPoint(path, NULL, 2 - offsetX, 11 - offsetY);
        CGPathAddLineToPoint(path, NULL, 5 - offsetX, 7 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 6 - offsetY);
        CGPathAddLineToPoint(path, NULL, 8 - offsetX, 0 - offsetY);
        
        CGPathCloseSubpath(path);
        
        self.physicsBody = [SKPhysicsBody bodyWithPolygonFromPath:path];
        
        self.physicsBody.mass = 0.039;
        
        self.physicsBody.categoryBitMask = kGNGCategoryNawaz;
        self.physicsBody.contactTestBitMask = kGNGCategoryGround;
        
        
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
        /* NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"NawazPuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];
        _puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, -5);
        [self addChild:self.puffTrailEmitter];
        self.puffTrailBirthRate = _puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0; */
        
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
        [self actionForKey:kGNGKeyNawazAnimation].speed = 1;
        
        //self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    }
    else {
        [self actionForKey:kGNGKeyNawazAnimation].speed = 0;
        //self.puffTrailEmitter.particleBirthRate = 0;
    }
}



- (void)setCrashed:(BOOL)crashed
{
    _crashed = crashed;
    if (crashed) {
        self.engineRunning = NO;
    
    }
}
- (void)flap
{
    if (!self.crashed && self.position.y < kGNGMaxAltitude) {
        // Make sure plane can't drop faster than -200.
        if (self.physicsBody.velocity.dy < -200) {
            self.physicsBody.velocity = CGVectorMake(0, -200);
        }
        [self.physicsBody applyImpulse:CGVectorMake(0.0, 20)];
        // Make sure that the plane can't go up faster than 300.
        if (self.physicsBody.velocity.dy > 300) {
            self.physicsBody.velocity = CGVectorMake(0, 300);
        }
    }
}

- (void)setRandomColour
{
    [self removeActionForKey:kGNGKeyNawazAnimation];
    SKAction *animation = [self.nawazAnimations objectAtIndex:arc4random_uniform(self.nawazAnimations.count)];

    [self runAction:animation withKey:kGNGKeyNawazAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kGNGKeyNawazAnimation].speed =0;
    }

}

- (void)collide:(SKPhysicsBody *)body
{
    if (!self.crashed) {
        if (body.categoryBitMask == kGNGCategoryGround) {
            
            self.crashed = YES;
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

    if(!self.crashed)
    {
        self.zRotation = fmaxf(fminf(self.physicsBody.velocity.dy, 400), -400) / 400;
    }

}

@end
