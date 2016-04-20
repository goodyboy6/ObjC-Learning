//
//  KVC_KVO_.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/3/19.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "KVC_KVO_.h"
#import "FBKVOController.h"

@interface KVC_KVO_ ()

@property (strong, nonatomic)  KVOObject *KVOObject;

@end

@implementation KVC_KVO_

- (void)viewDidLoad {
    [super viewDidLoad];
    
     //Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
    
     //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [addButton addTarget:self action:@selector(addPerson) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    textField.placeholder = @"可以修改place holder color";
    textField.borderStyle = UITextBorderStyleRoundedRect;
    self.navigationItem.titleView = textField;
    
    //use kvc to change placeholder color
    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //data drive views
    self.KVOObject = [[KVOObject alloc] init];
    self.KVOObject.pid = 293402423;
    [self.KVOController observe:self.KVOObject keyPath:@"personArray" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld block:^(id observer, id object, NSDictionary *change) {
        NSLog(@"-------%@", change);
        NSLog(@"-------change %@", change[NSKeyValueChangeIndexesKey]);
        NSLog(@"-------kind %@",  change[NSKeyValueChangeKindKey]);
        NSLog(@"-------obj %@", change[NSKeyValueChangeNewKey]);

        NSKeyValueChange changeType = [change[NSKeyValueChangeKindKey] integerValue];
        
        NSInteger changeIndex = [change[NSKeyValueChangeIndexesKey] lastIndex];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:changeIndex inSection:0];
        
        switch (changeType) {
            case NSKeyValueChangeSetting:
                //called when personArray is assigned by a new array
                [self.tableView reloadData];
                break;
            case NSKeyValueChangeInsertion:
                [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                break;
            case NSKeyValueChangeRemoval:
                [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                break;
            case NSKeyValueChangeReplacement:
                //table view already changed
                break;
                
            default:
                break;
        }
    }];
    
    [self.KVOController observe:self.KVOObject keyPath:@"pid" options:NSKeyValueObservingOptionPrior block:^(id observer, id object, NSDictionary *change) {
        NSLog(@"----%@", change);
        [self.tableView reloadData];
    }];
    
    //other test
    [self testKVC];
    [self testMutableDictionary];
}

#pragma mark - actions
- (void)addPerson
{
    Person *obj = [[Person alloc] init];
    obj.name = @"added one";
    obj.birthday = [[NSDate date] description];
    obj.sex = @"female";
    
    [[self.KVOObject mutableArrayValueForKey:@"personArray"] insertObject:obj atIndex:0];
    
    if (self.KVOObject.personArray.count > 8) {
        //this will trigger kvo change with NSKeyValueChangeSetting
        //self.KVOObject.personArray = [NSMutableArray array];
        
        //if assgin Nil to a scalar variable like a NSInteger, you must overwrite setNilValueForKey:
        [self.KVOObject setValue:nil forKey:@"pid"];
        
        NSError *error = nil;
        BOOL assignResult = [self.KVOObject validateValue:nil forKey:@"pid" error:&error];
        if (!assignResult) {
            NSLog(@"validateValue eror : %@", error);
        }
        
        //also you can get a potential 'key', though it's not a property
        NSLog(@"undefined key : %@", [self.KVOObject valueForUndefinedKey:@"ttt"]);
    }
}

#pragma mark - test method
- (void)testKVC
{
    //you can get all the proprety of object in an array
    NSMutableArray *persons = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        Person *obj = [[Person alloc] init];
        obj.name = [NSString stringWithFormat:@"hello %@", @(i)];
        obj.birthday = [[NSDate date] description];
        obj.sex = @"female";
        [persons addObject:obj];
    }

    //funny tip
    NSLog(@"all names: %@", [persons valueForKey:@"name"]);
    NSLog(@"all different sex: %@", [persons valueForKeyPath:@"@distinctUnionOfObjects.sex"]);//NSArray
    NSLog(@"all sex: %@", [persons valueForKeyPath:@"@unionOfObjects.sex"]);

    NSArray *a = @[@4, @84, @44, @2, @84];
    NSLog(@"max = %@", [a valueForKeyPath:@"@max.self"]);
    NSLog(@"min = %@", [a valueForKeyPath:@"@min.self"]);
    NSLog(@"avg = %@", [a valueForKeyPath:@"@avg.self"]);
    NSLog(@"sum = %@", [a valueForKeyPath:@"@sum.self"]);
    NSLog(@"count = %@", [a valueForKeyPath:@"@count.self"]);
    NSLog(@"distinctUnionOfObjects = %@", [a valueForKeyPath:@"@distinctUnionOfObjects.self"]);
    
    NSArray *array = @[@"name", @"w", @"aa", @"jimsa", @"aa"];
    NSLog(@"all uppercaseString: %@", [array valueForKeyPath:@"uppercaseString"]);
}

