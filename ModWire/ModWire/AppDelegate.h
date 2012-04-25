//
//  AppDelegate.h
//  ModWire
//
//  Created by Lion User on 01/04/2012.
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

@property (strong, nonatomic) IBOutlet UIWindow *window;

@property (strong, nonatomic) IBOutlet ViewController *viewController;

@property (strong, nonatomic, readonly) PdAudioController *audioController;

@end
