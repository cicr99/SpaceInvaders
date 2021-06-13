
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

section .text

global paint_points
paint_points:
    INI
    %define punt_map [ebp + 12]
    %define punt_points [ebp + 8]

    mov ebx, punt_points
    mov esi, punt_map

    mov [esi], byte 'S'
    mov [esi + 4], byte 'C'
    mov [esi + 8], byte 'O'
    mov [esi + 12], byte 'R'
    mov [esi + 16], byte 'E'
    mov [esi + 20], byte ':'
    ;mov [esi + 24], byte ':'

    mov eax, [ebx + 4]
    mov ebx, 10
    mov ecx, 5
    mov edi, 32
    add edi, 12
    ciclo:
    xor edx, edx  ; make edx = 0
    div ebx
    add dl, '0'
    mov [esi + edi], byte dl
    mov [esi + edi + 1], byte 13
    sub edi, 4
    loop ciclo

    END
    %undef punt_map
    %undef punt_points
    ret
    