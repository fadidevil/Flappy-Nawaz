//
//  GNGObstaclLayer.h
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 24/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGScrollingNode.h"
#import "GNGCollectable.h"

@interface GNGObstacleLayer : GNGScrollingNode

@property (nonatomic, weak) id<GNGCollectableDelegate> collectableDelegate;

@property (nonatomic) CGFloat floor;
@property (nonatomic) CGFloat ceiling;

-(void)reset;

@end
