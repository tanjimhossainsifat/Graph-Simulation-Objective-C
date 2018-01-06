//
//  DrawGraphViewController.m
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/5/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "DrawGraphViewController.h"

@interface DrawGraphViewController ()

@end

@implementation DrawGraphViewController

@synthesize navigationController = _navigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.instructionLabel.hidden = YES;
    
    [self createVertexButtons];
    
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

-(void) createVertexButtons {
    
    for (int i=0;i<_numberOfVertex;i++) {
        float width = self.viewForDrawing.frame.size.width;
        float height = self.viewForDrawing.frame.size.height;
        
        int numberOfButtonOnLeftSide = (_numberOfVertex>>1)+(_numberOfVertex & 1);
        
        float vertexButtonCenterY = (height/(numberOfButtonOnLeftSide+1))*(i/2 + 1);
        float vertexButtonCenterX;
        if((i&1)==1)//odd
            vertexButtonCenterX= width/2+(width/4);
        else //eve
            vertexButtonCenterX = width/2 - (width/4);
        
        UIButton *vertexButton = [[UIButton alloc] initWithFrame:CGRectMake(vertexButtonCenterX, vertexButtonCenterY, 50, 50)];
        [vertexButton setCenter:CGPointMake(vertexButtonCenterX, vertexButtonCenterY)];
        if(self.vertexNameType == VertexNameTypeNumerical)
            [vertexButton setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
        else
            [vertexButton setTitle:[NSString stringWithFormat:@"%c",'A'+i] forState:UIControlStateNormal];
        
        [vertexButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [vertexButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        
        [vertexButton setBackgroundImage:[UIImage imageNamed:@"white_circle"] forState:UIControlStateNormal];
        [vertexButton setBackgroundImage:[UIImage imageNamed:@"red_circle"] forState:UIControlStateSelected];
        
        vertexButton.tag = i;
        
        [self.viewForDrawing addSubview:vertexButton];
        
    }
}

- (IBAction)onButtonSubmit:(id)sender {
}
@end
