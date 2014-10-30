//
//  GNGGameScene.m
//  Tappy Nawaz
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
#import "GNGGetReadyMenu.h"
#import "GNGWeatherLayer.h"
#include "SoundManager.h"


typedef enum : NSUInteger {
    GameReady,
    GameRunning,
    GameOver,
} GameState;


@interface GNGGameScene()

@property (nonatomic) GNGNawaz *player;
@property (nonatomic) SKNode *world;
@property (nonatomic) GNGScrollingLayer *background;
@property (nonatomic) GNGObstacleLayer *obstacles;
@property (nonatomic) GNGScrollingLayer *foreground;
@property (nonatomic) GNGBitmapFontLabel *scoreLabel;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) GNGGameOverMenu *gameOverMenu;
@property (nonatomic) GNGGetReadyMenu *getReadyMenu;
@property (nonatomic) GameState gameState;
@property (nonatomic) GNGWeatherLayer *weather;


@end
static const CGFloat kMinFPS = 10.0 / 60.0;
static NSString *const kGNGKeyBestScore = @"BestScore";

@implementation GNGGameScene


- (id) initWithSize:(CGSize)size
{
//    Get Atlas File
    
    if (self = [super initWithSize:size]) {
        
//        Audio Crunch
        [[SoundManager sharedManager] prepareToPlayWithSound:@"Crunch.caf"];
        
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
        
        // Setup weather.
        _weather = [[GNGWeatherLayer alloc] initWithSize:self.size];
        [_world addChild:_weather];
        
        // Setup score label.
        _scoreLabel = [[GNGBitmapFontLabel alloc] initWithText:@"0" andFontName:@"number"];
        _scoreLabel.position = CGPointMake(self.size.width * 0.5, self.size.height - 50);
        [self addChild:_scoreLabel];
        
        // Load best score.
        self.bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:kGNGKeyBestScore];

        
        // Setup game over menu.
        
        _gameOverMenu = [[GNGGameOverMenu alloc] initWithSize:size];
        _gameOverMenu.delegate = self;
        
        // Setup get ready menu.
        _getReadyMenu = [[GNGGetReadyMenu alloc] initWithSize:size andPlanePosition:CGPointMake(self.size.width * 0.3, self.size.height * 0.5)];
        [self addChild:_getReadyMenu];

       
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

-(void)pressedStartNewGameButton
{
    SKSpriteNode *blackRectangle = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:self.size];
    blackRectangle.anchorPoint = CGPointZero;
    blackRectangle.alpha = 0.0;
    [self addChild:blackRectangle];
    SKAction *startNewGame = [SKAction runBlock:^{
        [self newGame];
        [self.gameOverMenu removeFromParent];
            [self.getReadyMenu show];
    }];
    SKAction *fadeTransition = [SKAction sequence:@[[SKAction fadeInWithDuration:0.4],
                                                    startNewGame,
                                                    [SKAction fadeOutWithDuration:0.6],
                                                    [SKAction removeFromParent]]];
    [blackRectangle runAction:fadeTransition];
}

-(void)newGame
{
    // Randomize tileset.
    [[GNGTilesetTextureProvider getProvider] randomizeTileset];

    // Set weather conditions.
    NSString *tilesetName = [GNGTilesetTextureProvider getProvider].currentTilesetName;
    self.weather.conditions = WeatherClear;
    if ([tilesetName isEqualToString:kGNGTilesetIce] || [tilesetName isEqualToString:kGNGTilesetSnow]) {
        // 1 in 2 chance for snow on snow and ice tilesets.
        if (arc4random_uniform(2) == 0) {
            self.weather.conditions = WeatherSnowing;
        }
    }
    if ([tilesetName isEqualToString:kGNGTilesetGrass] || [tilesetName isEqualToString:kGNGTilesetDirt]) {
        // 1 in 3 chance for rain on dirt and grass tilesets.
        if (arc4random_uniform(3) == 0) {
            self.weather.conditions = WeatherRaining;
        }
    }
    
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
    self.scoreLabel.alpha = 1.0;
    
    // Reset plane.
    self.player.position = CGPointMake(self.size.width * 0.3, self.size.height * 0.5);
    self.player.physicsBody.affectedByGravity = NO;
    [self.player reset];
    
    // Set game state to ready
    self.gameState = GameReady;



}

-(void)gameOver
{
//    Update Game State
    self.gameState = GameOver;
    
    // Fade out score display.
    [self.scoreLabel runAction:[SKAction fadeOutWithDuration:0.4]];
    
    // Properties on game over menu.
    self.gameOverMenu.score = self.score;
    self.gameOverMenu.medal = [self getMedalForCurrentScore];
//    Updating best Score
    if (self.score > self.bestScore) {
        self.bestScore = self.score;
        [[NSUserDefaults standardUserDefaults] setInteger:self.bestScore forKey:kGNGKeyBestScore];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    self.gameOverMenu.bestScore = self.bestScore;
//    show Game over menu
    [self addChild:self.gameOverMenu];
    [self.gameOverMenu show];
}

-(void)wasCollected:(GNGCollectable *)collectable
{
    self.score += collectable.pointValue;
}

-(void)setScore:(NSInteger)score
{
    _score = score;
    self.scoreLabel.text = [NSString stringWithFormat:@"%ld", (long)score];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
        if (self.gameState == GameReady) {
            [self.getReadyMenu hide];
        self.player.physicsBody.affectedByGravity = YES;
        self.obstacles.scrolling = YES;
        self.gameState = GameRunning;
    }
    if (self.gameState == GameRunning) {
        self.player.accelerating = YES;
    }
    
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.gameState == GameRunning) {
        self.player.accelerating = NO;
    }
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

-(void)bump
{
    SKAction *bump = [SKAction sequence:@[[SKAction moveBy:CGVectorMake(-5, -4) duration:0.1],
                                          [SKAction moveTo:CGPointZero duration:0.1]]];
    [self.world runAction:bump];
}

- (void) update:(NSTimeInterval)currentTime
{
    static NSTimeInterval lastCallTime;
    NSTimeInterval timeElapsed = currentTime - lastCallTime;
    if (timeElapsed > kMinFPS) {
        timeElapsed = kMinFPS;
    }
    lastCallTime = currentTime;
    
    if (self.gameState == GameRunning && self.player.crashed) {
        
        // Player just crashed in last frame so trigger game over.
        [self bump];
        [self gameOver];
    }
    
    [self.player update];
    if (self.gameState != GameOver) {
        [self.background updateWithTimeElpased:timeElapsed];
        [self.foreground updateWithTimeElpased:timeElapsed];
        [self.obstacles updateWithTimeElpased:timeElapsed];
    }
}
-(MedalType)getMedalForCurrentScore
{
    NSInteger adjustedScore = self.score - (self.bestScore / 5);
    if (adjustedScore >= 45) {
        return MedalGold;
    } else if (adjustedScore >= 25) {
        return MedalSilver;
    } else if (adjustedScore >= 10) {
        return MedalBronze;
    }
    return MedalNone;
}

    @end
