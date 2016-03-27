//
//  EdgePanTransitionAnimator.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol EdgePanTransitionDelegate <NSObject>

- (void)didFinishTransition;

@end

@interface EdgePanTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, weak) id<EdgePanTransitionDelegate> delegate;

@end