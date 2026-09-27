; MASM64 x64 Windows 最小GUI骨干模板
; 编译命令: ml64 main.asm /link /subsystem:windows /entry:main kernel32.lib user32.lib

extrn GetStdHandle:PROC
extrn WriteConsoleA:PROC
extrn MessageBoxA:PROC
extrn ExitProcess:PROC

.data
szTitle     db  "MASM64 Demo",0
szMsg       db  "Hello MASM64 Windows!",0

.code

main PROC
    ; 64位栈对齐：进入入口，栈需要保持16字节对齐
    ; call 会压入8字节返回地址，所以sub rsp, 20h 保证对齐 + 预留4个参数影子空间(shadow space)
    sub     rsp, 28h        ; shadow space 32(20h) + 额外8保证16字节对齐

    ; MessageBoxA(hWnd, lpText, lpCaption, uType)
    ; RCX = hWnd = NULL(0)
    ; RDX = lpText
    ; R8  = lpCaption
    ; R9  = uType = MB_OK = 0
    xor     rcx, rcx
    lea     rdx, szMsg
    lea     r8, szTitle
    xor     r9, r9
    call    MessageBoxA

    ; ExitProcess(uExitCode)
    xor     rcx, rcx
    call    ExitProcess

main ENDP

END