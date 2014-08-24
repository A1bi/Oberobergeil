//
//  SamplerSampleView.h
//  Oberobergeil
//
//  Created by Albrecht Oster on 20.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SamplerSampleView : UIControl
{
    CAShapeLayer *_circleLayer;
}

@property (nonatomic, readonly) UILabel *nameLabel;

- (void)spinWithDuration:(NSTimeInterval)duration;
- (void)popUpAfterDelay:(NSTimeInterval)delay;

@end
