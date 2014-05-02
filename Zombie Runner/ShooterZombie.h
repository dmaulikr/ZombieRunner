//
//  ShooterZombie.h
//  Zombie Runner
//
//  Created by Corey Matzat on 5/2/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Zombie.h"
#import "Bullet.h"
#import "Player.h"

@interface ShooterZombie : Zombie

-(instancetype)initShooterZombieForParent:(SKScene*)parent andAvoidPlayer:(Player*)player;
-(Bullet*)shootPlayer:(Player*)player;

@end
