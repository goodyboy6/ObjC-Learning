//
//  CADCubeViewController.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CADCubeViewController.h"

@interface CADCubeViewController ()

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *cubeFaces;

@end

@implementation CADCubeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //后期可以加入一些手势和每个页面的点击
    
    [self makeACube];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ide = @"fsada";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ide forIndexPath:indexPath];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", indexPath];
    
    return cell;
}


- (void)makeACube
{
    self.containerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.containerView.layer.sublayerTransform = ({
        CATransform3D ori = CATransform3DIdentity;
        ori.m34 = -1.0/500.0;
        ori = CATransform3DRotate(ori, -M_PI_4, 1, 0, 0);
        ori = CATransform3DRotate(ori, -M_PI_4, 0, 1, 0);
        ori;
    });
    
    [self.cubeFaces enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.layer.contentsScale = [UIScreen mainScreen].scale;
    }];
    
    //以4为底部,立方体中心点在平面上
    //右侧1
    UIView *face = self.cubeFaces[0];
    face.backgroundColor = [UIColor redColor];
    CATransform3D transform = CATransform3DMakeTranslation(50, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    face.layer.transform = transform;
    face.layer.doubleSided = YES;
    
    //上面2
    face = self.cubeFaces[1];
    face.backgroundColor = [UIColor purpleColor];
    transform = CATransform3DMakeTranslation(0, 0, 50);
    face.layer.transform = transform;
    
    //左侧3
    face = self.cubeFaces[2];
    face.backgroundColor = [UIColor blueColor];
    
    transform = CATransform3DMakeTranslation(-50, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    face.layer.transform = transform;
    
    //下侧4
    face = self.cubeFaces[3];
    face.backgroundColor = [UIColor yellowColor];
    transform = CATransform3DMakeTranslation(0, 0, -50);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    face.layer.transform = transform;
    
    //前5
    face = self.cubeFaces[4];
    face.backgroundColor = [UIColor orangeColor];
    transform = CATransform3DMakeTranslation(0, -50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    face.layer.transform = transform;
    
    //后6
    face = self.cubeFaces[5];
    face.backgroundColor = [UIColor blackColor];
    transform = CATransform3DMakeTranslation(0, 50, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    face.layer.transform = transform;
}

@end
