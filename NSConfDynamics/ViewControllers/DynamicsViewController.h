//
//  DynamicsViewController.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/10/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DynamicsViewController : UIViewController

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) NSMutableArray    *behaviours;
@property (nonatomic, strong) NSMutableArray    *items;

@property (nonatomic, strong) IBOutletCollection(UIView) NSArray    *obstacles;

- (void)createItems;
- (void)createBehaviours;

@end
