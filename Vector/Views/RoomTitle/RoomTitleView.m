/*
 Copyright 2015 OpenMarket Ltd
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "RoomTitleView.h"

#import "VectorDesignValues.h"

#import "MXRoom+Vector.h"

@implementation RoomTitleView

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([RoomTitleView class])
                          bundle:[NSBundle bundleForClass:[RoomTitleView class]]];
}

- (void)dealloc
{
    _roomPreviewData = nil;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.displayNameTextField.textColor = kVectorTextColorBlack;
    
    if (_titleMask)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportTapGesture:)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        [tap setDelegate:self];
        [self.titleMask addGestureRecognizer:tap];
        self.titleMask.userInteractionEnabled = YES;
    }
    
    if (_roomDetailsMask)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reportTapGesture:)];
        [tap setNumberOfTouchesRequired:1];
        [tap setNumberOfTapsRequired:1];
        [tap setDelegate:self];
        [self.roomDetailsMask addGestureRecognizer:tap];
        self.roomDetailsMask.userInteractionEnabled = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.superview)
    {
        // Center horizontally the display name into the navigation bar
        CGRect frame = self.superview.frame;

        // Look for the navigation bar.
        UINavigationBar *navigationBar;
        UIView *superView = self;
        while (superView.superview)
        {
            if ([superView.superview isKindOfClass:[UINavigationBar class]])
            {
                navigationBar = (UINavigationBar*)superView.superview;
                break;
            }
            
            superView = superView.superview;
        }
        
        if (navigationBar)
        {
            CGSize navBarSize = navigationBar.frame.size;
            CGFloat superviewCenterX = frame.origin.x + (frame.size.width / 2);
            
            // Check whether the view is not moving away (see navigation between view controllers).
            if (superviewCenterX < navBarSize.width)
            {
                // Center the display name
                self.displayNameCenterXConstraint.constant = (navBarSize.width / 2) - superviewCenterX;
            }
        }        
    }
}

- (void)setRoomPreviewData:(RoomPreviewData *)roomPreviewData
{
    _roomPreviewData = roomPreviewData;
    
    [self refreshDisplay];
}

- (void)refreshDisplay
{
    [super refreshDisplay];
    
    // Consider in priority the preview data (if any)
    if (self.roomPreviewData)
    {
        self.displayNameTextField.text = self.roomPreviewData.roomName;
    }
    else if (self.mxRoom)
    {
        self.displayNameTextField.text = self.mxRoom.vectorDisplayname;
        if (!self.displayNameTextField.text.length)
        {
            self.displayNameTextField.text = NSLocalizedStringFromTable(@"room_displayname_no_title", @"Vector", nil);
            self.displayNameTextField.textColor = kVectorTextColorGray;
        }
        else
        {
            self.displayNameTextField.textColor = kVectorTextColorBlack;
        }
    }
}

- (void)destroy
{
    self.tapGestureDelegate = nil;
    
    [super destroy];
}

- (void)reportTapGesture:(UITapGestureRecognizer*)tapGestureRecognizer
{
    if (self.tapGestureDelegate)
    {
        [self.tapGestureDelegate roomTitleView:self recognizeTapGesture:tapGestureRecognizer];
    }
}

@end
