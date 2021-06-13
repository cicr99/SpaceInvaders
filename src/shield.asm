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

global paint_shield
paint_shield:
    INI
    %define punt_shield [ebp + 8]
    %define punt_map [ebp + 12]

    ;checking whether the shield is activated or not
    mov eax, punt_shield
    mov bl, [eax + 6]
    cmp bl, 1
    je end
    
    mov edx, [eax + 12]; punt ship
    xor eax, eax
    cmp byte [edx + 6], 0; checking whether the ship is alive
    je ship2

    ; calculating the position of the ship in the map
    mov al, [edx + 4]
    mov bl, 80
    mul bl
    xor ebx, ebx
    mov bl, [edx + 4 + 1]
    add eax, ebx
    mov ebx, 4
    mul ebx
    add eax, punt_map

    ; painting the background of the ship
    add [eax + 1], byte 0b0110_0000
    add [eax - 4 + 1], byte 0b0110_0000
    add [eax - 8 + 1], byte 0b0110_0000
    add [eax + 4 + 1], byte 0b0110_0000
    add [eax + 8 + 1], byte 0b0110_0000

    ship2:
    mov eax, punt_shield
    mov edx, [eax + 16] ;punt ship2
    xor eax, eax
    cmp byte [edx + 6], 0 ; checking whether the ship2 is alive
    je end

    mov al, [edx + 4]
    mov bl, 80
    mul bl
    xor ebx, ebx
    mov bl, [edx + 4 + 1]
    add eax, ebx
    mov ebx, 4
    mul ebx
    add eax, punt_map

    add [eax + 1], byte 0b0001_0000
    add [eax - 4 + 1], byte 0b0001_0000
    add [eax - 8 + 1], byte 0b0001_0000
    add [eax + 4 + 1], byte 0b0001_0000
    add [eax + 8 + 1], byte 0b0001_0000


    end:
    END
    %undef punt_shield
    %undef punt_map
    ret


global create_shield
create_shield:
  INI
  %define punt_shield [ebp + 8]

  mov eax, punt_shield
  mov [eax + 6], byte 0

  END
  %undef punt_shield
  ret


