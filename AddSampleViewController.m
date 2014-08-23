//
//  AddSampleViewController.m
//  Oberobergeil
//
//  Created by Albrecht Oster on 21.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "AddSampleViewController.h"
#import "Sample.h"

#define MAX_RECORDING_DURATION 30

@interface AddSampleViewController ()

@property (retain, nonatomic) IBOutlet UILabel *recordingDurationLabel;
@property (retain, nonatomic) IBOutlet UIProgressView *recordingProgress;
@property (retain, nonatomic) IBOutlet UIBarButtonItem *saveBtn;
@property (retain, nonatomic) IBOutlet UITextField *nameField;

- (void)updateRecordingDuration;
- (void)updateRecordingDurationAndScheduleNextUpdate;
- (void)cancelRecordingDurationUpdating;

@end

@implementation AddSampleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", [[NSProcessInfo processInfo] globallyUniqueString], @"recording.m4a"];
    _tmpSampleURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:fileName]];
    
    NSDictionary *settings = @{ AVEncoderAudioQualityKey: @(AVAudioQualityHigh), AVEncoderBitRateKey: @(16), AVNumberOfChannelsKey: @(2), AVSampleRateKey: @(44100), AVFormatIDKey: @(kAudioFormatAppleLossless) };
    
    NSError *error = nil;
    _recorder = [[AVAudioRecorder alloc] initWithURL:_tmpSampleURL settings:settings error:&error];
    if (error) {
        NSLog(@"error: %@", [error localizedDescription]);
    } else {
        [_recorder prepareToRecord];
    }
    
    _durationFormatter = [[NSNumberFormatter alloc] init];
    _durationFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    _durationFormatter.minimumFractionDigits = 1;
    _durationFormatter.maximumFractionDigits = 1;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateRecordingDuration];
}

- (void)dealloc
{
    [_recordingProgress release];
    [_recordingDurationLabel release];
    [_saveBtn release];
    [_nameField release];
    [_durationFormatter release];
    [super dealloc];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)dismiss
{
    [_recorder deleteRecording];
    [_delegate addSampleViewController:self didFinishWithSample:nil];
}

- (IBAction)save
{
    NSError *error = nil;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *dst = [manager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:&error];
    dst = [dst URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.caf", [NSProcessInfo processInfo].globallyUniqueString]];
    
    if (!error) {
        [manager moveItemAtURL:_tmpSampleURL toURL:dst error:&error];
        if (!error) {
            Sample *sample = [NSEntityDescription insertNewObjectForEntityForName:@"Sample" inManagedObjectContext:_managedObjectContext];
            sample.url = [NSString stringWithFormat:@"%@", dst];
            sample.name = _nameField.text;
            
            [_delegate addSampleViewController:self didFinishWithSample:sample];
        }
    }
}

- (IBAction)startRecording
{
    [self.view endEditing:YES];
    
    [_recorder recordForDuration:MAX_RECORDING_DURATION];
    
    _hasRecorded = NO;
    [self updateSaveBtn];
    [self updateRecordingDurationAndScheduleNextUpdate];
}

- (IBAction)stopRecording
{
    [_recorder stop];
    _hasRecorded = YES;
    [self cancelRecordingDurationUpdating];
    [self updateSaveBtn];
}

- (IBAction)cancelRecording
{
    [self stopRecording];
    [_recorder deleteRecording];
    [self updateRecordingDuration];
}

- (void)updateRecordingDuration
{
    NSString *duration = [_durationFormatter stringFromNumber:[NSNumber numberWithFloat:_recorder.currentTime]];
    [_recordingDurationLabel setText:[NSString stringWithFormat:@"%@ Sek.", duration]];
    [_recordingProgress setProgress:_recorder.currentTime / MAX_RECORDING_DURATION animated:YES];
}

- (void)updateRecordingDurationAndScheduleNextUpdate
{
    [self updateRecordingDuration];
    [self performSelector:@selector(updateRecordingDurationAndScheduleNextUpdate) withObject:nil afterDelay:0.1];
}

- (void)cancelRecordingDurationUpdating
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateRecordingDurationAndScheduleNextUpdate) object:nil];
}

- (IBAction)updateSaveBtn
{
    _saveBtn.enabled = _hasRecorded && _nameField.text.length > 0;
}

@end
