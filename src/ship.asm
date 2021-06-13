

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

global paint_ship
paint_ship:
  INI
  %define punt_map [ebp + 12]
  %define punt_ship [ebp + 8]

  mov edx, punt_ship

  mov al, [edx + 6]
  cmp al, 0
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

  mov [eax + 1], byte 5
  mov [eax], byte '8'
  mov [eax - 4 + 1], byte 5
  mov [eax - 4], byte '/'
  mov [eax - 8 + 1], byte 7
  mov [eax - 8], byte '<'
  mov [eax + 4 + 1], byte 5
  mov [eax + 4], byte '\'
  mov [eax + 8 + 1], byte 7
  mov [eax + 8], byte '>'

end:
  END

  %undef punt_map
  %undef punt_ship
  ret




global paint_ship2
paint_ship2:
  INI
  %define punt_map [ebp + 12]
  %define punt_ship [ebp + 8]

  mov edx, punt_ship

  mov al, [edx + 6]
  cmp al, 0
  je finish

  mov al, [edx + 4]
  mov bl, 80
  mul bl
  xor ebx, ebx
  mov bl, [edx + 4 + 1]
  add eax, ebx
  mov ebx, 4
  mul ebx
  add eax, punt_map

  mov [eax + 1], byte 4
  mov [eax], byte '6'
  mov [eax - 4 + 1], byte 4
  mov [eax - 4], byte '/'
  mov [eax - 8 + 1], byte 6
  mov [eax - 8], byte '<'
  mov [eax + 4 + 1], byte 4
  mov [eax + 4], byte '\'
  mov [eax + 8 + 1], byte 6
  mov [eax + 8], byte '>'

  finish:
  END

  %undef punt_map
  %undef punt_ship
  ret
