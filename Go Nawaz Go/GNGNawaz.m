//
//  GNGNawaz.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 30/09/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGNawaz.h"

@interface GNGNawaz()
@property (nonatomic) NSMutableArray *nawazAnimations;
@property (nonatomic) SKEmitterNode *puffTrailEmitter;
@property (nonatomic) CGFloat puffTrailBirthRate;

@end
static NSString* const kKeyNawazAnimation = @"NawazAnimation";


@implementation GNGNawaz

- (id)init
{
    self = [super initWithImageNamed:@"Nawaz@2x"];
    if (self) {
        
        self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:self.size.width * 0.5];
        self.physicsBody.mass = 0.08;
        
        
        _nawazAnimations = [[NSMutableArray alloc] init];
        
        NSArray *frames = @[[SKTexture textureWithImageNamed:@"Nawaz"]];
        SKAction *animation = [SKAction animateWithTextures:frames timePerFrame:0.133 resize:NO restore:NO];
        [self runAction:[SKAction repeatActionForever:animation]];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"NawazAnimations" ofType:@"plist"];
        NSDictionary *animations = [NSDictionary dictionaryWithContentsOfFile:path];
        for (NSString *key in animations) {
            [self.nawazAnimations addObject:[self animationFormArray:[animations objectForKey:key] withDuration:0.4]];
        }
        
        //puff trail
        NSString *particleFile = [[NSBundle mainBundle] pathForResource:@"NawazPuffTrail" ofType:@"sks"];
        _puffTrailEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:particleFile];

        _puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, -5);
        [self addChild:self.puffTrailEmitter];
        self.puffTrailBirthRate = _puffTrailEmitter.particleBirthRate;
        self.puffTrailEmitter.particleBirthRate = 0;
        
        [self setRandomColour];
    }
    return self;
}
- (void)setEngineRunning:(BOOL)engineRunning
{
    _engineRunning = engineRunning;
    if (engineRunning) {
        [self actionForKey:kKeyNawazAnimation].speed = 1;
        self.puffTrailEmitter.particleBirthRate = self.puffTrailBirthRate;
    }
    else {
        [self actionForKey:kKeyNawazAnimation].speed = 0;
        self.puffTrailEmitter.particleBirthRate = 0;
    }
}


- (void)setRandomColour
{
    [self removeActionForKey:kKeyNawazAnimation];
    SKAction *animation = [self.nawazAnimations objectAtIndex:arc4random_uniform(self.nawazAnimations.count)];
    [self runAction:animation withKey:kKeyNawazAnimation];
    if (!self.engineRunning) {
        [self actionForKey:kKeyNawazAnimation].speed =0;
    }

}


-(SKAction*)animationFormArray:(NSArray*)textureNames withDuration:(CGFloat)duration
{
    //Create array to hold textures..
    
    NSMutableArray *frames = [[NSMutableArray alloc] init];
    
    //Get planes atls.
 
    SKTextureAtlas *nawazAtles = [SKTextureAtlas atlasNamed:@"Nawaz"];
    
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
}

@end
