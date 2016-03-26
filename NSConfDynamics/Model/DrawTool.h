//
//  DrawTool.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DrawTool : NSObject

/**
 *  Generate a random color
 *
 *  @return UIColor instance
 */
+ (UIColor*)randomColor;

/**
 *  Draw a line on a given layar between 2 points
 *
 *  @param layer  drawing layer
 *  @param pointA first point
 *  @param pointB second point
 *  @param color  color of the line
 *
 *  @return line instance
 */
+ (CAShapeLayer*)makeLineOnLayer:(CALayer *)layer lineFromPointA:(NSString*)pointA toPointB:(NSString*)pointB color:(UIColor*)color;

@end
