//
//  DrawGraphViewController.m
//  Graph-Simulation-Objective-C
//
//  Created by Tanjim Hossain on 1/5/18.
//  Copyright © 2018 Tanjim Hossain. All rights reserved.
//

#import "DrawGraphViewController.h"
#import "Graph.h"
#import "BFSViewController.h"

@interface DrawGraphViewController ()

@end

@implementation DrawGraphViewController
{
    BOOL isFirstVertexSelected;
    UIButton *firstVertexButton;
    UIButton *secondVertexButton;
    NSMutableDictionary *edgeDic;
    NSMutableArray *vertexButtonList;
    NSMutableDictionary *shapeLayerDic;
    Algorithm selectedAlgorithm;
}

@synthesize navigationController = _navigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.instructionLabel.hidden = YES;
    isFirstVertexSelected = NO;
    selectedAlgorithm = AlgorithmNone;
    edgeDic = [[NSMutableDictionary alloc] init];
    vertexButtonList = [[NSMutableArray alloc] initWithCapacity:8];
    shapeLayerDic = [[NSMutableDictionary alloc] init];
    
    [self createVertexButtons];

    
}


- (void) drawEdgesFromVertex:(int)fromVertex ToVertex:(int)toVertex {
    
    UIButton *fromVertexButton = (UIButton *)[vertexButtonList objectAtIndex:fromVertex];
    UIButton *toVertexButton = (UIButton *)[vertexButtonList objectAtIndex:toVertex];
    
    CGPoint firstPoint = CGPointMake(fromVertexButton.frame.origin.x+fromVertexButton.frame.size.width/2, fromVertexButton.frame.origin.y+fromVertexButton.frame.size.height/2);
    CGPoint secondPoint = CGPointMake(toVertexButton.frame.origin.x+toVertexButton.frame.size.width/2, toVertexButton.frame.origin.y+toVertexButton.frame.size.height/2);
    CGPoint controlPoint = [self getQuadCurveControlPointForFirstPoint:firstPoint andSecondPoint:secondPoint];
    
    double angle = atan2(secondPoint.x-firstPoint.x, secondPoint.y-firstPoint.y) * 180/M_PI;
    
    UIBezierPath *edgePath = [UIBezierPath bezierPath];
    [edgePath moveToPoint:firstPoint];
    [edgePath addQuadCurveToPoint:secondPoint controlPoint:controlPoint];
    
    /*
    UIBezierPath *helperPath = [UIBezierPath bezierPath];
    [helperPath addArcWithCenter:secondPoint radius:30 startAngle:(angle)*M_PI/180 endAngle:(angle-5)*M_PI/180 clockwise:YES];
    CGPoint arrowPoint1 = [helperPath currentPoint];
    [helperPath addArcWithCenter:secondPoint radius:30 startAngle:(angle)*M_PI/180 endAngle:(angle+5)*M_PI/180 clockwise:NO];
    CGPoint arrowPoint2 = [helperPath currentPoint];
    
    [edgePath addLineToPoint:arrowPoint1];
    [edgePath addLineToPoint:arrowPoint2];
    [edgePath addLineToPoint:secondPoint];
    */
    
    CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
    shapeLayer.path = edgePath.CGPath;
    shapeLayer.lineWidth = 2.0;
    [shapeLayer setStrokeColor:[UIColor redColor].CGColor];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewForDrawing.layer addSublayer:shapeLayer];
    });
    NSString *shapeLayerDicKey = [NSString stringWithFormat:@"%d->%d",fromVertex,toVertex];
    [shapeLayerDic setObject:shapeLayer forKey:shapeLayerDicKey];
    
}


-(void) eraseEdgeFromVertex:(int)fromVertex ToVertex:(int)toVertex {
    NSString *shapeLayerDicKey = [NSString stringWithFormat:@"%d->%d",fromVertex,toVertex];
    CAShapeLayer *shapeLayer = [shapeLayerDic objectForKey:shapeLayerDicKey];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(shapeLayer) [shapeLayer removeFromSuperlayer];
    });
    
    if(shapeLayer) [shapeLayerDic removeObjectForKey:shapeLayerDicKey];
    
}

-(void) createVertexButtons {
    
    [vertexButtonList removeAllObjects];
    
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
        
        [vertexButtonList insertObject:vertexButton atIndex:i];
        
        [vertexButton addTarget:self action:@selector(onButtonVertexButton:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.viewForDrawing addSubview:vertexButton];
        
    }
}

