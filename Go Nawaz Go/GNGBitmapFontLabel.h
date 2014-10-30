//
//  GNGBitmapFontLabel.h
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 25/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    BitmapFontAlignmentLeft,
    BitmapFontAlignmentCenter,
    BitmapFontAlignmentRight,
} BitmapFontAlignment;

@interface GNGBitmapFontLabel : SKNode

@property (nonatomic) NSString* fontName;
@property (nonatomic) NSString* text;
@property (nonatomic) CGFloat letterSpacing;
@property (nonatomic) BitmapFontAlignment alignment;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;


@end
