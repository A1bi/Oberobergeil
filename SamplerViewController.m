//
//  SamplerViewController.m
//  Oberobergeil
//
//  Created by Albrecht Oster on 20.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "SamplerViewController.h"
#import "SamplerSampleView.h"

@interface SamplerViewController ()

@end

@implementation SamplerViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SamplerSampleView *sample = [[SamplerSampleView alloc] initWithFrame:CGRectMake(50, 100, 70, 70)];
    sample.nameLabel.text = @"Habt ihr Bock?";
    [self.view addSubview:sample];
}

@end
