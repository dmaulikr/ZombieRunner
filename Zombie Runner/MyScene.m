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
#import "Ammo.h"
#import "GiantZombie.h"
#import "SmartZombie.h"
#import "ShooterZombie.h"

typedef NS_OPTIONS(uint32_t, CollisionCategory)
{
    CollisionCategoryPlayer = 0x1 << 0,
    CollisionCategoryBullet = 0x1 << 1,
    CollisionCategoryZombie = 0x1 << 2,
    CollisionCategoryAmmo = 0x1 << 3
};

@interface MyScene() <SKPhysicsContactDelegate>

@property (strong, nonatomic) JoystickItem *stick;
@property (strong, nonatomic) Player *player;
@property (strong, nonatomic) NSMutableArray *zombies;
@property (strong, nonatomic) NSMutableArray *ammoBoxes;
@property (strong, nonatomic) Bullet *bullet;
@property (strong, nonatomic) Bullet *zomBullet;
@property (strong, nonatomic) NSTimer *zombieSpawnTimer;
@property (strong, nonatomic) NSTimer *giantZombieSpawnTimer;
@property (strong, nonatomic) NSTimer *smartZombieSpawnTimer;
@property (strong, nonatomic) NSTimer *zombieVelocityTimer;
@property (strong, nonatomic) NSTimer *shooterZombieTimer;
@property (strong, nonatomic) ShooterZombie *shooter;
@property (strong, nonatomic) Bullet *shooterBullet;
@property (strong, nonatomic) NSTimer *ammoTimer;
@property (nonatomic) CFTimeInterval touchTime;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) BOOL playerIsAlive;
@property (nonatomic) BOOL shooterIsDead;
@property (nonatomic) NSInteger ammoCount;
@property (nonatomic) NSUInteger score;
@property (strong, nonatomic) SKLabelNode *ammoLabel;
@property (strong, nonatomic) SKLabelNode *scoreLabel;
@property (nonatomic) BOOL gameInProgress;

@end


@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.backgroundColor = [SKColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
        self.physicsWorld.contactDelegate = self;
        
        _stick = [[JoystickItem alloc] initJoystickItemForParent:self];
        
        _zombieSpawnTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0 target: self selector: @selector(addZombie) userInfo: nil repeats: YES];
        _smartZombieSpawnTimer = [NSTimer scheduledTimerWithTimeInterval: 13.0 target: self selector: @selector(addSmartZombie) userInfo: nil repeats: YES];
        _giantZombieSpawnTimer = [NSTimer scheduledTimerWithTimeInterval: 9.0 target: self selector: @selector(addGiantZombie) userInfo: nil repeats: YES];
        _shooterZombieTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(updateShooter) userInfo:nil repeats:YES];
        _zombieVelocityTimer = [NSTimer scheduledTimerWithTimeInterval: 0.3 target: self selector: @selector(updateZombieVelocity) userInfo: nil repeats: YES];
        _ammoTimer = [NSTimer scheduledTimerWithTimeInterval: 10 target: self selector: @selector(updateAmmo) userInfo: nil repeats: YES];
        
        _ammoLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        _ammoLabel.fontSize = 18;
        _ammoLabel.fontColor = [UIColor blackColor];
        _ammoLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 40);
        [self addChild:_ammoLabel];
        
        _scoreLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        _scoreLabel.fontSize = 18;
        _scoreLabel.fontColor = [UIColor blackColor];
        _scoreLabel.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height - 60);
        [self addChild:_scoreLabel];
        
        _gameInProgress = false;
    }
    return self;
}

