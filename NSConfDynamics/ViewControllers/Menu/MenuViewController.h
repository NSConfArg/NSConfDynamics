//
//  MenuViewController.h
//  NSConfDynamics
//
//  Created by Rodrigo Mato on 3/22/16.
//  Copyright © 2016 RodrigoMato. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SideMenuDelegate <NSObject>

- (void)didSelectMenuOptionAtIndex:(NSInteger)index;

@end


@interface MenuViewController : UITableViewController

@property (nonatomic, strong) id<SideMenuDelegate> delegate;

@end
