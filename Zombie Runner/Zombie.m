//
//  Zombie.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

-(instancetype)initZombieForParent:(SKScene*)parent
{
    //self = [super initWithColor:[UIColor colorWithRed:0.1 green:.7 blue:0.1 alpha:1] size:CGSizeMake(12, 12)];
    
    self = [super initWithImageNamed:@"zombie.png"];
    
    self.position = [self randomPointWithinContainerSize:parent.size forViewSize:self.size];
    self.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:6];
    self.physicsBody.affectedByGravity = false;
    self.physicsBody.allowsRotation = false;
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

