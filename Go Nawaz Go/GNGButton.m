//
//  GNGButton.m
//  Tappy Nawaz
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGButton.h"
#import <objc/message.h>

@interface GNGButton()
@property (nonatomic) CGRect fullSizeFrame;
@property (nonatomic) BOOL pressed;
@end

@implementation GNGButton

+(instancetype)spriteNodeWithTexture:(SKTexture *)texture
{
    GNGButton *instance = [super spriteNodeWithTexture:texture];
    instance.pressedScale = 0.9;
    instance.userInteractionEnabled = YES;
    return instance;
}

-(void)setPressedTarget:(id)pressedTarget withAction:(SEL)pressedAction
{
    _pressedTarget = pressedTarget;
    _pressedAction = pressedAction;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.fullSizeFrame = self.frame;
    [self touchesMoved:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (self.pressed != CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            self.pressed = !self.pressed;
            if (self.pressed) {
                [self setScale:self.pressedScale];
                [self.pressedSound play];
            } else {
                [self setScale:1.0];
            }
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    self.pressed = NO;
    for (UITouch *touch in touches) {
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            // Pressed button.
            
            objc_msgSend(self.pressedTarget, self.pressedAction);
        }
    }
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
    self.pressed = NO;
}

@end
