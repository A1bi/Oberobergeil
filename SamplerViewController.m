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

#define MAX_SAMPLE_COLUMNS 4
#define SAMPLE_MARGIN_RATIO .2

@interface SamplerViewController ()

- (void)addSampleViewForSample:(Sample *)sample;
- (void)sampleViewTapped:(SamplerSampleView *)sampleView;

@end

@implementation SamplerViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _samples = [[NSMutableDictionary alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Sample"];
    NSArray *samples = [_managedObjectContext executeFetchRequest:request error:nil];
    for (Sample *sample in samples) {
        [self addSampleViewForSample:sample];
    }
}

- (void)dealloc
{
    [_samples release];
    [super dealloc];
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

- (void)sampleViewTapped:(SamplerSampleView *)sampleView
{
    Sample *sample = _samples[[NSValue valueWithNonretainedObject:sampleView]];
    if (!sample.player.playing) {
        [sample.player play];
        [sampleView spinWithDuration:sample.duration];
    }
}

- (void)addSampleViewForSample:(Sample *)sample
{
    CGFloat columnWidth = self.view.bounds.size.width / MAX_SAMPLE_COLUMNS,
            marginWidth = columnWidth * SAMPLE_MARGIN_RATIO,
            sampleWidth = columnWidth - marginWidth - marginWidth / MAX_SAMPLE_COLUMNS;
    NSInteger numberOfSamples = _samples.allKeys.count,
              column = numberOfSamples % MAX_SAMPLE_COLUMNS,
              row = numberOfSamples / MAX_SAMPLE_COLUMNS;
    
    CGRect sampleRect;
    sampleRect.size = CGSizeMake(sampleWidth, sampleWidth);
    sampleRect.origin = CGPointMake(column * (sampleWidth + marginWidth) + marginWidth, row * columnWidth + marginWidth + 100);
    
    SamplerSampleView *sampleView = [[SamplerSampleView alloc] initWithFrame:sampleRect];
    sampleView.nameLabel.text = sample.name;
    [sampleView addTarget:self action:@selector(sampleViewTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sampleView];
    
    _samples[[NSValue valueWithNonretainedObject:sampleView]] = sample;
}

#pragma mark AddSampleViewController delegate

- (void)addSampleViewController:(AddSampleViewController *)controller didFinishWithSample:(Sample *)sample
{
    if (sample) {
        NSError *error = nil;
        [sample.managedObjectContext save:&error];
        
        [self addSampleViewForSample:sample];
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
