#import "DYYYFeatureManagers.h"
#import <objc/runtime.h>

#pragma mark - DYYYGradientTextView

@interface DYYYGradientTextView ()

@property(nonatomic, strong) CAGradientLayer *gradientLayer;
@property(nonatomic, strong) CATextLayer *textLayer;
@property(nonatomic, assign) BOOL isAnimating;

@end

@implementation DYYYGradientTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.clipsToBounds = YES;

    _gradientLayer = [CAGradientLayer layer];
    _gradientLayer.startPoint = CGPointMake(0, 0.5);
    _gradientLayer.endPoint = CGPointMake(1, 0.5);
    _gradientLayer.colors = @[
        (__bridge id)[UIColor systemRedColor].CGColor,
        (__bridge id)[UIColor systemBlueColor].CGColor
    ];
    [self.layer addSublayer:_gradientLayer];

    _textLayer = [CATextLayer layer];
    _textLayer.alignmentMode = kCAAlignmentCenter;
    _textLayer.contentsScale = [UIScreen mainScreen].scale;
    [_gradientLayer addSublayer:_textLayer];

    _font = [UIFont boldSystemFontOfSize:20];
    _animationSpeed = 2.0;
    _isAnimating = NO;

    _gradientColors = @[[UIColor systemRedColor], [UIColor systemBlueColor]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _gradientLayer.frame = self.bounds;
    _textLayer.frame = self.bounds;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    [self updateTextLayer];
}

- (void)setFont:(UIFont *)font {
    _font = font;
    [self updateTextLayer];
}

- (void)updateTextLayer {
    self.textLayer.string = self.text;
    self.textLayer.font = (__bridge CFTypeRef)self.font;
    self.textLayer.fontSize = self.font.pointSize;
    self.textLayer.foregroundColor = [UIColor clearColor].CGColor;
}

- (void)updateGradientColors:(NSArray<UIColor *> *)colors {
    if (colors.count < 2) return;
    _gradientColors = colors;
    NSMutableArray *cgColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        [cgColors addObject:(__bridge id)color.CGColor];
    }
    self.gradientLayer.colors = cgColors;
}

- (void)startAnimation {
    if (self.isAnimating) return;
    self.isAnimating = YES;

    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"locations"];
    animation.fromValue = @[@(-0.5), @0, @0.5];
    animation.toValue = @[@0.5, @1, @1.5];
    animation.duration = self.animationSpeed;
    animation.repeatCount = HUGE_VALF;
    [self.gradientLayer addAnimation:animation forKey:@"gradientAnimation"];
}

- (void)stopAnimation {
    self.isAnimating = NO;
    [self.gradientLayer removeAnimationForKey:@"gradientAnimation"];
}

@end

#pragma mark - DYYYThemeManager

@implementation DYYYThemeManager

+ (instancetype)shared {
    static DYYYThemeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadThemeSettings];
    }
    return self;
}

- (void)loadThemeSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *themeStyle = [defaults objectForKey:@"DYYYThemeStyle"];
    if (!themeStyle) themeStyle = @"默认风格";

    _themeStyle = themeStyle;

    NSString *primaryHex = [defaults objectForKey:@"DYYYThemePrimaryColor"];
    NSString *bgHex = [defaults objectForKey:@"DYYYThemeBackgroundColor"];
    NSString *accentHex = [defaults objectForKey:@"DYYYThemeAccentColor"];

    if (primaryHex.length > 0) {
        _primaryColor = [self colorFromHexString:primaryHex] ?: [UIColor systemBlueColor];
    } else {
        _primaryColor = [self defaultPrimaryColorForTheme:themeStyle];
    }

    if (bgHex.length > 0) {
        _backgroundColor = [self colorFromHexString:bgHex] ?: [UIColor systemBackgroundColor];
    } else {
        _backgroundColor = [self defaultBackgroundColorForTheme:themeStyle];
    }

    if (accentHex.length > 0) {
        _accentColor = [self colorFromHexString:accentHex] ?: [UIColor systemPinkColor];
    } else {
        _accentColor = [self defaultAccentColorForTheme:themeStyle];
    }
}

- (UIColor *)defaultPrimaryColorForTheme:(NSString *)themeStyle {
    if ([themeStyle isEqualToString:@"炫彩风格"]) {
        return [UIColor systemPurpleColor];
    } else if ([themeStyle isEqualToString:@"简约风格"]) {
        return [UIColor systemGrayColor];
    } else if ([themeStyle isEqualToString:@"赛博风格"]) {
        return [UIColor systemCyanColor];
    } else if ([themeStyle isEqualToString:@"奶油风格"]) {
        return [UIColor colorWithRed:255/255.0 green:204/255.0 blue:170/255.0 alpha:1.0];
    } else if ([themeStyle isEqualToString:@"暗夜风格"]) {
        return [UIColor systemIndigoColor];
    }
    return [UIColor systemBlueColor];
}

