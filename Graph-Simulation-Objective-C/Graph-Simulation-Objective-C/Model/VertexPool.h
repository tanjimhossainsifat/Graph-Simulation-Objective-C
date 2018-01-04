//
//  VertexPool.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/4/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VertexPool : NSObject

+(instancetype) sharedInstance;

- (void) addEdgeFrom:(NSString *)fromVertexID to:(NSString *)toVertexID withDistanc:(int )distance;

-(NSArray *) getAllVertex;
-(NSUInteger) getNumberOfVertex;

-(NSArray *) getAllEdge;
-(NSUInteger) getNumberOfEdge;

@end
