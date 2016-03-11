//
//  GravityViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/10/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "GravityViewController.h"
#define MAX_DENSITY 9999999
#define FREE        0
#define OBSTACLES   1


@interface GravityViewController ()

@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehaviour;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (nonatomic) CGRect squarePosition;


@end


@implementation GravityViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Gravity"];
}


#pragma mark - Dynamics

- (void)createItems {
    
    // Red Square with tap gesture
    CGRect localBounds = self.view.bounds;
    CGFloat side = 100;
    self.squarePosition = CGRectMake(10, 10, side, side);
    UIView *redSquare = [[UIView alloc] initWithFrame:self.squarePosition];
    [redSquare setBackgroundColor:[UIColor redColor]];
    [redSquare addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onItemTap)]];
    [self.items addObject:redSquare];
    
    for (UIView *view in self.items) {
        [self.view addSubview:view];
    }
}

- (void)createBehaviours {
    
    // Gravity
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.items];
    [self.behaviours addObject:self.gravityBehavior];
    
    // Collisions
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.items];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.behaviours addObject:self.collisionBehavior];
    
    // Dynamic Items (properties)
    self.dynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:self.obstacles];
    self.dynamicItemBehaviour.density = MAX_DENSITY;
    [self.behaviours addObject:self.dynamicItemBehaviour];
}

- (void)toggleObstacles:(BOOL)toggleValue {
    
    for (UIView *view in self.obstacles) {
        if (toggleValue)
            [self.collisionBehavior removeItem:view];
        else
            [self.collisionBehavior addItem:view];
    }
}


#pragma mark - Callbacks

- (IBAction)onValueChanged:(id)sender {
    
    UISegmentedControl *control = (UISegmentedControl*)sender;
    // Restore position
    UIView *square = self.items[0];
    square.frame = self.squarePosition;
    
    // Show/hide obstacles
    for (UIView *view in self.obstacles) {
        
        [view setHidden:(control.selectedSegmentIndex == FREE)];
        [self toggleObstacles:(control.selectedSegmentIndex == FREE)];
    }
    
    // Remove Behaviours
    [self.animator removeAllBehaviors];
    
}

- (void)onItemTap {
    
    for (UIDynamicBehavior *behaviour in self.behaviours) {
        [self.animator addBehavior:behaviour];
    }
}

@end
