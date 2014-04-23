//
//  JoystickItem.h
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface JoystickItem : SKSpriteNode

-(instancetype)initJoystickItemForParent:(SKScene*)parent;

-(void)updatePositionForTouch:(UITouch*)touch;

-(void)released;

@end
