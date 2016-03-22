//
//  SpringBehaviour.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "SpringBehaviour.h"

@implementation SpringBehaviour

- (instancetype)initWithItems:(NSArray *)items withAnchorPoint:(NSString *)anchorPointString {

    self = [super init];
    if(self) {
        
        CGPoint anchorPoint = CGPointFromString(anchorPointString);
        
        // Gravity + Collision
        UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc] initWithItems:items];
        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:items];
        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
        
        // Attachments
        UIAttachmentBehavior *item1AttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:[items objectAtIndex:0] attachedToAnchor:anchorPoint];
        UIAttachmentBehavior *item2AttachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:[items objectAtIndex:1]
                                                                                  offsetFromCenter:UIOffsetMake(-20.0, 0)
                                                                                    attachedToItem:[items objectAtIndex:0]
                                                                                  offsetFromCenter:UIOffsetZero];
        [item1AttachmentBehavior setFrequency:1.0];
        [item1AttachmentBehavior setFrequency:1.0];
        [item2AttachmentBehavior setDamping:0.65];
        [item2AttachmentBehavior setDamping:0.65];
        
        // Add them to our custom behaviour
        [self addChildBehavior:gravityBehavior];
//        [self addChildBehavior:collisionBehavior];
        [self addChildBehavior:item1AttachmentBehavior];
        [self addChildBehavior:item2AttachmentBehavior];
    }
    return self;
}

@end
