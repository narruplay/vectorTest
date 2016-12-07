//
//  AKMainMenuController.m
//  Vector
//
//  Created by Adel Khaziakhmetov on 06.12.16.
//  Copyright © 2016 matrix.org. All rights reserved.
//

#import "AKMainMenuController.h"


@implementation AKMainMenuController
{
    UISwipeGestureRecognizer *swipeGesture;
}

+(AKMainMenuController *) sharedController{
    static AKMainMenuController * menuController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        menuController = [AKMainMenuController new];
    });
    return menuController;
}

-(void) setPresentingController:(UIViewController *) presentingController{
    _presentingController = presentingController;
    if (presentingController){
        [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification  object:nil];
        
        [self orientationChanged:nil];
        
        //[self addObserver:presentingController forKeyPath:@"view.frame" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial context:nil];
    }
}

-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"view.frame"]){
        self.fullMainMenuView.frame = self.presentingController.view.frame;
    }
}

-(void) addGestureRecognizer{
    if (!swipeGesture){
        swipeGesture = [UISwipeGestureRecognizer new];
        swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
        [swipeGesture addTarget:self action:@selector(gestureHandler:)];
    }
    
    [self.presentingController.view addGestureRecognizer:swipeGesture];
}

-(void) removeGestureRecognizer{
    if (swipeGesture && self.presentingController){
        [self.presentingController.view removeGestureRecognizer:swipeGesture];
        if (self.isPresented){
            [self.partialMainMenuView removeFromSuperview];
        }
    }
}

-(void) gestureHandler:(UISwipeGestureRecognizer *) gesture{
    if (![AKMainMenuController sharedController].isPresented &&
        [[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationLandscapeLeft &&
        [[UIApplication sharedApplication] statusBarOrientation] != UIInterfaceOrientationLandscapeRight){
        [[AKMainMenuController sharedController] presentMainMenuWithAnimation];
    }
}

-(void) orientationChanged:(NSNotification *)notification{
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight ||
        [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationUnknown){
        [self presentFullMainMenuController];
    }else{
        [self hideFullMainMenuController];
    }
}

-(void) presentMainMenuWithAnimation{
    
    self.partialMainMenuView = [[NSBundle mainBundle] loadNibNamed:@"PartialMainMenuView" owner:self options:nil].firstObject;
    
    UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
    self.partialMainMenuView.frame = currentWindow.bounds;
    [currentWindow addSubview:self.partialMainMenuView];

    self.partialMainMenuView.center = CGPointMake(-self.partialMainMenuView.center.x, self.partialMainMenuView.center.y);
    
    UITapGestureRecognizer * gesture = [UITapGestureRecognizer new];
    [gesture addTarget:self action:@selector(tapGestureHandler:)];
    [self.partialMainMenuView addGestureRecognizer:gesture];
    
    [UIView animateWithDuration:1.0 animations:^{
        self.partialMainMenuView.center = CGPointMake(-self.partialMainMenuView.center.x, self.partialMainMenuView.center.y);
    } completion:^(BOOL finished) {
        self.isPresented = true;
        NSLog(@"Main menu is showed");
    }];
}

-(void) hideMainMenuWithAnimation{
    [UIView animateWithDuration:1.0 animations:^{
        self.partialMainMenuView.center = CGPointMake(-self.partialMainMenuView.center.x, self.partialMainMenuView.center.y);
    } completion:^(BOOL finished) {
        NSLog(@"Main menu is hidden");
        self.isPresented = false;
        [self.partialMainMenuView removeFromSuperview];
        self.partialMainMenuView = nil;
    }];
}

-(void) presentFullMainMenuController{
    [self removeGestureRecognizer];

    if (self.isHidden == false && [NSStringFromClass(self.presentingController.class) isEqualToString:@"HomeViewController"]){
        self.fullMainMenuView = [[NSBundle mainBundle] loadNibNamed:@"FullMainMenuView" owner:self options:nil].firstObject;
        self.fullMainMenuView.frame = self.presentingController.view.bounds;
        [[UIApplication sharedApplication].keyWindow addSubview:self.fullMainMenuView];
    }
}

-(void) presentFullMainMenuControllerWithAnimation{
    [self removeGestureRecognizer];
    
    if (self.isHidden == false && [NSStringFromClass(self.presentingController.class) isEqualToString:@"HomeViewController"]){
        self.fullMainMenuView = [[NSBundle mainBundle] loadNibNamed:@"FullMainMenuView" owner:self options:nil].firstObject;
        self.fullMainMenuView.frame = self.presentingController.view.bounds;
        
        self.fullMainMenuView.center = CGPointMake(-self.fullMainMenuView.center.x, self.fullMainMenuView.center.y);
        [[UIApplication sharedApplication].keyWindow addSubview:self.fullMainMenuView];
        [UIView animateWithDuration:0.5 animations:^{
            self.fullMainMenuView.center = CGPointMake(-self.fullMainMenuView.center.x, self.fullMainMenuView.center.y);
        } completion:^(BOOL finished) {
            NSLog(@"Main menu is showed");
        }];
    }
}

-(void) hideFullMainMenuController{
    [self addGestureRecognizer];
    
    [self.fullMainMenuView removeFromSuperview];
}

-(void) hideFullMainMenuControllerWithAnimation{
    [self addGestureRecognizer];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.fullMainMenuView.center = CGPointMake(-self.fullMainMenuView.center.x, self.fullMainMenuView.center.y);
    } completion:^(BOOL finished) {
        NSLog(@"Main menu is hidden");
        [self.fullMainMenuView removeFromSuperview];
    }];

}

-(void) tapGestureHandler:(UITapGestureRecognizer *) gesture{
    CGPoint touchPoint = [gesture locationInView:self.partialMainMenuView];
    if ([self.partialMainMenuView hitTest:touchPoint withEvent:nil].tag == 1){
        [self hideMainMenuWithAnimation];
    }
    
}

@end
