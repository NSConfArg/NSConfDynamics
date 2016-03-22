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

+ (CAShapeLayer*)makeLineOnLayer:(CALayer *)layer lineFromPointA:(NSString*)pointA toPointB:(NSString*)pointB color:(UIColor*)color;

@end
