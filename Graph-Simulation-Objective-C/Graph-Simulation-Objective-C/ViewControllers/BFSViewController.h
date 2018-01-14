//
//  BFSViewController.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/14/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Graph.h"

typedef NS_ENUM(NSUInteger, BFSColor) {
    BFSColorWhite,
    BFSColorBrown,
    BFSColorBlack
};

@interface BFSViewController : UIViewController

@property (nonatomic, strong) Graph *G;
@property (nonatomic, strong) NSString *root;

@property (nonatomic, strong) UINavigationController *navigationController;

@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *queueView;
@property (weak, nonatomic) IBOutlet UIView *currentVertexView;
@property (weak, nonatomic) IBOutlet UIView *adjacentVerticesView;
@property (weak, nonatomic) IBOutlet UIView *outputView;

@end
