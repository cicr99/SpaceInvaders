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

global paint_actual_power
paint_actual_power:
    INI
    %define punt_map [ebp + 12]
    %define punt_actual_power [ebp + 8]

    mov esi, punt_map
    add esi, 80

    mov [esi], byte 'P'
    add esi, 4
    mov [esi], byte 'O'
    add esi, 4
    mov [esi], byte 'W'
    add esi, 4
    mov [esi], byte 'E'
    add esi, 4
    mov [esi], byte 'R'
    add esi, 4
    mov [esi], byte ':'
    add esi, 4
    mov [esi], byte ' '
    add esi, 4

    mov eax, punt_actual_power
    mov ebx, [eax + 8]
    cmp [ebx], byte 0
    je end

    mov edi, [eax + 4]
    mov ebx, [edi]
    mov cl, [ebx + 20]
    mov [esi], byte cl
    mov cl, [ebx + 21]
    mov [esi + 1], byte cl

    end:
    END
    %undef punt_map
    %undef punt_actual_power
    ret