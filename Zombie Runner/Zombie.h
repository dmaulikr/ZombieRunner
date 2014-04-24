//
//  Zombie.h
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"

@interface Zombie : SKSpriteNode

-(instancetype)initZombieForParent:(SKScene*)parent;
-(void)updateVelocityTowardPlayer:(Player*)player;

@end