- (void)testMutableDictionary
{
    NSDictionary *before = @{
                             @"tt":@"before",
                             @"rr":@"before"
                             };
    NSLog(@"before: %@", before);
    NSMutableDictionary *after = [before mutableCopy];
    [after setObject:@"after" forKey:@"tt"];
    [after setObject:@"new@" forKey:@"new"];
    NSLog(@"after: %@", after);
    NSLog(@"before: %@", before);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.KVOObject.personArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ttt"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ttt"];
    }
    
    Person *p = self.KVOObject.personArray[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %d",p.name, self.KVOObject.pid];
    cell.detailTextLabel.text = p.birthday;
    
    return cell;
}

// Override to support conditional editing of the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //use 'collection proxy object' to change colloction data
    [[self.KVOObject mutableArrayValueForKey:@"personArray"] removeObjectAtIndex:indexPath.row];
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    [[self.KVOObject mutableArrayValueForKey:@"personArray"] exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

@end

@implementation KVOObject

+ (BOOL)accessInstanceVariablesDirectly
{
    //more detail: http://blog.sina.com.cn/s/blog_7dc11a2e01016ezf.html
    //when call setValue:forKey: valueForKey:, it firstly find <>. if not find, it comes to here to ask.
    //if return YES, continue searching following: _<>, _is<>, is<>
    //if return NO, it go to setValue:forUndefinedKey: or valueForUndefinedKey:, if you have not overwrite the methods,
    //it will crash.
    return YES;
}

+ (NSSet *)keyPathsForValuesAffectingPid
{
    //this is funny!!!
    //return the keys which will trigger the kvo of 'pid', default is 'pid' itself
    //if return '[NSSet setWithObjects:@"personArray", nil]' which means any changes of 'personArray' will trigger kvo of 'pid'
    return nil;//[NSSet setWithObjects:@"personArray", nil];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //good for that it's readonly for caller
        _personArray = [NSMutableArray array];
    }
    return self;
}

#pragma mark - validate
//if not overwrite 'validateValue:forKey:error:', call this method
- (BOOL)validatePid:(inout __autoreleasing id *)ioValue error:(out NSError *__autoreleasing *)outError
{
    if (ioValue == nil) {
        *outError = [NSError errorWithDomain:@"cn.gikoo" code:401 userInfo:@{NSLocalizedDescriptionKey: @"pid not allow to be nil"}];
        return NO;
    }
    return YES;
}

//The default implementation of this method searches the class of the receiver for a validator method whose name matches the pattern -validate<Key>:error:. If such a method is found it is invoked and the result is returned. If no such method is found, YES is returned.
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKey:(NSString *)inKey error:(out NSError *__autoreleasing *)outError
{
    if (ioValue == nil && [inKey isEqualToString:@"pid"]) {
        *outError = [NSError errorWithDomain:@"cn.gikoo" code:401 userInfo:@{NSLocalizedDescriptionKey: @"pid not allow to be nil"}];
        return NO;
    }
    return YES;
}

#pragma mark - NSMutableArray observer
//more detail: http://blog.sina.com.cn/s/blog_7dc11a2e01016ezf.html
- (void)insertObject:(Person *)object inPersonArrayAtIndex:(NSUInteger)index
{
    [self.personArray insertObject:object atIndex:index];
}

- (void)removeObjectFromPersonArrayAtIndex:(NSUInteger)index
{
    [self.personArray removeObjectAtIndex:index];
}

#pragma mark - kvo
//when called [setValue:nil forKey:@"pid"];
- (void)setNilValueForKey:(NSString *)key
{
    if ([key isEqualToString:@"pid"]) {
        [self setValue:@0 forKey:@"pid"];
    }else{
        [super setNilValueForKey:key];
    }
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return @"UndefinedKey";
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (void)dealloc
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end

@implementation Person

- (void)dealloc
{
    NSLog(@"%@ - %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
}

@end
