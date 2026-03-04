# DYYY 增强版 - 功能说明文档

## 项目概述

这是对原始 DYYY（抖音 UI 调整 Tweak）项目的增强版本，在保留所有原有功能的基础上，新增了两个主要功能：

1. **底栏标题自定义**
2. **主题系统（背景色 & 配色方案）**

---

## 📋 项目结构

```
DYYY/
├── DYYY.xm                      # 核心 Hook 和功能实现
├── DYYYSettings.xm              # 设置界面配置和处理
├── DYYYSettingViewController.m   # 设置视图控制器
├── DYYYUtils.h/m                # 工具类（包含颜色处理）
├── Makefile                     # 编译配置
├── control                      # DEB 包元数据
└── BUILD_INSTRUCTIONS.md        # 编译和打包说明
```

---

## ✨ 新增功能详解

### 1. 底栏标题自定义

#### 功能说明
允许用户修改抖音底部导航栏（TabBar）中各个按钮的显示文本。

#### 实现原理
- **映射函数**: `DYYYBottomTabTitleMapping()` 在 DYYY.xm 中
  - 读取 `DYYYModifyBottomTabText` 的设置值
  - 解析格式：`原标题=新标题#原标题2=新标题2`
  - 返回标题映射字典

- **应用位置**: `AWENormalModeTabBar` 的 `layoutSubviews` 方法
  - 遍历所有底栏子视图
  - 根据 `accessibilityLabel` 识别按钮类型
  - 应用标题修改
  - 更新 `accessibilityLabel` 确保隐藏功能正常工作

#### 配置格式示例
```
商城=购物
商城=购物#消息=聊天
商城=购物#消息=聊天#朋友=好友#我=我的账户
```

#### 设置入口
设置 → 界面设置 → 标题自定义 → 设置底栏标题

#### 修改的文件
1. **DYYY.xm** (L98-147)
   - 添加 `DYYYBottomTabTitleMapping()` 函数

2. **DYYY.xm** (L5523-5532)
   - 在 `layoutSubviews` 中添加标题应用逻辑

3. **DYYYSettings.xm** (L862-930)
   - 添加底栏标题修改的设置项
   - 实现点击处理和保存逻辑

---

### 2. 主题系统

#### 功能说明
提供灵活的主题定制系统，支持自定义应用的背景色和主色调。

#### 可自定义项目

| 项目 | 说明 | 格式 | 例子 |
|------|------|------|------|
| 选择主题 | 预设主题选择 | - | 待扩展 |
| 设置背景颜色 | 应用背景色 | 十六进制 (3-6位) | F5F5F5, #FF0000 |
| 背景透明度 | 背景透明度 | 0-1 小数 | 0.5, 0.8 |
| 主色调颜色 | 应用主配色 | 十六进制 (3-6位) | 1E90FF, #00AA00 |

#### 实现原理

**全局变量和常量** (DYYY.xm, L37-40)
```objc
static NSString *const kDYYYThemeStyleKey = @"DYYYThemeStyle";
static NSString *const kDYYYBackgroundColorKey = @"DYYYBackgroundColor";
static NSString *const kDYYYBackgroundAlphaKey = @"DYYYBackgroundAlpha";
static NSString *const kDYYYPrimaryColorKey = @"DYYYPrimaryColor";
```

**颜色获取函数** (DYYY.xm, L47-75)
```objc
// 获取背景色（支持透明度）
static UIColor *DYYYGetThemeBackgroundColor(void)

// 获取主色调
static UIColor *DYYYGetThemePrimaryColor(void)
```

**颜色处理**
- 使用现有的 `DYYYUtils.colorFromSchemeHexString()` 方法
- 支持单色、渐变色和随机色
- 可通过 alpha 值调整透明度

#### 存储方式
所有主题设置都通过 `NSUserDefaults` 存储：
- Key: `DYYYThemeStyle`, `DYYYBackgroundColor`, `DYYYBackgroundAlpha`, `DYYYPrimaryColor`
- 值: 字符串格式（便于持久化和编辑）

