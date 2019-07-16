//
//  JSAnalogueStick.m
//  Controller
//
//  Created by James Addyman on 29/03/2013.
//  Copyright (c) 2013 James Addyman. All rights reserved.
//

#import "JSAnalogueStick.h"

#define RADIUS ([self bounds].size.width / 2)
#define RULELength (sqrt(2) / 2)
@implementation JSAnalogueStick

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self commonInit];
        self.timer=[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delayMethod) userInfo:nil repeats:YES];
        self.timer.fireDate=[NSDate distantFuture];
        
        _start=NO;
        _isRunning = NO;
	}
	
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		[self commonInit];
	}
	
	return self;
}

- (void)commonInit
{
	_backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"analogue_bg"]];
	CGRect backgroundImageFrame = [_backgroundImageView frame];
	backgroundImageFrame.size = [self bounds].size;
	backgroundImageFrame.origin = CGPointZero;
	[_backgroundImageView setFrame:backgroundImageFrame];
	[self addSubview:_backgroundImageView];
	
	_handleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"analogue_handle"]];
	CGRect handleImageFrame = [_handleImageView frame];
	handleImageFrame.size = CGSizeMake([_backgroundImageView bounds].size.width / 1.5,
									   [_backgroundImageView bounds].size.height / 1.5);
	handleImageFrame.origin = CGPointMake(([self bounds].size.width - handleImageFrame.size.width) / 2,
										  ([self bounds].size.height - handleImageFrame.size.height) / 2);
	[_handleImageView setFrame:handleImageFrame];
	[self addSubview:_handleImageView];
	
	_xValue = 0;
	_yValue = 0;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    self.timer.fireDate=[NSDate distantPast];
    _isRunning = YES;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    
    CGFloat normalisedX = (location.x / RADIUS) - 1;
    CGFloat normalisedY = ((location.y / RADIUS) - 1) * -1;
    
    if (normalisedX > 1.0)
    {
        location.x = [self bounds].size.width;
        normalisedX = 1.0;
    }
    else if (normalisedX < -1.0)
    {
        location.x = 0.0;
        normalisedX = -1.0;
    }
    
    if (normalisedY > 1.0)
    {
        location.y = 0.0;
        normalisedY = 1.0;
    }
    else if (normalisedY < -1.0)
    {
        location.y = [self bounds].size.height;
        normalisedY = -1.0;
    }
    
    if (self.invertedYAxis)
    {
        normalisedY *= -1;
    }
    
    _xValue = normalisedX;
    _yValue = normalisedY;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(location.x - ([_handleImageView bounds].size.width / 2),
                                          location.y - ([_handleImageView bounds].size.width / 2));
    [_handleImageView setFrame:handleImageFrame];

    
    
}
- (void)delayMethod{
    
//    NSLog(@"在跑");
    
    if ([self.delegate respondsToSelector:@selector(analogueStickDidChangeValue:)])
    {
        [self.delegate analogueStickDidChangeValue:self];
    }
    

}
- (void)dealloc{

}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
	CGPoint location = [[touches anyObject] locationInView:self];
	
	CGFloat normalisedX = (location.x / RADIUS) - 1;
	CGFloat normalisedY = ((location.y / RADIUS) - 1) * -1;
    NSLog(@"location%f", location.x);
	if (normalisedX > 1.0)
	{
		location.x = [self bounds].size.width;
		normalisedX = 1.0;
	}
	else if (normalisedX < -1.0)
	{
		location.x = 0.0;
		normalisedX = -1.0;
	}
	
	if (normalisedY > 1.0)
	{
		location.y = 0.0;
		normalisedY = 1.0;
	}
	else if (normalisedY < -1.0)
	{
		location.y = [self bounds].size.height;
		normalisedY = -1.0;
	}
	
	if (self.invertedYAxis)
	{
		normalisedY *= -1;
	}
	
    
    CGFloat centerX = location.x - _backgroundImageView.center.x;
    CGFloat centerY = location.y - _backgroundImageView.center.y;
    if (centerX < 0) {
        centerX *= -1;
    }
    if (centerY < 0) {
        centerY *= -1;
    }
    if (sqrt(centerX*centerX + centerY*centerY) >= _backgroundImageView.frame.size.width / 2) {
        
        CGFloat X = location.x - _backgroundImageView.center.x;
        CGFloat Y = location.y - _backgroundImageView.center.y;
        
        CGFloat temp = centerY / centerY;
        CGFloat total = sqrt(X*X + Y*Y);
        CGFloat small = total - _backgroundImageView.frame.size.width / 2;
        CGFloat smallY = sqrt(small * small / (temp * temp + 1));
        CGFloat smallX = smallY * temp;
        
        if (location.x > _backgroundImageView.center.x && location.y > _backgroundImageView.center.y){
            _handleImageView.center = CGPointMake(location.x - smallX, location.y - smallY);
        }else if (location.x > _backgroundImageView.center.x && location.y < _backgroundImageView.center.y) {
            _handleImageView.center = CGPointMake(location.x - smallX, location.y + smallY);
        }else if (location.x < _backgroundImageView.center.x && location.y > _backgroundImageView.center.y) {
            _handleImageView.center = CGPointMake(location.x + smallX, location.y - smallY);
        }else if (location.x < _backgroundImageView.center.x && location.y < _backgroundImageView.center.y) {
            _handleImageView.center = CGPointMake(location.x + smallX, location.y + smallY);
        }
        
    }else{
        _handleImageView.center = location;
    }
    
    
    
    _xValue = (_handleImageView.center.x - RADIUS) / RADIUS;
    _yValue = -(_handleImageView.center.y - RADIUS) / RADIUS;
    if (_xValue > 0.999) {
        _xValue = 1.0000;
    }
    if (_xValue < -0.9999) {
        _xValue = -1.0000;
    }
    if (_yValue > 0.999) {
        _yValue = 1.0000;
    }
    if (_yValue < -0.999) {
        _yValue = -1.0000;
    }
    
    /**
     *  x， y 到圆形的距离
     */
    CGFloat xlen;
    CGFloat ylen;
    
    /**
     *  x ， y  斜率
     */
    CGFloat ifx;
    CGFloat ify;
    /**
     * 坐标点
     */
    CGFloat handXValue = _handleImageView.center.x;
    CGFloat handYValue = _handleImageView.center.y;
    CGFloat bgcenterX = _backgroundImageView.center.x;
    CGFloat bgcenterY = _backgroundImageView.center.y;
    
    
    ifx = (handYValue - bgcenterY) / (handXValue - bgcenterX);
    ify = (handXValue - bgcenterX) / (handYValue - bgcenterY);
