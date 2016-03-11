//
//  MainViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/10/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@property (nonatomic, strong) UIFieldBehavior *fieldBehaviour;
@property (nonatomic, strong) UICollisionBehavior *collisionBehaviour;
@property (nonatomic, strong) UIPushBehavior *pushBehaviour;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Add Behaviours
    for (UIDynamicBehavior *behaviour in self.behaviours) {
        [self.animator addBehavior:behaviour];
    }
    [self configUIElements];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configUIElements {
    
    [self.view bringSubviewToFront:self.pushButton];
    
    self.pushButton.layer.borderWidth = 2;
    self.pushButton.layer.cornerRadius = self.pushButton.frame.size.width/2;
    self.pushButton.layer.borderColor = [self.pushButton.tintColor CGColor];
}

- (void)setConfLogoOnNavBar {
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 44, 25)];
    [imageView setContentMode:UIViewContentModeScaleAspectFit];
    [imageView setImage:[UIImage imageNamed:@"nsconf_logo"]];
    self.navigationItem.titleView = imageView;
}


#pragma mark - Dynamics

/**
 *  Create all behaviours to be added to the animator
 */
- (void)createBehaviours {
    
    // Field Behaviour
    self.fieldBehaviour = [UIFieldBehavior noiseFieldWithSmoothness:0.4 animationSpeed:0.2];
    self.fieldBehaviour.position = self.view.center;
    self.fieldBehaviour.region = [UIRegion infiniteRegion];
    self.fieldBehaviour.strength = 0.7;
    [self.behaviours addObject:self.fieldBehaviour];
    for (UIView *view in self.items) {
        [self.fieldBehaviour addItem:view];
    }
    
    // Collision Behaviour
    for (UIView *view in self.items) {
        UICollisionBehavior *behaviour = [[UICollisionBehavior alloc] initWithItems:@[view]];
        behaviour.translatesReferenceBoundsIntoBoundary = YES;
        [self.behaviours addObject:behaviour];
    }
//    self.collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:self.items];
//    self.collisionBehaviour.translatesReferenceBoundsIntoBoundary = YES;
//    [self.behaviours addObject:self.collisionBehaviour];

}

/**
 *  Add instantaneous push forces to each view item
 */
- (void)addPushBehaviours {
    
    for (UIView *view in self.items) {
        
        UIPushBehavior *push = [[UIPushBehavior alloc]initWithItems:@[view] mode:UIPushBehaviorModeInstantaneous];
        [push setAngle:(arc4random() % 90)];
        [push setMagnitude:2];
        [self.animator addBehavior:push];
    }
}

/**
 *  Create X new items at random positions within bounds
 */
- (void)createItems {
    
    CGSize localSize = self.view.bounds.size;
    UIView *view = nil;
    UIImage *logoImage = [UIImage imageNamed:@"nsconf_logo"];
    CGFloat side = 50;
    CGRect imageFrame = CGRectMake(0, 0, side, side);
    int randomX = 0;
    int randomY = 0;

    for (int i= 0; i < 40; i++) {
        
        // Position
        randomX = side + arc4random() % (int)((localSize.width-side) - side);
        randomY = side + arc4random() % (int)((localSize.height-side) - side);
        
        // Init item
        view = [[UIView alloc] initWithFrame:CGRectMake(randomX, randomY, side, side)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];
        [imageView setImage:logoImage];
        [view addSubview:imageView];
        [self.view addSubview:view];
        [self.items addObject:view];
    }
}

- (IBAction)pushPressed:(id)sender {
    [self addPushBehaviours];
}

@end
