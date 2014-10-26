//
//  GNGButton.m
//  Go Nawaz Go
//
//  Created by Fahad Mustafa on 26/10/2014.
//  Copyright (c) 2014 FahadMusafa. All rights reserved.
//

#import "GNGButton.h"
#import <objc/message.h>

@interface GNGButton()
@property (nonatomic) CGRect fullSizeFrame;
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
        if (CGRectContainsPoint(self.fullSizeFrame, [touch locationInNode:self.parent])) {
            [self setScale:self.pressedScale];
        } else {
            [self setScale:1.0];
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self setScale:1.0];
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
}

@end
