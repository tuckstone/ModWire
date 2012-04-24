//
//  DraggableIcon.m
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DraggableIcon.h"

@implementation DraggableIcon
@synthesize myName, startPoint, x, y, ismovable, background, connectedTo, connectedFrom;
@synthesize ishighlighted, inbounds, otherIcons, controls;

-(void)setImage:(NSString *)imagename{
    myName = imagename;
    UIColor *image = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:imagename]];
    self.background = image;
    self.backgroundColor = image;
}

-(void)highlighter:(BOOL)state
{
    if (state == TRUE) {
        self.alpha = 0.5;
        self.ishighlighted = TRUE;
    }else {
        self.alpha = 1.0;
        self.ishighlighted = FALSE;
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!ismovable) {
        //If view is immovable, don't move it
        self.alpha = 0.5;
    }else {
        startPoint = [[touches anyObject] locationInView:self];
        self.alpha = 0.5;
    }
    for (DraggableIcon *curricon in self.otherIcons) {
        if (curricon.ishighlighted == YES)
        {
            [curricon highlighter:FALSE];
        }
    }
    [self highlighter:TRUE];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    if (!ismovable) {
        //If view is immovable, don't move it
    }else {
        CGPoint movePoint = [[touches anyObject] locationInView:self.superview];
        movePoint.x -= startPoint.x;
        movePoint.y -= startPoint.y;
        CGRect movFrame = [self frame];
        movFrame.origin = movePoint;
        self.x = movePoint.x;
        self.y = movePoint.y;
        [self setFrame:movFrame];  
    }  
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.y >= 429 || self.x >= 862) {
        [self removeFromSuperview];
        [self.otherIcons removeObject:self];
        self.inbounds = NO;
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
