//
//  SamplerViewController.m
//  Oberobergeil
//
//  Created by Albrecht Oster on 20.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "SamplerViewController.h"
#import "SamplerSampleView.h"
#import "Sample.h"

@interface SamplerViewController ()

@end

@implementation SamplerViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    
    SamplerSampleView *sample = [[SamplerSampleView alloc] initWithFrame:CGRectMake(50, 100, 70, 70)];
    sample.nameLabel.text = @"Habt ihr Bock?";
    [self.view addSubview:sample];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddSampleSegue"]) {
        UINavigationController *nav = (UINavigationController *)segue.destinationViewController;
        AddSampleViewController *adder = (AddSampleViewController *)nav.topViewController;
        adder.delegate = self;
        adder.managedObjectContext = _managedObjectContext;
    }
}

#pragma mark AddSampleViewController delegate

- (void)addSampleViewController:(AddSampleViewController *)controller didFinishWithSample:(Sample *)sample
{
    NSError *error = nil;
    [sample.managedObjectContext save:&error];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
