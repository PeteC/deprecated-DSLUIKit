//
//  AppDelegate.m
//  DSLUIKitExample
//
//  Created by Pete Callaway on 29/01/2012.
//  Copyright (c) 2012 Dative Studios. All rights reserved.
//

#import "AppDelegate.h"
#import "DSLNavigationController.h"
#import "DSLTabBarController.h"
#import "ViewController.h"


@implementation AppDelegate


@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    NSMutableArray *tabbedControllers = [NSMutableArray array];
    
    ViewController *childController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    childController.title = @"Controller 1";
    DSLNavigationController *controller = [DSLNavigationController navigationControllerWithRootViewController:childController];
    controller.dsl_navigationBar.backgroundImage = [UIImage imageNamed:@"navbar-background"];
    controller.tabBarItem.image = [UIImage imageNamed:@"tabbar-item01"];
    controller.tabBarItem.dsl_selectedImage = [UIImage imageNamed:@"tabbar-item01-selected"];
    [tabbedControllers addObject:controller];
    
    childController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    childController.title = @"Controller 2";
    controller = [DSLNavigationController navigationControllerWithRootViewController:childController];
    controller.dsl_navigationBar.backgroundImage = [UIImage imageNamed:@"navbar-background"];
    controller.tabBarItem.image = [UIImage imageNamed:@"tabbar-item02"];
    controller.tabBarItem.dsl_selectedImage = [UIImage imageNamed:@"tabbar-item02-selected"];
    [tabbedControllers addObject:controller];

    DSLTabBarController *tabController = [[DSLTabBarController alloc] initWithViewControllers:tabbedControllers];
    tabController.tabBarBackgroundImage = [UIImage imageNamed:@"tabbar-background"];
    
    self.window.rootViewController = tabController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
