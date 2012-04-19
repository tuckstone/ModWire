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
@synthesize currIcons;
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
    [keyboardScrollView TouchForwardingUIScrollView
    
    //Code to make 2 static Icons
    CGRect bounds = CGRectMake(50, 250, 72, 72);
    DraggableIcon *soundStart = [[DraggableIcon alloc] initWithFrame:bounds];
    soundStart.ismovable = NO;
    soundStart.inbounds = YES;
    soundStart.ishighlighted = NO;
    soundStart.otherIcons = currIcons;
    [soundStart setImage:@"audio-in.png"];
    [self.view addSubview:soundStart];
    
    CGRect bounds2 = CGRectMake(750, 250, 72, 72);
    DraggableIcon *soundEnd = [[DraggableIcon alloc] initWithFrame:bounds2];
    soundEnd.ismovable = NO;
    soundEnd.inbounds = YES;
    soundEnd.ishighlighted = NO;
    soundEnd.otherIcons = currIcons;
    [soundEnd setImage:@"output.png"];
    [self.view addSubview:soundEnd];
    
    [currIcons addObject:soundEnd];
    [currIcons addObject:soundStart];
    
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
    if ([touches count] == 2) {
        CALayer *layer = [[CALayer alloc]init];
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat components[4] = {0.0f, 0.0f, 0.0f, 1.0f};
        CGColorRef blackColor = CGColorCreate(colorSpace, components);
        layer.backgroundColor = blackColor;
        CGFloat width = 1.0;
        setLayerToLineFromAToB(layer, [[[touches allObjects] objectAtIndex:0] locationInView:self.view], [[[touches allObjects] objectAtIndex:1] locationInView:self.view], width);
    }
}

void setLayerToLineFromAToB(CALayer *layer, CGPoint a, CGPoint b, CGFloat lineWidth)
{
    CGPoint center = { 0.5 * (a.x + b.x), 0.5 * (a.y + b.y) };
    CGFloat length = sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y));
    CGFloat angle = atan2(a.y - b.y, a.x - b.x);
    
    layer.position = center;
    layer.bounds = (CGRect) { {0, 0}, { length + lineWidth, lineWidth } };
    layer.transform = CATransform3DMakeRotation(angle, 0, 0, 1);
}

@end
