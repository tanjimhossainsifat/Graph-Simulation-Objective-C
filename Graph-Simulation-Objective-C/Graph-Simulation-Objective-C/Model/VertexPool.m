//
//  VertexPool.m
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/4/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "VertexPool.h"
#import "Vertex.h"
#import "Edge.h"

@implementation VertexPool {
    NSMutableDictionary *vertexPoolDic;
    NSMutableArray *edgePoolList;
    NSMutableDictionary *adjacencyDic;
}

+(instancetype) sharedInstance {
    
    static VertexPool *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[VertexPool alloc] init];
    });
    
    return sharedInstance;
}

-(id) init {
    self = [super init];
    vertexPoolDic = [[NSMutableDictionary alloc] init];
    edgePoolList = [[NSMutableArray alloc] init];
    adjacencyDic = [[NSMutableDictionary alloc] init];
    return self;
}

- (void) addEdgeFrom:(NSString *)fromVertexID to:(NSString *)toVertexID withDistanc:(int )distance {
    
    Vertex *from = [self getVertexWithID:fromVertexID];
    Vertex *to = [self getVertexWithID:toVertexID];
    
    Edge *edge = [self getEdgeFrom:from to:to withDistance:distance];
    
    [self addAdjacencyEdge:edge forVertex:from];
}

#pragma mark - Vertex related methods
-(Vertex *) getVertexWithID:(NSString *)vertexID {
    Vertex *vertex = [vertexPoolDic objectForKey:vertexID];
    if(!vertex) {
        vertex = [Vertex alloc] ;
        vertex.id = vertexID;
        [vertexPoolDic setObject:vertex forKey:vertexID];
    }
    return vertex;
}
-(NSArray *) getAllVertex {
    return vertexPoolDic.allValues;
}
-(NSUInteger) getNumberOfVertex {
    return vertexPoolDic.allValues.count;
}

#pragma mark - Edge related methods
-(Edge *) getEdgeFrom:(Vertex *)from to:(Vertex *)to withDistance:(int) distance {
    
    Edge *edge = [[Edge alloc] init];
    edge.from = from;
    edge.to = to;
    edge.distance = distance;
    
    [edgePoolList addObject:edge];
    
    return edge;
    
}

-(NSArray *) getAllEdge {
    return edgePoolList;
}

-(NSUInteger) getNumberOfEdge {
    return edgePoolList.count;
}

#pragma  mark - Adjacency related Method
-(void) addAdjacencyEdge:(Edge *)edge forVertex:(Vertex *)vertex {
    NSMutableArray *adjacencyList = [adjacencyDic objectForKey:vertex];
    if(!adjacencyList) {
        adjacencyList = [[NSMutableArray alloc] init];
    }
    [adjacencyList addObject:edge];
    
    [adjacencyDic setObject:adjacencyList forKey:vertex];
}

@end
