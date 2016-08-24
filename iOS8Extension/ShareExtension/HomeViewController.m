//
//  RootViewController.m
//  iOS8Extension
//
//  Created by yixiaoluo on 2016/8/23.
//  Copyright © 2016年 yixiaoluo. All rights reserved.
//

#import "HomeViewController.h"
#import "FriendsTableViewController.h"

@interface HomeViewController ()

@property (nonatomic) NSArray *titlesArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(goback)];
    
    self.titlesArray = @[
                         @"place holder",
                         @"发送给朋友",
                         @"分享到朋友圈",
                         @"收藏"
                         ];
}

- (void)goback
{
    if (self.gobackHandler) {
        self.gobackHandler();
    }else{
        [self.extensionContext completeRequestReturningItems:@[] completionHandler:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter
- (void)getUrlInfoInBackgroundThread:(void(^)(NSString *title, NSString *url, UIImage *image))completion
{
    __block BOOL didReciveImage = NO;
    __block BOOL didReciveUrl = NO;
    
    NSExtensionItem *item = self.extensionContext.inputItems.count > 0 ?self.extensionContext.inputItems[0] : nil;
    
    NSString *title = item.attributedContentText.string;
    __block UIImage *image = nil;
    __block NSString *url =nil;

    dispatch_block_t checkReciveInfo = ^{
        if (didReciveUrl && didReciveImage) {
                completion(title, url, image);
        }
    };
    
    //获取类型
    NSItemProvider *provider = item.attachments.count > 0? item.attachments[0] : nil;
    __block NSString *identifier = nil;
    [provider.registeredTypeIdentifiers enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([provider hasItemConformingToTypeIdentifier:obj]) {
            identifier = obj;
            *stop = YES;
        }
    }];
    
    if (identifier) {
        //后台线程获取地址
        [provider loadItemForTypeIdentifier:identifier options:item.userInfo completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
            if (item) {
                url = [(NSURL *)item absoluteString];
            }
            didReciveUrl = YES;
            checkReciveInfo();
        }];
        //后台线程获取缩略图
        [provider loadPreviewImageWithOptions:item.userInfo completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
            if (item) {
                image = (UIImage *)item;
            }
            didReciveImage = YES;
            checkReciveInfo();
        }];
    }
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    // Configure the cell...
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"subtitle"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"subtitle"];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        }
        
        [self getUrlInfoInBackgroundThread:^(NSString *title, NSString *url, UIImage *image) {
            dispatch_async(dispatch_get_main_queue(), ^{
                cell.textLabel.text = title;
                cell.detailTextLabel.text = url;
                cell.imageView.image = image;
            });
        }];
        
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"default"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"default"];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = self.titlesArray[indexPath.row];
        cell.textLabel.textColor = [UIColor purpleColor];
        cell.imageView.image = [UIImage imageNamed:@"iMac-icon"];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row == 0 ? 80 : 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendsTableViewController *friends = [[FriendsTableViewController alloc] init];
    [friends setPreferredContentSize:CGSizeMake(0, 46*3 + 400)];
    [self.navigationController pushViewController:friends animated:YES];
}

@end
