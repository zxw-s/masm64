# MASM README（x32/x64）

# 项目简介

基于 MASM（Microsoft Macro Assembler，微软宏汇编器），Windows平台，支持 **32位(x32) / 64位(x64)** 汇编程序开发。
内置3套链接方案：

1. MinGW GCC（封装ld，入门快速验证）
2. MinGW ld（原生链接器，无C运行时包装，底层学习）
3. Microsoft link.exe（VS BuildTools 原生链接器，MASM官方配套，推荐）

开发工具：VSCode + C/C++插件 + cppvsdbg调试器

> 调试特性：VSCode调试面板直接查看CPU寄存器（rax/rbx/rip / eax/ebx/eip）

# 环境依赖

## 必须安装

1. **MASM（ml.exe / ml64.exe）**
   - 来自 Visual Studio BuildTools，安装「使用C++的桌面开发」组件
   - `ml.exe`：32位汇编器；`ml64.exe`：64位汇编器
   - ⚠️ MASM工具必须在**VS开发者终端**环境运行，否则找不到ml/ml64/link
2. **MinGW-w64**（使用gcc / ld链接时才需要）
   - 编译32位程序需要完整32bit库支持
3. VSCode插件：C/C++（Microsoft官方插件，提供cppvsdbg调试）

# 关于 tasks.json 中 command 路径说明

> 本项目tasks.json上传GitHub/Gitee时，**全部直接写程序名，不硬编码绝对路径**
> 示例：`"command":"ml64"` / `"command":"link"` / `"command":"gcc"`

## 两种写法对比

1. 直接写命令名（✅推荐，仓库版本使用这个）
   
   - 原理：读取终端环境变量`PATH`自动搜索程序
   - 优点：可移植，其他人克隆项目不需要修改tasks.json
   - 前提：VSCode从**VS开发者终端**启动，自动注入VS工具链环境变量

2. 写死绝对路径（❌不建议提交到代码仓库，仅本地临时调试）
   
   ```json
   "command": "C:\\Program Files\\Microsoft Visual Studio\\2022\\BuildTools\\Bin\\x64\\ml64.exe"
   ```
   
   - 缺点：VS安装目录每个人不一样，换电脑直接失效；提交仓库会给其他人带来麻烦
   - Windows JSON路径规则：必须使用双反斜杠`\\`，单反斜杠`\`会导致JSON解析报错

## 报错处理：提示“xxx不是内部或外部命令”

二选一：

1. 【推荐】从VS开发者终端启动VSCode，自动加载ml、ml64、link环境变量；MinGW、NASM可手动添加到系统PATH，重启VSCode生效
2. 本地临时方案：command填写完整绝对路径，**提交仓库前务必改回命令名**

# 项目目录结构

```plaintext
.
├── .vscode
│ ├── tasks.json // 编译任务配置，x32/x64 + gcc/ld/mslink全套任务
│ └── launch.json // 调试配置，6套调试方案
├── src // 汇编源码目录（*.asm）
├── README.md
└── .gitignore
```

# 编译任务说明（Ctrl+Shift+B 调出任务列表）

> 编译产物命名规则：`文件名_位数_链接器.exe`，产物互不覆盖
> 例：`test_x64_gcc.exe`、`test_x32_mslink.exe`

## 🔹 64位(x64)任务

1. `masm-build-x64`：仅汇编，ml64生成x64 obj目标文件
2. `masm-link-x64-gcc`：汇编 + GCC链接
3. `masm-link-x64-ld`：汇编 + MinGW ld链接
4. `masm-link-x64-mslink`：汇编 + MS link.exe链接（MASM首选）
5. `build-run-x64-gcc`：汇编+链接+一键运行(GCC)
6. `build-run-x64-ld`：汇编+链接+一键运行(ld)
7. `build-run-x64-mslink`：汇编+链接+一键运行(link.exe)

## 🔹 32位(x32)任务

1. `masm-build-x32`：仅汇编，ml生成x32 obj目标文件
2. `masm-link-x32-gcc`：汇编 + GCC链接
3. `masm-link-x32-ld`：汇编 + MinGW ld链接
4. `masm-link-x32-mslink`：汇编 + MS link.exe链接（MASM首选）
5. `build-run-x32-gcc`：汇编+链接+一键运行(GCC)
6. `build-run-x32-ld`：汇编+链接+一键运行(ld)
7. `build-run-x32-mslink`：汇编+链接+一键运行(link.exe)

# 三套链接器对比

| 链接器      | 来源            | 优点                            | 适用场景                   |
| -------- | ------------- | ----------------------------- | ---------------------- |
| GCC      | MinGW-w64     | 使用简单，自动处理入口，快速验证代码            | 快速Demo，临时测试            |
| ld       | MinGW-w64     | 底层原生链接器，无C标准库包装，贴近PE原理        | PE文件底层、操作系统原理实验        |
| link.exe | VS BuildTools | MASM官方配套，Windows原生PE链接器，兼容性最好 | MASM开发、逆向学习，**推荐默认使用** |

> ⚠️ 重要提示：MASM汇编器`ml.exe/ml64.exe`本身就依赖VS环境。无论用哪套链接器，**推荐全程从VS开发者终端启动VSCode**。

# 调试使用方法

1. 打开对应的`.asm`源码文件
2. Ctrl+Shift+B，执行编译任务生成exe
3. F5启动调试，下拉选择对应调试配置：
   - MASM x64 GCC
   - MASM x64 LD
   - MASM x64 MS Link
   - MASM x32 GCC
   - MASM x32 LD
   - MASM x32 MS Link
4. VSCode左侧调试面板，可以直接查看通用寄存器、指令指针、栈信息。

# 示例代码

## x64示例 src/test_x64.asm

```asm
; MASM x64 汇编
.code
main proc
    mov rax, 01234h
    ret
main endp
end
```

## x32示例 src/test_x32.asm

```asm
; MASM x32 汇编
.386
.model flat,stdcall
.code
main proc
    mov eax, 01234h
    ret
main endp
end main
```

# Git提交规范

```plaintext
feat: 新增xxx汇编demo
fix: 修复汇编链接报错
docs: 更新README说明
refactor: 重构汇编代码
```

# 常见问题排查

1. `ml/ml64不是内部命令`：必须在**VS开发者终端**启动VSCode
2. gcc `-m32`报错：MinGW缺少32位库，更换完整MinGW-w64版本
3. link.exe找不到：同上，VS开发者终端环境变量才会加载VS工具链
4. 程序直接闪退：使用F5调试，设置断点在入口函数观察寄存器
5. 寄存器窗口看不到：确认调试器选择`cppvsdbg`，不要使用gdb
6. x64 MASM语法报错：MASM x64不支持`.model flat`，语法和32位MASM差异很大

# License

MIT
