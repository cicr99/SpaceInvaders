%define MOVE_ASM

%include "move.mac"

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


section.text
global move_up_cartel
move_up_cartel:
  INI
  %define object [ebp + 8]
  mov eax, object
  mov bl, [eax + 1]
  cmp [eax], bl
  je next_up
  sub byte [eax], 2
  next_up:
  %undef object
  END
  ret

global move_down_cartel
move_down_cartel:
  INI
  %define object [ebp + 8]
  mov eax, object
  mov bl, [eax + 2]
  cmp [eax], bl
  je next_down
  add byte [eax], 2
  next_down:
  %undef object
  END
  ret

global move_up
move_up:
  INI
  %define object [ebp + 8]
  mov eax, object
  dec byte [eax + 4]
  cmp byte [eax + 4], 0
  jge move_up.next
  mov [eax + 4], byte 0
  move_up.next:
  %undef object
  END
  ret

global move_down
move_down:
  INI
  %define object [ebp + 8]
  mov eax, object
  inc byte [eax + 4]
  cmp byte [eax + 4], 24
  jle move_down.next
  mov [eax + 4], byte 24
  move_down.next:
  %undef object
  END
  ret

global move_left
move_left:
  INI
  %define object [ebp + 8]
  mov eax, object
  dec byte [eax + 4 + 1]
  cmp byte [eax + 4 + 1], 2
  jge move_left.next
  mov [eax + 4 + 1], byte 2
  move_left.next:
  %undef object
  END
  ret

global move_right
move_right:
  INI
  %define object [ebp + 8]
  mov eax, object
  inc byte [eax + 4 + 1]
  cmp byte [eax + 4 + 1], 77
  jle move_right.next
  mov [eax + 4 + 1], byte 77
  move_right.next:
  %undef object
  END
  ret

global change_direction
change_direction:
  INI
  %define object [ebp + 8]
  mov eax, object
  cmp byte [eax + 7], 1
  je decre
  cmp byte [eax + 7], 0
  je cre
  jump:
  %undef object
  END
  ret

  cre:
  inc byte [eax + 7]
  jmp jump

  decre:
  dec byte [eax + 7]
  jmp jump

global move_diag_right_up
move_diag_right_up:
  INI
  %define object [ebp + 8]
  mov eax, object
  cmp byte [eax + 4], 0
  je fin
  cmp byte [eax + 5], 79
  je fin
  dec byte [eax + 4]
  inc byte [eax + 5]
  fin:
  %undef object
  END
  ret

global move_diag_left_up
move_diag_left_up:
  INI
  %define object [ebp + 8]
  mov eax, object
  cmp byte [eax + 4], 0
  je .end
  cmp byte [eax + 5], 0
  je .end
  dec byte [eax + 4]
  dec byte [eax + 5]
  .end:
  %undef object
  END
  ret





;move_object(esp + 4: direction of the object to move)
global move_object
move_object:
  INI
  %define object [ebp + 8]
  
  mov eax, object
  cmp byte [eax + 7], 1
  je move_object_up
  cmp byte [eax + 7], 0
  je move_object_down
  cmp byte [eax + 7], 2
  je move_object_dru
  cmp byte [eax + 7], 3
  je move_object_dlu
  cmp byte [eax + 7], 4
  je move_object_right
  cmp byte [eax + 7], 5
  je move_object_left

  finish:
  %undef object
  END
  ret

  move_object_up:
  cmp byte [eax + 4], 0
  je it_crashed
  push eax
  call move_up
  add esp, 4
  jmp finish

  move_object_down:
  cmp byte [eax + 4], 24
  je it_crashed
  push eax
  call move_down
  add esp, 4
  jmp finish

  move_object_dru:
  cmp byte [eax + 4], 0
  je it_crashed
  cmp byte [eax + 5], 79
  je it_crashed
  push eax
  call move_diag_right_up
  add esp, 4
  jmp finish

  move_object_dlu:
  cmp byte [eax + 4], 0
  je it_crashed
  cmp byte [eax + 5], 0
  je it_crashed
  push eax
  call move_diag_left_up
  add esp, 4
  jmp finish

  move_object_right:
  cmp byte [eax + 5], 77
  je it_crashed
  push eax
  call move_right
  add esp, 4
  jmp finish

  move_object_left:
  cmp byte [eax + 5], 2
  je it_crashed
  push eax
  call move_left
  add esp, 4
  jmp finish

  it_crashed:
  mov byte [eax + 6], 1
  jmp finish







global move_shots
move_shots:
  INI
  %define shots [ebp + 8]
  %define shots_amount [ebp + 12]

  mov eax, shots
  mov edx, shots_amount
  mov ecx, 0
  mov cl, [edx]
  find1:
  cmp byte [eax + 6], 0
  jne continue1
  push eax
  call move_object
  add esp, 4
  continue1:
  add eax, 8
  loop find1

  %undef shots
  %undef shots_amount
  END
  ret





global move_ultrashot
move_ultrashot:
  INI
  %define ultrashot [ebp + 8]

  mov eax, ultrashot
  mov ebx , [eax + 12] ;punt shots
  mov ecx, 3

  move_them:
    cmp byte [ebx + 6], 1
    je .continue
    push ebx
    call move_object
    add esp, 4
    .continue:
    add ebx, 8
  loop move_them

  %undef ultrashot
  END
  ret