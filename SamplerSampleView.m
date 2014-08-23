//
//  SamplerSampleView.m
//  Oberobergeil
//
//  Created by Albrecht Oster on 20.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "SamplerSampleView.h"

@interface SamplerSampleView ()

- (void)addNameLabel;
- (void)addCircle;
- (void)tapped;

@end

@implementation SamplerSampleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addCircle];
        [self addNameLabel];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

- (void)dealloc
{
    [_nameLabel release];
    [_circleLayer release];
    [super dealloc];
}

- (void)spinWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation *circle = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    circle.fromValue = @(0);
    circle.toValue = @(1);
    
    CAKeyframeAnimation *alpha = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    alpha.values = @[@(1), @(.5), @(1)];
    alpha.keyTimes = @[@(0), @(0.05), @(1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = duration;
    group.animations = @[circle, alpha];
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [_circleLayer addAnimation:group forKey:@"spinAnimation"];
}

- (void)addNameLabel
{
    CGRect rect = CGRectMake(self.bounds.size.width * .1, self.bounds.size.height * .1, self.bounds.size.width * .8, self.bounds.size.height * .8);
    _nameLabel = [[UILabel alloc] initWithFrame:rect];
    
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.numberOfLines = 0;
    _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self addSubview:_nameLabel];
}

- (void)addCircle
{
    CGSize size = self.bounds.size;
    CGFloat lineWidth = 5;
    
    _circleLayer = [[CAShapeLayer layer] retain];
    _circleLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width - lineWidth * 2, size.height - lineWidth * 2) cornerRadius:size.height / 2].CGPath;
    
    _circleLayer.position = CGPointMake(lineWidth, lineWidth);
    CGColorRef color = [UIColor colorWithRed:59/255.0 green:187/255.0 blue:1 alpha:1].CGColor;
    _circleLayer.strokeColor = color;
    _circleLayer.lineWidth = lineWidth;
    
    [self.layer addSublayer:_circleLayer];
}

- (void)tapped
{
    [self spinWithDuration:3];
}

@end
