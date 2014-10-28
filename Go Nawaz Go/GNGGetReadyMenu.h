//
//  GNGGetReadyMenu.h
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 28/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GNGGetReadyMenu : SKNode

@property (nonatomic) CGSize size;
-(instancetype)initWithSize:(CGSize)size andPlanePosition:(CGPoint)planePosition;
-(void)show;
-(void)hide;


@end
