#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""redact.py — 截图脱敏（release-note-builder）。纯 Pillow，工具无关。

先把原图备份到 assets/<version>-release/_raw/ 并把 _raw/ 写进 .gitignore，再用本脚本原地打码。

用法:
  python3 redact.py <img.png> [--pill x0,y0,x1,y1 ...] [--blank x0,y0,x1,y1 ...]
    --pill   浅灰圆角块，遮登录账号块 / 列表 PII（姓名·邮箱）
    --blank  白底圆角块，擦表单输入值（邮箱/电话/证件号），看起来像空输入框

坐标按图的实际像素。先 Read 图量出敏感区域位置（可裁一小块放大量准），坐标是页面布局相关的，每次按页定位。
"""
import sys
from PIL import Image, ImageDraw


def parse(args, flag):
    out, i = [], 0
    while i < len(args):
        if args[i] == flag and i + 1 < len(args):
            out.append(tuple(int(x) for x in args[i + 1].split(',')))
            i += 2
        else:
            i += 1
    return out


def main():
    if len(sys.argv) < 2:
        print(__doc__)
        sys.exit(1)
    img = sys.argv[1]
    rest = sys.argv[2:]
    pills = parse(rest, '--pill')
    blanks = parse(rest, '--blank')
    im = Image.open(img).convert('RGB')
    d = ImageDraw.Draw(im)
    for b in pills:
        d.rounded_rectangle(b, radius=7, fill=(231, 233, 240), outline=(208, 212, 222), width=1)
    for b in blanks:
        d.rounded_rectangle(b, radius=6, fill=(255, 255, 255), outline=(224, 227, 234), width=1)
    im.save(img)
    print(f"redacted {img}: {len(pills)} pill + {len(blanks)} blank")


if __name__ == '__main__':
    main()
