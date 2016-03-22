//
//  SpringBehaviour.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpringBehaviour : UIDynamicBehavior

- (instancetype)initWithItems:(NSArray *)items withAnchorPoint:(NSString *)anchorPointString;

@end
