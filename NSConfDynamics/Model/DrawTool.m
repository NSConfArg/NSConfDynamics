//
//  DrawTool.m
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "DrawTool.h"

@implementation DrawTool


+ (CAShapeLayer*)makeLineOnLayer:(CALayer *)layer lineFromPointA:(NSString*)pointA toPointB:(NSString*)pointB color:(UIColor*)color {
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:CGPointFromString(pointA) ];
    [linePath addLineToPoint:CGPointFromString(pointB)];
    shapeLayer.path=linePath.CGPath;
    shapeLayer.fillColor = nil;
    shapeLayer.lineWidth = 3;
    shapeLayer.opacity = 1.0;
    shapeLayer.strokeColor = [color CGColor];
    [layer addSublayer:shapeLayer];
    return shapeLayer;
}

@end
