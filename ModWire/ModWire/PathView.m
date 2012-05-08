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
    self.numPaths = 0;
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
    self.currentFrom.pathNum = numPaths;
    self.numPaths += 1;
}

- (void)drawRect:(CGRect)rect
{
    if (numPaths == 0) {
        [currentPaths removeAllObjects];
    }
    // Drawing code
    for (UIBezierPath *path in currentPaths) {
        path.lineWidth = 5;
        [[UIColor blackColor] setFill];
        [[UIColor blackColor] setStroke];
        [path fill];
        [path stroke];
    }
}

-(void)deleteLineWithIndex:(NSInteger)index
{
    [currentPaths removeObjectAtIndex:index];
    numPaths --;
    [self setNeedsDisplay];
}

-(void)updateLineWithIndex:(NSInteger)index startX:(NSInteger)sx startY:(NSInteger)sy endX:(NSInteger)ex endY:(NSInteger)ey
{
    [[currentPaths objectAtIndex:index] removeAllPoints];
    [[currentPaths objectAtIndex:index] moveToPoint:CGPointMake(sx + 36, sy + 36)];
    [[currentPaths objectAtIndex:index] addLineToPoint:CGPointMake(ex + 36, ey + 36)];
    [self setNeedsDisplay];
}

@end
