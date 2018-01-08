//
//  InputViewController.m
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/5/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "InputViewController.h"
#import "DrawGraphViewController.h"

@interface InputViewController ()

@end

@implementation InputViewController

@synthesize navigationController = _navigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onButtonApply:(id)sender {
    
    NSUInteger vertextNumber = [self.vertexNumberTextField.text integerValue];
    BOOL isWeightedGraph = [self.isWeightedGraphSwitch isOn];
    NSUInteger selectedVertexType = [self.vertexTypeSegmentControl selectedSegmentIndex];
    
    if(!vertextNumber || vertextNumber>8) {
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please enter number of vertex (Maximum 8 allowed)" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:okAction];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
        return;
    }
    
    DrawGraphViewController *drawGraphVC = [[DrawGraphViewController alloc] init];
    drawGraphVC.navigationController = self.navigationController;
    drawGraphVC.numberOfVertex = (int) vertextNumber;
    drawGraphVC.isWeightedGraph = isWeightedGraph;
    if(selectedVertexType == 0) {
        drawGraphVC.vertexNameType = VertexNameTypeNumerical;
    }
    else {
        drawGraphVC.vertexNameType = VertexNameTypeAlphabetical;
    }
    
    [self.navigationController pushViewController:drawGraphVC animated:YES];
}
@end
