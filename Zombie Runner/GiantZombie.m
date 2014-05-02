//
//  GiantZombie.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/30/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "GiantZombie.h"

#define VELOCITY 50

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
    CollisionCategoryAmmo = 0x1 << 3
};

@implementation GiantZombie

-(instancetype)initGiantZombieForParent:(SKScene*)parent andAvoidPlayer:(Player *)player
{
    self = [super initWithImageNamed:@"giantzombie.png"];
    
    self.position = [self randomPointWithinContainerSize:parent.size forViewSize:self.size andAvoidPlayer:player];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:9];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.allowsRotation = false;
    self.health = 60;
    self.physicsBody.categoryBitMask = CollisionCategoryZombie;
    [self setRandomVelocity];
    [parent addChild:self];
    
    return self;
}

- (CGPoint) randomPointWithinContainerSize:(CGSize)containerSize forViewSize:(CGSize)size andAvoidPlayer:(Player*)player
{
    int randomX;
    int randomY;
    
    float dist = 0;
    
    do
    {
        CGFloat xRange = containerSize.width - size.width;
        CGFloat yRange = containerSize.height - size.height;
        
        CGFloat minX = (containerSize.width - xRange) / 2;
        CGFloat minY = (containerSize.height - yRange) / 2;
        
        randomX = (arc4random() % (int)floorf(xRange)) + minX;
        randomY = (arc4random() % (int)floorf(yRange)) + minY;
        
        float diffX = (randomX - player.position.x);
        float diffY = (randomY - player.position.y);
        
        dist = sqrtf(diffX*diffX+diffY*diffY);
    } while (dist < 150);
    
    return CGPointMake(randomX, randomY);
}

-(NSMutableArray*)spawnBabyZombiesInScene:(SKScene*)scene
{
    NSMutableArray *zoms = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (int i = 0; i < 3; i++)
    {
        CGPoint newLoc = CGPointMake(self.position.x + 1, self.position.y - 1 + i);
        Zombie *zombie = [[Zombie alloc] initZombieForParent:scene atPoint:newLoc];
        [zoms addObject:zombie];
    }
    
    return zoms;
}

-(void)updateVelocityTowardPlayer:(Player *)player
{
    float diffX = player.position.x - self.position.x;
    float diffY = player.position.y - self.position.y;
    
    float dist = sqrtf(diffX * diffX + diffY * diffY);
    
    if (dist == 0)
    {
        dist = 1;
    }
    
    float facX = 0;
    float facY = 0;
    
    if (dist < 500)
    {
        facX = 2 * diffX / dist;
        facY = 2 * diffY / dist;
    }
    else
    {
        float velX = self.physicsBody.velocity.dx != 0 ? self.physicsBody.velocity.dx : .000001;
        float velY = self.physicsBody.velocity.dy;
        float angle = atan(fabsf(velY/velX));
        float ranFac = ((rand()%19)/10 - .9);
        
        angle += ranFac;
        facX = cosf(angle);
        facY = sinf(angle);
        
        if (velX < 0)
            facX *= -1;
        
        if (velY < 0)
            facY *= -1;
        
        if (angle > M_1_PI/2)
            velX *= -1;
        else if (angle < 0)
            velY *= -1;
    }
    
    self.physicsBody.velocity = CGVectorMake(facX * VELOCITY, facY * VELOCITY);
}

-(void)setRandomVelocity
{
    float angle = arc4random() * M_2_PI;
    
    float facX = VELOCITY * cosf(angle);
    float facY = VELOCITY * sinf(angle);
    
    self.physicsBody.velocity = CGVectorMake(facX, facY);
}


@end
