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

extern create_shot

section .text

global paint_eternal_shot
paint_eternal_shot:
    INI
    %define punt_shot [ebp + 8]
    %define punt_map [ebp + 12]

    mov edx, punt_shot

    mov al, [edx + 6]
    mov bl, 1
    cmp al, bl
    je .end
    xor eax, eax
    xor ebx, ebx

    mov al, [edx + 4]
    mov bl, 80
    mul bl
    xor ebx, ebx
    mov bl, [edx + 4 + 1]
    add eax, ebx
    mov ebx, 4
    mul ebx
    add eax, punt_map

    mov [eax], byte 15
    mov [eax + 1], byte 4

    .end:
    END
    %undef punt_map
    %undef punt_alien
    ret


global create_eternal_shot
create_eternal_shot:
  INI
  %define shot [ebp + 8]

  mov eax, shot
  cmp byte [eax + 6], 0
  je .end

  mov ebx, [eax + 12] ; punt ship
  push dword 1 ; amount of shots
  push eax
  push dword 1 ; direction of the shot(1 up)
  push ebx
  call create_shot
  add esp, 16

  .end:
  %undef shot
  END
  ret