//
//  Joystick.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Joystick.h"


@implementation Joystick

-(instancetype)initJoystickForParent:(SKSpriteNode *)parent
{
    self = [super initWithImageNamed:@"joystick.png"];
    
    self.position = CGPointMake(0, 0);
    
    [parent addChild:self];
    
    return self;
}



@end
