//
//  Bullet.h
//  Zombie Runner
//
//  Created by Corey Matzat on 4/26/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Player.h"
#import "Zombie.h"

@interface Bullet : SKSpriteNode

-(instancetype)initBulletForParent:(SKScene*)parent atEntity:(SKSpriteNode*)entity withVelocity:(CGVector)velocity;

@end
