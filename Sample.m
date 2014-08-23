//
//  Sample.m
//  Oberobergeil
//
//  Created by Albrecht Oster on 23.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "Sample.h"
#import <AVFoundation/AVFoundation.h>

@interface Sample ()

- (void)updatePlayer;

@end

@implementation Sample

@dynamic name;
@dynamic url;
@dynamic createdAt;
@synthesize player = _player;

- (void)awakeFromInsert
{
    self.createdAt = [NSDate dateWithTimeIntervalSinceNow:0];
    
    [self addObserver:self forKeyPath:@"url" options:0 context:nil];
}

- (void)awakeFromFetch
{
    [self updatePlayer];
}

- (NSTimeInterval)duration
{
    return _player.duration;
}

- (void)didTurnIntoFault
{
    [_player release];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"url"]) {
        [self updatePlayer];
    }
}

- (void)updatePlayer
{
    [_player release];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:self.url] error:nil];
    [_player prepareToPlay];
}

@end
