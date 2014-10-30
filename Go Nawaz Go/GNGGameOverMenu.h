//
//  GNGGameOverMenu.h
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum : NSUInteger {
    MedalNone,
    MedalBronze,
    MedalSilver,
    MedalGold,
} MedalType;
@protocol GNGGameOverMenuDelegate <NSObject>

-(void)pressedStartNewGameButton;

@end

@interface GNGGameOverMenu : SKNode

@property (nonatomic) CGSize size;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger bestScore;
@property (nonatomic) MedalType medal;
@property (nonatomic, weak) id<GNGGameOverMenuDelegate> delegate;


-(instancetype)initWithSize:(CGSize)size;

-(void)show;

@end
