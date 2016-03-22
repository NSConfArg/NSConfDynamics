//
//  SnapViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/10/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "SnapViewController.h"

@interface SnapViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property(nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property(nonatomic, strong) UISnapBehavior *snapBehavior;

@end

@implementation SnapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createItems];
    [self setTitle:@"Snap"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    CGRect frame = self.mainView.frame;
    _snapBehavior = [self addSnapBehavior:self.mainView toPoint:CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createItems {
    
    // Main sphere
    self.mainView.layer.cornerRadius = self.mainView.frame.size.width/2;
    [self.mainView setBackgroundColor:[UIColor redColor]];
    _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.mainView addGestureRecognizer:_gestureRecognizer];
    [self.items addObject:self.mainView];
}

- (UISnapBehavior*)addSnapBehavior:(UIView*)view toPoint:(CGPoint)point {
    
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    [self.animator addBehavior:snap];
    return snap;
}

- (void)onPanGesture:(UIPanGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan)
        [self.animator removeBehavior:_snapBehavior];
    
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        // Adjust Position
        CGPoint newCenter = self.mainView.center;
        newCenter.x += [gesture translationInView:self.view].x;
        newCenter.y += [gesture translationInView:self.view].y;
        self.mainView.center = newCenter;
        
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
        [self.animator addBehavior:_snapBehavior];
}

@end
