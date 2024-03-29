//
//  SamplerViewController.h
//  Oberobergeil
//
//  Created by Albrecht Oster on 20.08.14.
//  Copyright (c) 2014 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddSampleViewController.h"

@interface SamplerViewController : UIViewController <AddSampleViewControllerDelegate, UIScrollViewDelegate>
{
    NSMutableDictionary *_samples;
    NSArray *_addedSampleViews;
}

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

