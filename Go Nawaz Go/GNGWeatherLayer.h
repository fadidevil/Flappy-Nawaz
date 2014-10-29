//
//  GNGWeatherLayer.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 29/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    WeatherClear,
    WeatherRaining,
    WeatherSnowing,
} WeatherType;


@interface GNGWeatherLayer : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) WeatherType conditions;
-(instancetype)initWithSize:(CGSize)size;

@end
