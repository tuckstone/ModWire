//
//  ViewController.h
//  ModWire
//
//  Created by Jessica Noble on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardView.h"
#import "icon.h"


@class TouchForwardingUIScrollView;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    NSMutableArray *icons;
@private
    TouchForwardingUIScrollView* keyboardScrollView;
    KeyboardView* keyboardView;

/* UIScrollView* controlScrollView;
UIPageControl* controlPageControl;

OscillatorView* oscillatorView;
OscillatorDetailView* oscillatorDetailView;
ModulationView* modulationView;
FilterView* filterView;
EnvelopeView* envelopeView;
EnvelopeView* filterEnvelopeView;
ArpeggioView* arpeggioView;

// Synthesizer components
AudioOutput* output;
synth::Controller* controller_;

AudioStreamBasicDescription outputFormat;
 */
}

@property (strong, nonatomic) IBOutlet UITableView *paletteTable;

@property (nonatomic, retain) IBOutlet UIScrollView *keyboardScrollView;

- (IBAction)buttonPressed:(id)sender;

- (void)noteOn:(int)note;
- (void)noteOff:(int)note;

@end
