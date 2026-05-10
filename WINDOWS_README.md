# Claude Code - Windows 版本

基于 Claude Code 项目的 Windows 优化版本

## 快速开始

### 一键安装运行

在项目根目录，双击运行：

```cmd
bin\claude-haha.bat
```

这个脚本会：
1. 自动检测 Bun 是否已安装
2. 如果没有安装，自动从 https://bun.sh 下载安装
3. 安装项目依赖
4. 启动 Claude Code

## 手动安装

如果自动安装失败，你可以手动安装：

### 1. 安装 Bun

以管理员身份打开 PowerShell，运行：

```powershell
irm bun.sh/install.ps1 | iex
```

或者从 https://bun.sh 下载安装程序。

### 2. 安装依赖

```cmd
bun install
```

### 3. 运行

```cmd
bun run bin/claude-haha
```

或

```cmd
bin\claude-haha.bat
```

## 文件说明

| 文件 | 说明 |
|------|------|
| [`bin/claude-haha.bat`](file:///workspace/bin/claude-haha.bat) | Windows 主启动脚本（推荐） |
| [`bin/install.bat`](file:///workspace/bin/install.bat) | Windows 安装向导 |
| [`bin/recovery.bat`](file:///workspace/bin/recovery.bat) | Windows 恢复模式 |
| [`bin/launcher.cjs`](file:///workspace/bin/launcher.cjs) | Node.js 启动器（可打包成 exe） |
| [`dist/claude-haha.bat`](file:///workspace/dist/claude-haha.bat) | 分发版启动脚本 |

## 生成 .exe 文件

### 使用 pkg 打包

```cmd
npx pkg bin/launcher.cjs --targets node18-win-x64 --output claude-haha.exe
```

注意：pkg 需要下载 Node.js 二进制文件，首次运行可能需要较长时间。

### 使用 Bun 编译（需要完整项目文件）

由于项目依赖部分内部模块，直接使用 `bun build --compile` 需要完整的项目源代码。

## 环境变量

- `CLAUDE_CODE_FORCE_RECOVERY_CLI=1` - 强制使用恢复模式
- `NODE_OPTIONS` - Node/Bun 选项

## 故障排除

### 权限问题

如果遇到 PowerShell 权限问题，运行：

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Bun 找不到

确保 Bun 在 PATH 中，或者手动指定路径：

```cmd
set BUN_PATH=%USERPROFILE%\.bun\bin\bun.exe
%USERPROFILE%\.bun\bin\bun.exe run bin/claude-haha
```

### 依赖安装失败

删除 `node_modules` 和 `bun.lock`，重新安装：

```cmd
rmdir /s /q node_modules
del bun.lock
bun install
```
