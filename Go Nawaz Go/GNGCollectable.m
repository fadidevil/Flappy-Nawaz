//
//  GNGCollectable.m
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 25/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGCollectable.h"

@implementation GNGCollectable

-(void)collect
{
    [self.collectionSound play];
    
    [self runAction:[SKAction removeFromParent]];
    if (self.delegate) {
        [self.delegate wasCollected:self];
    }
}

@end