#pragma mark - Button Actions
- (IBAction)onButtonSubmit:(id)sender {
    
    UIAlertAction *bfsAction = [UIAlertAction actionWithTitle:@"BFS" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        selectedAlgorithm = AlgorithmBFS;
        [self showPopupToSelectRootVertex];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Algorithm" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:bfsAction];
    [alert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
    
    
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
        
        if(firstVertexButton != secondVertexButton)[self checkEdgeAndModifyFromVertex1:firstVertexButton.tag ToVertex2:secondVertexButton.tag];
        
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
            [self drawEdgesFromVertex:vertex1 ToVertex:vertex2];
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
                [self drawEdgesFromVertex:vertex1 ToVertex:vertex2];
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
                [self drawEdgesFromVertex:vertex1 ToVertex:vertex2];
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
        [self eraseEdgeFromVertex:vertex1 ToVertex:vertex2];
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

-(CGPoint) getQuadCurveControlPointForFirstPoint:(CGPoint)firstPoint andSecondPoint:(CGPoint)secondPoint {
    
    if(firstPoint.y < secondPoint.y) {//first at top, second at bottom
        
        if(firstPoint.x < secondPoint.x) {//first at left, second at right
            
            return CGPointMake(firstPoint.x, secondPoint.y);
        }
        else if(firstPoint.x > secondPoint.x) {//first at right, second at left
            return CGPointMake(secondPoint.x, firstPoint.y);
        }
        else {//first and second both at same width
            return CGPointMake(firstPoint.x - 100, (firstPoint.y + secondPoint.y)/2);
        }
        
    }
    else if(firstPoint.y > secondPoint.y) {//first at bottom, second at bottom
        
        if(firstPoint.x < secondPoint.x) {//first at left, second at right
            
            return CGPointMake(secondPoint.x, firstPoint.y);
        }
        else if(firstPoint.x > secondPoint.x) {//first at right, second at left
            return CGPointMake(firstPoint.x, secondPoint.y);
        }
        else {//first and second both at same width
            return CGPointMake(firstPoint.x + 100, (firstPoint.y + secondPoint.y)/2);
        }
    }
    else {//first and second both are at same height
        
        if(firstPoint.x < secondPoint.x) {//first at left, second at right
            
            return CGPointMake((firstPoint.x+secondPoint.x)/2, secondPoint.y + 100);
        }
        else if(firstPoint.x > secondPoint.x) {//first at right, second at left
            return CGPointMake((firstPoint.x+secondPoint.x)/2, secondPoint.y - 100);
        }
        else {//first and second both at same width
            return CGPointMake(firstPoint.x + 100, firstPoint.y);
        }
        
    }
}

-(void) showPopupToSelectRootVertex {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Select Root Vertex" message:@"From the list, choose the root vertex" preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i=0;i <_numberOfVertex;i++) {
        
        NSString *vertexName;
        if(self.vertexNameType == VertexNameTypeNumerical)
            vertexName = [NSString stringWithFormat:@"%d",i];
        else
            vertexName = [NSString stringWithFormat:@"%c",'A'+i];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:vertexName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self initiateGraphWithRoot:vertexName];
        }];
        [alert addAction:action];
    }
    
    UIAlertAction *randAction = [UIAlertAction actionWithTitle:@"Random" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *vertexName;
        if(self.vertexNameType == VertexNameTypeNumerical)
            vertexName = [NSString stringWithFormat:@"%d",rand()%_numberOfVertex];
        else
            vertexName = [NSString stringWithFormat:@"%c",'A'+(rand()%_numberOfVertex)];
        [self initiateGraphWithRoot:vertexName];
    }];
    [alert addAction:randAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alert animated:YES completion:nil];
    });
}

- (void) initiateGraphWithRoot:(NSString *) rootVertex {
    
    Graph *G = [[Graph alloc] init];
    
    for (NSString *edgeString in edgeDic.allKeys) {
        if(edgeString && edgeString.length>0) {
            NSArray *edgeStringArray = [edgeString componentsSeparatedByString:@"->"];
            NSString *fromVertex = [edgeStringArray objectAtIndex:0];
            NSString *toVertex = [edgeStringArray objectAtIndex:1];
            NSString *weightString = [edgeDic objectForKey:edgeString];
            NSInteger weight = [weightString integerValue];
            
            if(fromVertex && fromVertex.length>0 && toVertex && toVertex.length>0 && weight) {
                
                NSInteger fromVertexIndex = [fromVertex integerValue];
                NSInteger toVertexIndex = [toVertex integerValue];
                
                if(self.vertexNameType == VertexNameTypeNumerical) {
                    fromVertex = [NSString stringWithFormat:@"%d",(int)fromVertexIndex];
                    toVertex = [NSString stringWithFormat:@"%d",(int)toVertexIndex];
                }
                else if(self.vertexNameType == VertexNameTypeAlphabetical) {
                    fromVertex = [NSString stringWithFormat:@"%c",'A'+(int)fromVertexIndex];
                    toVertex = [NSString stringWithFormat:@"%c",'A'+(int)toVertexIndex];
                }
                
                [G insertEdgeFrom:fromVertex to:toVertex withDistance:(int)weight];
            }
            
        }
    }
    
    if(selectedAlgorithm == AlgorithmBFS) {
        BFSViewController *bfsVC = [[BFSViewController alloc] init];
        bfsVC.G = G;
        bfsVC.root = rootVertex;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:bfsVC animated:YES];
        });
    }
    else {
        
    }
}
@end
