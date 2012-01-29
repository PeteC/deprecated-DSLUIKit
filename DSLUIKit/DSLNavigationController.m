/*
 DSLNavigationController.m
 
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


#import "DSLNavigationController.h"

@interface DSLNavigationController()

@property (nonatomic, strong) IBOutlet UINavigationBar *navigationBar;

@end


@implementation DSLNavigationController

@dynamic navigationBar;


#pragma mark - Initialisation

// Designated initialiser
+ (id)navigationController {
    static UINib *nib = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        nib = [UINib nibWithNibName:@"DSLNavigationController" bundle:nil];
    });
    
    NSArray *objects = [nib instantiateWithOwner:nil options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[DSLNavigationController class]]) {
            return object;
        }
    }
    
    return nil;
}

+ (id)navigationControllerWithRootViewController:(UIViewController*)rootController {
    DSLNavigationController *controller = [self navigationController];
    controller.viewControllers = [NSArray arrayWithObject:rootController];
    
    return controller;
}

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    NSAssert(NO, @"DSLNavigationControllers should be created with the navigationController or navigationControllerWithRootViewController class methods");
    return nil;
}

- (DSLNavigationBar*)dsl_navigationBar {
    NSAssert([self.navigationBar isKindOfClass:[DSLNavigationBar class]], @"Instance of DSLNavigationController is not using a DSLNavigationBar. Was it created using one of the designated initialisers?");
    return (DSLNavigationBar*)self.navigationBar;
}

@end
