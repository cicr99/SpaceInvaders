%include "sound.mac"

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

section .data
timer_sound resd 2

section .text

;ebp + 8 memory direction of the ship that shot
;ebp + 12 direction of the shot (0 down, 1 up, 2 diag-right-up, 3 diag-left-up)
;ebp + 16 direction of the array of shots
;ebp + 20 length of the array
global create_shot
create_shot:
  INI
  %define punt_ship [ebp + 8]
  %define mov_dir [ebp + 12]
  %define punt_shots [ebp + 16]
  %define shots_amount [ebp + 20]



  mov ecx, shots_amount
  mov eax, punt_shots
  find_available_shot:
  cmp byte [eax + 6], 1
  je create
  add eax, 8
  loop find_available_shot
  jmp shot_finished

  create:
  mov ebx, punt_ship ; ship that shot
  mov ecx, mov_dir ; direction of the shot
  mov dx, [ebx + 4] ; row and col
  mov [eax + 4], dx
  mov [eax + 6], byte 0
  mov [eax + 7], cl

  shot_finished:
  %undef punt_ship
  %undef mov_dir
  %undef punt_shots
  %undef shots_amount
  END
  ret


;destroy(pos1, pos2, type)
;pos1: object to be destroyed
;pos2: object that destroys
;type: indicates the kind of object to be destroyed
;      0 ship
global destroy
destroy:
  push esi

  mov esi, [esp + 4]
  mov edx, [esp + 8]
  mov eax, 0
  mov al, [edx + 4]
  cmp [esi + 4], al
  jne did_not_match
  mov eax, [esp + 12]
  cmp dword [eax], 0
  je destroying_a_ship

  end_destroying:
  pop esi
  ret

  did_not_match:
    mov eax, 0
    jmp end_destroying

  destroying_a_ship:
    mov eax, 0
    mov al, [esi + 5]
    ;mov dl, [edx + 5]
    sub al, 2
    cmp [edx + 5], al
    jb did_not_match
    add al, 4
    cmp [edx + 5], al
    ja did_not_match
    mov eax, 1
    jmp end_destroying







global destroy_shots
destroy_shots:
 INI
 %define punt_ship_shots [ebp + 8]
 %define punt_alien_shots [ebp + 12]
 %define punt_amount_ship_shots [ebp + 16]
 %define punt_amount_alien_shots [ebp + 20]
 %define punt_points [ebp + 24]
 %define bool_eternal [ebp + 28]

  mov eax, punt_amount_ship_shots
  mov ecx, 0
  mov cl, [eax]
  mov edi, punt_ship_shots
  ciclo4:
    mov dh, [edi + 6]
    cmp dh, 1
    je continue4
    mov ebx, punt_alien_shots
    mov esi, ecx
    mov eax, punt_amount_alien_shots
    mov ecx, 0
    mov cl, [eax]
    ciclo5:
      mov dh, [ebx + 6]
      cmp dh, 1
      je continue5
      mov dx, [ebx + 4]
      cmp dx, [edi + 4]
      je it_matched
      inc dl
      cmp dx, [edi + 4]
      je it_matched
      continue5:
      add ebx, 8
    loop ciclo5
    mov ecx, esi
    continue4:
    add edi, 8
  loop ciclo4
  jmp end_destroy_shots


  it_matched:
  mov [ebx + 6], byte 1
  mov eax, bool_eternal
  cmp byte [eax], 1
  je continue7
  mov [edi + 6], byte 1

  continue7:
  pusha
  mov ax, 1080
  mov cx, 50
  MAKE_SOUND ax, cx, timer_sound
  popa

  pusha
  mov eax, punt_points
  mov ecx, 20
  add [eax + 4], ecx
  popa

  jmp continue5

  end_destroy_shots:
  END
  %undef punt_alien_shots
  %undef punt_ship_shots
  %undef punt_amount_alien_shots
  %undef punt_amount_ship_shots
  %undef punt_points
  ret







