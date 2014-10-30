//
//  GNGCollectable.h
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 25/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SoundManager.h"

@class GNGCollectable;

@protocol GNGCollectableDelegate <NSObject>

-(void)wasCollected:(GNGCollectable*)collectable;

@end

@interface GNGCollectable : SKSpriteNode

@property (nonatomic) Sound *collectionSound;
@property (nonatomic, weak) id<GNGCollectableDelegate> delegate;
@property (nonatomic) NSInteger pointValue;

-(void)collect;

@end
