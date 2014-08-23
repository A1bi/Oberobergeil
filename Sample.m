//
//  Sample.m
//  Oberobergeil
//
//  Created by Albrecht Oster on 23.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import "Sample.h"


@implementation Sample

@dynamic name;
@dynamic url;
@dynamic createdAt;

- (void)awakeFromInsert
{
    self.createdAt = [NSDate dateWithTimeIntervalSinceNow:0];
}

@end