global destroy_ship
destroy_ship:
  INI
  %define punt_ship [ebp + 8]
  %define punt_shot [ebp + 12]
  %define punt_amount_shots [ebp + 16]
  %define punt_shield [ebp + 20]

  mov ebx, punt_ship
  mov dh, [ebx + 6]
  cmp dh, 0
  je finish

  mov eax, punt_amount_shots
  mov ecx, 0
  mov cl, [eax]
  mov eax, punt_shot
  ciclo3:
    mov dh, [eax + 6]
    cmp dh, 1
    je continue3
    mov dl, [ebx + 4]
    cmp dl, [eax + 4]
    je same_row1
    same_row1_ret:
    continue3:
    add eax, 8
  loop ciclo3
  jmp finish


  same_row1:
  mov dl, [ebx + 5]
  add dl, 2
  cmp [eax + 5], dl
  jbe same_row1_correct
  jmp same_row1_ret

  same_row1_correct:
  mov dl, [ebx + 5]
  sub dl, 2
  cmp [eax + 5], dl
  jae same_row1_correct2
  jmp same_row1_ret

  same_row1_correct2:
  mov edi, punt_shield
  cmp byte [edi + 6], 0
  je safety
  dec byte [ebx + 6]
  not_safety:
  mov [eax + 6], byte 1
  pusha
  mov ax, 780
  mov cx, 50
  MAKE_SOUND ax, cx, timer_sound
  popa
  cmp byte [ebx + 6], 0
  je finish_sound
  jmp same_row1_ret

  safety:
  mov byte [edi + 6], 1
  jmp not_safety


  ; mov edi, punt_ship ; ship
  ; cmp byte [edi + 6], 0
  ; je finish

  ; mov edx, punt_amount_shots
  ; mov ecx, 0
  ; mov cl, [edx] ; amount of shots
  ; mov ebx, punt_shots

  ; ciclo3:
  ;   cmp byte [ebx + 6], 0
  ;   jne continue3
  ;   push dword 0
  ;   ; mov edx, 0
  ;   ; mov dx, [ebx + 4] ; row and column of the shot
  ;   ; push edx
  ;   ; mov edx, 0
  ;   ; mov dx, [edi + 4] ; row and column of the ship
  ;   ; push edx
  ;   push ebx
  ;   push edi
  ;   call destroy
  ;   add esp, 12
  ;   cmp eax, 1
  ;   je it_crashed
  ;   continue3:
  ;   add ebx, 8
  ; loop ciclo3
  ; jmp finish


  ; it_crashed:
  ;   mov [ebx + 6], byte 1
  ;   dec byte [edi + 6]
  ;   cmp byte [edi + 6], 0
  ;   je finish
  ;   jmp continue3

finish_sound:
  MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound
    MAKE_SOUND 1000, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound
    MAKE_SOUND 1000, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound
    MAKE_SOUND 1000, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound
    MAKE_SOUND 1000, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound
    MAKE_SOUND 1000, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound
    MAKE_SOUND 1000, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 700, 50, timer_sound
    MAKE_SOUND 300, 50, timer_sound
    MAKE_SOUND 500, 50, timer_sound
    MAKE_SOUND 800, 50, timer_sound

    jmp finish

  finish:
    END
    %undef punt_ship
    %undef punt_shots
    %undef punt_amount_shots
    ret







