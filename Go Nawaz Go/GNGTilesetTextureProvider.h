//
//  GNGTilesetTextureProvider.h
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GNGTilesetTextureProvider : NSObject

@property (nonatomic) NSString *currentTilesetName;

+(instancetype)getProvider;
-(void)randomizeTileset;
-(SKTexture*)getTextureForKey:(NSString*)key;

@end
