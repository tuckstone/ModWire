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

@interface ViewController () <PGMidiDelegate, PGMidiSourceDelegate>
//nothing here
@end

@implementation ViewController
@synthesize paletteTable, optionView, currButton, keyboardScrollView, label1, label2, slider1, slider2, iconButton, midi;
@synthesize currIcons, currPaths, workView, soundStart, soundEnd;
int lastKeyPressed = 0;

- (void)noteOn:(int)note {
    note = note - 4;
    NSLog(@"NOTE ON %d",note);
    lastKeyPressed = note;
    [PdBase sendFloat:note toReceiver:@"startnote"];
}

- (void)noteOff:(int)note {
    note = note - 4;
    NSLog(@"NOTE OFF %d",note);
    if (note == lastKeyPressed) {
        [PdBase sendFloat:note toReceiver:@"stopnote"];
    }
}

- (IBAction)setFilterCutoffFreq:(id)sender
{
    [PdBase sendFloat:[(UISlider *) sender value] toReceiver:@"filtnum"];
}

- (IBAction)setOscDetune:(id)sender
{
    int tuneInt = (int) [(UISlider *) sender value];
    NSLog(@"%d",tuneInt);
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
    patch = [PdBase openFile:@"synth_engine.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"failed to load synth engine, will quit now");
        exit(0);
    }
    
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
        
    
    //Add Gesture Recognition to working View
    UITapGestureRecognizer *twoFingersOneTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoFingersOneTap)];
    twoFingersOneTap.numberOfTouchesRequired = 2;
    [self.workView addGestureRecognizer:twoFingersOneTap];
    
    
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
    
    //Code to make 2 static Icons
    self.workView.backgroundColor = [UIColor lightGrayColor];
    CGRect bounds = CGRectMake(50, 220, 72, 72);
    soundStart = [[DraggableIcon alloc] initWithFrame:bounds];
    soundStart.ismovable = NO;
    soundStart.inbounds = YES;
    soundStart.ishighlighted = NO;
    soundStart.otherIcons = currIcons;
    [soundStart setImage:@"audio-in.png"];
    [self.view addSubview:soundStart];
    
    CGRect bounds2 = CGRectMake(750, 220, 72, 72);
    soundEnd = [[DraggableIcon alloc] initWithFrame:bounds2];
    soundEnd.ismovable = NO;
    soundEnd.inbounds = YES;
    soundEnd.ishighlighted = NO;
    soundEnd.otherIcons = currIcons;
    [soundEnd setImage:@"output.png"];
    [self.view addSubview:soundEnd];
    [currIcons addObject:soundStart];
    [currIcons addObject:soundEnd];
    
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
    [PdBase closeFile:patch];
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
    icon *LFO = [[icon alloc] initWithTitle:@"LFO" andImage:@"lfo.png"];
    [icons addObject:LFO];
    icon *delay = [[icon alloc] initWithTitle:@"Delay" andImage:@"delay.png.png"];
    [icons addObject:delay];
    icon *filter = [[icon alloc] initWithTitle:@"Filter" andImage:@"filter.png"];
    [icons addObject:filter];
    icon *modulator = [[icon alloc] initWithTitle:@"Modulator" andImage:@"modulator.png"];
    [icons addObject:modulator];
    icon *oscillator = [[icon alloc] initWithTitle:@"Oscillator" andImage:@"oscillator.png"];
    [icons addObject:oscillator];
    icon *waveshaper = [[icon alloc] initWithTitle:@"Waveshaper" andImage:@"waveshaper.png"];
    [icons addObject:waveshaper];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"LOL");
    if ([touches count] > 1) {
        BOOL first = FALSE;
        BOOL second = FALSE;
        DraggableIcon *firstIconTouched;
        DraggableIcon *secondIconTouched;
        CGPoint firstlocationpoint = [[[touches allObjects] objectAtIndex:0]locationInView:self.view];
        CGPoint secondlocationpoint = [[[touches allObjects] objectAtIndex:1]locationInView:self.view];
        for(DraggableIcon *check in currIcons)
        {
            if(firstlocationpoint.x > check.x && firstlocationpoint.x < (check.x +72))
            {
                if(firstlocationpoint.y >check.y && firstlocationpoint.y < (check.y +72))
                {
                    first = TRUE;
                    firstIconTouched = check;
                }
            }
            if(secondlocationpoint.x > check.x && secondlocationpoint.x < (check.x +72))
            {
                if(secondlocationpoint.y >check.y && secondlocationpoint.y < (check.y +72))
                {
                    second = TRUE;
                    secondIconTouched = check;
                }
            }
        }
        if(first && second)
        {
            UIBezierPath *myPath=[[UIBezierPath alloc]init];
            myPath.lineWidth=10;
            [myPath addLineToPoint:CGPointMake(firstIconTouched.x, firstIconTouched.y)];
            [myPath addLineToPoint:CGPointMake(secondIconTouched.x, secondIconTouched.y)];
        }
    }
}

-(IBAction)buildSound:(id)sender
{
    DraggableIcon *programTraverser = soundStart;
    BOOL didFindError = FALSE;
    while (programTraverser != soundEnd && !didFindError) {
        //This is where mike will take all the datas from the views
        
        //yup, right there
        
        
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
    }
    
    //programTraverser should now be soundEnd.  If all went well.  I hope.
}

-(void)twoFingersOneTap
{
    NSLog(@"HELLO");
}

@end
