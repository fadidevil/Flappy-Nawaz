//
//  GNGScrollingLayer.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 10/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGScrollingLayer.h"

@interface GNGScrollingLayer()
@property (nonatomic) SKSpriteNode *rightmostTile;

@end

@implementation GNGScrollingLayer
- (id)initWithTiles:(NSArray *)tileSpriteNodes
{
    if (self = [super init]) {
        for (SKSpriteNode *tile in tileSpriteNodes) {
            tile.anchorPoint = CGPointZero;
            tile.name = @"Tile";
            [self addChild:tile];
        }
        [self layoutTiles];
    }
    return self;
}
//We setup a method stub to layout our tiles:
-(void)layoutTiles
{
    self.rightmostTile = nil;
    [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
        node.position = CGPointMake(self.rightmostTile.position.x +
                                    self.rightmostTile.size.width, node.position.y);
        self.rightmostTile = (SKSpriteNode*)node;
    }];
}

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed
{
    [super updateWithTimeElpased:timeElapsed];
    if (self.scrolling && self.horizontalScrollSpeed < 0 && self.scene) {
        [self enumerateChildNodesWithName:@"Tile" usingBlock:^(SKNode *node, BOOL *stop) {
            CGPoint nodePostionInScene = [self convertPoint:node.position toNode:self.scene];
            if (nodePostionInScene.x + node.frame.size.width <
                -self.scene.size.width * self.scene.anchorPoint.x) {
                node.position = CGPointMake(self.rightmostTile.position.x +
                                            self.rightmostTile.size.width, node.position.y);
                self.rightmostTile = (SKSpriteNode*)node;
            }
        }];
    }
}

@end
