//
//  GNGTilesetTextureProvider.m
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGTilesetTextureProvider.h"

@interface GNGTilesetTextureProvider()

@property (nonatomic)NSMutableDictionary *tilesets;
@property (nonatomic) NSDictionary *currentTileset;

@end

@implementation GNGTilesetTextureProvider

+(instancetype)getProvider
{
    static GNGTilesetTextureProvider* provider = nil;
    @synchronized(self) {
        if (!provider) {
            provider = [[GNGTilesetTextureProvider alloc] init];
        }
        return provider;
    }
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadTilesets];
        [self randomizeTileset];
    }
    return self;
}

-(void)randomizeTileset
{
    NSArray *tilesetKeys = [self.tilesets allKeys];
  self.currentTilesetName = [tilesetKeys objectAtIndex:arc4random_uniform((uint)tilesetKeys.count)];
    self.currentTileset = [self.tilesets objectForKey:self.currentTilesetName];
}

-(SKTexture*)getTextureForKey:(NSString*)key
{
    return [self.currentTileset objectForKey:key];
}


-(void)loadTilesets
{
    self.tilesets = [[NSMutableDictionary alloc] init];
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    // Get path to property list.
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TilesetGraphics" ofType:@"plist"];
    // Load contents of file.
    NSDictionary *tilesetList = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    // Loop through tilesetList.
    for (NSString *tilesetKey in tilesetList) {
        // Get dictionary of texture names.
        NSDictionary *textureList = [tilesetList objectForKey:tilesetKey];
        // Create dictionary to hold textures.
        NSMutableDictionary *textures = [[NSMutableDictionary alloc] init];
        for (NSString *textureKey in textureList) {
            // Get texture for key.
            SKTexture *texture = [atlas textureNamed:[textureList objectForKey:textureKey]];
            // Insert texture to textures dictionary.
            [textures setObject:texture forKey:textureKey];
        }
        // Add textures dictionary to tilesets.
        [self.tilesets setObject:textures forKey:tilesetKey];
    }
}

@end

