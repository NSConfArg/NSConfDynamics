//
//  SlideBehaviour.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideBehaviour : UIDynamicBehavior

- (instancetype)initWithItem:(UIView*)item;

@property (strong, nonatomic) UIPanGestureRecognizer    *panGesture;
@property (strong, nonatomic) UIAttachmentBehavior      *attachmentBehaviour;
@property (strong, nonatomic) UIDynamicItemBehavior     *dynamicItemBehavior;

@end