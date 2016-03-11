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

}

#pragma mark - overriden methods

- (void)createItems{}
- (void)createBehaviours{}

@end
