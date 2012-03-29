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

@implementation ViewController
@synthesize paletteTable, optionView, currButton;

- (void)noteOn:(int)note {
    NSLog(@"NOTE ON %d",note);
}

- (void)noteOff:(int)note {
    NSLog(@"NOTE OFF %d",note);
}

-(NSInteger) tableView: (UITableView *)tableView numberOfSectionsInTableView:(UITableView *)paletteView
{
    return paletteTable.numberOfSections;
}

-(NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    icons = [[NSMutableArray alloc]init];
    
    [self defineIconDictionary];
    
    CGRect paletteRect = CGRectMake(888.0f, 0.0f, 146.0f, 748.0f);
    self.paletteTable = [[UITableView alloc]initWithFrame:paletteRect style:UITableViewStylePlain];
    paletteTable.rowHeight = 100;
    paletteTable.backgroundColor = [UIColor blueColor];
    paletteTable.userInteractionEnabled = YES;
    
    // Set up data source for table
    self.paletteTable.dataSource = self;
    
    // Add delegate to handle cell events
    self.paletteTable.delegate = self;
    [self.view addSubview:self.paletteTable];
    
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
    
    // Forward touch events to the keyboard
    //[keyboardScrollView setTouchView:keyboardView];
    
    UITableViewCell *cell;
    
    //NSLog(@"count: %d ",[icons count]);
    
    for (NSUInteger i = 0; i < [icons count]; i++)
    {
        //NSLog(@"hi!");
        NSIndexPath *thisIndex = [[NSIndexPath alloc]initWithIndex:i];
        cell = [self tableView:paletteTable cellForRowAtIndexPath:thisIndex];
        //UIImageView *lpf = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lowPassFilter.png"]];
        //cell.imageView.image = [[UIImage alloc]initWithContentsOfFile:[[icons objectAtIndex:i]imageName]];
        [cell.imageView sizeToFit];
        cell.imageView.image = [UIImage imageNamed:@"lowPassFilter.png"];
        cell.textLabel.text = [[icons objectAtIndex:i]title];
        
        NSLog(@"%@",cell.textLabel.text);
    }
    
    [self.paletteTable reloadData];
    
}


- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Icon";
    UITableViewCell *cell = nil;
    if ([tableView isEqual:self.paletteTable]) {
        
        // Set up cell
        cell = [paletteTable cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            cell.textLabel.text = cellIdentifier;
        }
    }
    return cell;
}


-(void)tableView:(UITableView *)paletteTable didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //make icon appear in editorView
}

-(IBAction)buttonPressed:(id)sender
{
    currButton = (UIButton *)sender;
    if ([currButton.currentTitle isEqualToString: @"1"]){
        if (keyboardScrollView.isHidden == TRUE)
        {
            [keyboardScrollView setHidden:FALSE];
        }else {
            [keyboardScrollView setHidden:TRUE];
        }
   }

}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
    icon *lowPass = [[icon alloc] initWithTitle:@"Low Pass Filter" andImage:@"lowPassFilter.png"];
    [icons addObject:lowPass];
    icon *LFO = [[icon alloc] initWithTitle:@"LFO" andImage:@"LFO.png"];
    [icons addObject:LFO];
}

@end
