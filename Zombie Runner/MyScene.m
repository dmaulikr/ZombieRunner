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
#import "Bullet.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
};

@interface MyScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) JoystickItem *stick;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSMutableArray *zombies;
@property (strong, nonatomic) Bullet *bullet;
@property (strong, nonatomic) NSTimer *zombieSpawnTimer;
@property (strong, nonatomic) NSTimer *zombieSpawnTimer2;
@property (strong, nonatomic) NSTimer *zombieVelocityTimer;
@property (nonatomic) CFTimeInterval touchTime;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) BOOL playerIsAlive;

@end


@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.physicsWorld.contactDelegate = self;
        
        //static const uint32_t zombieCategory     =  0x1 << 0;
        //static const uint32_t playerCategory     =  0x1 << 1;
        
        [self resetGame];
        
        _stick = [[JoystickItem alloc] initJoystickItemForParent:self];
        
        _zombieSpawnTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(addZombie) userInfo: nil repeats: YES];
        _zombieSpawnTimer2 = [NSTimer scheduledTimerWithTimeInterval: 9.0 target: self selector: @selector(addZombie) userInfo: nil repeats: YES];
        _zombieVelocityTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(updateZombieVelocity) userInfo: nil repeats: YES];

    }
    return self;
}

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    SKNode *zombie = (contact.bodyA.node != _bullet) ? contact.bodyA.node : contact.bodyB.node;
    if ([zombie isKindOfClass:[Zombie class]])
    {
        [_zombies removeObject:zombie];
        [zombie removeFromParent];
        [_bullet removeFromParent];
        _bullet = nil;
    }
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
        else
        {
            _startPoint = location;
            _touchTime = CACurrentMediaTime();
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
        else
        {
            if (CACurrentMediaTime() - _touchTime < 0.3 && !_bullet)
            {
                UITouch *touch = [touches anyObject];
                CGPoint location = [touch locationInNode:self];
                CGPoint diff = CGPointMake(location.x - _startPoint.x, location.y - _startPoint.y);
                float diffLength = sqrtf(diff.x*diff.x + diff.y*diff.y);
                CGVector velocity = CGVectorMake(diff.x*400/fabsf(diffLength), diff.y*400/fabsf(diffLength));
                if (diffLength > 4.0f)
                {
                    _bullet = [[Bullet alloc] initBulletForParent:self atPlayer:_player withVelocity:velocity];
                    _bullet.physicsBody.usesPreciseCollisionDetection = YES;
                    _bullet.physicsBody.categoryBitMask = CollisionCategoryBullet;
                    _bullet.physicsBody.contactTestBitMask = CollisionCategoryZombie;
                }
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
    _playerIsAlive = ![_player checkContactedBodiesForDeath];
    
    if ([_bullet checkForDespawn:self])
    {
        [_bullet removeFromParent];
        _bullet = nil;
    }
    /*Zombie *zombie = [_bullet checkForKill:_zombies];
    if (zombie)
    {
        [_zombies removeObject:zombie];
        [zombie removeFromParent];
        [_bullet removeFromParent];
        _bullet = nil;
    }*/
    
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
    
    _bullet = nil;
    
    _playerIsAlive = true;
    
    _zombies = [[NSMutableArray alloc] init];
    
    _player = [[Player alloc] initPlayerForParent:self];
    
    [self addZombies:20];
}

-(void)addZombie
{
    if (_playerIsAlive)
    {
        Zombie *zombie = [[Zombie alloc] initZombieForParent:self];
        zombie.physicsBody.categoryBitMask = CollisionCategoryZombie;
        [_zombies addObject:zombie];
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
