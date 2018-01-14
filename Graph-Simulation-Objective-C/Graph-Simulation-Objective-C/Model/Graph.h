//
//  Graph.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/4/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Vertex.h"
#import "Edge.h"

@interface Graph : NSObject

-(id) init;
- (void) insertEdgeFrom:(NSString *)fromVertexName to:(NSString *)toVertexName withDistance:(int) distance;

-(NSArray<Vertex *> *) getAllVertices;
-(Vertex *) getVertexForName:(NSString *) vertexName;
-(NSArray<Edge *> *) getAllEdges;

- (NSArray<Edge *> *) getAllOutgoingEdgesFromVertex:(Vertex *) vertex;
- (NSArray<Vertex *> *) getAdjacentVerticesFromVertex:(Vertex *) fromVertex;
@end
