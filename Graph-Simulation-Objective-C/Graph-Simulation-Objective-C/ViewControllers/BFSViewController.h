//
//  BFSViewController.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/14/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

@interface BFSViewController : UIViewController

@property (nonatomic, strong) Graph *G;
@property (nonatomic, assign) int root;

@property (nonatomic, strong) UINavigationController *navigationController;
@end
