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

extern paint_shot
extern create_shot

global paint_ultrashot
paint_ultrashot:
  INI
  %define punt_object [ebp + 8]
  %define punt_map [ebp + 12]

  mov edi, punt_object
  cmp byte [edi + 6], 1
  je end_painting


  mov ebx, [edi + 12]; punt_shots
  mov ecx, 3
  mov eax, [ebx]; punt function to paint

  for:
    push dword punt_map
    push ebx
    call eax
    add esp, 8
    add ebx, 8
  loop for

  end_painting:
  %undef punt_object
  %undef punt_map
  END
  ret


global create_ultrashot
create_ultrashot:
  INI
  %define punt_object [ebp + 8]

  mov edi, punt_object
  mov [edi + 6], byte 0 ; activating ultrashot
  mov eax, [edi + 16] ; punt ship
  mov edx, [edi + 12]; punt shot
  mov ecx, 3
  mov esi, 1

  ciclo:
    push dword 1
    push edx
    push esi
    push eax
    call create_shot
    add esp, 16
    add edx, 8
    inc esi
  loop ciclo

  %undef punt_object
  END
  ret