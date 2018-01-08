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
{
    BOOL isFirstVertexSelected;
    UIButton *firstVertexButton;
    UIButton *secondVertexButton;
    NSMutableDictionary *edgeDic;
}

@synthesize navigationController = _navigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.instructionLabel.hidden = YES;
    isFirstVertexSelected = NO;
    edgeDic = [[NSMutableDictionary alloc] init];
    
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
        
        [vertexButton addTarget:self action:@selector(onButtonVertexButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.viewForDrawing addSubview:vertexButton];
        
    }
}

#pragma mark - Button Actions
- (IBAction)onButtonSubmit:(id)sender {
}

-(void) onButtonVertexButton:(UIButton *) sender {
    
    UIButton *vertexButton = sender;
    
    if(isFirstVertexSelected == NO) {
        isFirstVertexSelected = YES;
        firstVertexButton = vertexButton;
        [vertexButton setSelected:YES];
    }
    else {
        isFirstVertexSelected = NO;
        [firstVertexButton setSelected:NO];
        secondVertexButton = vertexButton;
        
        [self checkEdgeAndModifyFromVertex1:firstVertexButton.tag ToVertex2:secondVertexButton.tag];
        
    }
    
    
}

#pragma mark - Private methods
- (void) checkEdgeAndModifyFromVertex1:(int) vertex1 ToVertex2:(int) vertex2 {
    
    NSString *edgeDicKey = [NSString stringWithFormat:@"%d->%d",vertex1,vertex2];
    
    NSString *weightForEdgeDicKey = [edgeDic objectForKey:edgeDicKey];
    
    if(weightForEdgeDicKey) {//Already has a value for this edge
        
        UIAlertAction *updateAction = [UIAlertAction actionWithTitle:@"Modify" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self showPopupToUpdateEdgeWeightFromVertex:vertex1 ToVertex:vertex2 WithError:nil];
            
        }];
        UIAlertAction *removeAction = [UIAlertAction actionWithTitle:@"Remove this edge" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            [self showPopupToRemoveEdgeFromVertex:vertex1 ToVertex:vertex2];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
        
        NSString *msg;
        if(self.isWeightedGraph) {
            msg = @"An edge is already added between these vertices. Do you want to Modify or Remove this edge?";
        }
        else {
            msg = @"An edge is already added between these vertices. Do you want to Remove this edge?";
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Edge already added" message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        if(self.isWeightedGraph) [alert addAction:updateAction];
        [alert addAction:removeAction];
        [alert addAction:cancelAction];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alert animated:YES completion:nil];
        });
        
        
    }
    else {//This edge is new
        
        if(!self.isWeightedGraph) {
            [edgeDic setValue:@"1" forKey:edgeDicKey]; //For unweighted graph, weight is fixed
        }
        else {
            [self showPopupToInsertEdgeWeightFromVertex:vertex1 ToVertex:vertex2 WithError:nil];
            
        }
        
    }
}

-(void) showPopupToInsertEdgeWeightFromVertex:(int)vertex1 ToVertex:(int)vertex2 WithError:(NSString *) error {
    
    NSString *msg;
    if(!error || error.length==0) {
        msg = @"Add weight value for this edge";
    }
    else {
        msg = error;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Insert Weight" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *insertAction = [UIAlertAction actionWithTitle:@"Insert" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        if(textField && textField.text && textField.text.length>0) {
            NSInteger number = [textField.text integerValue];
            if(!number) {
                [self showPopupToInsertEdgeWeightFromVertex:vertex1 ToVertex:vertex2 WithError:@"Insert a valid number"];
            }
            else {
                NSString *edgeDicKey = [NSString stringWithFormat:@"%d->%d",vertex1,vertex2];
                [edgeDic setObject:[NSString stringWithFormat:@"%ld",(long)number] forKey:edgeDicKey];
            }
        }
        else {
            [self showPopupToInsertEdgeWeightFromVertex:vertex1 ToVertex:vertex2 WithError:@"Insert Again"];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Insert Weight";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:insertAction];
    [alert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
}

-(void) showPopupToUpdateEdgeWeightFromVertex:(int)vertex1 ToVertex:(int)vertex2 WithError:(NSString *) error {
    
    NSString *msg;
    if(!error || error.length==0) {
        msg = @"Update weight value for this edge";
    }
    else {
        msg = error;
    }
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Update Weight" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *insertAction = [UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alert.textFields.firstObject;
        if(textField && textField.text && textField.text.length>0) {
            NSInteger number = [textField.text integerValue];
            if(!number) {
                [self showPopupToUpdateEdgeWeightFromVertex:vertex1 ToVertex:vertex2 WithError:@"Insert a valid number"];
            }
            else {
                NSString *edgeDicKey = [NSString stringWithFormat:@"%d->%d",vertex1,vertex2];
                [edgeDic setObject:[NSString stringWithFormat:@"%ld",(long)number] forKey:edgeDicKey];
            }
        }
        else {
            [self showPopupToUpdateEdgeWeightFromVertex:vertex1 ToVertex:vertex2 WithError:@"Update Again"];
        }
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Update Weight";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [alert addAction:insertAction];
    [alert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
}

-(void) showPopupToRemoveEdgeFromVertex:(int)vertex1 ToVertex:(int)vertex2
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Are you sure" message:@"Do you want to remove this edge?" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *edgeDicKey = [NSString stringWithFormat:@"%d->%d",vertex1,vertex2];
        [edgeDic removeObjectForKey:edgeDicKey];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}
@end
