// 最简化版本的DYYY.xm

%hook UIViewController
- (void)viewDidLoad {
    %orig;
    NSLog(@"DYYY loaded");
}
%end
