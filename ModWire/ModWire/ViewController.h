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
  
@private
    TouchForwardingUIScrollView* keyboardScrollView;
    KeyboardView* keyboardView;
    NSMutableArray *icons;
    UITableView *paletteTable;

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

@property (strong, nonatomic) UITableView *paletteTable;

@property (nonatomic, retain) IBOutlet UIScrollView *keyboardScrollView;

@property (nonatomic, retain) IBOutlet UIView *optionView;

@property (nonatomic, retain) UIButton *currButton;

- (IBAction)buttonPressed:(id)sender;

- (void)noteOn:(int)note;
- (void)noteOff:(int)note;

- (void) defineIconDictionary;

@end
