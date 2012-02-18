/*
 DSLTabBarController.m
 
 Copyright (c) 2011 Dative Studios. All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice, this
 list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 
 * Neither the name of the author nor the names of its contributors may be used
 to endorse or promote products derived from this software without specific
 prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "DSLTabBarController.h"


@interface DSLTabBarController ()<UINavigationControllerDelegate>

- (void)updateTabBar;
- (void)layoutTabBarButtons;

@end


@implementation DSLTabBarController {
    __strong NSArray *_tabButtons;
    __strong UIView *_tabView;
    __strong UIView *_containerView;
}

@synthesize selectedControllerIndex = _selectedControllerIndex;
@synthesize tabBarBackgroundImage = _tabBarBackgroundImage;
@synthesize tabBarHeight = _tabBarHeight;
@synthesize viewControllers = _viewControllers;


#pragma mark - Property accessors

- (void)setSelectedControllerIndex:(NSUInteger)selectedControllerIndex {
    if (_viewControllers.count == 0 || selectedControllerIndex >= _viewControllers.count) {
        return;
    }
    
    // Send hide messages to the current view controller
    if (_containerView.subviews.count > 0 && _selectedControllerIndex < _viewControllers.count) {
        UIViewController *controllerBeingHidden = [_viewControllers objectAtIndex:_selectedControllerIndex];
        [controllerBeingHidden viewWillDisappear:NO];
        [controllerBeingHidden viewDidDisappear:NO];
    }
    
    _selectedControllerIndex = selectedControllerIndex;
    
    UIViewController *selectedViewController = [_viewControllers objectAtIndex:selectedControllerIndex];
    
    UIView *currentChildView = (_containerView.subviews.count > 0) ? [_containerView.subviews objectAtIndex:0] : nil;
    UIView *viewToShow = selectedViewController.view;
    
    if (currentChildView != viewToShow) {
        [currentChildView removeFromSuperview];

        viewToShow.frame = _containerView.bounds;
        viewToShow.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [selectedViewController viewWillAppear:NO];
        [_containerView addSubview:viewToShow];
        [selectedViewController viewDidAppear:NO];
    }
    
    [_tabButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
        button.selected = (index == selectedControllerIndex);
    }];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)controller;
            navigationController.delegate = nil;
        }
    }];
    
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _viewControllers = [NSArray arrayWithArray:viewControllers];

    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        if ([controller isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navigationController = (UINavigationController*)controller;
            navigationController.delegate = self;
        }
    }];

    if (self.isViewLoaded) {
        [self updateTabBar];
    }
}


#pragma mark - Initialisation

// Designated initialiser
- (id)initWithViewControllers:(NSArray*)viewControllers {
	self = [self init];
	if (self != nil) {
		// Initialise properties
        self.tabBarHeight = 49;
        self.viewControllers = viewControllers;
	}
	
	return self;
}


#pragma mark - UIViewController methods

- (void)loadView {
    [super loadView];
    
    CGRect frame = CGRectZero;
    frame.size.height = self.tabBarHeight;
    frame.origin.y = self.view.bounds.size.height - frame.size.height;
    frame.size.width = self.view.bounds.size.width;
    _tabView = [[UIView alloc] initWithFrame:frame];
    _tabView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    _tabView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:_tabView];
    
    frame = CGRectZero;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.bounds.size.height - _tabView.bounds.size.height;
    _containerView = [[UIView alloc] initWithFrame:frame];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _containerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_containerView];
    
    if (self.tabBarBackgroundImage != nil) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:self.tabBarBackgroundImage];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.frame = _tabView.bounds;
        [_tabView addSubview:imageView];
    }
    
    [self updateTabBar];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    __block BOOL shouldAutorotate = YES;
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childController, NSUInteger index, BOOL *stop) {
        shouldAutorotate = [childController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
        if (!shouldAutorotate) {
            *stop = YES;
        }
    }];
    
    return shouldAutorotate;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *childController, NSUInteger idx, BOOL *stop) {
        [childController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }];
    
    [self layoutTabBarButtons];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *childController, NSUInteger idx, BOOL *stop) {
        [childController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    }];
    
    [self layoutTabBarButtons];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *childController, NSUInteger idx, BOOL *stop) {
        [childController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    }];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    
//    CGRect newTabFrame = _tabView.frame;
//    newTabFrame.origin.y = self.view.bounds.size.height;
//    
//    if (animated) {
//        [UIView animateWithDuration:0.25f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            _tabView.frame = newTabFrame;
//        } completion:^(BOOL finished) {
//        }];
//    }
//    else {
//        _tabView.frame = newTabFrame;
//    }
//}


#pragma mark -

- (void)updateTabBar {
    [_tabButtons makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _tabButtons = nil;
    if (_viewControllers.count == 0) {
        return;
    }

    NSMutableArray *buttons = [NSMutableArray array];
    [_viewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger index, BOOL *stop) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:controller.tabBarItem.image forState:UIControlStateNormal];
        [button setImage:controller.tabBarItem.dsl_selectedImage forState:UIControlStateSelected];
        [button setImage:controller.tabBarItem.dsl_selectedImage forState:UIControlStateSelected | UIControlStateHighlighted];
        [button addTarget:self action:@selector(didTapTabBarButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabView addSubview:button];
        
        [buttons addObject:button];
    }];
    
    _tabButtons = buttons;
    [self layoutTabBarButtons];
    
    self.selectedControllerIndex = self.selectedControllerIndex;
}

- (void)layoutTabBarButtons {
    CGFloat buttonWidth = _tabView.bounds.size.width / _tabButtons.count;
    
    [_tabButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger index, BOOL *stop) {
        CGRect frame = CGRectZero;
        frame.origin.x = buttonWidth * index;
        frame.size.width = buttonWidth;
        frame.size.height = _tabView.bounds.size.height;
        
        button.frame = CGRectIntegral(frame);
    }];
}

- (void)didTapTabBarButton:(id)sender {
    __block NSUInteger tappedIndex = NSNotFound;
    [_tabButtons enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        if (obj == sender) {
            tappedIndex = index;
            *stop = YES;
        }
    }];
    
    if (tappedIndex != NSNotFound) {
        if (tappedIndex != self.selectedControllerIndex) {
            self.selectedControllerIndex = tappedIndex;
        }
        else {
            UIViewController *tappedController = [_viewControllers objectAtIndex:tappedIndex];
            if ([tappedController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navigationController = (UINavigationController*)tappedController;
                [navigationController popToRootViewControllerAnimated:YES];
            }
        }
    }
}

@end


@implementation UIViewController (DSLTabBarController)

- (void)dsl_presentModalViewController:(UIViewController*)controller animated:(BOOL)animated {
    id rootViewController = [[[UIApplication sharedApplication] keyWindow] rootViewController];

    if ([rootViewController isKindOfClass:[DSLTabBarController class]]) {
        [rootViewController presentModalViewController:controller animated:animated];
    }
    else {
        [self presentModalViewController:controller animated:animated];
    }
}

@end
