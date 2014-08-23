//
//  Sample.h
//  Oberobergeil
//
//  Created by Albrecht Oster on 23.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AVAudioPlayer;

@interface Sample : NSManagedObject

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSDate *createdAt;
@property (nonatomic, readonly) AVAudioPlayer *player;
@property (nonatomic, readonly) NSTimeInterval duration;

@end
