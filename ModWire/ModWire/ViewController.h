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
#import "PdDispatcher.h"


@class TouchForwardingUIScrollView;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    PdDispatcher *dispatcher;
    void *patch;
    
@private
    TouchForwardingUIScrollView* keyboardScrollView;
    KeyboardView* keyboardView;
    NSMutableArray *icons;
    UITableView *paletteTable;
    NSUInteger i;

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

@property (nonatomic, retain) IBOutlet UIView *optionView;

@property (nonatomic, retain) UIButton *currButton;

@property (nonatomic, retain) UIButton *iconButton;

@property (nonatomic, retain) IBOutlet UILabel *label1;

@property (nonatomic, retain) IBOutlet UILabel *label2;

@property (nonatomic, retain) IBOutlet UISlider *slider1;

@property (nonatomic, retain) IBOutlet UISlider *slider2;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)iconPressed:(id)sender;

- (void)noteOn:(int)note;
- (void)noteOff:(int)note;
- (IBAction)setFilterCutoffFreq:(id)sender;
- (IBAction)setOscDetune:(id)sender;
- (void) defineIconDictionary;

@end