-(void) didBeginContact:(SKPhysicsContact *)contact
{
    if ((contact.bodyA.node == _player) || (contact.bodyB.node == _player))
    {
        SKNode *contactNode = (contact.bodyA.node != _player) ? contact.bodyA.node : contact.bodyB.node;
        if ([contactNode isKindOfClass:[Zombie class]] || contactNode == _shooterBullet)
        {
            [_shooterBullet removeFromParent];
            _shooterBullet = nil;
            [self endGame];
        }
        else if ([contactNode isKindOfClass:[Ammo class]])
        {
            [_ammoBoxes removeObject:(Ammo*)contactNode];
            [contactNode removeFromParent];
            _ammoCount += 8;
            [self updateAmmoLabelText];
        }
    }
    else if ((contact.bodyA.node == _shooterBullet) || (contact.bodyB.node == _shooterBullet))
    {
        SKNode *contactNode = (contact.bodyA.node != _shooterBullet) ? contact.bodyA.node : contact.bodyB.node;
        if ([contactNode isKindOfClass:[Zombie class]])
        {
            Zombie *newZombie = [[Zombie alloc] initZombieForParent:self atPoint:_shooterBullet.position];
            [_zombies addObject:newZombie];
            [_shooterBullet removeFromParent];
            _shooterBullet = nil;
        }
        else if ([contactNode isKindOfClass:[Ammo class]])
        {
            [_ammoBoxes removeObject:(Ammo*)contactNode];
            [contactNode removeFromParent];
            [_shooterBullet removeFromParent];
            _shooterBullet = nil;
        }
        else if ([contactNode isKindOfClass:[Bullet class]])
        {
            [_shooterBullet removeFromParent];
            _shooterBullet = nil;
            [_bullet removeFromParent];
            _bullet = nil;
        }
        else
        {
            [_shooterBullet removeFromParent];
            _shooterBullet = nil;
        }
    }
    else if ((contact.bodyA.node == _bullet) || (contact.bodyB.node == _bullet))
    {
        SKNode *contactNode = (contact.bodyA.node != _bullet) ? contact.bodyA.node : contact.bodyB.node;
        if ([contactNode isKindOfClass:[Zombie class]])
        {
            Zombie *zombie = (Zombie*)contactNode;
            zombie.health -= 20;
            [_bullet removeFromParent];
            _bullet = nil;
            
            if (zombie.health <= 0)
            {
                if ([contactNode isKindOfClass:[GiantZombie class]])
                {
                    NSMutableArray *newZoms = [(GiantZombie*)contactNode spawnBabyZombiesInScene:self];
                
                    _score += 5;
                    for (Zombie *zombie in newZoms)
                    {
                        [_zombies addObject:zombie];
                    }
                
                }
                [_zombies removeObject:contactNode];
                [contactNode removeFromParent];
                _score += 5;
                [self updateScoreLabelText];
            }
        }
        else if ([contactNode isKindOfClass:[Ammo class]])
        {
            [_ammoBoxes removeObject:(Ammo*)contactNode];
            [contactNode removeFromParent];
            [self updateAmmoLabelText];
            [_bullet removeFromParent];
            _bullet = nil;
            _score -= 2;
            [self updateScoreLabelText];
        }
        else
        {
            [_bullet removeFromParent];
            _bullet = nil;
        }
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
            if (_gameInProgress)
            {
                _startPoint = location;
                _touchTime = CACurrentMediaTime();
            }
            else
            {
                _gameInProgress = true;
                [self resetGame];
            }
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
                if (diffLength > 4.0f && _ammoCount > 0)
                {
                    _bullet = [[Bullet alloc] initBulletForParent:self atEntity:_player withVelocity:velocity];
                    _ammoCount--;
                    [self updateAmmoLabelText];
                }
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime
{
  
}

-(void)resetGame
{
    for (SKNode *child in self.children)
    {
        if (![child isKindOfClass:[JoystickItem class]] && ![child isKindOfClass:[SKLabelNode class]])
        {
            [child removeFromParent];
        }
    }
    
    _bullet = nil;
    _shooter = nil;
    _shooterBullet = nil;
    
    _playerIsAlive = true;
    _shooterIsDead = false;
    
    _zombies = [[NSMutableArray alloc] init];
    _ammoBoxes = [[NSMutableArray alloc] init];
    
    _player = [[Player alloc] initPlayerForParent:self];
    
    [self addZombies:20];
    
    _score = 0;
    _ammoCount = 16;
    
    [self updateAmmoLabelText];
    [self updateScoreLabelText];
}

-(void)endGame
{
    _gameInProgress = false;
    _playerIsAlive = false;
    
    NSString *message = [NSString stringWithFormat:@"You've been caught by zombies!\nYour score is %lu.", (unsigned long)_score];
    UIAlertView *deathAlert = [[UIAlertView alloc] initWithTitle:@"DEAD!" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [deathAlert show];
        
    for (Zombie *zombie in _zombies)
    {
            zombie.physicsBody.velocity = CGVectorMake(0, 0);
    }
    
    _player.physicsBody.velocity = CGVectorMake(0, 0);
    
    _bullet.physicsBody.velocity = CGVectorMake(0, 0);
    
    [_stick released];
}

-(void)updateAmmoLabelText
{
    if (_ammoCount > 0)
    {
        _ammoLabel.text = [NSString stringWithFormat:@"Ammo: %2.0ld", (long)_ammoCount];
    }
    else
    {
        _ammoLabel.text = @"Ammo:  0";
    }
}

-(void)updateScoreLabelText
{
    if (_score > 0)
    {
        _scoreLabel.text = [NSString stringWithFormat:@"Score: %4.0lu", (unsigned long)_score];
    }
    else
    {
        _scoreLabel.text = @"Score:    0";
    }
}

-(void)addZombie
{
    if (_playerIsAlive)
    {
        Zombie *zombie = [[Zombie alloc] initZombieForParent:self andAvoidPlayer:_player];
        [_zombies addObject:zombie];
        _score++;
        [self updateScoreLabelText];
    }
}

-(void)addSmartZombie
{
    if (_playerIsAlive)
    {
        SmartZombie *zombie = [[SmartZombie alloc] initSmartZombieForParent:self andAvoidPlayer:_player];
        [_zombies addObject:zombie];
        _score++;
        [self updateScoreLabelText];
    }
}

-(void)addGiantZombie
{
    if (_playerIsAlive)
    {
        GiantZombie *zombie = [[GiantZombie alloc] initGiantZombieForParent:self andAvoidPlayer:_player];
        [_zombies addObject:zombie];
        _score++;
        [self updateScoreLabelText];
    }
}

-(void)updateShooter
{
    if (_playerIsAlive)
    {
        static int loop = 0;
    
        if (loop % 4 == 0)
        {
            if (_shooter == nil && _shooterIsDead)
            {
                [self addShooterZombie];
                _shooterIsDead = false;
            }
            else if (_shooter == nil && !_shooterIsDead)
            {
                _shooterIsDead = true;
            }
        }
        _shooterBullet = [_shooter shootPlayer:_player];
        loop++;
    }
}

-(void)addShooterZombie
{
    if (_playerIsAlive)
    {
        _shooter = [[ShooterZombie alloc] initShooterZombieForParent:self andAvoidPlayer:_player];
        [_zombies addObject:_shooter];
        _score++;
        [self updateScoreLabelText];
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

-(void)updateAmmo
{
    if (_playerIsAlive)
    {
        if ([_ammoBoxes count] == 3)
        {
            [[_ammoBoxes firstObject] removeFromParent];
            [_ammoBoxes removeObjectAtIndex:0];
        }
        Ammo *ammo = [[Ammo alloc] initAmmoForParent:self];
        [_ammoBoxes addObject:ammo];
    }
    
}

@end
