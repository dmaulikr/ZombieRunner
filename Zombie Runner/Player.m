//
//  Player.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "Player.h"

@implementation Player

-(instancetype)initPlayerForParent:(SKScene *)parent
{
    self = [super initWithColor:[UIColor blackColor] size:CGSizeMake(12, 12)];
    
    self.position = [self randomPointWithinContainerSize:parent.size forViewSize:self.size];
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
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
    
    NSLog(@"Point: %d, %d", randomX, randomY);
    
    return CGPointMake(randomX, randomY);
}

@end
