#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYYYGradientTextView : UIView

@property(nonatomic, copy) NSString *text;
@property(nonatomic, strong) UIFont *font;
@property(nonatomic, assign) CGFloat animationSpeed;
@property(nonatomic, strong) NSArray<UIColor *> *gradientColors;

- (void)startAnimation;
- (void)stopAnimation;
- (void)updateGradientColors:(NSArray<UIColor *> *)colors;

@end

@interface DYYYThemeManager : NSObject

@property(nonatomic, strong, readonly) UIColor *primaryColor;
@property(nonatomic, strong, readonly) UIColor *backgroundColor;
@property(nonatomic, strong, readonly) UIColor *accentColor;
@property(nonatomic, copy, readonly) NSString *themeStyle;

+ (instancetype)shared;

- (void)applyTheme;
- (UIColor *)colorFromHexString:(NSString *)hexString;
- (NSArray<UIColor *> *)gradientColorsForPreset:(NSString *)preset;

@end

@interface DYYYVoicePackageManager : NSObject

+ (instancetype)shared;

- (NSString *)voicePackageDirectory;
- (void)saveVoicePackageWithData:(NSData *)data filename:(NSString *)filename;
- (NSArray<NSString *> *)allVoicePackages;
- (void)deleteVoicePackage:(NSString *)filename;
- (void)clearAllVoicePackages;

@end

@interface DYYYStickerManager : NSObject

+ (instancetype)shared;

- (NSString *)stickerDirectory;
- (void)saveStickerWithData:(NSData *)data filename:(NSString *)filename;
- (NSArray<NSString *> *)allStickers;
- (void)deleteSticker:(NSString *)filename;
- (void)clearAllStickers;

@end

NS_ASSUME_NONNULL_END
