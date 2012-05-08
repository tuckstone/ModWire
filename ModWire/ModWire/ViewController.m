//
//  ViewController.m
//  ModWire
//
//  Created by Jessica Noble on 3/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "KeyboardView.h"
#import "TouchForwardingUIScrollView.h"
#import "icon.h"
#import "CoreMidi/CoreMidi.h"
#import "PGMidi.h"
#import "iOSVersionDetection.h"
#import "PathView.h"
#import "Control.h"

//patch costants
NSString *canvas_string = @"#N canvas 494 239 450 300 10;\r";
NSString *audio_out_string = @"#N canvas 0 22 450 300 audio_out 0;\r#X obj 160 110 hip~ 1;\r#X obj 169 161 dac~;\r#X obj 165 53 inlet~;\r#X connect 0 0 1 0;\r#X connect 0 0 1 1;\r#X connect 2 0 0 0;\r#X restore 205 61 pd audio_out;\r";
NSString *sine_wave_string = @"#N canvas 631 239 450 300 sine_wave 0;\r#X obj 95 76 mtof;\r#X obj 98 168 osc~ 220;\r#X obj 95 36 r notein;\r#X obj 253 9 r detune;\r#X obj 102 226 outlet~;\r#X obj 298 66 / 127;\r#X obj 309 105 + 0.5;\r#X obj 179 140 *;\r#X connect 0 0 7 0;\r#X connect 1 0 4 0;\r#X connect 2 0 0 0;\r#X connect 3 0 5 0;\r#X connect 5 0 6 0;\r#X connect 6 0 7 1;\r#X connect 7 0 1 0;\r#X restore 176 117 pd sine_wave;\r";
NSString *sine_5_string = @"#N canvas 631 239 450 300 sine_wave5 0;\r#X obj 95 76 mtof;\r#X obj 98 168 osc~ 220;\r#X obj 120 16 r notein;\r#X obj 253 9 r detune;\r#X obj 102 226 outlet~;\r#X obj 298 66 / 127;\r#X obj 309 105 + 0.5;\r#X obj 179 140 *;\r#X obj 113 51 + 7;\r#X connect 0 0 7 0;\r#X connect 1 0 4 0;\r#X connect 2 0 8 0;\r#X connect 3 0 5 0;\r#X connect 5 0 6 0;\r#X connect 6 0 7 1;\r#X connect 7 0 1 0;\r#X connect 8 0 0 0;\r#X restore 176 117 pd sine_wave5;\r";
NSString *saw_wave_string = @"#N canvas 773 203 450 300 saw_wave 0;\r#X obj 97 164 phasor~ 220;\r#X obj 95 76 mtof;\r#X obj 256 15 r detune;\r#X obj 61 15 r notein;\r#X obj 84 255 outlet~;\r#X obj 183 124 *;\r#X obj 286 70 / 127;\r#X obj 305 105 + 0.5;\r#X obj 258 203 -~ 0.5;\r#X obj 278 246 *~ 2;\r#X connect 0 0 8 0;\r#X connect 1 0 5 0;\r#X connect 2 0 6 0;\r#X connect 3 0 1 0;\r#X connect 5 0 0 0;\r#X connect 6 0 7 0;\r#X connect 7 0 5 1;\r#X connect 8 0 9 0;\r#X connect 9 0 4 0;\r#X restore 200 129 pd saw_wave;\r";
NSString *saw_5_string = @"#N canvas 773 203 450 300 saw_wave5 0;\r#X obj 97 164 phasor~ 220;\r#X obj 95 76 mtof;\r#X obj 256 15 r detune;\r#X obj 61 15 r notein;\r#X obj 84 255 outlet~;\r#X obj 183 124 *;\r#X obj 286 70 / 127;\r#X obj 305 105 + 0.5;\r#X obj 258 203 -~ 0.5;\r#X obj 278 246 *~ 2;\r#X obj 102 44 + 7;\r#X connect 0 0 8 0;\r#X connect 1 0 5 0;\r#X connect 2 0 6 0;\r#X connect 3 0 10 0;\r#X connect 5 0 0 0;\r#X connect 6 0 7 0;\r#X connect 7 0 5 1;\r#X connect 8 0 9 0;\r#X connect 9 0 4 0;\r#X connect 10 0 1 0;\r#X restore 200 129 pd saw_wave5;\r";
NSString *square_wave_string = @"#N canvas 169 99 458 480 square_wave 1;\r#X obj 95 76 mtof;\r#X obj 256 15 r detune;\r#X obj 61 15 r notein;\r#X obj 160 448 outlet~;\r#X obj 183 124 *;\r#X obj 286 70 / 127;\r#X obj 305 105 + 0.5;\r#X obj 192 341 -~;\r#X msg 273 200 0;\r#X obj 270 173 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 303 261 + 0.5;\r#X obj 109 279 phasor~ 220;\r#X obj 229 287 phasor~ 220;\r#X connect 0 0 4 0;\r#X connect 1 0 5 0;\r#X connect 2 0 0 0;\r#X connect 4 0 11 0;\r#X connect 4 0 9 0;\r#X connect 4 0 12 0;\r#X connect 5 0 6 0;\r#X connect 6 0 4 1;\r#X connect 7 0 3 0;\r#X connect 8 0 10 0;\r#X connect 8 0 11 1;\r#X connect 9 0 8 0;\r#X connect 10 0 12 1;\r#X connect 11 0 7 0;\r#X connect 12 0 7 1;\r#X restore 163 63 pd square_wave;\r";
NSString *square_5_string = @"#N canvas 169 99 458 480 square_wave5 0;\r#X obj 95 76 mtof;\r#X obj 256 15 r detune;\r#X obj 61 15 r notein;\r#X obj 160 448 outlet~;\r#X obj 183 124 *;\r#X obj 286 70 / 127;\r#X obj 305 105 + 0.5;\r#X obj 192 341 -~;\r#X msg 273 200 0;\r#X obj 270 173 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 303 261 + 0.5;\r#X obj 109 279 phasor~ 220;\r#X obj 229 287 phasor~ 220;\r#X obj 164 52 + 7;\r#X connect 0 0 4 0;\r#X connect 1 0 5 0;\r#X connect 2 0 13 0;\r#X connect 4 0 11 0;\r#X connect 4 0 9 0;\r#X connect 4 0 12 0;\r#X connect 5 0 6 0;\r#X connect 6 0 4 1;\r#X connect 7 0 3 0;\r#X connect 8 0 10 0;\r#X connect 8 0 11 1;\r#X connect 9 0 8 0;\r#X connect 10 0 12 1;\r#X connect 11 0 7 0;\r#X connect 12 0 7 1;\r#X connect 13 0 0 0;\r#X restore 163 63 pd square_wave5;\r";
NSString *noise_wave_string = @"#X obj 218 86 noise~;\r";
NSString *low_pass_string = @"#N canvas 222 36 450 300 low_pass 1;\r#X obj 202 112 mtof;\r#X obj 126 182 lop~ 220;\r#X obj 178 30 r frequency;\r#X obj 117 122 inlet~;\r#X obj 129 240 outlet~;\r#X connect 0 0 1 1;\r#X connect 1 0 4 0;\r#X connect 2 0 0 0;\r#X connect 3 0 1 0;\r#X restore 140 139 pd low_pass;\r";
NSString *high_pass_string = @"#N canvas 0 22 450 300 high_pass 0;\r#X obj 202 112 mtof;\r#X obj 126 182 hip~ 220;\r#X obj 199 71 r frequency;\r#X obj 116 69 inlet~;\r#X obj 133 238 outlet~;\r#X connect 0 0 1 1;\r#X connect 1 0 4 0;\r#X connect 2 0 0 0;\r#X connect 3 0 1 0;\r#X restore 167 144 pd high_pass;\r";
NSString *band_pass_string = @"#N canvas 0 22 450 300 band_pass 1;\r#X obj 264 190 / 12.7;\r#X obj 175 246 bp~ 220 1;\r#X obj 311 97 r resonance;\r#X obj 166 101 r frequency;\r#X obj 138 195 inlet~;\r#X obj 165 278 outlet~;\r#X connect 0 0 1 2;\r#X connect 1 0 5 0;\r#X connect 2 0 0 0;\r#X connect 3 0 1 1;\r#X connect 4 0 1 0;\r#X restore 89 68 pd band_pass;\r";
NSString *LFO_filter_string = @"#N canvas 325 175 562 567 LFO_filter 1;\r#X obj 97 355 inlet~;\r#X obj 109 473 outlet~;\r#X obj 106 415 vcf~ 220 6;\r#X obj 169 359 mtof~;\r#X obj 193 134 phasor~ 1;\r#X obj 228 212 *~ 50;\r#X obj 169 20 r rate;\r#X obj 187 291 clip~ 0 127;\r#X obj 307 25 r amount;\r#X obj 224 260 +~ 63;\r#X obj 351 147 / 2;\r#X msg 245 85 63;\r#X obj 251 58 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 320 190 -;\r#X connect 0 0 2 0;\r#X connect 2 0 1 0;\r#X connect 3 0 2 1;\r#X connect 4 0 5 0;\r#X connect 5 0 9 0;\r#X connect 6 0 4 0;\r#X connect 7 0 3 0;\r#X connect 8 0 5 1;\r#X connect 8 0 10 0;\r#X connect 8 0 12 0;\r#X connect 9 0 7 0;\r#X connect 10 0 13 1;\r#X connect 11 0 13 0;\r#X connect 12 0 11 0;\r#X connect 13 0 9 1;\r#X restore 162 121 pd LFO_filter;\r";
NSString *envelope_generator_string = @"#N canvas 0 22 450 300 envelope_generator 1;\r#X obj 208 159 vline~ 0 100;\r#X obj 154 206 *~;\r#X obj 345 45 r attack;\r#X obj 254 62 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 274 118 pack 1 100;\r#X obj 142 120 pack 0 100;\r#X obj 123 71 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 248 27 r noteon;\r#X obj 115 25 r noteoff;\r#X obj 189 31 r decay;\r#X obj 198 78 * 10;\r#X obj 333 80 * 10;\r#X obj 127 159 inlet~;\r#X obj 141 244 outlet~;\r#X connect 0 0 1 1;\r#X connect 1 0 13 0;\r#X connect 2 0 11 0;\r#X connect 3 0 4 0;\r#X connect 4 0 0 0;\r#X connect 5 0 0 0;\r#X connect 6 0 5 0;\r#X connect 7 0 3 0;\r#X connect 8 0 6 0;\r#X connect 9 0 10 0;\r#X connect 10 0 5 1;\r#X connect 11 0 4 1;\r#X connect 12 0 1 0;\r#X restore 183 113 pd envelope_generator;\r";
NSString *add_waves_string = @"#N canvas 53 122 450 300 add 0;\r#X obj 120 55 inlet~;\r#X obj 179 150 /~ 2;\r#X obj 195 262 outlet~;\r#X connect 0 0 1 0;\r#X connect 1 0 2 0;\r#X restore 160 126 pd add;\r";
NSString *final_patch_string;

