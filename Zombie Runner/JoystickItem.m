//
//  JoystickItem.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "JoystickItem.h"
#import "Joystick.h"

@interface JoystickItem()

@property (strong, nonatomic) Joystick *joystick;

@end

@implementation JoystickItem

-(instancetype)initJoystickItemForParent:(SKScene *)parent
{
    self = [super initWithImageNamed:@"joystickbg.png"];
    
    self.position = CGPointMake(120, 120);
    
    _joystick = [[Joystick alloc] initJoystickForParent:self];
    
    [parent addChild:self];
    
    return self;
}

-(void)updatePositionForTouch:(UITouch*)touch
{
    CGPoint location = [touch locationInNode:self.parent];
    
    float diffX = location.x - self.position.x;
    float diffY = location.y - self.position.y;
    
    float dist = sqrtf(diffX * diffX + diffY * diffY);
    
    float posX = diffX * 24 / dist;
    float posY = diffY * 24 / dist;
    
    _joystick.position = CGPointMake(posX, posY);
}

-(void)released
{
    _joystick.position = CGPointMake(0, 0);
}



@end