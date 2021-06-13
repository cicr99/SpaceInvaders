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

global paint_box
paint_box:
    INI
    %define punt_box [ebp + 8]
    %define punt_map [ebp + 12]

    xor eax, eax
    xor ebx, ebx
    xor ecx, ecx
    xor edx, edx

    mov edx, punt_box
    cmp byte [edx + 6], 1
    je paint_end

    mov al, [edx + 4] ;row
    mov bl, 80
    mul bl
    xor ebx, ebx
    mov bl, [edx + 5] ;column
    add eax, ebx
    mov ebx, 4
    mul ebx
    add eax, punt_map

    mov [eax], byte '?'
    mov [eax + 1], byte 0b0110_0000



    paint_end:
    %undef punt_box
    %undef punt_map
    END
    ret


global create_box
create_box:
    INI
    %define punt_box [ebp + 8]

    mov ebx, punt_box
    cmp byte [ebx + 6], 0
    je create_end

    mov [ebx + 6], byte 0 ; box activated
    mov [ebx + 4], byte 1 ; row 1
    rdtsc
    xor edx, edx
    mov ecx, 3
    div ecx

    cmp edx, 0
    je left
    cmp edx, 1
    je right
    cmp edx, 2
    je down

    create_end:
    END
    %undef punt_box
    ret

    left:
    mov [ebx + 5], byte 79 ;column 79
    mov [ebx + 7], byte 5 ;direction 5(left)
    jmp create_end

    right:
    mov [ebx + 5], byte 0 ;column 0
    mov [ebx + 7], byte 4 ;direction 4 (right)
    jmp create_end

    down:
    rdtsc
    xor edx, edx
    mov ecx, 75
    div ecx
    add edx, 2
    mov [ebx + 5], dl ;column between 2 and 77 inclusive
    mov [ebx + 7], byte 0 ; direction 0 (down)
    jmp create_end