@interface ViewController () <PGMidiDelegate, PGMidiSourceDelegate>
//nothing here
@end

@implementation ViewController
@synthesize paletteTable, optionView, currButton, keyboardScrollView, label1, label2, slider1, slider2, iconButton, midi;
@synthesize currIcons, currPaths, workView, soundStart, soundEnd, clearView, connectionLabel, selectedicon, icons, editMode, traverserCount;
int lastKeyPressed = 0;

- (void)noteOn:(int)note {
    note = note - 4;
    lastKeyPressed = note;
    [PdBase sendFloat:note toReceiver:@"notein"];
    [PdBase sendBangToReceiver:@"noteon"];
    [PdBase sendFloat:63 toReceiver:@"detune"];
}

- (void)noteOff:(int)note {
    note = note - 4;
    if (note == lastKeyPressed) {
        [PdBase sendBangToReceiver:@"noteoff"];
    }
}


-(IBAction) sliderChanged:(id)sender
{
    
    UISlider *tempSlider = (UISlider*)sender;
    if (tempSlider == slider1)
    {
        float tempVal = slider1.value;
        Control *thisControl = [[selectedicon controls] objectAtIndex:0];
        thisControl.controlValue = [NSNumber numberWithFloat:tempVal];
        [PdBase sendFloat:tempVal toReceiver:[[[selectedicon controls] objectAtIndex:0] title]];
    }
    if (tempSlider == slider2)
    {
        float tempVal = slider2.value;
        Control *thisControl = [[selectedicon controls] objectAtIndex:1];
        thisControl.controlValue = [NSNumber numberWithFloat:tempVal];
        [PdBase sendFloat:tempVal toReceiver:[[[selectedicon controls] objectAtIndex:1] title]];
    }
}
 
