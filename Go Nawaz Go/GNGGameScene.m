//
//  GNGGameScene.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 30/09/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGGameScene.h"
#import "GNGNawaz.h"
#import "GNGScrollingLayer.h"
#import "GNGConstants.h"
#import "GNGObstacleLayer.h"
#import "GNGBitmapFontLabel.h"
#import "GNGTilesetTextureProvider.h"
#import "GNGButton.h"
#import "GNGGameOverMenu.h"

@interface GNGGameScene()

@property (nonatomic) GNGNawaz *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) GNGScrollingLayer *background;
@property (nonatomic) GNGObstacleLayer *obstacles;
@property (nonatomic) GNGScrollingLayer *foreground;
@property (nonatomic) GNGBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) GNGGameOverMenu *gameOverMenu;


@end
static const CGFloat kMinFPS = 10.0 / 60.0;

@implementation GNGGameScene


- (id) initWithSize:(CGSize)size
{
//    Get Atlas File
    
    if (self = [super initWithSize:size]) {
        
        //    background color
        self.backgroundColor = [SKColor colorWithRed:0.835294118 green:0.929411765 blue:0.968627451 alpha:1.0];

        
        SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
        
        self.physicsWorld.gravity = CGVectorMake(0.0, -4.0);
        self.physicsWorld.contactDelegate = self;
        
       
        //World
        _world = [SKNode node];
        [self addChild:_world];
        
//        Setup BackGround
        NSMutableArray *backgroundTiles = [[NSMutableArray alloc] init];
        for (int i = 0; i < 3; i++) {
            [backgroundTiles addObject:[SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"background"]]];
        }
        
        _background = [[GNGScrollingLayer alloc] initWithTiles:backgroundTiles];
    _background.horizontalScrollSpeed = -60;
        _background.scrolling = YES;
        [_world addChild:_background];
        
    
        
        // Setup obstacle layer.
        _obstacles = [[GNGObstacleLayer alloc] init];
        _obstacles.collectableDelegate = self;
        _obstacles.horizontalScrollSpeed = -80;
        _obstacles.scrolling = YES;
        _obstacles.floor = 0.0;
        _obstacles.ceiling = self.size.height;
        [_world addChild:_obstacles];
        
        // Setup foreground.
        _foreground = [[GNGScrollingLayer alloc] initWithTiles:@[[self generateGroundTile],
                                                                [self generateGroundTile],
                                                                [self generateGroundTile]]];
       
        _foreground.horizontalScrollSpeed = -80;
        _foreground.scrolling = YES;
        [_world addChild:_foreground];
        
        //player
        _player = [[GNGNawaz alloc] init];
        _player.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        _player.physicsBody.affectedByGravity = NO;
    [_world addChild:_player];
        
        // Setup score label.
        _scoreLabel = [[GNGBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 100);
        [self addChild:_scoreLabel];
        
        // Setup game over menu.
        _gameOverMenu = [[GNGGameOverMenu alloc] initWithSize:size];
        [self addChild:_gameOverMenu];

        
        
        // Start a new game.
        [self newGame];

        
    }
                return self;
        
}



-(SKSpriteNode*)generateGroundTile
{
    SKTextureAtlas *graphics = [SKTextureAtlas atlasNamed:@"Graphics"];
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithTexture:[graphics textureNamed:@"groundGrass"]];
    sprite.anchorPoint = CGPointZero;
    
    CGFloat offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
    CGFloat offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 403 - offsetX, 16 - offsetY);
    CGPathAddLineToPoint(path, NULL, 383 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 371 - offsetX, 34 - offsetY);
    CGPathAddLineToPoint(path, NULL, 328 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 319 - offsetX, 23 - offsetY);
    CGPathAddLineToPoint(path, NULL, 299 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 286 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 266 - offsetX, 7 - offsetY);
    CGPathAddLineToPoint(path, NULL, 254 - offsetX, 12 - offsetY);
    CGPathAddLineToPoint(path, NULL, 235 - offsetX, 12 - offsetY);
    CGPathAddLineToPoint(path, NULL, 219 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 186 - offsetX, 28 - offsetY);
    CGPathAddLineToPoint(path, NULL, 174 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 154 - offsetX, 21 - offsetY);
    CGPathAddLineToPoint(path, NULL, 124 - offsetX, 32 - offsetY);
    CGPathAddLineToPoint(path, NULL, 79 - offsetX, 30 - offsetY);
    CGPathAddLineToPoint(path, NULL, 67 - offsetX, 18 - offsetY);
    CGPathAddLineToPoint(path, NULL, 44 - offsetX, 12 - offsetY);
    CGPathAddLineToPoint(path, NULL, 20 - offsetX, 13 - offsetY);
    CGPathAddLineToPoint(path, NULL, 17 - offsetX, 17 - offsetY);
    CGPathAddLineToPoint(path, NULL, 0 - offsetX, 16 - offsetY);
    
    
    
    sprite.physicsBody = [SKPhysicsBody bodyWithEdgeChainFromPath:path];
    sprite.physicsBody.categoryBitMask = kGNGCategoryGround;
    
    return sprite;
}

-(void)newGame
{
    // Randomize tileset.
    [[GNGTilesetTextureProvider getProvider] randomizeTileset];

    
//    ResetLayers
    self.foreground.position = CGPointZero;
    for (SKSpriteNode *node in self.foreground.children) {
        node.texture = [[GNGTilesetTextureProvider getProvider] getTextureForKey:@"ground"];
    }
    [self.foreground layoutTiles];
    self.obstacles.position = CGPointZero;
    [self.obstacles reset];
    self.obstacles.scrolling = NO;
    self.background.position = CGPointZero;
    [self.background layoutTiles];
    
    // Reset score.
    self.score = 0;
    
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];


}

-(void)wasCollected:(GNGCollectable *)collectable
{
    self.score += collectable.pointValue * 1;
}

-(void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

        if (self.player.crashed) {
            // Reset game.
            [self newGame];
        }
        else{
            
            
            _player.physicsBody.affectedByGravity = YES;
            self.player.accelerating = YES;
            self.obstacles.scrolling = YES;
        }
    }

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

    
        self.player.accelerating = NO;
    
}



- (void)didBeginContact:(SKPhysicsContact *)contact
{
    if (contact.bodyA.categoryBitMask == kGNGCategoryNawaz) {
        [self.player collide:contact.bodyB];
    }
    else if (contact.bodyB.categoryBitMask == kGNGCategoryNawaz) {
        [self.player collide:contact.bodyA];
    }
}

- (void) update:(NSTimeInterval)currentTime
{
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    [self.player update];
    if (!self.player.crashed) {
        [self.background updateWithTimeElpased:timeElapsed];
        [self.foreground updateWithTimeElpased:timeElapsed];
        [self.obstacles updateWithTimeElpased:timeElapsed];
    }
}

    @end
