//
//  AddSampleViewController.h
//  Oberobergeil
//
//  Created by Albrecht Oster on 21.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AddSampleViewController : UITableViewController <UITextFieldDelegate>
{
    AVAudioRecorder *_recorder;
    NSNumberFormatter *_durationFormatter;
    BOOL _hasRecorded;
}

@property (retain, nonatomic) IBOutlet UILabel *recordingDurationLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *recordingProgress;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (retain, nonatomic) IBOutlet UITextField *nameField;

@end
