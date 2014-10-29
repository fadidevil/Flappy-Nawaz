//
//  GNGWeatherLayer.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 29/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGWeatherLayer.h"
#import "SoundManager.h"

@interface GNGWeatherLayer()
@property (nonatomic) SKEmitterNode *rainEmitter;
@property (nonatomic) SKEmitterNode *snowEmitter;
@property (nonatomic) Sound *rainSound;
@end

@implementation GNGWeatherLayer

- (instancetype)initWithSize:(CGSize)size
{
    self = [super init];
    if (self) {
        _size = size;
        // Load rain effect.
        NSString *rainEffectPath = [[NSBundle mainBundle] pathForResource:@"RainEffect" ofType:@"sks"];
        _rainEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:rainEffectPath];
        _rainEmitter.position = CGPointMake(size.width * 0.5 + 32, size.height + 5);
        // Setup rain sound.
        _rainSound = [Sound soundNamed:@"Rain.caf"];
        _rainSound.looping = YES;
        
        // Load snow effect.
        NSString *snowEffectPath = [[NSBundle mainBundle] pathForResource:@"SnowEffect" ofType:@"sks"];
        _snowEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:snowEffectPath];
        _snowEmitter.position = CGPointMake(size.width * 0.5, size.height + 5);
    }
    return self;
}

-(void)setConditions:(WeatherType)conditions
{
    if (_conditions != conditions) {
        _conditions = conditions;
        // Remove existing weather effect.
        [self removeAllChildren];
        // Stop any existing sounds from playing.
        if (self.rainSound.playing) {
            [self.rainSound fadeOut:1.0];
        }
        
                
        // Add weather conditions.
        switch (conditions) {
            case WeatherRaining:
                [self.rainSound play];
                [self.rainSound fadeIn:1.0];
                [self addChild:self.rainEmitter];
                [self.rainEmitter advanceSimulationTime:5];
                break;
            case WeatherSnowing:
                [self addChild:self.snowEmitter];
                [self.snowEmitter advanceSimulationTime:5];
                break;
            default:
                break;
        }
    }
}

@end
