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

//patch costants
NSString *canvas_string = @"#N canvas 494 239 450 300 10;\r";
NSString *audio_out_string = @"#N canvas 0 22 450 300 audio_out 0;\r#X obj 160 110 hip~ 1;\r#X obj 169 161 dac~;\r#X obj 165 53 inlet~;\r#X connect 0 0 1 0;\r#X connect 0 0 1 1;\r#X connect 2 0 0 0;\r#X restore 205 61 pd audio_out;\r";
NSString *sine_wave_string = @"#N canvas 631 239 450 300 sine_wave 0;\r#X obj 95 76 mtof;\r#X obj 98 168 osc~ 220;\r#X obj 95 36 r notein;\r#X obj 253 9 r detune;\r#X obj 102 226 outlet~;\r#X obj 298 66 / 127;\r#X obj 309 105 + 0.5;\r#X obj 179 140 *;\r#X connect 0 0 7 0;\r#X connect 1 0 4 0;\r#X connect 2 0 0 0;\r#X connect 3 0 5 0;\r#X connect 5 0 6 0;\r#X connect 6 0 7 1;\r#X connect 7 0 1 0;\r#X restore 176 117 pd sine_wave;\r";
NSString *saw_wave_string = @"#N canvas 773 203 450 300 saw_wave 0;\r#X obj 97 164 phasor~ 220;\r#X obj 95 76 mtof;\r#X obj 256 15 r detune;\r#X obj 61 15 r notein;\r#X obj 84 255 outlet~;\r#X obj 183 124 *;\r#X obj 286 70 / 127;\r#X obj 305 105 + 0.5;\r#X obj 258 203 -~ 0.5;\r#X obj 278 246 *~ 2;\r#X connect 0 0 8 0;\r#X connect 1 0 5 0;\r#X connect 2 0 6 0;\r#X connect 3 0 1 0;\r#X connect 5 0 0 0;\r#X connect 6 0 7 0;\r#X connect 7 0 5 1;\r#X connect 8 0 9 0;\r#X connect 9 0 4 0;\r#X restore 200 129 pd saw_wave;\r";
NSString *square_wave_string = @"#N canvas 773 203 450 300 saw_wave 0;\r#X obj 97 164 phasor~ 220;\r#X obj 95 76 mtof;\r#X obj 256 15 r detune;\r#X obj 61 15 r notein;\r#X obj 84 255 outlet~;\r#X obj 183 124 *;\r#X obj 286 70 / 127;\r#X obj 305 105 + 0.5;\r#X obj 258 203 -~ 0.5;\r#X obj 278 246 *~ 2;\r#X connect 0 0 8 0;\r#X connect 1 0 5 0;\r#X connect 2 0 6 0;\r#X connect 3 0 1 0;\r#X connect 5 0 0 0;\r#X connect 6 0 7 0;\r#X connect 7 0 5 1;\r#X connect 8 0 9 0;\r#X connect 9 0 4 0;\r#X restore 200 129 pd saw_wave;\r";
NSString *low_pass_string = @"#N canvas 222 36 450 300 low_pass 1;\r#X obj 202 112 mtof;\r#X obj 126 182 lop~ 220;\r#X obj 178 30 r frequency;\r#X obj 117 122 inlet~;\r#X obj 129 240 outlet~;\r#X connect 0 0 1 1;\r#X connect 1 0 4 0;\r#X connect 2 0 0 0;\r#X connect 3 0 1 0;\r#X restore 140 139 pd low_pass;\r";
NSString *high_pass_string = @"#N canvas 0 22 450 300 high_pass 0;\r#X obj 202 112 mtof;\r#X obj 126 182 hip~ 220;\r#X obj 199 71 r frequency;\r#X obj 116 69 inlet~;\r#X obj 133 238 outlet~;\r#X connect 0 0 1 1;\r#X connect 1 0 4 0;\r#X connect 2 0 0 0;\r#X connect 3 0 1 0;\r#X restore 167 144 pd high_pass;\r";
NSString *band_pass_string = @"#N canvas 0 22 450 300 band_pass 1;\r#X obj 264 190 / 12.7;\r#X obj 175 246 bp~ 220 1;\r#X obj 311 97 r resonance;\r#X obj 166 101 r frequency;\r#X obj 138 195 inlet~;\r#X obj 165 278 outlet~;\r#X connect 0 0 1 2;\r#X connect 1 0 5 0;\r#X connect 2 0 0 0;\r#X connect 3 0 1 1;\r#X connect 4 0 1 0;\r#X restore 89 68 pd band_pass;\r";
NSString *envelope_generator_string = @"#N canvas 0 22 450 300 envelope_generator 1;\r#X obj 208 159 vline~ 0 100;\r#X obj 154 206 *~;\r#X obj 345 45 r attack;\r#X obj 254 62 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 274 118 pack 1 100;\r#X obj 142 120 pack 0 100;\r#X obj 123 71 bng 15 250 50 0 empty empty empty 17 7 0 10 -262144 -1 -1;\r#X obj 248 27 r noteon;\r#X obj 115 25 r noteoff;\r#X obj 189 31 r decay;\r#X obj 198 78 * 10;\r#X obj 333 80 * 10;\r#X obj 127 159 inlet~;\r#X obj 141 244 outlet~;\r#X connect 0 0 1 1;\r#X connect 1 0 13 0;\r#X connect 2 0 11 0;\r#X connect 3 0 4 0;\r#X connect 4 0 0 0;\r#X connect 5 0 0 0;\r#X connect 6 0 5 0;\r#X connect 7 0 3 0;\r#X connect 8 0 6 0;\r#X connect 9 0 10 0;\r#X connect 10 0 5 1;\r#X connect 11 0 4 1;\r#X connect 12 0 1 0;\r#X restore 183 113 pd envelope_generator;\r";
NSString *final_patch_string;

