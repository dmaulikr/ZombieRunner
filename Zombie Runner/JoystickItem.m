//
//  JoystickItem.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "JoystickItem.h"
#import "Joystick.h"

#define RADIUS 24

@interface JoystickItem()

@property (strong, nonatomic) Joystick *joystick;

@end

@implementation JoystickItem

@synthesize touch = _touch;

-(instancetype)initJoystickItemForParent:(SKScene *)parent
{
    self = [super initWithImageNamed:@"joystickbg.png"];
    
    self.position = CGPointMake(120, 120);
    
    _joystick = [[Joystick alloc] initJoystickForParent:self];
    
    [parent addChild:self];
    
    return self;
}

-(CGVector)updateJoystick
{
    CGPoint location = [_touch locationInNode:self.parent];
    
    float diffX = location.x - self.position.x;
    float diffY = location.y - self.position.y;
    
    float dist = sqrtf(diffX * diffX + diffY * diffY);
    
    if (dist == 0)
    {
        dist = 1;
    }
    
    float facX = diffX / dist;
    float facY = diffY / dist;
    
    _joystick.position = CGPointMake(facX * 24, facY * 24);
    
    return CGVectorMake(facX, facY);
}

-(void)released
{
    _joystick.position = CGPointMake(0, 0);
    _touch = nil;
}



@end