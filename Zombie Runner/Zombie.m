//
//  Zombie.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Zombie.h"

#define VELOCITY 57

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
    CollisionCategoryAmmo = 0x1 << 3
};

@implementation Zombie

-(instancetype)initZombieForParent:(SKScene*)parent
{
    //self = [super initWithColor:[UIColor colorWithRed:0.1 green:.7 blue:0.1 alpha:1] size:CGSizeMake(12, 12)];
    
    self = [super initWithImageNamed:@"zombie.png"];
    
    self.position = [self randomPointWithinContainerSize:parent.size forViewSize:self.size];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:6];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.allowsRotation = false;
    self.physicsBody.categoryBitMask = CollisionCategoryZombie;
    [self setRandomVelocity];
    [parent addChild:self];
    
    return self;
}

- (CGPoint) randomPointWithinContainerSize:(CGSize)containerSize forViewSize:(CGSize)size
{
    CGFloat xRange = containerSize.width - size.width;
    CGFloat yRange = containerSize.height - size.height;
    
    CGFloat minX = (containerSize.width - xRange) / 2;
    CGFloat minY = (containerSize.height - yRange) / 2;
    
    int randomX = (arc4random() % (int)floorf(xRange)) + minX;
    int randomY = (arc4random() % (int)floorf(yRange)) + minY;
    
    return CGPointMake(randomX, randomY);
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
    
    if (dist < 150)
    {
        facX = 2 * diffX / dist;
        facY = 2 * diffY / dist;
    }
    else
    {
        float velX;
        if (self.physicsBody.velocity.dx != 0)
        {
            velX = self.physicsBody.velocity.dx;
        }
        else
        {
            velX = .000001;
        }
        float velY = self.physicsBody.velocity.dy;
        
        float angle = atan(fabsf(velY/velX));
        
        float ranFac = ((rand()%19)/10 - .9);
        
        angle += ranFac;
        
        facX = cosf(angle);
        facY = sinf(angle);
        
        if (velX < 0)
        {
            facX *= -1;
        }
        
        if (velY < 0)
        {
            facY *= -1;
        }
        
        if (angle > M_1_PI/2)
        {
            velX *= -1;
        }
        else if (angle < 0)
        {
            velY *= -1;
        }
        
        
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

