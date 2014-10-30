//
//  GNGScrollingLayer.h
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 10/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGScrollingNode.h"

@interface GNGScrollingLayer : GNGScrollingNode

- (id)initWithTiles:(NSArray*)tileSpriteNode;
-(void)layoutTiles;

@end