-(NSInteger) tableView: (UITableView *)tableView numberOfSectionsInTableView:(UITableView *)paletteView
{
    return paletteTable.numberOfSections;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [icons count];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (void) attachToAllExistingSources
{
    for (PGMidiSource *source in midi.sources)
    {
        source.delegate = self;
    }
}

- (void) setMidi:(PGMidi*)m
{
    midi.delegate = nil;
    midi = m;
    midi.delegate = self;
    
    [self attachToAllExistingSources];
    NSLog(@"Set Midi");
}


- (void) midi:(PGMidi*)midi sourceAdded:(PGMidiSource *)source
{
    NSLog(@"Source Added");
}

- (void) midi:(PGMidi*)midi sourceRemoved:(PGMidiSource *)source
{
    NSLog(@"Source Removed");
}

- (void) midi:(PGMidi*)midi destinationAdded:(PGMidiDestination *)destination
{
    NSLog(@"Destination Added");
}

- (void) midi:(PGMidi*)midi destinationRemoved:(PGMidiDestination *)destination
{
    NSLog(@"Destination Removed");
}

- (void) midiSource:(PGMidiSource*)midi midiReceived:(const MIDIPacketList *)packetList
{
    
    NSLog(@"Midi Received");
    
    const MIDIPacket *packet = &packetList->packet[0];
    uint8_t byte1 = (packet->length > 0) ? packet->data[0]:0;
    uint8_t byte2 = (packet->length > 0) ? packet->data[1]:0;
    NSLog(@"MIDI = %d,%d",byte1,byte2);
    
    
    if (byte1 == 144) { //note on
        NSNumber *tmpNumber = [[NSNumber alloc] initWithInt:byte2];
        
        [self performSelectorOnMainThread:@selector(handleMidiNoteOn:) withObject:tmpNumber waitUntilDone:NO];
    }
    if (byte1 == 128) { //note off
        NSNumber *tmpNumber = [[NSNumber alloc] initWithInt:byte2];
        
        [self performSelectorOnMainThread:@selector(handleMidiNoteOff:) withObject:tmpNumber waitUntilDone:NO];
    }
    
    packet = MIDIPacketNext(packet);
}

-(void) handleMidiNoteOn:(NSNumber *) noteNumber
{
    int note = [noteNumber intValue] + 4;
    [self noteOn:note];
}

-(void) handleMidiNoteOff:(NSNumber *) noteNumber
{
    int note = [noteNumber intValue] + 4;
    [self noteOff:note];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    editMode = TRUE;
    //setup synth engine
    dispatcher = [[PdDispatcher alloc] init];
    [PdBase setDelegate:dispatcher];
        
    currIcons = [[NSMutableSet alloc] init];
    
    
    
    //set up icon palette
    
    //create table sidebar for icons
    CGRect paletteRect = CGRectMake(934.0f, 0.0f, 100.0f, 748.0f);
    self.paletteTable = [[UITableView alloc]initWithFrame:paletteRect style:UITableViewStylePlain];
    //self.paletteTable = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    //add icon palette subview to view
    [self.view addSubview:self.paletteTable];
    
    // Set up data source for table
    self.paletteTable.dataSource = self;
    
    // Add delegate to handle cell events
    self.paletteTable.delegate = self;
    
    //Visible parameters of table
    paletteTable.rowHeight = 100;
    paletteTable.backgroundColor = [UIColor whiteColor];
    
    // Ensure that the table autoresizes correctly
    self.paletteTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    icons = [[NSMutableArray alloc]init];    //Create array for icon classes
    [self defineIconDictionary];    // define icon classes in array
            
    CGRect keyboardViewFrame;
    keyboardViewFrame.origin.x = 0;
    keyboardViewFrame.origin.y = 0;
    keyboardViewFrame.size.width = 3200;
    // Leave some empty space for scrolling
    keyboardViewFrame.size.height = keyboardScrollView.frame.size.height - 20;
    keyboardView = [[KeyboardView alloc] initWithFrame:keyboardViewFrame
                                       withOctaveCount:8];
    [keyboardView setKeyboardDelegate:self];
    [keyboardScrollView addSubview:keyboardView];  
    [keyboardScrollView setContentSize:keyboardView.frame.size];
    [keyboardScrollView setScrollEnabled:YES];
    
    //Make Clear View for path drawing
    CGRect bounds3 = CGRectMake(0, 0, 934, 501);
    clearView = [[PathView alloc] initWithFrame:bounds3];
    clearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearView];
    
    //soundStart.clearParentView = clearView;
    //soundEnd.clearParentView = clearView;
    
    final_patch_string = [[NSString alloc] init];
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Icon";
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.paletteTable]) {
        // Set up cell
        cell = [paletteTable cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            cell.imageView.image = [UIImage imageNamed:[[icons objectAtIndex:indexPath.row] imageName]];
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)paletteTable didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!editMode) {
        
    }else{
        //make icon appear in editorView
        CGRect bounds = CGRectMake(100, 100, 72, 72);
        DraggableIcon *testDrag = [[DraggableIcon alloc] initWithFrame:bounds];
        //TEMP NAME -> needs to access the cell's image name and find appropriate image
        [testDrag setImage:[[icons objectAtIndex:indexPath.row] imageName]];
        testDrag.ismovable = YES;
        testDrag.inbounds = YES;
        testDrag.ishighlighted = NO;
        testDrag.otherIcons = currIcons;
        testDrag.clearParentView = clearView;
        [self.view addSubview:testDrag];
        [currIcons addObject:testDrag];
    
        if(testDrag.myName == @"sine oscillator.png")
        {
            Control *first = [[Control alloc]initWithName:@"detune" withType:@"slider"];
            [[testDrag controls] addObject:first];
        }
        if(testDrag.myName == @"sine5 oscillator.png")
        {
            Control *first = [[Control alloc]initWithName:@"detune" withType:@"slider"];
            [[testDrag controls] addObject:first];
        }
        if(testDrag.myName == @"saw oscillator.png")
        {
            Control *first = [[Control alloc]initWithName:@"detune" withType:@"slider"];
            [[testDrag controls] addObject:first];
        }
        if(testDrag.myName == @"saw5 oscillator.png")
        {
            Control *first = [[Control alloc]initWithName:@"detune" withType:@"slider"];
            [[testDrag controls] addObject:first];
        }
        if(testDrag.myName == @"square oscillator.png")
        {
            Control *first = [[Control alloc]initWithName:@"detune" withType:@"slider"];
            [[testDrag controls] addObject:first];
            Control *second = [[Control alloc]initWithName:@"pulse width" withType:@"slider"];
            [[testDrag controls] addObject:second];
        }
        if(testDrag.myName == @"square5 oscillator.png")
        {
            Control *first = [[Control alloc]initWithName:@"detune" withType:@"slider"];
            [[testDrag controls] addObject:first];
            Control *second = [[Control alloc]initWithName:@"pulse width" withType:@"slider"];
            [[testDrag controls] addObject:second];
        }
        if(testDrag.myName == @"low pass filter.png")
        {
            Control *first = [[Control alloc]initWithName:@"frequency" withType:@"slider"];
            [[testDrag controls] addObject:first];
        }
        if(testDrag.myName == @"high pass filter.png")
        {
            Control *first = [[Control alloc]initWithName:@"frequency" withType:@"slider"];
            [[testDrag controls] addObject:first];
        }
        if(testDrag.myName == @"band pass filter.png")
        {
            Control *first = [[Control alloc]initWithName:@"frequency" withType:@"slider"];
            [[testDrag controls] addObject:first];
            Control *second = [[Control alloc]initWithName:@"resonance" withType:@"slider"];
            [[testDrag controls] addObject:second];
        }
        if(testDrag.myName == @"LFO filter.png")
        {
            Control *first = [[Control alloc]initWithName:@"rate" withType:@"slider"];
            [[testDrag controls] addObject:first];
            Control *second = [[Control alloc]initWithName:@"amount" withType:@"slider"];
            [[testDrag controls] addObject:second];
        }
        if(testDrag.myName == @"amplitude envelope.png")
        {
            Control *first = [[Control alloc]initWithName:@"attack" withType:@"slider"];
            [[testDrag controls] addObject:first];
            Control *second = [[Control alloc]initWithName:@"decay" withType:@"slider"];
            [[testDrag controls] addObject:second];
        }
        
        selectedicon = testDrag.selectedIcon;
    }
    
}

