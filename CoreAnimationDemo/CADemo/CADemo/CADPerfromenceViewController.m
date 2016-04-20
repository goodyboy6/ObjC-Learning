//
//  CADPerfromenceViewController.m
//  CADemo
//
//  Created by yixiaoluo on 15/11/5.
//  Copyright © 2015年 yixiaoluo. All rights reserved.
//

#import "CADPerfromenceViewController.h"

@interface CADPerfromenceViewCell : UITableViewCell

@end

@implementation CADPerfromenceViewCell

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.frame = ({
        CGRect f = self.imageView.frame;
        f.size.width = f.size.height;
        f;
    });
    self.textLabel.frame = ({
        CGRect f = self.textLabel.frame;
        f.origin.x = CGRectGetMaxX(self.imageView.frame)+3;
        f;
    });
};

@end

@interface CADPerfromenceViewController ()

@property (nonatomic) NSArray *persons;

@end

@implementation CADPerfromenceViewController

NSString *nameAtIndex(NSInteger index)
{
    NSArray *names = @[@"asndlkansd", @"nsaldnfgkldngdklfs",@"fnsdlnfs",@"fnsdkf",@"fkjsdnfksd",@"qweqlw",@"eqwneql",@"nlkealsnda",@"dnadnlasnk",@"nasldnlas"];
    
    return names[index%names.count];
}

NSString *avatarAtIndex(NSInteger index){
    NSArray *avatarNames = @[@"copy@2x", @"iconfont-feiji@3x",@"iconfont-quan@2x",@"9d2cbeb8gw1exuu672uqgj20dw0kujte",@"Super_Star_NSMB2@x",@"005vbOHfgw1extuefy849j30zk0pljvr"];
    
    return avatarNames[index%avatarNames.count];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1000];
    for (NSInteger i=0; i<1000; i++) {
        [array addObject:@{
                          @"name":nameAtIndex(i),
                          @"avatar":avatarAtIndex(i)
                          }];
    }
    
    self.persons = [array copy];
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
    return self.persons.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cad" forIndexPath:indexPath];
    
    [self configureCell:(CADPerfromenceViewCell *)cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = self.persons[indexPath.row];
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:item[@"avatar"] ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.textLabel.text = item[@"name"];
    
    
    //corner radius
    cell.imageView.image = image;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height/2;
//    cell.imageView.layer.masksToBounds = YES;

    //改进2
    CAShapeLayer *layer = (CAShapeLayer *)[cell.contentView.layer.sublayers lastObject];
    if (![layer isKindOfClass:[CAShapeLayer class]]) {
        layer = [CAShapeLayer layer];
        layer.frame = CGRectMake(16, 0, 43.5, 43.5);
        layer.contentsScale = [UIScreen mainScreen].scale;
        layer.contentsGravity = kCAGravityResizeAspect;
        layer.path = [UIBezierPath bezierPathWithRoundedRect:layer.bounds cornerRadius:layer.frame.size.height/2].CGPath;
        [cell.contentView.layer addSublayer:layer];
    }
    layer.contents = (__bridge id)image.CGImage;
    [layer display];
    
//    //改进一 光栅化:缓存图层内容，离屏渲染将会被保存
//    cell.layer.shouldRasterize = YES;
//    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
}


@end
