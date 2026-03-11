// 最小化版本的DYYY.xm

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

// 基本函数
NSArray *DYYYGetVoicePackageList(void) {
    return @[];
}

NSArray *DYYYGetStickerCollectionList(void) {
    return @[];
}

void DYYYPlayVoiceFromPackage(NSString *filePath) {
    NSLog(@"Playing voice: %@", filePath);
}

// 基本hook
%hook UIViewController
- (void)viewDidLoad {
    %orig;
    NSLog(@"DYYY loaded");
}
%end
