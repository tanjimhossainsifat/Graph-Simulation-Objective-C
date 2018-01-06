//
//  DrawGraphViewController.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/5/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,VertexNameType) {
    VertexNameTypeNumerical,
    VertexNameTypeAlphabetical
};

@interface DrawGraphViewController : UIViewController

@property (nonatomic, strong) UINavigationController *navigationController;

@property (weak, nonatomic) IBOutlet UILabel *instructionLabel;
@property (weak, nonatomic) IBOutlet UIView *viewForDrawing;

@property (nonatomic, assign) VertexNameType vertexNameType;
@property (nonatomic, assign) int numberOfVertex;
@property (nonatomic, assign) BOOL isWeightedGraph;

- (IBAction)onButtonSubmit:(id)sender;


@end
