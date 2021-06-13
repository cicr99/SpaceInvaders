%include "keyboard.mac"

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

%macro ASCII 3
    cmp %1, %2
    jne %%end
    mov al, %3
    jmp letra_ya
    %%end:
%endmacro

global paint_punctuation
paint_punctuation:
    INI
    %define punt_map[ebp + 12]
    %define punt_punctuations[ebp + 8]

    mov esi, punt_map
    mov eax, punt_punctuations
    mov edi, [eax + 4]
    add esi, 960
    mov ecx, 10
    ciclo:
        mov eax, 11
        sub eax, ecx
        mov ebx, 2
        mul ebx

        ;mov eax, ecx
        ;add eax, ecx
        mov ebx, 80
        mul ebx
        mov ebx, 4
        mul ebx
        add eax, 20
        mov dl, 11
        sub dl, cl
        add dl, '0'
        mov [esi + eax], byte dl
        add eax, 4
        mov [esi + eax], byte '-'
        add eax, 80
        ;print name
        mov dl, [edi + 1]
        mov [esi + eax], dl
        add eax, 4
        mov dl, [edi + 2]
        mov [esi + eax], dl
        add eax, 4
        mov dl, [edi + 3]
        mov [esi + eax], dl
        add eax, 80
        ;print points
        pusha
            mov ecx, eax
            mov eax, [edi + 4]
            mov edi, ecx
            mov ebx, 10
            mov ecx, 5
            ;mov edi, 32
            add edi, 20
            ciclo2:
            xor edx, edx  ; make edx = 0TAKE_NAME
            div ebx
            add dl, '0'
            mov [esi + edi], byte dl
            ;mov [esi + edi + 1], byte 13
            sub edi, 4
            loop ciclo2
        popa
        add edi, 8
    loop ciclo

    END
    %undef punt_map
    %undef punt_punctuations
    ret

global take_name
take_name:
    INI
    %define punt_name [ebp + 10]
    %define key [ebp + 8]

    xor eax, eax

    ;jmp take_name_end

    mov al, key

    ASCII al, KEY.A, 'A'
    ASCII al, KEY.B, 'B'
    ASCII al, KEY.C, 'C'
    ASCII al, KEY.D, 'D'
    ASCII al, KEY.E, 'E'
    ASCII al, KEY.F, 'F'
    ASCII al, KEY.G, 'G'
    ASCII al, KEY.H, 'H'
    ASCII al, KEY.I, 'I'
    ASCII al, KEY.J, 'J'
    ASCII al, KEY.K, 'K'
    ASCII al, KEY.L, 'L'
    ASCII al, KEY.M, 'M'
    ASCII al, KEY.N, 'N'
    ASCII al, KEY.O, 'O'
    ASCII al, KEY.P, 'P'
    ASCII al, KEY.Q, 'Q'
    ASCII al, KEY.R, 'R'
    ASCII al, KEY.S, 'S'
    ASCII al, KEY.T, 'T'
    ASCII al, KEY.U, 'U'
    ASCII al, KEY.V, 'V'
    ASCII al, KEY.W, 'W'
    ASCII al, KEY.X, 'X'
    ASCII al, KEY.Y, 'Y'
    ASCII al, KEY.Z, 'Z'
    ASCII al, KEY.1, '1'
    ASCII al, KEY.2, '2'
    ASCII al, KEY.3, '3'
    ASCII al, KEY.4, '4'
    ASCII al, KEY.5, '5'
    ASCII al, KEY.6, '6'
    ASCII al, KEY.7, '7'
    ASCII al, KEY.8, '8'
    ASCII al, KEY.9, '9'
    ASCII al, KEY.BckSp, byte 0  

    jmp take_name_end

    letra_ya:

    mov ebx, punt_name
    cmp [ebx + 1], byte 0
    je ini1
    cmp [ebx + 2], byte 0
    je ini2
    cmp [ebx + 3], byte 0
    je ini3

    cmp al, 0
    jne take_name_end
    mov [ebx + 3], byte 0


    jmp take_name_end

    ini1:
    mov [ebx + 1], al
    jmp take_name_end
    ini2:
    cmp al, 0
    je del2
    mov [ebx + 2], al
    jmp take_name_end
    ini3:
    cmp al, 0
    je del3
    mov [ebx + 3], al
    jmp take_name_end

    del2:
    mov [ebx + 1], byte 0
    jmp take_name_end

    del3:
    mov [ebx + 2], byte 0
    jmp take_name_end

    take_name_end:

    END
    %undef punt_name
    %undef key
    ret

global add_puntuation
add_puntuation:
    INI
    %define punt_new_puntuation [ebp + 12]
    %define punt_puntuations [ebp + 8]

    mov esi, punt_new_puntuation
    mov edi, punt_puntuations
    mov eax, [esi + 4]
    cmp [edi + 76], eax
    ja end

    ;mov esi, punt_new_puntuation
    ;mov ebx, [esi + 4]
    ;mov edi, punt_puntuations
    ;cmp [edi + 76], ebx
    ;jb poner

    mov eax, [esi + 4]
    mov [edi + 76], eax
    mov eax, [esi]
    mov [edi + 72], eax

    mov ecx, 9
    ciclo_swap:
        mov eax, ecx
        mov ebx, 8
        mul ebx

        mov ebx, [edi + eax + 4]
        cmp [edi + eax - 4], ebx
        ja end

        ;swap
        mov edx, [edi + eax]
        push edx
        mov edx, [edi + eax + 4]
        push edx

        mov edx, [edi + eax - 8]
        mov [edi + eax], edx
        mov edx, [edi + eax - 4]
        mov [edi + eax + 4], edx

        pop edx
        mov [edi + eax - 4], edx
        pop edx
        mov [edi + eax - 8], edx

    loop ciclo_swap
    jmp end

    poner:
        mov esi, punt_new_puntuation
        mov ebx, [esi + 4]
        mov edi, punt_puntuations
        mov [edi + 20], ebx
        mov ebx, [esi]
        mov [edi + 16], ebx

    end:

    END
    %undef punt_punctuations
    %undef punt_new_punctuation
    ret