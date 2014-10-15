//
//  GNGScrollingNode.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 10/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GNGScrollingNode : SKNode
@property (nonatomic) CGFloat horizontalScrollSpeed; // Distance to scroll per second.
@property (nonatomic) BOOL scrolling;

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed;

@end