global destroy_alien
destroy_alien:
  INI
  %define punt_amount_shots [ebp + 8]
  %define punt_shot [ebp + 12]
  %define punt_alien [ebp + 16]
  %define punt_living_aliens [ebp + 20]
  %define punt_points [ebp + 24]
  %define bool_eternal [ebp + 28]


  ; mov eax, punt_amount_shots
  ; mov ecx, 0
  ; mov cl, [eax]
  ; mov edi, punt_shot
  ; ciclo:
  ;   mov dh, [edi + 6]
  ;   cmp dh, 1
  ;   je continue1
  ;   mov ebx, punt_alien
  ;   mov esi, ecx
  ;   mov ecx, 30
  ;   ciclo2:
  ;     mov dh, [ebx + 6]
  ;     cmp dh, 0
  ;     jne continue2
  ;     push dword 0
  ;     push edi
  ;     push ebx
  ;     call destroy
  ;     add esp, 12
  ;     cmp eax, 1
  ;     je same_row_correct2
  ;     continue2:
  ;     add ebx, 12
  ;   loop ciclo2
  ;   mov ecx, esi
  ;   continue1:
  ;   add edi, 8
  ; loop ciclo
  ; jmp end

  ; same_row_correct2:
  ; mov [ebx + 6], byte 1
  ; mov [edi + 6], byte 1

  ; mov eax, punt_living_aliens
  ; dec byte [eax]

  ; jmp continue2


  mov eax, punt_amount_shots
  mov ecx, 0
  mov cl, [eax]
  mov eax, punt_shot
  ciclo:
    mov dh, [eax + 6]
    cmp dh, 1
    je continue1
    mov ebx, punt_alien
    mov esi, ecx
    mov ecx, 30
    ciclo2:
      mov dh, [ebx + 6]
      cmp dh, 1
      je continue2
      mov dl, [ebx + 4]
      cmp dl, [eax + 4]
      je same_row
      same_row_ret:
      continue2:
      add ebx, 12
    loop ciclo2
    mov ecx, esi
    continue1:
    add eax, 8
  loop ciclo
  jmp end


  same_row:
  mov dl, [ebx + 5]
  add dl, 2
  cmp [eax + 5], dl
  jbe same_row_correct
  jmp same_row_ret

  same_row_correct:
  mov dl, [ebx + 5]
  sub dl, 2
  cmp [eax + 5], dl
  jae same_row_correct2
  jmp same_row_ret

  same_row_correct2:
  mov [ebx + 6], byte 1
  mov edi, bool_eternal
  cmp byte [edi], 1
  je continue6
  mov [eax + 6], byte 1

  continue6:
  pusha
  mov ax, 480
  mov cx, 50
  MAKE_SOUND ax, cx, timer_sound
  mov eax, punt_points
  xor ecx, ecx
  mov cx, [ebx + 9]
  add [eax + 4], ecx

  mov eax, punt_living_aliens
  dec byte [eax]
  popa

  jmp same_row_ret


  end:
  END
  %undef punt_shot
  %undef punt_alien
  %undef punt_amount_shots
  %undef punt_living_aliens
  %undef bool_eternal
  ret


global destroy_box
destroy_box:
  INI
  %define punt_box [ebp + 8]
  %define punt_shots [ebp + 12]
  %define punt_amount_shots [ebp + 16]
  %define punt_bool [ebp + 20]
  %define bool_eternal [ebp + 24]

  mov edi, punt_box
  cmp byte [edi + 6], 1
  je destroy_box_end

  xor ecx, ecx
  mov edx, punt_amount_shots
  mov cl, [edx]
  mov eax, punt_shots
  xor edx, edx
  mov dx, [edi + 4]; row and column of the box

  for:
    cmp byte [eax + 6], 1
    je .continue
    cmp [eax + 4], dx
    je matched
    .continue:
    add eax, 8
    loop for

    jmp destroy_box_end

  matched:
  mov ebx, bool_eternal
  cmp byte [ebx], 1
  je is_eternal
  mov byte [eax + 6], 1
  is_eternal:
  mov byte [edi + 6], 1
  mov eax, punt_bool
  mov byte [eax], 1

  destroy_box_end:
  %undef punt_box
  %undef punt_shots
  %undef punt_amount_shots
  %undef punt_bool
  %undef bool_eternal
  END
  ret








global paint_shot
paint_shot:
    INI
    %define punt_map [ebp + 12]
    %define punt_shot [ebp + 8]

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

    mov [eax], byte 4
    mov [eax + 1], byte 7

    .end:
    END
    %undef punt_map
    %undef punt_alien
    ret
