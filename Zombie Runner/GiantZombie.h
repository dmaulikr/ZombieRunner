//
//  GiantZombie.h
//  Zombie Runner
//
//  Created by Corey Matzat on 4/30/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Zombie.h"

@interface GiantZombie : Zombie

-(instancetype)initGiantZombieForParent:(SKScene*)parent andAvoidPlayer:(Player*)player;
-(void)updateVelocityTowardPlayer:(Player*)player;
-(NSMutableArray*)spawnBabyZombiesInScene:(SKScene*)scene;

@end
