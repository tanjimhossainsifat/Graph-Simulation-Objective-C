//
//  Graph.m
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/4/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "Graph.h"

@implementation Graph {
    NSMutableArray *adjacencyList;
    NSMutableDictionary *vertexPoolDic;
    NSMutableArray *edgePoolList;
    
    int vertexCounter;
}

-(id) init {
    self = [super init];
    vertexCounter = 0;
    
    adjacencyList = [[NSMutableArray alloc] init];
    vertexPoolDic = [[NSMutableDictionary alloc] init];
    edgePoolList = [[NSMutableArray alloc] init];
    
    return self;
}

- (void) insertEdgeFrom:(NSString *)fromVertexName to:(NSString *)toVertexName withDistance:(int) distance {
    
    Vertex *fromVertex = [self getVertexForName:fromVertexName];
    Vertex *toVertex = [self getVertexForName:toVertexName];
    
    Edge *edge = [self getEdgeFromVertex:fromVertex toVertex:toVertex withDistance:distance];
    
    [self insertAdjacencyEdge:edge fromVertex:fromVertex];
    
}

#pragma mark - Vertex related methods

-(Vertex *) getVertexForName:(NSString *) vertexName {
    
    Vertex *vertex = [vertexPoolDic objectForKey:vertexName];
    if(!vertex) {
        vertex = [[Vertex alloc] init];
        vertex.name = vertexName;
        vertex.id = vertexCounter;
        vertexCounter++;
        [vertexPoolDic setObject:vertex forKey:vertexName];
    }
    return vertex;
}

-(NSArray<Vertex *> *) getAllVertices {
    return  vertexPoolDic.allValues;
}

#pragma mark - Edge related methods

-(Edge *) getEdgeFromVertex:(Vertex *)fromVertex toVertex:(Vertex *)toVertex withDistance:(int) distance {
    
    Edge *edge = [[Edge alloc] init];
    edge.from = fromVertex;
    edge.to = toVertex;
    edge.distance = distance;
    
    [edgePoolList addObject:edge];
    
    return edge;
}

-(NSArray<Edge *> *) getAllEdges {
    return edgePoolList;
}

#pragma mark - Adjacency related methods

- (void) insertAdjacencyEdge:(Edge *)edge fromVertex:(Vertex *) fromVertex {
    
    int index = fromVertex.id;
    
    NSMutableArray *eachAdjacency = [adjacencyList objectAtIndex:index];
    if(!eachAdjacency) {
        eachAdjacency = [[NSMutableArray alloc] init];
        [adjacencyList insertObject:eachAdjacency atIndex:index];
    }
    
    [eachAdjacency addObject:edge];
}

- (NSArray<Edge *> *) getAllOutgoingEdgesFromVertex:(Vertex *) vertex {
    return  [adjacencyList objectAtIndex:vertex.id];
}

- (NSArray<Vertex *> *) getAdjacentVerticesFromVertex:(Vertex *) fromVertex {
    NSArray<Edge *> *adjacentEdges =  [adjacencyList objectAtIndex:fromVertex.id];
    NSMutableArray *adjacentVertices = [[NSMutableArray alloc] init];
    for(Edge *eachEdge in adjacentEdges) {
        [adjacentVertices addObject:eachEdge.to];
    }
    
    return adjacentVertices;
}

@end
