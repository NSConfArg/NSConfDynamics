//
//  BaseContainerViewController.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import "MenuViewController.h"
#import "DynamicsViewController.h"
#import <UIKit/UIKit.h>

typedef enum MenuOption {
    kOption1 = 0,
    kOption2 = 0,
    kOption3 = 0,
    kOption4 = 0,
}MenuOption;

@interface BaseContainerViewController : DynamicsViewController <UIGestureRecognizerDelegate, SideMenuDelegate>

- (void)didSelectMenuOptionAtIndex:(NSInteger)index;

@end
