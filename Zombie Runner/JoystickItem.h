//
//  JoystickItem.h
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JoystickItem : SKSpriteNode

@property (weak, nonatomic) UITouch *touch;

-(instancetype)initJoystickItemForParent:(SKScene*)parent;
-(CGVector)updateJoystick;
-(void)released;

@end
