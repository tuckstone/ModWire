//
//  PathView.h
//  ModWire
//
//  Created by Lion User on 24/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DraggableIcon;
@interface PathView : UIView

@property (nonatomic) DraggableIcon *currentFrom;
@property (nonatomic) DraggableIcon *currentTo;
@property (nonatomic) NSInteger numPaths;

@property (nonatomic, retain) NSMutableArray *currentPaths;

-(void)beginDrawFrom: (DraggableIcon *)from To:(DraggableIcon *)to;
-(void)deleteLineWithIndex: (NSInteger)index;
-(void)updateLineWithIndex: (NSInteger)index startX: (NSInteger) sx startY: (NSInteger) sy endX: (NSInteger) ex endY: (NSInteger) ey;
@end
