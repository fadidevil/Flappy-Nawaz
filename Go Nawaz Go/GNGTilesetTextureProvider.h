//
//  GNGTilesetTextureProvider.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface GNGTilesetTextureProvider : NSObject

+(instancetype)getProvider;
-(void)randomizeTileset;
-(SKTexture*)getTextureForKey:(NSString*)key;

@end
