//
//  BFSViewController.m
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/14/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "BFSViewController.h"

@interface BFSViewController ()

@end

@implementation BFSViewController
{
    NSMutableArray *queue;
    NSMutableArray *outputArray;
}
@synthesize navigationController = _navigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    outputArray = [[NSMutableArray alloc] init];
    
    [self BFS];
}

-(void) BFS {
    
    int colorList[[[self.G getAllVertices] count]];
    for( int i = 0; i< [[self.G getAllVertices] count]; i++) {
        BFSColor color = BFSColorWhite;
        colorList[i] = color;
    }
    Vertex *root = [self.G getVertexForName:self.root];
    queue = [[NSMutableArray alloc] init];
    [queue addObject:root];
    colorList[root.id] = BFSColorBrown;
    
    while([queue count] > 0) {
        Vertex *node = [queue firstObject];
        [queue removeObject:node];
        NSArray<Vertex *> *adjacentVertices = [self.G getAdjacentVerticesFromVertex:node];
        for (Vertex *eachAdjacentVertex in adjacentVertices) {
            if(colorList[eachAdjacentVertex.id] == BFSColorWhite) {
                [queue addObject:eachAdjacentVertex];
                colorList[eachAdjacentVertex.id] = BFSColorBrown;
            }
        }
        colorList[node.id] = BFSColorBlack;
        [outputArray addObject:node];
        
    }
    
    for(int i = 0; i<[outputArray count];i++) {
        NSLog(@"%@\n",[[outputArray objectAtIndex:i] name]);
    }
}

@end
