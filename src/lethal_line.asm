
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


global paint_lethal_line
paint_lethal_line:
    INI
    %define punt_object [ebp + 8]
    %define punt_map [ebp + 12]

    mov edi, punt_object
    cmp byte [edi + 6], 1
    je end

    mov al, [edi + 4]
    mov bl, 80
    mul bl
    xor ebx, ebx
    mov ebx, 4
    mul ebx
    add eax, punt_map

    mov ecx, 80
    fill_row:
    mov [eax], byte '#'
    mov edx, ecx
    shr edx, 1
    jc odd_col
    mov [eax + 1], byte 4
    jmp continue
    odd_col:
    mov [eax + 1], byte 1
    continue:
    add eax, 4
    loop fill_row


    end:
    %undef punt_object
    %undef punt_map
    END
    ret


global create_lethal_line:
create_lethal_line:
    INI
    %define punt_object [ebp + 8]

    mov edi, punt_object
    cmp byte [edi + 6], 0
    je .end

    mov [edi + 4], byte 13
    mov [edi + 5], byte 0
    mov [edi + 6], byte 0

    .end:
    %undef punt_object
    END
    ret


global annihilate
annihilate:
    INI
    %define punt_object [ebp + 8]
    %define punt_alien [ebp + 12]
    %define punt_living_aliens [ebp + 16]

    mov edi, punt_object
    cmp byte [edi + 6], 1
    je finish

    mov eax, punt_alien
    mov ebx, punt_living_aliens
    mov ecx, 30
    xor edx, edx
    mov dl, [edi + 4] ; row of the lethal line
    for:
        cmp [eax + 6], byte 1
        je .continue
        cmp [eax + 4], dl
        je it_matched
        .continue:
        add eax, 12
    loop for
    jmp finish


    it_matched:
        mov [eax + 6], byte 1
        dec dword [ebx]
        jmp for.continue

    finish:
    %undef punt_alien
    %undef punt_object
    %undef punt_living_aliens
    END
    ret
