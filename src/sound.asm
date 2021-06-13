%macro INI 0
  push ebp
  mov ebp, esp
  pusha
%endmacro

%macro END 0
  popa
  mov esp, ebp
  pop ebp
%endmacro

section .bss
watch resd 2

section .text
extern delay

global make_sound
make_sound:
    INI
    %define frecuency [ebp + 14]
    %define time [ebp + 12]
    %define punt_timer [ebp + 8]

    mov  cx, frecuency  ; Lo hemos dejado fijo
    mov  al,182      
    out  043H,al     ; acceso a los registros del temporizador
    mov  al  , cl
    out  042H, al    ; enviamos byte inferior
    mov  al  , ch
    out  042H, al    ; enviamos byte superior
    ;iniciar prender la bocina
    in   al,061H
    or   al,03H
    out  061H,al
    ;duracion
    xor ebx, ebx
    mov bx,time
    for:      ;esperar el tiempo
    ;call get_inputIntro
        push ebx
        push dword punt_timer
        call delay
        add esp, 8
        cmp eax,0
        jne stop
    jmp for
    stop:
    in   al,97       ;cerrar la bocina
    and  al,0FCH
    out  97,al

    end:
    END
    %undef frecuency
    %undef time
    ret