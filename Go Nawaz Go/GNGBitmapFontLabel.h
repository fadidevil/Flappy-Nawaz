//
//  GNGBitmapFontLabel.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 25/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GNGBitmapFontLabel : SKNode

@property (nonatomic) NSString* fontName;
@property (nonatomic) NSString* text;
@property (nonatomic) CGFloat letterSpacing;

-(instancetype)initWithText:(NSString*)text andFontName:(NSString*)fontName;


@end
