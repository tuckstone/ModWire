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
#import "DraggableIcon.h"

@class TouchForwardingUIScrollView;
@class PGMidi;

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    PdDispatcher *dispatcher;
    void *patch;
    PGMidi *midi;
    
@private
    TouchForwardingUIScrollView* keyboardScrollView;
    KeyboardView* keyboardView;
    NSMutableArray *icons;
    UITableView *paletteTable;
    NSUInteger i;
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

@property (nonatomic, strong) PGMidi *midi;

@property (nonatomic) NSMutableSet *currIcons;

@property (nonatomic) NSMutableSet *currPaths;

@property (nonatomic) IBOutlet UIView * workView;

@property (nonatomic) DraggableIcon *soundStart;

@property (nonatomic) DraggableIcon *soundEnd;

- (IBAction)buttonPressed:(id)sender;

- (IBAction)iconPressed:(id)sender;

-(IBAction)buildSound:(id)sender;

- (void)noteOn:(int)note;
- (void)noteOff:(int)note;
- (IBAction)setFilterCutoffFreq:(id)sender;
- (IBAction)setOscDetune:(id)sender;
- (void) defineIconDictionary;
@end
