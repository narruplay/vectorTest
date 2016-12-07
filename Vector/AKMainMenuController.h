//
//  AKMainMenuController.h
//  Vector
//
//  Created by Adel Khaziakhmetov on 06.12.16.
//  Copyright © 2016 matrix.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface AKMainMenuController : NSObject

@property (strong, nonatomic) UIView *partialMainMenuView;
@property (strong, nonatomic) UIView *fullMainMenuView;
@property (strong, nonatomic) UIViewController *presentingController;

@property (assign, nonatomic) BOOL isPresented;
@property (assign, nonatomic) BOOL isHidden;

+(AKMainMenuController *) sharedController;

-(void) presentMainMenuWithAnimation;

-(void) hideMainMenuWithAnimation;

-(void) presentFullMainMenuController;

-(void) presentFullMainMenuControllerWithAnimation;

-(void) hideFullMainMenuController;

-(void) hideFullMainMenuControllerWithAnimation;

@end
