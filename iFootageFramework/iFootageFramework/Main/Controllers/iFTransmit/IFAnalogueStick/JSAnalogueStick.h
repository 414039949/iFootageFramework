//
//  JSAnalogueStick.h
//  Controller
//
//  Created by James Addyman on 29/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class  JSAnalogueStick;

@protocol JSAnalogueStickDelegate <NSObject>

@optional
- (void)analogueStickDidChangeValue:(JSAnalogueStick *)analogueStick;

@end

@interface JSAnalogueStick : UIView

@property (nonatomic, readonly) CGFloat xValue;
@property (nonatomic, readonly) CGFloat yValue;
@property (nonatomic, strong)NSTimer * timer;


@property (nonatomic, assign) BOOL invertedYAxis;

@property (nonatomic, assign) IBOutlet id <JSAnalogueStickDelegate> delegate;

@property (nonatomic, readonly) UIImageView *backgroundImageView;
@property (nonatomic, readonly) UIImageView *handleImageView;

@property (nonatomic, assign) BOOL start;//是否开始计时

@property (nonatomic, assign) BOOL isRunning;


@end
