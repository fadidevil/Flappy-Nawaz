//
//  GNGObstaclLayer.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 24/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGObstacleLayer.h"
#import "GNGConstants.h"

@interface GNGObstacleLayer()

@property (nonatomic) CGFloat marker;

@end

static const CGFloat kGNGMarkerBuffer = 200.0;
static const CGFloat kGNGVerticalGap = 90.0;

static NSString *const kGNGKeyMountainUp = @"MountainUp";
static NSString *const kGNGKeyMountainDown = @"MountainDown";
static const CGFloat kGNGSpaceBetweenObstacleSets = 180.0;

@implementation GNGObstacleLayer

-(void)reset
{
    // Loop through child nodes and reposition for reuse.
    for (SKNode *node in self.children) {
        node.position = CGPointMake(-1000, 0);
    }
    // Reposition marker.
    if (self.scene) {
        self.marker = self.scene.size.width + kGNGMarkerBuffer;
    }
}

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElpased:timeElapsed];
    if (self.scrolling && self.scene)
    
    {
//    Find Markers location in scene
        CGPoint markerLocationInScene = [self convertPoint:CGPointMake(self.marker, 0) toNode:self.scene];
        // When marker comes onto screen, add new obstacles.
        if (markerLocationInScene.x - (self.scene.size.width * self.scene.anchorPoint.x)
            < self.scene.size.width + kGNGMarkerBuffer) {
            [self addObstacleSet];
        

        }
    }

}
-(void)addObstacleSet
{
//    Get Mountain Nodes
    SKSpriteNode *mountainUp = [self createObjectForKey:kGNGKeyMountainUp];
    SKSpriteNode *mountainDown = [self createObjectForKey:kGNGKeyMountainDown];
    
//    calculate Max vartiation
    CGFloat maxVariation = (mountainUp.size.height + mountainDown.size.height + kGNGVerticalGap) - (self.ceiling - self.floor);
    CGFloat yAdjustment = (CGFloat)arc4random_uniform(maxVariation);
    
//    mountain Postions
    mountainUp.position = CGPointMake(self.marker, self.floor + (mountainUp.size.height * 0.5) - yAdjustment);
    mountainDown.position = CGPointMake(self.marker, mountainUp.position.y + mountainDown.size.height + kGNGVerticalGap);
    
//    Reposition Marker
    self.marker += kGNGSpaceBetweenObstacleSets;
    
    
    
}
-(SKSpriteNode*)getUnusedObjectForKey:(NSString*)key
{
    if (self.scene) {
        // Get left edge of screen in local coordinates.
        CGFloat leftEdgeInLocalCoords = [self.scene convertPoint:CGPointMake(-self.scene.size.width * self.scene.anchorPoint.x, 0) toNode:self].x;
        // Try find object for key to the left of the screen.
        for (SKSpriteNode* node in self.children) {
            if (node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords) {
                // Return unused object.
                return node;
            }
        }
    }
    // Couldn't find an unused node with key so create a new one.
    return [self createObjectForKey:key];
}
    
    


- (SKSpriteNode*)createObjectForKey:(NSString*)key
{
    SKSpriteNode *object = nil;
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Graphics"];
    
    
    if (key == kGNGKeyMountainUp) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrass"]];
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 52 - offsetX, 199 - offsetY);
        CGPathAddLineToPoint(path, NULL, 30 - offsetX, 96 - offsetY);
        CGPathAddLineToPoint(path, NULL, 23 - offsetX, 89 - offsetY);
        CGPathAddLineToPoint(path, NULL, 0 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 90 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(path, NULL, 84 - offsetX, 51 - offsetY);
        CGPathAddLineToPoint(path, NULL, 58 - offsetX, 197 - offsetY);
        
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kGNGCategoryGround;
        
        [self addChild:object];
        
    }
    else if (key == kGNGKeyMountainDown) {
        object = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"MountainGrassDown"]];
        
        CGFloat offsetX = object.frame.size.width * object.anchorPoint.x;
        CGFloat offsetY = object.frame.size.height * object.anchorPoint.y;
        
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathMoveToPoint(path, NULL, 90 - offsetX, 198 - offsetY);
        CGPathAddLineToPoint(path, NULL, 1 - offsetX, 198 - offsetY);
        CGPathAddLineToPoint(path, NULL, 23 - offsetX, 107 - offsetY);
        CGPathAddLineToPoint(path, NULL, 52 - offsetX, 1 - offsetY);
        CGPathAddLineToPoint(path, NULL, 59 - offsetX, 0 - offsetY);
        CGPathCloseSubpath(path);
        
        object.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromPath:path];
        object.physicsBody.categoryBitMask = kGNGCategoryGround;
        
        
        [self addChild:object];
    }

    if (object) {
        object.name = key;
    }
    return object;
}

@end