#pragma mark --------判断 X  Y 临界点
    /**
     *  X轴的取值方法
     */
    if (fabs(ifx) <= 1.00) {
        xlen = sqrt(pow( (bgcenterY - handYValue), 2) + pow((bgcenterX - handXValue), 2)) / RADIUS;
        if ((handXValue - bgcenterX) < 0) {
            if (fabs(xlen) > 1.00) {
                xlen = 1.00;
            }
            xlen = -xlen;
        }
        
        //        NSLog(@"%f", _yValue);
    }else{
        xlen = _xValue / (RULELength * 0.8);
        if (xlen >= 1.000) {
            xlen = 1.000;
        }
        if (xlen <= -1.000) {
            xlen = -1.000;
        }
    }
    _xValue = xlen;
    
    
    /**
     *  Y轴的取值方法
     */
    if (fabs(ify) < 1.00) {
        ylen = sqrt(pow( (bgcenterX - handXValue), 2) + pow((bgcenterY - handYValue), 2)) / RADIUS;
        if ((handYValue - bgcenterY) > 0) {
            if (fabs(ylen) > 1.00) {
                ylen = 1.00;
            }
            ylen = -ylen;
        }
        
        
    }else{
        ylen = _yValue / (RULELength * 0.8);
        if (ylen >= 1.000) {
            ylen = 1.000;
        }
        if (ylen <= -1.000) {
            ylen = -1.000;
        }
    }
    _yValue = ylen;
#pragma mark --------
  //  [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0f];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	_xValue = 0.0;
	_yValue = 0.0;
    _isRunning = NO;
    
	CGRect handleImageFrame = [_handleImageView frame];
	handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) / 2,
										  ([self bounds].size.height - [_handleImageView bounds].size.height) / 2);
	[_handleImageView setFrame:handleImageFrame];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded");
  
    _isRunning = NO;
    
    _xValue = 0.0;
    _yValue = 0.0;
    
    CGRect handleImageFrame = [_handleImageView frame];
    handleImageFrame.origin = CGPointMake(([self bounds].size.width - [_handleImageView bounds].size.width) / 2,
                                          ([self bounds].size.height - [_handleImageView bounds].size.height) / 2);
    [_handleImageView setFrame:handleImageFrame];
    [self performSelector:@selector(delayTimer) withObject:nil afterDelay:0.1f];

}
- (void)delayTimer{
    
    self.start = NO;
    self.timer.fireDate=[NSDate distantFuture];
}

@end
