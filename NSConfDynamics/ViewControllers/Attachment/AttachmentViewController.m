//
//  AttachmentViewController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#define ACTIVE_GRAVITY  0
#import "AttachmentViewController.h"

@interface AttachmentViewController ()

@property (nonatomic) CGPoint   touchLocation;
@property (nonatomic) BOOL      touchActive;
@property (nonatomic, strong) CAShapeLayer  *attachmentLine;
@property (nonatomic, strong) UIView        *redSquare;

@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehaviour;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *dynamicItemBehaviour;

@property (nonatomic) CGRect squarePosition;


@end


@implementation AttachmentViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _touchActive = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"Attachment"];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onFrameUpdate)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}


#pragma mark - Dynamics

- (void)createItems {
    
    // Red Square
    CGFloat side = 100;
    self.squarePosition = CGRectMake(10, 10, side, side);
    _redSquare = [[UIView alloc] initWithFrame:self.squarePosition];
    [_redSquare setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_redSquare];
    [self.items addObject:_redSquare];
}

- (void)createBehaviours {

    // Gravity
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:self.items];
    [self.animator addBehavior:self.gravityBehavior];

    // Collisions
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:self.items];
//    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.collisionBehavior addBoundaryWithIdentifier:@"VerticalMin"
                                            fromPoint:CGPointMake(0, CGRectGetHeight(self.view.frame))
                                              toPoint:CGPointMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//    [self.collisionBehaviour addBoundaryWithIdentifier("verticalMin", fromPoint: CGPointMake(0, 0), toPoint: CGPointMake(CGRectGetMaxX(view.frame), 0))
    [self.animator addBehavior:self.collisionBehavior];
//
//    // Dynamic Items (properties)
//    self.dynamicItemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:self.obstacles];
//    self.dynamicItemBehaviour.density = MAX_DENSITY;
//    [self.behaviours addObject:self.dynamicItemBehaviour];
}


#pragma mark - Animation & Touches callbacks

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _touchActive = YES;
    UITouch *touch = [touches anyObject];
    _touchLocation = [touch locationInView:self.view];
    
    self.attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:_redSquare attachedToAnchor:_touchLocation];
    [self.animator addBehavior:self.attachmentBehaviour];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    _touchLocation = [touch locationInView:self.view];
    self.attachmentBehaviour.anchorPoint = _touchLocation;
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _touchActive = NO;
    [_attachmentLine removeFromSuperlayer];
    [self.animator removeBehavior:self.attachmentBehaviour];
}

- (void)onFrameUpdate {
    
    if (self.touchActive)
        [self makeLineLayer:self.view.layer lineFromPointA:_redSquare.center toPointB:_touchLocation];
}

-(void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB {
    
    if (_attachmentLine.superlayer)
        [_attachmentLine removeFromSuperlayer];
    
    _attachmentLine = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: pointA];
    [linePath addLineToPoint:pointB];
    _attachmentLine.path=linePath.CGPath;
    _attachmentLine.fillColor = nil;
    _attachmentLine.lineWidth = 3;
    _attachmentLine.opacity = 1.0;
    _attachmentLine.strokeColor = [UIColor blueColor].CGColor;
    [layer addSublayer:_attachmentLine];
}


#pragma mark - Segment Control

- (IBAction)segmentValueChanged:(id)sender {
    
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == ACTIVE_GRAVITY)
        [self.animator addBehavior:self.gravityBehavior];
    else
        [self.animator removeBehavior:self.gravityBehavior];
}

@end
