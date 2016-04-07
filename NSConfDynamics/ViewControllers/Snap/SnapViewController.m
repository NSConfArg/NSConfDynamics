//
//  SnapViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/10/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "DrawTool.h"
#import "SnapViewController.h"

@interface SnapViewController ()

@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;

@property (strong, nonatomic) NSMutableDictionary   *viewBehaviourHash;

@property (nonatomic) CGPoint           startingPoint;
@property (strong, nonatomic) NSArray   *snapPositions;

@property(nonatomic, strong) UIPanGestureRecognizer *gestureRecognizer;
@property(nonatomic, strong) UISnapBehavior *redSphereSnapBehavior;

@end

@implementation SnapViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self  = [super initWithCoder:aDecoder];
    if (self ) {
        _viewBehaviourHash = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Snap"];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self createSnapingViews];
    
    // Snapping positions
    CGFloat side = 70;
    CGRect localBounds = self.view.bounds;
    CGFloat padding = 20 + side/2;
    _snapPositions = @[[NSValue valueWithCGPoint:CGPointMake(0 + padding, 0 + padding)],
                       [NSValue valueWithCGPoint:CGPointMake(localBounds.size.width - padding, 0 + padding)],
                       [NSValue valueWithCGPoint:CGPointMake(0 + padding, localBounds.size.height - padding)],
                       [NSValue valueWithCGPoint:CGPointMake(localBounds.size.width - padding, localBounds.size.height - padding)]];
    
    // Reset Button
    self.resetButton.layer.borderWidth = 1;
    self.resetButton.layer.cornerRadius = 5;
    self.resetButton.layer.borderColor = [self.resetButton.tintColor CGColor];
    
    // Create Snap behaviour for main red sphere
    CGRect frame = self.mainView.frame;
    _redSphereSnapBehavior = [self addSnapBehavior:self.mainView toPoint:CGPointMake(frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2)];
    
    self.startingPoint = CGPointMake(localBounds.size.width/2, localBounds.size.height-padding);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSnapingViews {
    
    CGFloat padding = 20;
    NSInteger side = 70;
    CGRect localBounds = self.view.bounds;
    self.startingPoint = CGPointMake(localBounds.size.width/2 - side/2, localBounds.size.height-side-padding);
    
    // Snap Views
    UIView *view;
    UIImageView *imageView;
    UITapGestureRecognizer *tapGesture;
    UIImage *logoImage = [UIImage imageNamed:@"nsconf_logo"];
    for (int i=0; i < 4; i++) {
        
        view = [[UIView alloc] initWithFrame:CGRectMake(self.startingPoint.x, self.startingPoint.y, side, side)];
        [view setClipsToBounds:YES];
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        [imageView setImage:logoImage];
        [view addSubview:imageView];
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
        [view addGestureRecognizer:tapGesture];
        [view setTag:i];
        [self.items addObject:view];
        [self.view addSubview:view];
    }
}

- (void)createItems {
    
    // Main sphere
    self.mainView.layer.cornerRadius = self.mainView.frame.size.width/2;
    [self.mainView setBackgroundColor:[UIColor redColor]];
    _gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPanGesture:)];
    [self.mainView addGestureRecognizer:_gestureRecognizer];

}

- (void)onViewTap:(UITapGestureRecognizer *)recognizer {
    
    UIView *view = recognizer.view;
    CGPoint snapPosition = [((NSValue*)self.snapPositions[view.tag]) CGPointValue];
    [self addSnapBehavior:view toPoint:snapPosition];
}

- (UISnapBehavior*)addSnapBehavior:(UIView*)view toPoint:(CGPoint)point {
    
    // Remove previous snap behaiour in view, if one exists
    if (self.viewBehaviourHash[@(view.tag)])
        [self.animator removeBehavior:self.viewBehaviourHash[@(view.tag)]];
    
    // Add New Snap behaviour
    UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:point];
    [self.animator addBehavior:snap];
    [self.viewBehaviourHash setObject:snap forKey:@(view.tag)];
    return snap;
}

// Main sphere pan gestures
- (void)onPanGesture:(UIPanGestureRecognizer*)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan)
        [self.animator removeBehavior:_redSphereSnapBehavior];
    
    else if (gesture.state == UIGestureRecognizerStateChanged) {
        
        // Adjust Position
        CGPoint newCenter = self.mainView.center;
        newCenter.x += [gesture translationInView:self.view].x;
        newCenter.y += [gesture translationInView:self.view].y;
        self.mainView.center = newCenter;
        
        [gesture setTranslation:CGPointZero inView:self.view];
    }
    else if (gesture.state == UIGestureRecognizerStateEnded)
        [self.animator addBehavior:_redSphereSnapBehavior];
}

- (void)toggleDebug {
    
    // Remove all behaviours and items
    [self.animator removeAllBehaviors];
    self.behaviours = [NSMutableArray new];
    
    // Toggle debug mode
    self.debugEnabled = !self.debugEnabled;
    [self.animator setValue:@(self.debugEnabled) forKeyPath:@"debugEnabled"];
    
    // Add Behaviours and Items again
    [self createItems];
    [self createBehaviours];
    for (UIDynamicBehavior *behaviour in self.behaviours)
        [self.animator addBehavior:behaviour];
}

- (IBAction)onResetClicked:(id)sender {

    for (UIView *view in self.items) {
        [self addSnapBehavior:view toPoint:self.startingPoint];
    }
}

@end
