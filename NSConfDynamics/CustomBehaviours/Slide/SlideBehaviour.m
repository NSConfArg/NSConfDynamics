//
//  SlideBehaviour.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "SlideBehaviour.h"

@implementation SlideBehaviour

- (instancetype)initWithItem:(UIView*)item {
    
    self = [super init];
    if (self) {
        
        // Add a pan gesture to the view
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [item addGestureRecognizer:self.panGesture];
        
        // Add Attachmentto the items center
        self.attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:CGPointMake(item.center.x, item.center.y)];
        self.attachmentBehaviour.damping = 0.1;
        self.attachmentBehaviour.frequency = 5.0;
        
        // Add Collision Behaviour with bounds as boundary + insets
        UICollisionBehavior * collision = [[UICollisionBehavior alloc] initWithItems:@[item]];
        [collision setTranslatesReferenceBoundsIntoBoundaryWithInsets:UIEdgeInsetsMake(-item.superview.bounds.size.height*3/4, 0, 0, 0)];
        collision.collisionMode = UICollisionBehaviorModeBoundaries;
        [self addChildBehavior:collision];
        
        // Add Gravity Behaviour
        UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[item]];
        [self addChildBehavior:gravity];
        
        // Add Dynamic Behaviour to modify dynamic's parameters
        self.dynamicItemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
        self.dynamicItemBehavior.allowsRotation = NO;
        self.dynamicItemBehavior.elasticity = 0.4;
        self.dynamicItemBehavior.resistance = 0.7;
        [self addChildBehavior:self.dynamicItemBehavior];
    }
    return self;
}

- (void)onPan:(UIPanGestureRecognizer*)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        [self addChildBehavior:self.attachmentBehaviour];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGPoint delta = [pan translationInView:pan.view.superview];
        self.attachmentBehaviour.anchorPoint = CGPointMake(self.attachmentBehaviour.anchorPoint.x, self.attachmentBehaviour.anchorPoint.y + delta.y);
        [pan setTranslation:CGPointZero inView:pan.view.superview];
    
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled || pan.state == UIGestureRecognizerStateFailed) {
        
        [self removeChildBehavior:self.attachmentBehaviour];
    }
}

- (void)dealloc {
    
    [self.panGesture removeTarget:self action:@selector(onPan:)];
    [self.panGesture.view removeGestureRecognizer:self.panGesture];
}


@end
