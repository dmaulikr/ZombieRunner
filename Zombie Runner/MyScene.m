//  MyScene.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "MyScene.h"
#import "Zombie.h"
#import "Player.h"
#import "JoystickItem.h"
#import "Joystick.h"

@interface MyScene()

@property (strong, nonatomic) JoystickItem *stick;
@property (weak, nonatomic) UITouch *joystickTouch;

@end


@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        
        [self resetGame];
        
        _stick = [[JoystickItem alloc] initJoystickItemForParent:self];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        if ([[self nodeAtPoint:location] isKindOfClass:[Joystick class]])
        {
            _joystickTouch = touch;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
    {
        if ([touch isEqual:_joystickTouch])
        {
            [_stick updatePositionForTouch:touch];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        if ([touch isEqual:_joystickTouch])
        {
            [_stick released];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

-(void)resetGame
{
    for (SKNode *child in self.children)
    {
        [child removeFromParent];
    }
    
    [[Zombie alloc] initZombieForParent:self];
    [[Zombie alloc] initZombieForParent:self];
    [[Zombie alloc] initZombieForParent:self];
    
    [[Player alloc] initPlayerForParent:self];
}

@end
