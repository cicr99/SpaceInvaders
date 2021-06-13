
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

global paint_lives
paint_lives:
    INI
    %define punt_map [ebp + 12]
    %define punt_lives [ebp + 8]

    mov ebx, punt_lives
    mov esi, punt_map
    add esi, 240

    mov [esi], byte 'L'
    mov [esi + 4], byte 'I'
    mov [esi + 8], byte 'V'
    mov [esi + 12], byte 'E'
    mov [esi + 16], byte 'S'
    mov [esi + 20], byte ':'

    add esi, 24

    xor ecx, ecx
    mov eax, [ebx + 4]
    mov cl, [eax + 6]
    cmp cl, 0
    je no_lives_ship1

    ciclo:
    mov [esi], byte 3
    mov [esi + 1], byte 4
    add esi, 4
    loop ciclo

    no_lives_ship1:

    mov esi, punt_map
    add esi, 300

    xor ecx, ecx
    mov eax, [ebx + 8]
    mov cl, [eax + 6]
    cmp cl, 0
    je end

    ciclo2:
    mov [esi], byte 3
    mov [esi + 1], byte 4
    add esi, 4
    loop ciclo2

    end:
    END
    %undef punt_map
    %undef punt_lives
    ret