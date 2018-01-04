//
//  Edge.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/4/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"

@interface Edge : NSObject

@property (nonatomic, strong) Vertex *from;
@property (nonatomic, strong) Vertex *to;

@property (nonatomic, assign) int distance;

@end
