//
//  InputViewController.h
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/5/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController

@property (nonatomic, strong) UINavigationController *navigationController;

@property (weak, nonatomic) IBOutlet UITextField *vertexNumberTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *vertexTypeSegmentControl;
@property (weak, nonatomic) IBOutlet UISwitch *isWeightedGraphSwitch;


- (IBAction)onButtonApply:(id)sender;
@end
