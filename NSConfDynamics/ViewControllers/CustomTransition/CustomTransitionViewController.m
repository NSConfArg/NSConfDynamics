//
//  CustomTransitionViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "EdgePanTransitionAnimator.h"
#import "FromViewController.h"
#import "ToViewController.h"
#import "CustomTransitionViewController.h"

@interface CustomTransitionViewController () <UIViewControllerTransitioningDelegate, UICollisionBehaviorDelegate, EdgePanTransitionDelegate>

@property (nonatomic, strong) EdgePanTransitionAnimator *transitionAnimator;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interactionController;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIPushBehavior *pushBehavior;

@property (nonatomic) BOOL wasPushed;

@end


@implementation CustomTransitionViewController


- (EdgePanTransitionAnimator*)transitionAnimator {
    
    if (!_transitionAnimator) {
        _transitionAnimator = [[EdgePanTransitionAnimator alloc] init];
        _transitionAnimator.delegate = self;
    }
    
    return _transitionAnimator;
}


#pragma mark - Dynamic behaviors

- (UIGravityBehavior*)gravityBehavior {
    
    if (!_gravityBehavior) {
        _gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[self.containerView]];
        _gravityBehavior.gravityDirection = CGVectorMake(-1.0, 0.0);
    }
    
    return _gravityBehavior;
}

- (UIPushBehavior*)pushBehavior {
    
    if (!_pushBehavior) {
        _pushBehavior= [[UIPushBehavior alloc] initWithItems:@[self.containerView] mode:UIPushBehaviorModeInstantaneous];
        
        _pushBehavior.magnitude = 50.0;
    }
    
    return _pushBehavior;
}

- (UICollisionBehavior*)collisionBehavior {
    
    if (!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.containerView]];
        
        CGRect referenceViewBounds = self.dynamicAnimator.referenceView.bounds;
        [self.collisionBehavior addBoundaryWithIdentifier:@"left edge boundary"
                                                fromPoint:referenceViewBounds.origin
                                                  toPoint:CGPointMake(referenceViewBounds.origin.x, CGRectGetMaxY(referenceViewBounds))];
        
        _collisionBehavior.collisionDelegate = self;
    }
    
    return _collisionBehavior;
}


- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    
    if ([((NSString *)identifier) isEqualToString:@"edge boundary"] && !self.wasPushed) {
        
        self.wasPushed = YES;
        [self.dynamicAnimator addBehavior:self.pushBehavior];
        
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier {
    
    if ([((NSString *)identifier) isEqualToString:@"edge boundary"]) {
        [self.dynamicAnimator removeBehavior:self.pushBehavior];
        self.pushBehavior = nil;
        
        [self.dynamicAnimator addBehavior:self.gravityBehavior];
    }
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
//    // Disableedge pan back action
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)])
//        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UIScreenEdgePanGestureRecognizer *leftEdgeGestureRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(handleEdgeGesture:)];
    leftEdgeGestureRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:leftEdgeGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Add drop shadow to the left edge
    self.containerView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.containerView.layer.shadowOffset = CGSizeMake(-3.0, 0.0);
    self.containerView.layer.shadowOpacity = 0.7;
    self.containerView.layer.shadowRadius = 4.0;
}

- (BOOL)shouldAutorotate {
    return  NO;
}

# pragma mark - Transitioning animator delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return self.transitionAnimator;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    return self.interactionController;
}

#pragma mark - Pan gesture

- (void)handleEdgeGesture:(UIScreenEdgePanGestureRecognizer *)edgeGestureRecognizer {
    
    CGPoint anchorPoint = [edgeGestureRecognizer locationInView:self.view];
    // The anchor point X position is constant to prevent the pushed controller to move vertically
    anchorPoint.y = CGRectGetMidY(self.view.bounds);
    
    CGFloat translationPercent = [edgeGestureRecognizer translationInView:self.view].x / CGRectGetWidth(self.view.bounds);
    
    if (edgeGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.interactionController = [[UIPercentDrivenInteractiveTransition alloc] init];
        
        ToViewController *secondaryViewController = [[ToViewController alloc] init];
        secondaryViewController.transitioningDelegate = self;
        
        [self presentViewController:secondaryViewController animated:YES completion:nil];
        
    } else if (edgeGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        // Move the view controller in sync with the gesture
        [self.interactionController updateInteractiveTransition:translationPercent];
        
    } else if (edgeGestureRecognizer.state == UIGestureRecognizerStateEnded || edgeGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        self.wasPushed = NO;
        
        if (translationPercent > 0.4) {
            [self.dynamicAnimator removeAllBehaviors];
            [self.interactionController finishInteractiveTransition];
        } else
            [self.interactionController cancelInteractiveTransition];
        
        self.interactionController = nil;
    }
}

#pragma mark - EdgePanTransitionDelegate

// Transitioning animator delegate method
- (void)didFinishTransition {
    
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[self.containerView]];
    collisionBehavior.collisionDelegate = self;
    
    CGRect referenceViewBounds = self.dynamicAnimator.referenceView.bounds;
    [collisionBehavior addBoundaryWithIdentifier:@"edge boundary"
                                       fromPoint:referenceViewBounds.origin
                                         toPoint:CGPointMake(referenceViewBounds.origin.x, CGRectGetMaxY(referenceViewBounds))];
    [self.dynamicAnimator addBehavior:collisionBehavior];
}

@end
