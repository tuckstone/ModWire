//
//  AppDelegate.h
//  ModWire
//
//  Created by Jessica Noble on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PdAudioController.h"

@class ViewController;
@class PGMidi;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow *window;
    PGMidi *midi;
    ViewController *viewController;
}

@property (retain, nonatomic) IBOutlet UIWindow *window;

@property (retain, nonatomic) IBOutlet ViewController *viewController;

@property (strong, nonatomic, readonly) PdAudioController *audioController;

@end