-(IBAction)buttonPressed:(id)sender
{
    currButton = (UIButton *)sender;
    if ([currButton.currentTitle isEqualToString: @"1"]){
        if (keyboardScrollView.isHidden == TRUE)
        {
            [keyboardScrollView setHidden:FALSE];
            [label1 setHidden:TRUE];
            [label2 setHidden:TRUE];
            [slider1 setHidden:TRUE];
            [slider2 setHidden:TRUE];
        }
    }
    if ([currButton.currentTitle isEqualToString: @"2"]){
        [keyboardScrollView setHidden:TRUE];
        
        for(DraggableIcon *each in currIcons)
        {
            if(each.ishighlighted == TRUE)
            {
                selectedicon = each;
            }
        }
        
        if ([[selectedicon controls] count] == 1)
        {
            [label1 setHidden:FALSE];
            [slider1 setHidden:FALSE];
            Control *thisControl = [[selectedicon controls] objectAtIndex:0];
            slider1.value = [[thisControl controlValue] floatValue];
            label1.text = [[[selectedicon controls]objectAtIndex:0] title];
            slider1.minimumValue = 0;
            slider1.maximumValue = 127;
            
            [label2 setHidden:TRUE];
            [slider2 setHidden:TRUE];
        }
        
        if ([[selectedicon controls] count] == 2)
        {
            [label1 setHidden:FALSE];
            [slider1 setHidden:FALSE];
            Control *thisControl = [[selectedicon controls] objectAtIndex:0];
            slider1.value = [[thisControl controlValue] floatValue];
            label1.text = [[[selectedicon controls]objectAtIndex:0] title];
            slider1.minimumValue = 0;
            slider1.maximumValue = 127;
            
            [label2 setHidden:FALSE];
            [slider2 setHidden:FALSE];
            thisControl = [[selectedicon controls] objectAtIndex:1];
            slider2.value = [[thisControl controlValue] floatValue];
            label2.text = [[[selectedicon controls]objectAtIndex:1] title];
            slider2.minimumValue = 0;
            slider2.maximumValue = 127;
        }
    }
    if ([currButton.currentTitle isEqualToString:@"Play Mode!"]) {
        if ([currIcons count] == 0) {
            UIAlertView *badView = [[UIAlertView alloc]initWithTitle:@"Error!"
                                                             message:@"You have no icons!"
                                                            delegate:self
                                                   cancelButtonTitle:@"D'oh"
                                                   otherButtonTitles:nil,
                                    nil];
            [badView show];
        }else {
            [currButton setTitle:@"Edit Mode!" forState:UIControlStateNormal];
            editMode = FALSE;
            for (DraggableIcon *curricon in currIcons) {
                curricon.ismovable = FALSE;
            }
            [self buildSound];
        }
    }
    else if ([currButton.currentTitle isEqualToString:@"Edit Mode!"]) {
        [currButton setTitle:@"Play Mode!" forState:UIControlStateNormal];
        editMode = TRUE;
        for (DraggableIcon *curricon in currIcons) {
            curricon.ismovable = TRUE;
        }
    }
}