#### 设置入口
设置 → 界面设置 → 主题设置部分：
- 选择主题
- 设置背景颜色
- 背景透明度
- 主色调颜色

#### 修改的文件
1. **DYYY.xm** (L37-75)
   - 添加主题系统的全局变量
   - 添加颜色获取函数

2. **DYYYSettingViewController.m** (L173-190)
   - 在界面设置 section 开头添加主题系统选项

---

## 🔧 技术实现细节

### 底栏标题修改技术栈

1. **Hook Target**: `AWENormalModeTabBar`
2. **Hook Method**: `layoutSubviews`
3. **检测方式**: 通过 `accessibilityLabel` 识别按钮
4. **修改方式**: 调用 `setTitle:` 和 `setAccessibilityLabel:`

### 主题系统技术栈

1. **配置存储**: NSUserDefaults
2. **颜色处理**: DYYYUtils 的 `colorFromSchemeHexString()` 方法
3. **支持格式**: 
   - 单色: `#FF0000` 或 `FF0000`
   - 渐变: `#FF0000,#00FF00,#0000FF`
   - 特殊值: `rainbow`, `random`, 等

---

## 🎯 功能完整性检查清单

- ✅ 底栏标题应用逻辑实现
- ✅ 底栏标题设置界面添加
- ✅ 主题系统变量和函数
- ✅ 主题系统设置界面选项
- ✅ 所有原有功能保留
- ✅ 编译配置文件检查
- ✅ 文档和说明完善

---

## 📱 使用场景示例

### 例子 1: 个性化标签名称
想要将抖音底栏改成更个性化的名称？

**设置步骤**:
1. 打开抖音设置或双指长按进入DYYY设置
2. 进入 "界面设置" → "标题自定义" → "设置底栏标题"
3. 输入修改配置，例如：
   ```
   商城=购物#消息=消息#朋友=朋友#我=我的
   ```
4. 确认保存，底栏标签立即生效

### 例子 2: 应用主题定制
想要为应用设置特定的配色方案？

**设置步骤**:
1. 进入设置 → "界面设置"
2. 找到主题系统部分
3. 配置背景色，例如：`F5F5F5`
4. 设置背景透明度，例如：`0.9`
5. 选择主色调，例如：`1E90FF`
6. 保存配置

---

## 🚀 未来扩展建议

### 短期计划 (易实现)
1. **预设主题包**
   - 默认亮色主题 (#FFFFFF)
   - 默认暗色主题 (#1A1A1A)
   - 高对比度主题
   - 护眼主题

2. **导出/导入功能**
   - 支持将配置导出为 JSON
   - 从 JSON 导入配置
   - 便于分享和备份

3. **更多自定义项**
   - 字体大小偏移
   - 圆角半径
   - 边框颜色和宽度

### 中期计划 (需要一定改动)
1. **动态主题切换**
   - 根据系统暗色模式自动切换
   - 根据时间段自动切换
   - 快捷切换主题

2. **主题预览**
   - 在设置界面实时预览主题效果
   - 样本视图展示

3. **社区主题库**
   - 在线主题下载
   - 用户上传分享主题

### 长期计划 (需要重构)
1. **完整 UI 定制引擎**
   - CSS-like 配置语法
   - 模块化组件定制
   - 动画和过渡效果

2. **主题编辑器**
   - 可视化主题编辑工具
   - 实时预览
   - 拖拽定制

---

## 📝 版本信息

- **基础版本**: DYYY 2.2-8 (原始版本)
- **增强版本**: DYYY 2.2-8+ (含新功能)
- **修改日期**: 2026 年 3 月 4 日
- **平台**: iOS 14.0+
- **支持架构**: ARM64, ARM64e

---

## ⚖️ 法律声明

本项目仅供学习和交流之用。所有代码修改遵循原项目的开源协议。

**禁止用于商业用途。**

使用本插件须在符合 Apple 服务条款和当地法律的前提下进行。

---

## 📞 技术支持

如有任何问题或建议，请参考：
- 编译说明: [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md)
- 原项目: https://github.com/huami1314/DYYY

---

**祝您使用愉快！**
