# DYYY 增强版编译与打包说明

这份文档说明如何在 macOS 上编译 DYYY 插件并打包成 DEB 格式。

## 新增功能

### 1. 底栏标题自定义 ✨
- **功能说明**: 可以自定义修改底栏各标签的名称（商城、消息、朋友、我）
- **设置入口**: 设置 → 界面设置 → 标题自定义 → 设置底栏标题
- **使用方法**: 
  - 点击"设置底栏标题"
  - 按格式输入：`原标题=新标题`（如：商城=购物）
  - 多个修改用 `#` 分隔（如：商城=购物#消息=聊天#朋友=好友#我=账户）

### 2. 主题系统 🎨
- **功能说明**: 支持自定义应用整体主题和颜色方案
- **可自定义项目**:
  - `选择主题`: 预设主题选择（可扩展）
  - `设置背景颜色`: 设置应用背景色（十六进制格式，如 #F5F5F5）
  - `背景透明度`: 背景的透明度（0-1 之间的小数）
  - `主色调颜色`: 应用的主色调（十六进制格式）

---

## 编译前置条件

### 在 macOS 上

1. **安装 Xcode Command Line Tools**
   ```bash
   xcode-select --install
   ```

2. **安装 Theos**
   ```bash
   # 下载并安装 Theos
   git clone --recursive https://github.com/theos/theos.git ~/theos
   ```

3. **安装预编译的 Theos 依赖** (可选，推荐)
   ```bash
   ~/theos/bin/install.sh
   ```

4. **设置 THEOS 环境变量**
   在 `~/.zprofile` 或 `~/.bash_profile` 中添加:
   ```bash
   export THEOS=~/theos
   ```
   然后运行:
   ```bash
   source ~/.zprofile  # 或 source ~/.bash_profile
   ```

---

## 编译步骤

### 方法 1: 使用 Makefile（推荐）

1. **进入项目目录**
   ```bash
   cd ~/Desktop/oo/DYYY  # 根据你的实际路径调整
   ```

2. **编译项目** (默认方案)
   ```bash
   make clean
   make
   ```

3. **编译特定方案**
   
   编译 **RootHide** 方案:
   ```bash
   make clean
   make SCHEME=roothide
   ```
   
   编译 **Rootless** 方案:
   ```bash
   make clean
   make SCHEME=rootless
   ```

4. **生成的 DEB 文件位置**
   编译成功后，DEB 文件会生成在 `packages/` 目录中:
   ```bash
   ls -lh packages/*.deb
   ```

---

## 打包说明

### 生成的 DEB 文件

编译完成后，你会在 `packages/` 目录中找到 DEB 文件，名称类似:
- `com.huami.dyyy_2.2-8_iphoneos-arm.deb` (RootHide)
- `com.huami.dyyy_2.2-8+roothide_iphoneos-arm.deb` (Roothide 方案)

### DEB 文件部署

**在越狱 iOS 设备上安装**:

1. 将 DEB 文件复制到设备
2. 使用 SSH 连接到设备
3. 安装 DEB:
   ```bash
   dpkg -i com.huami.dyyy_2.2-8_iphoneos-arm.deb
   ```
4. 重启抖音或设备使更改生效

---

## 常见问题

### Q: 编译出错 "找不到 theos"
**A**: 确保 THEOS 环境变量已正确设置:
```bash
echo $THEOS
```
如果为空，重新运行:
```bash
export THEOS=~/theos
```

### Q: 编译出错 "找不到 SDK"
**A**: 确保安装了 Xcode Command Line Tools:
```bash
xcode-select --install
```

### Q: 如何更改 DEB 包的版本号？
**A**: 编辑 `control` 文件:
```plaintext
Version: 2.2-8  # 修改这里
```

### Q: 编译失败，显示"链接器错误"
**A**: 尝试清理重新编译:
```bash
make clean
rm -rf .theos
make
```

---

## 文件修改说明

本版本对以下文件进行了增强:

1. **DYYY.xm** - 核心功能文件
   - 添加 `DYYYBottomTabTitleMapping()` 函数 - 处理底栏标题映射
   - 添加主题系统的全局变量和获取函数
   - 在 `AWENormalModeTabBar` 的 `layoutSubviews` 中应用底栏标题修改

2. **DYYYSettings.xm** - 设置界面配置
   - 添加"设置底栏标题"的设置项和处理逻辑
   - 应用底栏标题修改时触发对应的 UI 更新

3. **DYYYSettingViewController.m** - 设置界面实现
   - 增加主题系统相关的设置项:
     - 选择主题
     - 设置背景颜色
     - 背景透明度
     - 主色调颜色

---

## 技术细节

### 底栏标题修改原理
- 通过获取 UIView 的 `accessibilityLabel` 来识别底栏按钮
- 使用 NSUserDefaults 存储修改配置（键: `DYYYModifyBottomTabText`）
- 在 `layoutSubviews` 中应用标题修改，格式: `原标题=新标题#原标题2=新标题2`

### 主题系统原理
- 使用 NSUserDefaults 存储主题设置:
  - `DYYYThemeStyle`: 主题风格
  - `DYYYBackgroundColor`: 背景色（十六进制）
  - `DYYYBackgroundAlpha`: 背景透明度
  - `DYYYPrimaryColor`: 主色调
- 通过 `DYYYGetThemeBackgroundColor()` 和 `DYYYGetThemePrimaryColor()` 函数获取颜色
- 利用现有的 `DYYYUtils.colorFromSchemeHexString()` 方法处理颜色转换

---

## 后续扩展建议

1. **主题预设功能**: 支持预定义的主题方案（如深色模式、高对比度等）
2. **主题导出导入**: 允许用户分享和导入主题配置
3. **动态主题切换**: 支持根据系统设置自动切换主题
4. **更多自定义项**: 字体大小、圆角半径等

---

## 许可证

仅供学习交流，禁止用于商业用途。

---

**最后更新**: 2026年3月4日
