# 截图采集 · 脱敏 · 预览 · base 锚定（技术细节与坑）

本文件是 release-note-builder 的硬核部分。截图采集是**平台相关**的，脱敏/预览/base 是**工具无关**的。

## 一、截图采集（按平台选方式）

### 通用要求（不论平台）
- 用**线上真实页面**，不要用原型（原型与线上有出入，公告失去可信度）。
- 每页一张**干净的应用界面**截图：统一窗口尺寸、内容完整、无浏览器边框/录制横幅、无鼠标光标。
- 统一存到素材目录 `assets/<version>-release/`，命名 `NN-端-页名.png`（如 `02-operator-models.png`）。

### 方式 A · Claude Code（Chrome MCP + macOS）—— 全自动，推荐
浏览器导航用 Chrome MCP（`navigate`/`computer`），**但截图落盘不要用 MCP 的 `save_to_disk`**：

> ⚠️ **核心坑**：Chrome MCP `computer` 的 `save_to_disk:true` 截图**不会落到本地可访问磁盘**（全盘 find 无果），只内联回传。要嵌进本地 HTML 必须拿到真实文件 → 改用系统 `screencapture`。

流程（每页）：
1. `navigate` 到页面 URL，等待加载。
2. 需要时 `computer` 操作（点开弹窗等），并把光标 `hover` 到角落避免入镜。
3. 用 `scripts/capture.sh <输出路径.png>` 截图（内部：AppleScript 把目标 Chrome 窗口提到前台 → `screencapture -x -R<bounds>` 按窗口区域截 → Pillow 裁掉顶部浏览器 chrome + 扩展"录制中"横幅）。
4. `Read` 截图核对干净度。

要点：
- **多显示器**：窗口可能在第二屏，bounds 不是 `0,0` 起；`capture.sh` 用 AppleScript **运行时动态取** `bounds of window`，不硬编码。
- **裁顶像素**：浏览器 chrome + 扩展横幅高度因环境而异（实测约 140±px）；先截一张原图、用 `Read` 量出"应用内容真正起始行"再定裁剪量，不要照搬数字。
- **定位 MCP 控制的窗口**：AppleScript 列窗口，找 URL 含目标域名的那个，取其 `id` / `bounds`。

### 方式 B · 有 shell + 系统截图（如 Codex on macOS）
没有 Chrome MCP 时：用户自己在浏览器打开页面 → 你用 `scripts/capture.sh` 截当前窗口（或用户指定 bounds）。导航靠用户手动，截图/裁剪/脱敏仍由脚本完成。

### 方式 C · 无浏览器自动化 / 无系统截图
降级为**用户提供截图**：让用户把每页截图放进 `assets/<version>-release/`，skill 只做脱敏 + 排版。仍然有价值（脱敏+四段式排版是大头）。

## 二、脱敏（默认开 · 工具无关）

用 `scripts/redact.py`（纯 Pillow）。**先备份原图再打码**：

1. 备份：原图复制到 `assets/<version>-release/_raw/`。
2. **`_raw/` 写进 `.gitignore`**（目录级 `.gitignore` 内容就一行 `_raw/`）。这是关键：只打码展示图不够，未脱敏原图若进 git 历史，PII 难清除。
3. 对每张图按区域打码：
   - **登录账号块**（页面右上角头像+账号名+角色）→ 浅灰圆角块遮盖，保留"退出"按钮。
   - **表单输入值**（邮箱/电话/统一社会信用代码）→ 白底擦除（看起来像空输入框）。
   - **列表 PII**（联系人姓名、邮箱）→ 浅灰块打码。
   - 测试数据（"测试供应商""测试联系人"）可保留；真实公司名按需。

定位坐标：先 `Read` 图量出敏感区域像素位置（可裁一小块放大量），再传给 `redact.py`。坐标是页面布局相关的，**每次按页定位**，不能照搬。

## 三、预览验证（工具无关）

> ⚠️ **坑**：部分浏览器自动化的 `navigate` 对 `file://` 会误加 `https://` 前缀（变成 `https://file:///…` 报错）。

→ 一律用本地服务器预览：
```bash
cd <发版说明所在目录> && python3 -m http.server 8899
# 浏览器开 http://localhost:8899/VX.X-发版说明.html
```
核对：四段式齐全、截图加载且干净、目录跳转、脱敏到位、无数据统计（若开关关）。看完 `pkill -f "http.server 8899"`。

## 四、base 锚定（仅当发版说明要进文档门户 / 在线部署时）

发版说明单独 HTML、用 `…/VX.X-发版说明.html` 带文件名访问时，相对图片路径没问题，**无需 base**。

但若把它挂进一个**门户索引页**、或部署在有 **SPA fallback**（任意不存在路径都返回某 index）的服务器，相对链接会在"无尾斜杠访问"或"fallback 累加路径"下丢目录层 → 404。此时在 `<head>` 注入动态 base 锚定到内容根：
```html
<script>
(function(){var u=location.href.split('#')[0].split('?')[0];
var m=u.match(/^(.*\/<根目录名>)(\/|$)/);   // 把 <根目录名> 换成实际锚点，如 docs/pm
var dir=m?m[1]+'/':(/\.html?$/i.test(u)?u.replace(/[^/]*$/,''):u.replace(/\/?$/,'/'));
document.write('<base href="'+dir+'">');})();
</script>
```
绝对路径在 `file://` 会坏、纯相对在无尾斜杠/fallback 会坏 —— 动态 base 锚定是同时兼容两者的解。
