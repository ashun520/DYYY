# -*- coding: utf-8 -*-
import codecs

# 读取文件
with open(r'c:\Users\haiwu\桌面\oo\DYYY\DYYYSettings.xm', 'rb') as f:
    content = f.read()

# 检查并移除 BOM
if content.startswith(b'\xef\xbb\xbf'):
    content = content[3:]
    print("BOM removed")
else:
    print("No BOM found")

# 写回文件
with open(r'c:\Users\haiwu\桌面\oo\DYYY\DYYYSettings.xm', 'wb') as f:
    f.write(content)

print("File processed successfully!")
