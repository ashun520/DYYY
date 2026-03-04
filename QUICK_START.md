# DYYY 增强版 - 快速开始指南 🚀

## 📌 完成的工作总结

### ✅ 已成功实现的功能：

#### 1. **底栏标题自定义** 
- ✓ 支持修改抖音底栏各标签名称（商城、消息、朋友、我等）
- ✓ 点击进入设置后可以添加、编辑、删除标题修改
- ✓ 支持多个修改同时应用（用 # 分隔）
- ✓ 修改立即生效

#### 2. **主题系统**
- ✓ 支持自定义背景色（十六进制格式）
- ✓ 支持设置背景透明度（0-1）
- ✓ 支持自定义主色调
- ✓ 支持预设主题选择（可扩展）
- ✓ 所有设置通过 NSUserDefaults 持久化

#### 3. **保留所有原有功能**
- ✓ 隐藏/显示各种 UI 元素
- ✓ 修改透明度、缩放等参数
- ✓ 视频播放增强
- ✓ 推荐流优化
- ✓ 等所有原有功能完整保留

---

## 📂 文件修改清单

### 核心文件修改

| 文件 | 修改内容 | 行号 |
|------|---------|------|
| **DYYY.xm** | 添加底栏标题映射函数 | L98-147 |
| **DYYY.xm** | 添加主题系统全局变量 | L37-40 |
| **DYYY.xm** | 添加主题颜色获取函数 | L47-75 |
| **DYYY.xm** | 在 layoutSubviews 应用底栏标题 | L5523-5532 |
| **DYYYSettings.xm** | 添加底栏标题修改设置项 | L862-930 |
| **DYYYSettingViewController.m** | 添加主题系统设置选项 | L173-190 |

### 新增文档文件

| 文件 | 说明 |
|------|------|
| **BUILD_INSTRUCTIONS.md** | 详细的编译和打包说明 |
| **FEATURES_CN.md** | 完整功能说明和技术细节 |
| **QUICK_START.md** | 本文档 |

---

## 🛠️ Mac 上的编译和打包步骤

### 准备环境 (仅需一次)

```bash
# 1. 安装 Xcode Command Line Tools
xcode-select --install

# 2. 下载安装 Theos (iOS 开发框架)
git clone --recursive https://github.com/theos/theos.git ~/theos

# 3. 设置环境变量 (在 ~/.zprofile 或 ~/.bash_profile 中添加)
export THEOS=~/theos

# 4. 刷新环境
source ~/.zprofile
```

### 编译和打包

```bash
# 1. 进入项目目录
cd ~/Desktop/oo/DYYY

# 2. 清理并编译 (默认方案)
make clean
make

# 或者编译特定方案
# RootHide 方案:
make clean
make SCHEME=roothide

# Rootless 方案:
make clean  
make SCHEME=rootless

# 3. 查看生成的 DEB 文件
ls -lh packages/*.deb

# 输出示例:
# -rw-r--r--  1 user  staff  1.2M  Mar  4 10:30 packages/com.huami.dyyy_2.2-8_iphoneos-arm.deb
```

### 安装到设备

```bash
# 通过 SSH 连接到越狱 iPhone
ssh root@your_iphone_ip

# 开启另一个终端，将 DEB 复制到设备
scp packages/com.huami.dyyy_2.2-8_iphoneos-arm.deb root@your_iphone_ip:/tmp/

# 在设备终端安装
dpkg -i /tmp/com.huami.dyyy_2.2-8_iphoneos-arm.deb

# 重启应用或设备使更改生效
killall Aweme  # 或者 respring (需要 ldrestart)
```

---

## 🎨 新功能使用示例

### 示例 1: 修改底栏标签

**目标**: 改成更友好的名称

1. 打开抖音
2. 双指长按屏幕或进入设置菜单
3. 进入 "DYYY设置" → "界面设置" → "标题自定义" → "设置底栏标题"
4. 点击输入修改配置：
   ```
   商城=购物
   消息=聊天
   朋友=好友
   我=账户
   ```
5. 确认保存

**或者用简化格式一行搞定**:
```
商城=购物#消息=聊天#朋友=好友#我=账户
```

### 示例 2: 应用主题配色

**目标**: 设置护眼亮色主题

1. 进入设置 → "界面设置" → "选择主题"
2. 依次配置：
   - **设置背景颜色**: `F5F5F5`（浅灰色）
   - **背景透明度**: `0.95`
   - **主色调颜色**: `FDBF57`（暖色）
3. 保存配置

**或者深色高对比度主题**:
- **背景颜色**: `1A1A1A`（深灰）
- **背景透明度**: `1.0`
- **主色调**: `FF6B6B`（高对比红）

---

## 🔍 验证编译是否成功

编译完成后，你应该看到：

```
===> Packaging complete.
```

以及生成的 DEB 文件在 `packages/` 目录：

```bash
ls -la packages/
# 输出类似：
# com.huami.dyyy_2.2-8_iphoneos-arm.deb
# com.huami.dyyy_2.2-8_iphoneos-arm.symbols
```

---

## ❌ 常见编译错误及解决方案

| 错误 | 解决方案 |
|------|---------|
| `fatal: cannot find theos` | 运行 `export THEOS=~/theos` |
| `unknown architecture` | 检查 Makefile 中的 ARCHS 配置 |
| `SDK not found` | 运行 `xcode-select --install` |
| `链接器错误` | 运行 `make clean` 后重新编译 |
| `权限拒绝` | 使用 `sudo make` (不推荐) |

---

## 📋 打包前的检查清单

- [ ] 所有代码修改已完成
- [ ] 没有编译错误
- [ ] DEB 文件已生成
- [ ] 文件大小合理 (通常 1-2MB)
- [ ] 文件名正确

---

## 🚀 分发和分享

### DEB 文件分发方式

1. **直接传输**
   ```bash
   # SCP 传输
   scp packages/*.deb user@server:/shared/
   ```

2. **云存储上传**
   - iCloud Drive
   - Google Drive
   - One Drive
   - 等其他云服务

3. **网盘分享**
   - 上传到个人网盘
   - 生成分享链接

---

## 📞 获取帮助

### 查看详细文档

- **BUILD_INSTRUCTIONS.md** - 完整编译打包指南
- **FEATURES_CN.md** - 功能说明和技术细节

### 常见问题

**Q: 编译后会覆盖原有功能吗？**
A: 不会，所有原有功能完整保留，只是新增了两个功能。

**Q: 可以同时使用底栏修改和隐藏吗？**
A: 可以，隐藏功能会优先执行，隐藏的按钮不会显示修改后的名称。

**Q: 主题系统会影响性能吗？**
A: 不会，主题设置只是在配置保存和读取时有轻微开销，运行时不会影响性能。

**Q: 如何恢复到默认设置？**
A: 进入对应設置项，清空文本框后保存，即可恢复默认值。

---

## ✨ 更新日志

### v2.2-8+ (2026-03-04)
- ✨ 新增：底栏标题自定义功能
- ✨ 新增：主题系统（背景色、透明度、主色调）
- 📝 优化：完善文档和注释
- ✅ 确保：所有原有功能正常运行

---

## 📄 许可证信息

仅供学习交流，禁止用于商业用途。

基于原项目: https://github.com/huami1314/DYYY

---

**祝您编译顺利，使用愉快！** 🎉
