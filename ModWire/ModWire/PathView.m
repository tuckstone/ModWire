//
//  PathView.m
//  ModWire
//
//  Created by Lion User on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PathView.h"
#import "DraggableIcon.h"
@implementation PathView
@synthesize currentTo, currentFrom, currentPaths, numPaths;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    self.currentPaths = [[NSMutableArray alloc] init];
    return self;
}

-(void)beginDrawFrom:(DraggableIcon *)from To:(DraggableIcon *)to
{
    self.currentFrom = from;
    self.currentTo = to;
    UIBezierPath *newpath = [UIBezierPath bezierPath];
    [newpath moveToPoint:CGPointMake(self.currentFrom.x + 36, self.currentFrom.y + 36)];
    [newpath addLineToPoint:CGPointMake(self.currentTo.x + 36, self.currentTo.y + 36)];
    [self.currentPaths addObject:newpath];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.numPaths += 1;
    // Drawing code
    for (UIBezierPath *path in currentPaths) {
        path.lineWidth = 5;
        [[UIColor blackColor] setFill];
        [[UIColor blackColor] setStroke];
        [path fill];
        [path stroke];
    }
}


@end
