//
//  Ammo.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/27/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Ammo.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
    CollisionCategoryAmmo = 0x1 << 3
};

@implementation Ammo

-(instancetype)initAmmoForParent:(SKScene *)parent
{
    self = [super initWithColor:[UIColor blueColor] size:CGSizeMake(16, 16)];
    
    self.position = [self randomPointWithinContainerSize:parent.size forViewSize:self.size];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.allowsRotation = false;
    self.physicsBody.categoryBitMask = CollisionCategoryAmmo;
    self.physicsBody.dynamic = false;
    
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

@end
