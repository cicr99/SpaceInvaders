
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

global paint_alien
paint_alien:
  INI
  %define punt_map [ebp + 12]
  %define punt_alien [ebp + 8]

  mov edx, punt_alien

  mov bl, [edx + 6]
  cmp bl, 1
  je end
  xor eax, eax
  xor ebx, ebx

  mov bl, [edx + 8]

  mov al, [edx + 4]
  mov cl, 80
  mul cl
  xor ecx, ecx
  mov cl, [edx + 4 + 1]
  add eax, ecx
  mov ecx, 4
  mul ecx
  add eax, punt_map

  ;xor ebx, ebx
  ;mov cl, [edx + 8]
  cmp bl, 1
  je paint_alien_1
  cmp bl, 2
  je paint_alien_2
  cmp bl, 3
  je paint_alien_3
  ;jmp end

  paint_alien_1:
  mov [eax + 1], byte 6
  mov [eax], byte 'o'
  mov [eax - 4 + 1], byte 3
  mov [eax - 4], byte 'o'
  mov [eax - 8 + 1], byte 8
  mov [eax - 8], byte '('
  mov [eax + 4 + 1], byte 3
  mov [eax + 4], byte 'o'
  mov [eax + 8 + 1], byte 8
  mov [eax + 8], byte ')'
  jmp end


  paint_alien_2:
  mov [eax + 1], byte 7
  mov [eax], byte 002
  mov [eax - 4 + 1], byte 4
  mov [eax - 4], byte '/'
  mov [eax - 8 + 1], byte 9
  mov [eax - 8], byte '>'
  mov [eax + 4 + 1], byte 4
  mov [eax + 4], byte '\'
  mov [eax + 8 + 1], byte 9
  mov [eax + 8], byte '<'
  jmp end

  paint_alien_3:
  mov [eax + 1], byte 15
  mov [eax], byte 001
  mov [eax - 4 + 1], byte 14
  mov [eax - 4], byte '-'
  mov [eax - 8 + 1], byte 2
  mov [eax - 8], byte 'V'
  mov [eax + 4 + 1], byte 14
  mov [eax + 4], byte '-'
  mov [eax + 8 + 1], byte 2
  mov [eax + 8], byte 'V'
  jmp end

  end:
  END
  %undef punt_map
  %undef punt_alien
  ret