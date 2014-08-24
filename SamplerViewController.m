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

@property (retain, nonatomic) IBOutlet UIScrollView *samplesScroller;

- (NSArray *)addSampleViewsForSamples:(NSArray *)samples;
- (void)popUpSampleViews:(NSArray *)sampleViews;
- (void)sampleViewTapped:(SamplerSampleView *)sampleView;

@end

@implementation SamplerViewController
            
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _samples = [[NSMutableDictionary alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Sample"];
    NSArray *samples = [_managedObjectContext executeFetchRequest:request error:nil];
    NSArray *sampleViews = [self addSampleViewsForSamples:samples];
    [self popUpSampleViews:sampleViews];
}

- (void)dealloc
{
    [_samples release];
    [_samplesScroller release];
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

- (NSArray *)addSampleViewsForSamples:(NSArray *)samples
{
    CGFloat columnWidth = _samplesScroller.bounds.size.width / MAX_SAMPLE_COLUMNS,
            marginWidth = columnWidth * SAMPLE_MARGIN_RATIO,
            sampleWidth = columnWidth - marginWidth - marginWidth / MAX_SAMPLE_COLUMNS;
    NSInteger numberOfSamples = _samples.allKeys.count;
    
    CGRect sampleRect = CGRectMake(0, 0, sampleWidth, sampleWidth);
    
    NSMutableArray *sampleViews = [NSMutableArray array];
    
    for (Sample *sample in samples) {
        NSInteger column = numberOfSamples % MAX_SAMPLE_COLUMNS,
                  row = numberOfSamples / MAX_SAMPLE_COLUMNS;
        
        sampleRect.origin = CGPointMake(column * (sampleWidth + marginWidth) + marginWidth, row * columnWidth + marginWidth);
        
        SamplerSampleView *sampleView = [[SamplerSampleView alloc] initWithFrame:sampleRect];
        sampleView.nameLabel.text = sample.name;
        [sampleView addTarget:self action:@selector(sampleViewTapped:) forControlEvents:UIControlEventTouchUpInside];
        [_samplesScroller addSubview:sampleView];
        [sampleViews addObject:sampleView];
        
        _samples[[NSValue valueWithNonretainedObject:sampleView]] = sample;
        numberOfSamples++;
    }
    
    CGFloat bottom = sampleRect.origin.y + sampleWidth + marginWidth;
    CGSize contentSize = _samplesScroller.contentSize;
    if (contentSize.height < bottom) {
        contentSize.height = bottom;
        _samplesScroller.contentSize = contentSize;
    }
    
    return sampleViews;
}

- (void)popUpSampleViews:(NSArray *)sampleViews
{
    NSTimeInterval delay = 0;
    for (SamplerSampleView *sampleView in sampleViews) {
        [sampleView popUpAfterDelay:delay];
        delay += .03;
    }
}

#pragma mark AddSampleViewController delegate

- (void)addSampleViewController:(AddSampleViewController *)controller didFinishWithSample:(Sample *)sample
{
    [self dismissViewControllerAnimated:YES completion:^{
        if (sample) {
            NSError *error = nil;
            [sample.managedObjectContext save:&error];
            if (error) return;
            
            [_addedSampleViews release];
            _addedSampleViews = [[self addSampleViewsForSamples:@[sample]] retain];
            
            [_samplesScroller setContentOffset:CGPointMake(0, _samplesScroller.contentSize.height - _samplesScroller.bounds.size.height) animated:YES];
        }
    }];
}

#pragma mark scroll view delegate

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (_addedSampleViews) {
        [self popUpSampleViews:_addedSampleViews];
        [_addedSampleViews release];
        _addedSampleViews = nil;
    }
}

@end
