//  MyScene.m
//  Zombie Runner
//
//  Created by Corey Matzat on 4/23/14.
//  Copyright (c) 2014 Corey Matzat. All rights reserved.
//

#import "MyScene.h"
#import "Zombie.h"
#import "Player.h"
#import "JoystickItem.h"
#import "Joystick.h"

@interface MyScene()

@property (strong, nonatomic) JoystickItem *stick;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSMutableArray *zombies;
@property (strong, nonatomic) NSTimer *zombieSpawnTimer;
@property (strong, nonatomic) NSTimer *zombieVelocityTimer;
@property (nonatomic) BOOL playerIsAlive;

@end


@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        
        
        [self resetGame];
        
        _stick = [[JoystickItem alloc] initJoystickItemForParent:self];
        
        _zombieSpawnTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(addZombie) userInfo: nil repeats: YES];
        _zombieVelocityTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(updateZombieVelocity) userInfo: nil repeats: YES];

    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    /* Called when a touch begins */
    
    for (UITouch *touch in touches)
    {
        CGPoint location = [touch locationInNode:self];
        
        if ([[self nodeAtPoint:location] isKindOfClass:[Joystick class]])
        {
            _stick.touch = touch;
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches)
    {
        if ([touch isEqual:_stick.touch])
        {
            [_player updateVelocity:[_stick updateJoystick]];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches)
    {
        if ([touch isEqual:_stick.touch])
        {
            [_stick released];
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    _playerIsAlive = ![_player checkContactedBodiesForDeath];
    
    if (!_playerIsAlive)
    {
        [self resetGame];
    }
}

-(void)resetGame
{
    for (SKNode *child in self.children)
    {
        if (![child isKindOfClass:[JoystickItem class]])
        {
            [child removeFromParent];
        }
    }
    
    _playerIsAlive = true;
    
    _zombies = [[NSMutableArray alloc] init];
    
    _player = [[Player alloc] initPlayerForParent:self];
    
    [self addZombies:10];
    
    
    //[NSTimer scheduledTimerWithTimeInterval: 6.0 target: self selector: @selector(addItem) userInfo: nil repeats: YES];
    
}

-(void)addZombie
{
    if (_playerIsAlive)
    {
        [_zombies addObject:[[Zombie alloc] initZombieForParent:self]];
    }
}

-(void)addZombies:(NSUInteger)num
{
    for (int i = 0; i < num; i++)
    {
        [self addZombie];
    }
}

-(void)updateZombieVelocity
{
    if (_playerIsAlive)
    {
        for (Zombie *zombie in _zombies)
        {
            [zombie updateVelocityTowardPlayer:_player];
        }
    }
}

@end
