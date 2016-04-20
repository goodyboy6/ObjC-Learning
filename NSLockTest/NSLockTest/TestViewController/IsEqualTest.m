//
//  IsEqualTestViewController.m
//  NSLockTest
//
//  Created by yixiaoluo on 15/2/26.
//  Copyright (c) 2015年 cn.gikoo. All rights reserved.
//

#import "IsEqualTest.h"
#import "TestModel.h"

@interface IsEqualTest ()

@property (nonatomic) NSMutableArray *array;

@end

@implementation IsEqualTest

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (NSInteger i = 0; i<3; i++) {
        [self.array addObject:[IsEqualTestObject buildAnObjectWithSameID]];
    }
    
    IsEqualTestObject *obj = [IsEqualTestObject buildAnObjectWithSameID];
    if ([self.array containsObject:obj]) {
        NSLog(@"%@ contains: %@", self.array, obj);
    }
    
    //indexOfObject:  containsObject: 都将会用到isEqual:方法
    NSUInteger index = [self.array indexOfObject:obj];
    if ( index!= NSNotFound) {
        NSLog(@"%@ indexOfObject:%@ == %@", self.array, obj, self.array[index]);
    }
}

- (NSMutableArray *)array
{
    if (_array == nil) {
        _array = [NSMutableArray array];
    }
    return _array;
}

@end

@implementation IsEqualTestObject

+ (instancetype)buildAnObjectWithSameID
{
    IsEqualTestObject *obj = [[IsEqualTestObject alloc] init];
    obj.objID = @(123);
    obj.name = [NSDate date].description;
    return obj;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if ([super isEqual:other]) {
        return YES;
    } else {
        if ([other isKindOfClass:[self class]]) {
            if ([((IsEqualTestObject *)other).objID isEqualToNumber:self.objID]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSUInteger)hash
{
    return (NSUInteger)self;
}

@end

