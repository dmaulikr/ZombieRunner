//
//  Player.h
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Player : SKSpriteNode

-(instancetype)initPlayerForParent:(SKScene*)parent;
-(void)updateVelocity:(CGVector)velocity;
-(BOOL)checkContactedBodiesForDeath;


@end
