//
//  CustomAttachmentController.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "DrawTool.h"
#import "SpringBehaviour.h"
#import "CustomAttachmentController.h"

@interface CustomAttachmentController () {
    CGPoint mainAnchor;
    BOOL    showAttachmentLines;
}

@property (strong, nonatomic) UIView *view1;
@property (strong, nonatomic) UIView *view2;

@property (nonatomic, strong) CAShapeLayer  *line1;
@property (nonatomic, strong) CAShapeLayer  *line2;

@end

@implementation CustomAttachmentController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onFrameUpdate)];
    [displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)createItems {
    
    // Red Square
    CGFloat side = 100;
    CGRect position = CGRectMake(10, 10, side, side);
    self.view1 = [[UIView alloc] initWithFrame:position];
    [self.view1 setBackgroundColor:[UIColor redColor]];
    [self.items addObject:self.view1];
    
    // Blue Square
    position = CGRectMake(self.view.bounds.size.width-10-side, 10, side, side);
    self.view2 = [[UIView alloc] initWithFrame:position];
    [self.view2 setBackgroundColor:[UIColor blueColor]];
    [self.items addObject:self.view2];
    
    for (UIView *view in self.items) {
        [self.view addSubview:view];
    }
    
}

- (void)createBehaviours {
    
    mainAnchor = CGPointMake(self.view.frame.size.width/2, 0);
    NSString *anchorPointString = NSStringFromCGPoint(mainAnchor);
    SpringBehaviour *springBehavior = [[SpringBehaviour alloc] initWithItems:self.items withAnchorPoint:anchorPointString];
    [self.animator addBehavior:springBehavior];
}


#pragma mark - Callbacks

- (void)onFrameUpdate {

    if (showAttachmentLines) {
        
            if (self.line1.superlayer)
            [self.line1 removeFromSuperlayer];
        self.line1 = [DrawTool makeLineOnLayer:self.view.layer
                                     lineFromPointA:NSStringFromCGPoint(mainAnchor)
                                           toPointB:NSStringFromCGPoint(self.view1.center)
                                              color:[UIColor greenColor]];
        
        // Line between views
        if (self.line2.superlayer)
            [self.line2 removeFromSuperlayer];
        self.line2 = [DrawTool makeLineOnLayer:self.view.layer
                                lineFromPointA:NSStringFromCGPoint(self.view1.center)
                                      toPointB:NSStringFromCGPoint(self.view2.center)
                                         color:[UIColor greenColor]];
    }
}

- (IBAction)segmentValueChanged:(id)sender {
    
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == 0) {
        showAttachmentLines = NO;
        [self.line1 removeFromSuperlayer];
        [self.line2 removeFromSuperlayer];
    }
    else
        showAttachmentLines = YES;
}


@end
