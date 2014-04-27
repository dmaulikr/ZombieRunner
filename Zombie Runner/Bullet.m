//
//  Bullet.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/26/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Bullet.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
};

@implementation Bullet

-(instancetype)initBulletForParent:(SKScene*)parent atPlayer:(Player*)player withVelocity:(CGVector)velocity
{
    self = [super initWithColor:[UIColor redColor] size:CGSizeMake(6, 6)];
    
    int adjX = 6;
    int adjY = 6;
    
    if (velocity.dx < 0)
    {
        adjX *= -1;
    }
    
    if (velocity.dy < 0)
    {
        adjY *= -1;
    }
    
    self.position = CGPointMake(player.position.x + adjX, player.position.y + adjY);
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.allowsRotation = false;
    self.physicsBody.linearDamping = 0;
    self.physicsBody.velocity = velocity;
    [parent addChild:self];
    
    return self;
}

-(float)distanceFromPoint:(CGPoint)point1 toPoint:(CGPoint)point2
{
    return sqrtf((point1.x - point2.x)*(point1.x - point2.x) + (point1.y + point2.y)*(point1.y + point2.y));
}

-(Zombie*)checkForKill:(NSMutableArray *)zombies
{
    Zombie *zombie = nil;
    
    for (Zombie *testZombie in zombies)
    {
        if ([self distanceFromPoint:testZombie.position toPoint:self.position] <= 9)
        {
            return testZombie;
        }
    }
    
    return zombie;
}

-(BOOL)checkForDespawn:(SKScene *)scene
{
    if (self.position.x < 10 || self.position.y < 10 || self.position.x > (scene.size.width - 10) || self.position.y > (scene.size.height - 10))
    {
        return true;
    }
    
    return false;
}



@end