@interface ViewController () <PGMidiDelegate, PGMidiSourceDelegate>
//nothing here
@end

@implementation ViewController
@synthesize paletteTable, optionView, currButton, keyboardScrollView, label1, label2, slider1, slider2, iconButton, midi;
@synthesize currIcons, currPaths, workView, soundStart, soundEnd, clearView, connectionLabel;
int lastKeyPressed = 0;

- (void)noteOn:(int)note {
    note = note - 4;
    NSLog(@"NOTE ON %d",note);
    lastKeyPressed = note;
    [PdBase sendFloat:note toReceiver:@"notein"];
    [PdBase sendBangToReceiver:@"noteon"];
    [PdBase sendFloat:63 toReceiver:@"detune"];
}

- (void)noteOff:(int)note {
    note = note - 4;
    NSLog(@"NOTE OFF %d",note);
    if (note == lastKeyPressed) {
        [PdBase sendBangToReceiver:@"noteoff"];
    }
}

- (IBAction)setFilterCutoffFreq:(id)sender
{
    [PdBase sendFloat:[(UISlider *) sender value] toReceiver:@"filtnum"];
}

- (IBAction)setOscDetune:(id)sender
{
    [PdBase sendFloat:[(UISlider *) sender value] toReceiver:@"detune"];
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
    
   
    
    /*
    //Makes 2 static icons
    CGRect bounds = CGRectMake(50.0, 220.0, 72.0, 72.0);
    soundStart = [[DraggableIcon alloc] initWithFrame:bounds];
    soundStart.ismovable = YES;
    soundStart.inbounds = YES;
    soundStart.ishighlighted = NO;
    soundStart.otherIcons = currIcons;
    soundStart.clearParentView = clearView;
    [soundStart setImage:@"audio-in.png"];
    [self.view addSubview:soundStart];
    
    CGRect bounds2 = CGRectMake(750, 220, 72, 72);
    soundEnd = [[DraggableIcon alloc] initWithFrame:bounds2];
    soundEnd.ismovable = YES;
    soundEnd.inbounds = YES;
    soundEnd.ishighlighted = NO;
    soundEnd.otherIcons = currIcons;
    soundEnd.clearParentView = clearView;
    [soundEnd setImage:@"output.png"];
    [self.view addSubview:soundEnd];
    [currIcons addObject:soundStart];
    [currIcons addObject:soundEnd];
    */
    
    //Make Clear View for path drawing
    CGRect bounds3 = CGRectMake(0, 0, 934, 501);
    clearView = [[PathView alloc] initWithFrame:bounds3];
    clearView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:clearView];
    
    //soundStart.clearParentView = clearView;
    //soundEnd.clearParentView = clearView;
    
    final_patch_string = [[NSString alloc] init];
    
    // Forward touch events to the keyboard
    //[keyboardScrollView setTouchView:keyboardView];
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell number: %d ",indexPath.row);
    static NSString *cellIdentifier = @"Icon";
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.paletteTable]) {
        // Set up cell
        cell = [paletteTable cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
            NSLog(@"Created a cell");
            cell.imageView.image = [UIImage imageNamed:[[icons objectAtIndex:indexPath.row] imageName]];
            //cell.imageView.image = [UIImage imageNamed:@"lowPassFilter.png"];
            NSLog(@"Added image to cell");
            
            
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)paletteTable didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
    NSLog(@"cell clicked %d",indexPath.row);
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
        [label1 setHidden:FALSE];
        [label2 setHidden:FALSE];
        [slider1 setHidden:FALSE];
        [slider2 setHidden:FALSE];
    }
    if ([currButton.currentTitle isEqualToString:@"Build Patch"]) {
        [self buildSound];
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
    icon *start = [[icon alloc] initWithTitle:@"Start" andImage:@"audio-in.png"];
    [icons addObject:start];
    icon *end = [[icon alloc] initWithTitle:@"End" andImage:@"output.png"];
    [icons addObject:end];
    icon *sine_wave = [[icon alloc] initWithTitle:@"Sine Wave" andImage:@"sine oscillator.png"];
    [icons addObject:sine_wave];
    icon *saw_wave = [[icon alloc] initWithTitle:@"Saw Wave" andImage:@"saw oscillator.png"];
    [icons addObject:saw_wave];
    icon *square_wave = [[icon alloc] initWithTitle:@"Square Wave" andImage:@"square oscillator.png"];
    [icons addObject:square_wave];
    icon *low_pass = [[icon alloc] initWithTitle:@"Low Pass" andImage:@"low pass filter.png"];
    [icons addObject:low_pass];
    icon *high_pass = [[icon alloc] initWithTitle:@"High Pass" andImage:@"high pass filter.png"];
    [icons addObject:high_pass];
    icon *band_pass = [[icon alloc] initWithTitle:@"Band Pass" andImage:@"band pass filter.png"];
    [icons addObject:band_pass];
    icon *amp_EG = [[icon alloc] initWithTitle:@"Envelope Generator" andImage:@"amplitude envelope.png"];
    [icons addObject:amp_EG];
    
}


