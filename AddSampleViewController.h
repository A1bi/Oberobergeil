//
//  AddSampleViewController.h
//  Oberobergeil
//
//  Created by Albrecht Oster on 21.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol AddSampleViewControllerDelegate;
@class Sample;

@interface AddSampleViewController : UITableViewController <UITextFieldDelegate>
{
    AVAudioRecorder *_recorder;
    NSNumberFormatter *_durationFormatter;
    NSURL *_tmpSampleURL;
    BOOL _hasRecorded;
}

@property (nonatomic, assign) id <AddSampleViewControllerDelegate> delegate;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

@protocol AddSampleViewControllerDelegate

- (void)addSampleViewController:(AddSampleViewController *)controller didFinishWithSample:(Sample *)sample;

@end