-(IBAction)iconPressed:(id)sender
{
    iconButton = (UIButton *)sender;
    if(label1.isHidden == TRUE)
    {
        [keyboardScrollView setHidden:TRUE];
        [label1 setHidden:FALSE];
        [label2 setHidden:FALSE];
        [slider1 setHidden:FALSE];
        [slider2 setHidden:FALSE];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    //unload synth engine
    if (patch) {
        [PdBase closeFile:patch];
    }
    [PdBase setDelegate:nil];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    
    if ((interfaceOrientation == UIInterfaceOrientationPortrait)||interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        return NO;
    }
    else {
        return YES;
    }
}

-(void)defineIconDictionary
{
    icon *end = [[icon alloc] initWithTitle:@"End" andImage:@"output.png"];
    [icons addObject:end];
    icon *add = [[icon alloc] initWithTitle:@"Add" andImage:@"add.png"];
    [icons addObject:add];
    icon *sine_wave = [[icon alloc] initWithTitle:@"Sine Wave" andImage:@"sine oscillator.png"];
    [icons addObject:sine_wave];
    icon *sine_wave5 = [[icon alloc] initWithTitle:@"Sine Wave 5" andImage:@"sine5 oscillator.png"];
    [icons addObject:sine_wave5];
    icon *saw_wave = [[icon alloc] initWithTitle:@"Saw Wave" andImage:@"saw oscillator.png"];
    [icons addObject:saw_wave];
    icon *saw_wave5 = [[icon alloc] initWithTitle:@"Saw Wave 5" andImage:@"saw5 oscillator.png"];
    [icons addObject:saw_wave5];
    icon *square_wave = [[icon alloc] initWithTitle:@"Square Wave" andImage:@"square oscillator.png"];
    [icons addObject:square_wave];
    icon *square_wave5 = [[icon alloc] initWithTitle:@"Square Wave 5" andImage:@"square5 oscillator.png"];
    [icons addObject:square_wave5];
    icon *noise_wave = [[icon alloc] initWithTitle:@"Noise" andImage:@"noise oscillator.png"];
    [icons addObject:noise_wave];
    icon *low_pass = [[icon alloc] initWithTitle:@"Low Pass" andImage:@"low pass filter.png"];
    [icons addObject:low_pass];
    icon *high_pass = [[icon alloc] initWithTitle:@"High Pass" andImage:@"high pass filter.png"];
    [icons addObject:high_pass];
    icon *band_pass = [[icon alloc] initWithTitle:@"Band Pass" andImage:@"band pass filter.png"];
    [icons addObject:band_pass];
    icon *LFO_filter = [[icon alloc] initWithTitle:@"LFO Filter" andImage:@"LFO filter.png"];
    [icons addObject:LFO_filter];
    icon *amp_EG = [[icon alloc] initWithTitle:@"Envelope Generator" andImage:@"amplitude envelope.png"];
    [icons addObject:amp_EG];
    
}


-(void)buildSound
{
    int totalcount = 0;
    traverserCount = 0;
    BOOL canStart = FALSE;
    NSInteger success = 0;
    for (DraggableIcon *curricon in self.currIcons) {
        if (curricon.myName == @"output.png")
        {
            canStart = TRUE;
            soundEnd = curricon;
        }
        totalcount ++;
    }
    final_patch_string = canvas_string;
    [self pdPatcher:soundEnd];
    traverserCount++;
    success = [self buildAndTraverse:soundEnd];
    if (success == 0)
    {
        [self writePatch:final_patch_string];
    }
}

-(NSInteger) buildAndTraverse:(DraggableIcon*)icon
{
    NSInteger returnVal = 0;
    icon.objectNumber = traverserCount;
    traverserCount++;
    [self pdPatcher:icon];
    if (icon.connectedFrom != NULL)
    {
        returnVal = [self buildAndTraverse:icon.connectedFrom];
    }
    if (icon.connectedFrom2 != NULL)
    {
        returnVal = [self buildAndTraverse:icon.connectedFrom2];
    }
    
    return returnVal;
}

    
-(void) pdPatcher:(DraggableIcon*)icon
{
    if (icon.myName == @"output.png") {
        final_patch_string = [final_patch_string stringByAppendingString:audio_out_string];
    }
    if (icon.myName == @"sine oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:sine_wave_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"sine5 oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:sine_5_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"saw oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:saw_wave_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"saw5 oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:saw_5_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"square oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:square_wave_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"square5 oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:square_5_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"noise oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:noise_wave_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"low pass filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:low_pass_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"high pass filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:high_pass_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"band pass filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:band_pass_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"LFO filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:LFO_filter_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"amplitude envelope.png") {
        final_patch_string = [final_patch_string stringByAppendingString:envelope_generator_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
    if (icon.myName == @"add.png") {
        final_patch_string = [final_patch_string stringByAppendingString:add_waves_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", icon.objectNumber, icon.connectedTo.objectNumber]];
    }
}

-(void)writePatch:(NSString *) patch_string_to_write{
    
    NSString *patchstring = [[NSString alloc] init];
    if (patch) {
        [PdBase closeFile:patch];
        patch = nil;
    }
    
    if (!patch) {
        
        patchstring = final_patch_string;
        NSLog(@"%@",patchstring);
        
        /*
        //this massive string replaced by our dynamically built string
        patchstring = @"#N canvas 631 120 634 585 10;\r#X obj 397 477 dac~;\r#X obj 322 133 mtof;\r#X obj 412 280 r filtnum;\r#X obj 399 329 mtof;\r#X obj 350 363 lop~ 1000;\r#X obj 348 280 +~;\r#X obj 296 239 -~ 0.5;\r#X obj 382 239 -~ 0.5;\r#X obj 295 211 phasor~ 220;\r#X obj 381 211 phasor~ 221;\r#X floatatom 330 109 5 0 0 0 - - -;\r#X floatatom 424 304 5 0 0 0 - - -;\r#X obj 347 305 *~ 0.2;\r#X text 126 283;\r#X obj 376 70 r startnote;\r#X obj 487 75 r stopnote;\r#X obj 360 176 + 1;\r#X obj 472 213 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X msg 474 258 1;\r#X obj 530 214 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X msg 532 259 0;\r#X obj 402 432 *~ 0;\r#X connect 1 0 8 0;\r#X connect 1 0 16 0;\r#X connect 2 0 11 0;\r#X connect 3 0 4 1;\r#X connect 4 0 21 0;\r#X connect 5 0 12 0;\r#X connect 6 0 5 0;\r#X connect 7 0 5 1;\r#X connect 8 0 6 0;\r#X connect 9 0 7 0;\r#X connect 10 0 1 0;\r#X connect 11 0 3 0;\r#X connect 12 0 4 0;\r#X connect 14 0 10 0;\r#X connect 14 0 17 0;\r#X connect 15 0 19 0;\r#X connect 16 0 9 0;\r#X connect 17 0 18 0;\r#X connect 18 0 21 1;\r#X connect 19 0 20 0;\r#X connect 20 0 21 1;\r#X connect 21 0 0 0;\r#X connect 21 0 0 1;";
         */
        
    }
    
    //file manager stuff
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [cacheDirectory stringByAppendingPathComponent:@"patch.pd"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"patch" ofType:@"pd"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:myPathInfo toPath:myPathDocs error:NULL];
    }
    
    BOOL sucess = [patchstring writeToFile:myPathDocs atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    if (sucess) {
        NSLog(@"write success");
    }
    else {
        NSLog(@"write failure");
        exit(0);
        
    }
    patch = [PdBase openFile:@"patch.pd" path:cacheDirectory];
    if (!patch) {
        NSLog(@"failed to open patch");
        exit(0);
    }
}

@end
