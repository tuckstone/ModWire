//
//  DraggableIcon.m
//  ModWire
//
//  Created by Lion User on 02/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DraggableIcon.h"
#import "ViewController.h"

@implementation DraggableIcon
@synthesize myName, startPoint, x, y, ismovable, background, connectedTo, connectedFrom, connectedFrom2;
@synthesize ishighlighted, inbounds, otherIcons, controls, isTouched, clearParentView, selectedIcon, pathNum, objectNumber;

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
    self.isTouched = TRUE;
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
    
    for(DraggableIcon *icon in otherIcons)
    {
        icon.selectedIcon = self;
        if (icon.isTouched == TRUE && icon != self) {
            if (self.connectedFrom != NULL)
            {
                if ([myName isEqualToString: @"add.png"])
                {
                    if (connectedFrom2 == NULL)
                    {
                        [self connectFrom2:icon toThis:self];
                    }
                    else
                    {
                        [self.connectedFrom2 deleteLine];
                        if (icon.connectedTo != NULL) {
                            [icon deleteLine];
                        }
                        [self connectFrom2:icon toThis:self];
                    }
                }
                else
                {
                    [self.connectedFrom deleteLine];
                    if (icon.connectedTo != NULL) {
                        [icon deleteLine];
                    }
                    [self connectFrom:icon toThis:self];
                }
            }
            else
            {
                if (icon.connectedTo != NULL) {
                    [icon deleteLine];
                }
                [self connectFrom:icon toThis:self];
            }
        }
    }
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
        if ([myName isEqualToString: @"add.png"]) {
            if (self.connectedFrom != NULL) {
                [connectedFrom updateLine];
            }
            if (self.connectedFrom2 != NULL) {
                [connectedFrom2 updateLine];
            }
            if (self.connectedTo != NULL) {
                [self updateLine];
            }
        }else {
            if (self.connectedFrom != NULL) {
                [connectedFrom updateLine];
            }
            if (self.connectedTo != NULL) {
                [self updateLine];
            }
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.y >= 429 || self.x >= 862) {
        self.inbounds = NO;
        if (self.connectedFrom != NULL) {
            [connectedFrom deleteLine];
        }
        if (self.connectedFrom2 != NULL) {
            [connectedFrom2 deleteLine];
        }
        if (connectedTo != NULL) {
            [self deleteLine];
        }
        [self removeFromSuperview];
        [self.otherIcons removeObject:self];
    }
    self.isTouched = FALSE;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.connectedTo = NULL;
        self.connectedFrom = NULL;
        self.isTouched = FALSE;
        controls = [[NSMutableArray alloc]init];
    }
    return self;
}

-(void)connectFrom:(DraggableIcon *)fromThis toThis:(DraggableIcon *)toThis
{
    fromThis.connectedTo = toThis;
    toThis.connectedFrom = fromThis;
    [self.clearParentView beginDrawFrom:fromThis To:toThis];
}

-(void)connectFrom2:(DraggableIcon *)fromThis toThis:(DraggableIcon *)toThis
{
    fromThis.connectedTo = toThis;
    toThis.connectedFrom2 = fromThis;
    [self.clearParentView beginDrawFrom:fromThis To:toThis];
}

-(void)deleteLine
{
    [clearParentView deleteLineWithIndex:pathNum];
    for (DraggableIcon *curricon in otherIcons) {
        if (curricon != self) {
            if (curricon.pathNum > self.pathNum) {
                curricon.pathNum --;
            }
        }
    }
    if ([connectedTo.myName isEqualToString:@"add.png"]) 
    {
        if (connectedTo.connectedFrom2 == self) {
            connectedTo.connectedFrom2 = NULL;
            connectedTo = NULL;
        }else {
            connectedTo.connectedFrom = NULL;
            connectedTo = NULL;
        }
    }else 
    {
        connectedTo.connectedFrom = NULL;
        connectedTo = NULL;
    }
}

-(void)updateLine
{
    [clearParentView updateLineWithIndex:pathNum startX:self.x startY:self.y endX:connectedTo.x endY:connectedTo.y];
}

@end
