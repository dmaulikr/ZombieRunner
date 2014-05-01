//
//  SmartZombie.h
//  Zombie Runner
//
//  Created by Corey Matzat on 5/1/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Zombie.h"

@interface SmartZombie : Zombie

-(instancetype)initSmartZombieForParent:(SKScene*)parent andAvoidPlayer:(Player*)player;

@end
