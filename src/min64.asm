; MASM x86-64 最小模板 (min64.asm)
; 编译：ml64 /c min64.asm  
; 链接：link /subsystem:console /entry:main min64.obj kernel32.lib
; ml64 64位MASM，无.model，无.stack，无INVOKE

ExitProcess PROTO :DWORD

.code
main PROC
    sub rsp, 20h        ; 预留32字节影子空间，保证16字节对齐
    mov rcx, 0          ; 第1参数放入RCX
    call ExitProcess
    add rsp, 20h        ; 恢复栈
    ret
main ENDP
END