- (UIColor *)defaultBackgroundColorForTheme:(NSString *)themeStyle {
    if ([themeStyle isEqualToString:@"炫彩风格"]) {
        return [UIColor colorWithRed:30/255.0 green:0/255.0 blue:60/255.0 alpha:1.0];
    } else if ([themeStyle isEqualToString:@"简约风格"]) {
        return [UIColor systemBackgroundColor];
    } else if ([themeStyle isEqualToString:@"赛博风格"]) {
        return [UIColor colorWithRed:0/255.0 green:10/255.0 blue:30/255.0 alpha:1.0];
    } else if ([themeStyle isEqualToString:@"奶油风格"]) {
        return [UIColor colorWithRed:255/255.0 green:248/255.0 blue:240/255.0 alpha:1.0];
    } else if ([themeStyle isEqualToString:@"暗夜风格"]) {
        return [UIColor blackColor];
    }
    return [UIColor systemBackgroundColor];
}

- (UIColor *)defaultAccentColorForTheme:(NSString *)themeStyle {
    if ([themeStyle isEqualToString:@"炫彩风格"]) {
        return [UIColor systemPinkColor];
    } else if ([themeStyle isEqualToString:@"简约风格"]) {
        return [UIColor systemBlueColor];
    } else if ([themeStyle isEqualToString:@"赛博风格"]) {
        return [UIColor systemYellowColor];
    } else if ([themeStyle isEqualToString:@"奶油风格"]) {
        return [UIColor colorWithRed:255/255.0 green:183/255.0 blue:178/255.0 alpha:1.0];
    } else if ([themeStyle isEqualToString:@"暗夜风格"]) {
        return [UIColor systemPurpleColor];
    }
    return [UIColor systemPinkColor];
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString || hexString.length < 6) return nil;

    NSString *cleanHex = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if (cleanHex.length != 6) return nil;

    unsigned int hexValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:cleanHex];
    [scanner scanHexInt:&hexValue];

    CGFloat red = ((hexValue >> 16) & 0xFF) / 255.0;
    CGFloat green = ((hexValue >> 8) & 0xFF) / 255.0;
    CGFloat blue = (hexValue & 0xFF) / 255.0;

    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (NSArray<UIColor *> *)gradientColorsForPreset:(NSString *)preset {
    if ([preset isEqualToString:@"默认渐变"]) {
        return @[[UIColor systemRedColor], [UIColor systemBlueColor]];
    } else if ([preset isEqualToString:@"彩虹渐变"]) {
        return @[[UIColor systemRedColor], [UIColor systemOrangeColor], [UIColor systemYellowColor], [UIColor systemGreenColor], [UIColor systemBlueColor], [UIColor systemPurpleColor]];
    } else if ([preset isEqualToString:@"日出渐变"]) {
        return @[[UIColor colorWithRed:255/255.0 green:94/255.0 blue:98/255.0 alpha:1.0],
                 [UIColor colorWithRed:255/255.0 green:159/255.0 blue:67/255.0 alpha:1.0],
                 [UIColor colorWithRed:254/255.0 green:202/255.0 blue:87/255.0 alpha:1.0]];
    } else if ([preset isEqualToString:@"星空渐变"]) {
        return @[[UIColor colorWithRed:11/255.0 green:11/255.0 blue:48/255.0 alpha:1.0],
                 [UIColor colorWithRed:31/255.0 green:30/255.0 blue:109/255.0 alpha:1.0],
                 [UIColor colorWithRed:57/255.0 green:133/255.0 blue:185/255.0 alpha:1.0]];
    } else if ([preset isEqualToString:@"糖果渐变"]) {
        return @[[UIColor colorWithRed:255/255.0 green:107/255.0 blue:107/255.0 alpha:1.0],
                 [UIColor colorWithRed:255/255.0 green:142/255.0 blue:113/255.0 alpha:1.0],
                 [UIColor colorWithRed:111/255.0 green:207/255.0 blue:255/255.0 alpha:1.0],
                 [UIColor green:207/255.0 blue:255/255.0 alpha:1.0]];
    } else if ([preset isEqualToString:@"深海渐变"]) {
        return @[[UIColor colorWithRed:0/255.0 green:68/255.0 blue:100/255.0 alpha:1.0],
                 [UIColor colorWithRed:0/255.0 green:137/255.0 blue:149/255.0 alpha:1.0],
                 [UIColor colorWithRed:0/255.0 green:190/255.0 blue:212/255.0 alpha:1.0]];
    } else if ([preset isEqualToString:@"火焰渐变"]) {
        return @[[UIColor colorWithRed:255/255.0 green:0/255.0 blue:0/255.0 alpha:1.0],
                 [UIColor colorWithRed:255/255.0 green:127/255.0 blue:0/255.0 alpha:1.0],
                 [UIColor colorWithRed:255/255.0 green:255/255.0 blue:0/255.0 alpha:1.0]];
    } else if ([preset isEqualToString:@"独角兽渐变"]) {
        return @[[UIColor colorWithRed:255/255.0 green:192/255.0 blue:203/255.0 alpha:1.0],
                 [UIColor colorWithRed:147/255.0 green:112/255.0 blue:219/255.0 alpha:1.0],
                 [UIColor colorWithRed:0/255.0 green:191/255.0 blue:255/255.0 alpha:1.0],
                 [UIColor colorWithRed:152/255.0 green:251/255.0 blue:152/255.0 alpha:1.0]];
    } else if ([preset isEqualToString:@"自定义"]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *startHex = [defaults objectForKey:@"DYYYGradientTextStartColor"];
        NSString *endHex = [defaults objectForKey:@"DYYYGradientTextEndColor"];
        UIColor *startColor = startHex.length > 0 ? [self colorFromHexString:startHex] : [UIColor systemRedColor];
        UIColor *endColor = endHex.length > 0 ? [self colorFromHexString:endHex] : [UIColor systemBlueColor];
        return @[startColor, endColor];
    }

    return @[[UIColor systemRedColor], [UIColor systemBlueColor]];
}

