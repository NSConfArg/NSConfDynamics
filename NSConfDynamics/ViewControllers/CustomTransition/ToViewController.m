//
//  ToViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "ToViewController.h"
#import "EdgePanTransitionAnimator.h"

@interface ToViewController() <UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) EdgePanTransitionAnimator *transitionAnimator;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

@end

@implementation ToViewController

- (EdgePanTransitionAnimator*)transitionAnimator {
    
    if (!_transitionAnimator) {
        _transitionAnimator = [[EdgePanTransitionAnimator alloc] init];
    }
    
    return _transitionAnimator;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // The view controller is full screen
    self.view.frame = [UIScreen mainScreen].bounds;
    
    // Dismiss Button
    self.dismissButton.layer.cornerRadius = 4;
    self.dismissButton.layer.borderWidth = 1;
    self.dismissButton.layer.borderColor = [self.dismissButton.tintColor CGColor];
}

- (IBAction)dismiss:(id)sender {
    self.transitioningDelegate = self;
    
    if ([self.presentingViewController conformsToProtocol:@protocol(EdgePanTransitionDelegate)]) {
        self.transitionAnimator.delegate = (id<EdgePanTransitionDelegate>)self.presentingViewController;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}

#pragma mark - Transitioning animator delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.transitionAnimator;
}


@end

