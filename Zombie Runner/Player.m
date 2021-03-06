//
//  Player.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Player.h"
#import "Zombie.h"

#define VELOCITY 120

@implementation Player

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
    CollisionCategoryAmmo = 0x1 << 3
};

-(instancetype)initPlayerForParent:(SKScene *)parent
{
    self = [super initWithImageNamed:@"player.png"];
    
    self.position = [self randomPointWithinContainerSize:parent.size forViewSize:self.size];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:6];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.allowsRotation = false;
    self.physicsBody.categoryBitMask = CollisionCategoryPlayer;
    self.physicsBody.contactTestBitMask = CollisionCategoryZombie | CollisionCategoryAmmo;
    self.physicsBody.usesPreciseCollisionDetection = YES;
    self.physicsBody.linearDamping = 0;
    
    
    
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

-(void)updateVelocity:(CGVector)velocity
{
    self.physicsBody.velocity = CGVectorMake(velocity.dx * VELOCITY, velocity.dy * VELOCITY);
}

-(BOOL)checkContactedBodiesForDeath
{
    for (SKPhysicsBody *body in [self.physicsBody allContactedBodies])
    {
        if ([body.node isKindOfClass:[Zombie class]])
        {
            return true;
        }
    }
    
    return false;
}

@end
