//
//  BaseContainerViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "MainViewController.h"
#import "BaseContainerViewController.h"
#define MENU_WIDTH      210
#define GESTURE_MARGIN  30


@interface BaseContainerViewController (){
    NSArray *menuSegues;
}

@property (weak, nonatomic) IBOutlet UIView *menuContainer;
@property (weak, nonatomic) IBOutlet UIView *mainContainer;
@property (weak, nonatomic) IBOutlet MainViewController *mainController;
@property (nonatomic, getter=isMenuOpen) BOOL menuOpen;

// Gesture Recognizers
@property (nonatomic, strong) UIScreenEdgePanGestureRecognizer  *leftScreenEdgeGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer            *panGestureRecognizer;

// Dynamics
@property (nonatomic, strong) UIGravityBehavior *gravityBehaviour;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;
@property (nonatomic, strong) UIAttachmentBehavior *panAttachmentBehaviour;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehaviour;

@end

@implementation BaseContainerViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        menuSegues = @[@"gravityControllerSegue", @"attachmentControllerSegue", @"snapControllerSegue", @"customBehaviour1Segue", @"customSlideSegue", @"CustomTransitionSegue"];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addGestureRecognizers];
    [self.navigationItem.backBarButtonItem setTitle:@""];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self addSideMenuBehaviours];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    self.menuOpen = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.mainContainer.frame = CGRectMake(0, 0, self.mainContainer.frame.size.width, self.mainContainer.frame.size.height);
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    // Clean up Dynamics
    [self.animator removeAllBehaviors];
    self.animator = nil;
    self.gravityBehaviour = nil;
    self.pushBehavior = nil;
    self.panAttachmentBehaviour = nil;
}

- (void)addSideMenuBehaviours {
    
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Collision with boundries and 100 pixel insets on the right bound
    UICollisionBehavior *collisionBehaviour = [[UICollisionBehavior alloc] initWithItems:@[self.mainContainer]];
    [collisionBehaviour setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-1, -1, -1, -MENU_WIDTH)];
    [self.animator addBehavior:collisionBehaviour];
    
    // X axis gravity
    self.gravityBehaviour = [[UIGravityBehavior alloc] initWithItems:@[self.mainContainer]];
    self.gravityBehaviour.gravityDirection = CGVectorMake(-1, 0);
    [self.animator addBehavior:self.gravityBehaviour];
    
    // Push
    self.pushBehavior = [[UIPushBehavior alloc] initWithItems:@[self.mainContainer] mode:UIPushBehaviorModeInstantaneous];
    self.pushBehavior.magnitude = 0.0f;
    self.pushBehavior.angle = 0.0f;
    [self.animator addBehavior:self.pushBehavior];
    
    // Modify Main View elasticity
    self.dynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self.mainContainer]];
    self.dynamicItemBehaviour.elasticity = 0.3f;
    [self.animator addBehavior:self.dynamicItemBehaviour];
}

- (void)addGestureRecognizers  {
   
    // Pan Gesture
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    self.panGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)onPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint location = [gestureRecognizer locationInView:self.view];
    location.y = CGRectGetMidY(self.mainContainer.bounds);
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        
        // Remove Gravity and add Attachment for the view dragging
        [self.animator removeBehavior:self.gravityBehaviour];
        self.panAttachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.mainContainer attachedToAnchor:location];
        [self.animator addBehavior:self.panAttachmentBehaviour];
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        self.panAttachmentBehaviour.anchorPoint = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        // Remove attatchment
        [self.animator removeBehavior:self.panAttachmentBehaviour], self.panAttachmentBehaviour = nil;
        
        // Set Menu state + Add Gravity again
        [self setMenuState];
        [self.animator addBehavior:self.gravityBehaviour];
        
        // Push behaviour for impulse - depending on final view velocity
        CGPoint velocity = [gestureRecognizer velocityInView:self.view];
        self.pushBehavior.pushDirection = CGVectorMake(velocity.x / 10.0f, 0);
        self.pushBehavior.active = YES;
    }
}

- (void)setMenuState {
    
    if ( ![self isMenuOpen] && self.mainContainer.frame.origin.x>GESTURE_MARGIN ) {
        
        self.menuOpen = YES;
        self.gravityBehaviour.gravityDirection = CGVectorMake(1, 0);
    }
    else if ( [self isMenuOpen] && self.mainContainer.frame.origin.x<(MENU_WIDTH-GESTURE_MARGIN) ) {
        
        self.menuOpen = NO;
        self.gravityBehaviour.gravityDirection = CGVectorMake(-1, 0);
    }
}

- (void)toggleDebug {
    [self.mainController toggleDebug];
}

#pragma mark - Menu Delegate

- (void)didSelectMenuOptionAtIndex:(NSInteger)index {
    
    if (index < menuSegues.count) {
        NSString *segue = menuSegues[index];
        [self performSegueWithIdentifier:segue sender:self];
    }
}

#pragma mark - Gesture Recognizer Delegate

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//    
//    if (gestureRecognizer == self.leftScreenEdgeGestureRecognizer && !self.isMenuOpen)
//        return YES;
//    
//    else if (gestureRecognizer == self.rightScreenPanGestureRecognizer && self.isMenuOpen)
//        return YES;
//    
//    return NO;
//}

#pragma mark - Dynamic Animator Delegate

- (void)dynamicAnimatorWillResume:(UIDynamicAnimator*)animator {
    
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator*)animator {
    
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"menuEmbedSegue"]) {
        MenuViewController *menuController  = segue.destinationViewController;
        menuController.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"mainEmbedSegue"]) {
        self.mainController = (MainViewController*)segue.destinationViewController;
    }
}


@end

