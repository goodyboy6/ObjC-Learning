# ObjC-Learning

## ReactiveCocoa

`objective-c`
//返回一个用来更新地理位置的信号量
- (RACSignal *)updateCurrentLocation
{
//已知[self didUpdateLocations]是locationManager:didUpdateLocations:回调的信号量，这个回调返回定位的GPS信息。[self didUpdateLocations]返回的GPS位置数组信号量，进行map操作，map操作简单的说就是遍历＋处理，[self didUpdateLocations]，每每返回一个位置数组，这一步的map函数都将其变为数组的最后一个对象输出，然后再用filter函数过滤，把请求时间超时的数据去掉，isStale是一个私有属性，这里就不粘出来了。
RACSignal *currentLocationUpdated = [[[self didUpdateLocations] map:^id(NSArray *locations) {
return locations.lastObject; //返回最后一个对象
}] filter:^BOOL(CLLocation *location) {
return !location.isStale; //过滤超时对象
}];
//map函数返回id类型，用来替换。filter函数返回 BOOL值，决定要不要过滤掉，返回NO就过滤。

//locationManager:didFailWithError:的信号量
RACSignal *locationUpdateFailed = [[[self didFailWithError] map:^id(NSError *error) {
return [RACSignal error:error];
}] switchToLatest];

//最后返回的信号量，是上面两股信号量的merge(混合)，take:1是不管这两个信号那一个先来，只返回一个，initially是信号量开始时候调用的block，finally则是信号量结束了调用的block。
return [[[[RACSignal merge:@[currentLocationUpdated, locationUpdateFailed]] take:1] initially:^{
[self.locationManager startUpdatingLocation];
}] finally:^{
[self.locationManager stopUpdatingLocation];
}];
}
``