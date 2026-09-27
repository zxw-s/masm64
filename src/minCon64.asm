; MASM64 x64 Console 最小骨干模板（黑窗口），subsystem:console
; 编译命令: ml64 miniCon64.asm /link /subsystem:Console /entry:main kernel32.lib user32.lib

extrn GetStdHandle:PROC
extrn WriteConsoleA:PROC
extrn MessageBoxA:PROC
extrn ExitProcess:PROC

.data
szTitle     db  "MASM64 Demo",0
szMsg       db  "Hello MASM64 Windows!",0

.code
main PROC
    sub rsp,28h

    ; GetStdHandle(STD_OUTPUT_HANDLE = -11)
    mov rcx, -11
    call GetStdHandle

    ; WriteConsoleA( hConsoleOutput, lpBuffer, nNumberOfCharsToWrite, lpNumberOfCharsWritten, lpReserved )
    mov rcx, rax
    lea rdx, szMsg
    mov r8, sizeof szMsg -1
    xor r9, r9
    push 0
    call WriteConsoleA

    xor rcx,0
    call ExitProcess
main ENDP

END