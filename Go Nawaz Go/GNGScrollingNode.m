//
//  GNGScrollingNode.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 10/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGScrollingNode.h"

@implementation GNGScrollingNode

- (void)updateWithTimeElpased:(NSTimeInterval)timeElapsed
{
    if (self.scrolling) {
        self.position = CGPointMake(self.position.x + (self.horizontalScrollSpeed * timeElapsed), self.position.y);
    }
    
}

@end
