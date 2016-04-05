//
//  CustomSlideViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#define USE_DYNAMICS    1
#import "SlideBehaviour.h"
#import "CustomSlideViewController.h"

@interface CustomSlideViewController ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property (strong, nonatomic) IBOutlet UIPanGestureRecognizer* panGesture;
@property (weak, nonatomic) IBOutlet UIView *slidingView;

@end

@implementation CustomSlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Custom Slide"];
}

- (void)toggleDebug {
    [super toggleDebug];
    if (self.segmentControl.selectedSegmentIndex == USE_DYNAMICS)
        [self addSlideBehaviour];
}

#pragma mark - Back Slide View

- (void)addSlideBehaviour {
    
    SlideBehaviour *slide = [[SlideBehaviour alloc] initWithItem:self.slidingView];
    [self.animator addBehavior:slide];
}

- (IBAction)onPan:(UIPanGestureRecognizer*)pan {
    
    static CGFloat startY;
    CGPoint delta = [pan translationInView:self.view.superview];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        startY = self.view.center.y;
        [pan setTranslation:CGPointZero inView:pan.view.superview];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        CGFloat newY = self.view.center.y + delta.y;
        
        // detect a collision with the bottom
        if (newY > startY)
            newY = startY;

        // attach the pan to the view
        self.view.center = CGPointMake(self.view.center.x, newY);
        [pan setTranslation:CGPointZero inView:pan.view.superview];
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        // "Gravity"
        [UIView animateWithDuration:.3 animations:^{
            self.view.center = CGPointMake(self.view.center.x, startY);
        }];
    }
}

- (IBAction)onSegmentChanged:(id)sender {
    
    if (self.segmentControl.selectedSegmentIndex != USE_DYNAMICS) {
        
        self.panGesture.enabled = YES;
        [self.animator removeAllBehaviors];
        
    } else if (self.segmentControl.selectedSegmentIndex == USE_DYNAMICS) {
        
        self.panGesture.enabled = NO;
        [self addSlideBehaviour];
    }
}
@end

