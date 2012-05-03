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
@property (nonatomic) NSInteger *numPaths;

@property (nonatomic, retain) NSMutableArray *currentPaths;

-(void)beginDrawFrom: (DraggableIcon *)from To:(DraggableIcon *)to;

@end
