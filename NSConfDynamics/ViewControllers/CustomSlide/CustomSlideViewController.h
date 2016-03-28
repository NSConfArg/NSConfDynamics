//
//  CustomSlideViewController.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/27/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "DynamicsViewController.h"
#import <UIKit/UIKit.h>

@interface CustomSlideViewController : DynamicsViewController

- (IBAction)onPan:(UIPanGestureRecognizer*)pan;
- (IBAction)onSegmentChanged:(id)sender;

@end
