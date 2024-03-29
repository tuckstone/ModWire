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
#import "PathView.h"

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
    UITableView *paletteTable;
    NSUInteger i;
}

@property (strong, nonatomic) NSMutableArray *icons;

@property (strong, nonatomic) IBOutlet UITableView *paletteTable;

@property (nonatomic, retain) IBOutlet UIScrollView *keyboardScrollView;

@property (nonatomic, retain) IBOutlet UIView *optionView;

@property (nonatomic) IBOutlet UILabel *connectionLabel;

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

@property (nonatomic) DraggableIcon * selectedicon;

@property (nonatomic) DraggableIcon *soundStart;

@property (nonatomic) DraggableIcon *soundEnd;

@property (nonatomic) PathView *clearView;

@property (nonatomic) BOOL editMode;

@property NSInteger traverserCount;

@property (nonatomic, strong) NSString *theButton;

- (IBAction)buttonPressed:(id)sender;

-(void)buildSound;

-(void) showKeyboardView;

-(void) showControlView;

-(NSInteger) buildAndTraverse:(DraggableIcon*)icon;

-(IBAction) sliderChanged:(id)sender;

- (void)noteOn:(int)note;
- (void)noteOff:(int)note;
- (void) defineIconDictionary;
@end