-(void)buildSound
{
    NSLog(@"build button pressed");

    for (DraggableIcon *curricon in self.currIcons) {
        if (curricon.myName == @"audio-in.png")
        {
            soundStart = curricon;
        }
        if (curricon.myName == @"output.png")
        {
            soundEnd = curricon;
        }
    }    
    
    final_patch_string = @"";
    
    DraggableIcon *programTraverser = soundStart;
    BOOL didFindError = FALSE;
    int while_count = 0;
    while (programTraverser != soundEnd && !didFindError) {
        //This is where mike will take all the datas from the views
        
        //yup, right there
        
        NSLog(@"%@",programTraverser.myName);
        [self pdPatcher:programTraverser.myName withCount:while_count];
        
        if (programTraverser.connectedTo == NULL) {
            //panic! those motherfuckers DONE GOOFED
            UIAlertView *badView = [[UIAlertView alloc]initWithTitle:@"Error"
                                                          message:@"You have a wiring error.  Please re-evaluate your program!"
                                                         delegate:self
                                                cancelButtonTitle:@"Sorry :("
                                                otherButtonTitles:nil,
                                 nil];
            [badView show];
            didFindError = TRUE;
        }
        if (!didFindError) {
            programTraverser = programTraverser.connectedTo;
        }
        while_count++;
    }
    
    //programTraverser should now be soundEnd.  If all went well.  I hope.
    NSLog(@"program traverser success");
    [self writePatch:final_patch_string withFinalCount:while_count];
    
}

-(void) pdPatcher:(NSString *) iconName withCount:(int)count
{
    if (iconName == @"audio-in.png") {
        final_patch_string = [final_patch_string stringByAppendingString:canvas_string];
    }
    if (iconName == @"sine oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:sine_wave_string];
    }
    if (iconName == @"saw oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:saw_wave_string];
    }
    if (iconName == @"square oscillator.png") {
        final_patch_string = [final_patch_string stringByAppendingString:square_wave_string];
    }
    if (iconName == @"low pass filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:low_pass_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", count - 2, count - 1]];
    }
    if (iconName == @"high pass filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:high_pass_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", count - 2, count - 1]];
    }
    if (iconName == @"band pass filter.png") {
        final_patch_string = [final_patch_string stringByAppendingString:band_pass_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", count - 2, count - 1]];
    }
    if (iconName == @"amplitude envelope.png") {
        final_patch_string = [final_patch_string stringByAppendingString:envelope_generator_string];
        final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", count - 2, count - 1]];
    }
}

-(void)writePatch:(NSString *) patch_string_to_write withFinalCount:(int)final_count{
    
    final_patch_string = [final_patch_string stringByAppendingString:audio_out_string];
    final_patch_string = [final_patch_string stringByAppendingString:[NSString stringWithFormat:@"#X connect %d 0 %d 0;\r", final_count - 2, final_count - 1]];
    
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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:@"patch.pd"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:myPathDocs])
    {
        NSString *myPathInfo = [[NSBundle mainBundle] pathForResource:@"patch" ofType:@"pd"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager copyItemAtPath:myPathInfo toPath:myPathDocs error:NULL];
    }
    
    BOOL sucess = [patchstring writeToFile:myPathDocs atomically:YES encoding:NSUTF8StringEncoding error:NULL];
    if (sucess) {
        NSLog(@"write sucess");
    }
    else {
        NSLog(@"write failure");
        exit(0);
        
    }
    patch = [PdBase openFile:@"patch.pd" path:documentsDirectory];
    if (!patch) {
        NSLog(@"failed to open patch");
        exit(0);
    }

}

@end
