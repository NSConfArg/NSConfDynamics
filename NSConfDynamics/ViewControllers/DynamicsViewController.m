//
//  DynamicsViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/10/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "DynamicsViewController.h"

@implementation DynamicsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {

        _behaviours = [NSMutableArray new];
        _items = [NSMutableArray new];
        _debugEnabled = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    [self createItems];
    [self createBehaviours];
    [self configUI];
}

- (void)configUI {
    
    // Remove back button title
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:self.navigationItem.backBarButtonItem.style
                                                                            target:nil
                                                                            action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"bug_icon"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(toggleDebug)];
}

- (void)toggleDebug {
    
    // Remove all behaviours and items
    [self.animator removeAllBehaviors];
    self.behaviours = [NSMutableArray new];
    for (UIView *view in self.items)
        [view removeFromSuperview];
    self.items = [NSMutableArray new];
    
    // Toggle debug mode
    self.debugEnabled = !self.debugEnabled;
    [self.animator setValue:@(self.debugEnabled) forKeyPath:@"debugEnabled"];
    
    // Add Behaviours and Items again
    [self createItems];
    [self createBehaviours];
    for (UIDynamicBehavior *behaviour in self.behaviours)
        [self.animator addBehavior:behaviour];
}

#pragma mark - overriden methods

- (void)createItems{}
- (void)createBehaviours{}

@end