- (CGFloat)speedForOption:(NSString *)option {
    if ([option isEqualToString:@"极慢"]) return 4.0;
    if ([option isEqualToString:@"慢速"]) return 3.0;
    if ([option isEqualToString:@"中速"]) return 2.0;
    if ([option isEqualToString:@"快速"]) return 1.0;
    if ([option isEqualToString:@"极快"]) return 0.5;
    return 2.0;
}

- (void)applyTheme {
    [self loadThemeSettings];
}

@end

#pragma mark - DYYYVoicePackageManager

@implementation DYYYVoicePackageManager

+ (instancetype)shared {
    static DYYYVoicePackageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)voicePackageDirectory {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *voicePath = [docPath stringByAppendingPathComponent:@"VoicePackage"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:voicePath]) {
        [fileManager createDirectoryAtPath:voicePath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return voicePath;
}

- (void)saveVoicePackageWithData:(NSData *)data filename:(NSString *)filename {
    if (!data || !filename) return;

    NSString *filePath = [[self voicePackageDirectory] stringByAppendingPathComponent:filename];
    [data writeToFile:filePath atomically:YES];
}

- (NSArray<NSString *> *)allVoicePackages {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:[self voicePackageDirectory] error:&error];

    if (error) {
        NSLog(@"Error getting voice packages: %@", error);
        return @[];
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH '.m4a' OR SELF ENDSWITH '.mp3' OR SELF ENDSWITH '.aac'"];
    return [files filteredArrayUsingPredicate:predicate];
}

- (void)deleteVoicePackage:(NSString *)filename {
    if (!filename) return;

    NSString *filePath = [[self voicePackageDirectory] stringByAppendingPathComponent:filename];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (void)clearAllVoicePackages {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [self allVoicePackages];

    for (NSString *filename in files) {
        NSString *filePath = [[self voicePackageDirectory] stringByAppendingPathComponent:filename];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

@end

#pragma mark - DYYYStickerManager

@implementation DYYYStickerManager

+ (instancetype)shared {
    static DYYYStickerManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)stickerDirectory {
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *stickerPath = [docPath stringByAppendingPathComponent:@"StickerCollect"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:stickerPath]) {
        [fileManager createDirectoryAtPath:stickerPath withIntermediateDirectories:YES attributes:nil error:nil];
    }

    return stickerPath;
}

- (void)saveStickerWithData:(NSData *)data filename:(NSString *)filename {
    if (!data || !filename) return;

    NSString *filePath = [[self stickerDirectory] stringByAppendingPathComponent:filename];
    [data writeToFile:filePath atomically:YES];
}

- (NSArray<NSString *> *)allStickers {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *files = [fileManager contentsOfDirectoryAtPath:[self stickerDirectory] error:&error];

    if (error) {
        NSLog(@"Error getting stickers: %@", error);
        return @[];
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF ENDSWITH '.gif' OR SELF ENDSWITH '.png' OR SELF ENDSWITH '.jpg' OR SELF ENDSWITH '.jpeg'"];
    return [files filteredArrayUsingPredicate:predicate];
}

- (void)deleteSticker:(NSString *)filename {
    if (!filename) return;

    NSString *filePath = [[self stickerDirectory] stringByAppendingPathComponent:filename];
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

- (void)clearAllStickers {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *files = [self allStickers];

    for (NSString *filename in files) {
        NSString *filePath = [[self stickerDirectory] stringByAppendingPathComponent:filename];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}

@end
