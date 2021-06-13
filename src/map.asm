%define MAP_ASM

%include "map.mac"

extern putc

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

global paint_map
paint_map:
  INI
  %define punt_map [ebp + 8]

  mov ch, 0
  mov cl, 0
  mov esi, 0
  mov edi, punt_map

  paint_map.jump:
  mov dx, cx
  shl edx, 16
  mov dh, [edi + esi + 1]
  mov dl, [edi + esi]

  push edx
  call putc
  add esp, 4

  add esi, 4
  cmp esi, 8000
  je paint_map.end
  inc ch
  cmp ch, 80
  je paint_map.incfil
  jmp paint_map.jump

  paint_map.incfil:
  mov ch, 0
  inc cl
  cmp cl, 25
  je paint_map.end
  jmp paint_map.jump

  paint_map.end:
  END
  %undef punt_map 
  ret

global refresh_map
refresh_map:
  INI

  %define punt_map [ebp + 16]
  %define punt_drawables [ebp + 12]
  %define caint_of_drawables [ebp + 8]

  mov eax, 0
  mov ebx, punt_drawables
  mov ecx, caint_of_drawables

  .cicle:
    push dword punt_map
    push dword [ebx + eax]
    ;mov edx [ebx + eax]
    mov edx, [ebx + eax]
    call [edx]
    add esp, 8
    

    ;call [ebx + eax + 4]
    ;add esp, 8

    add eax, 4
    loop .cicle

  END

  %undef punt_map
  %undef punt_drawables
  %undef caint_of_drawables
  
  ret

global fill_map
fill_map:
  INI
  %define punt_map.fill [ebp + 12]

  mov ebx, 0
  mov ah, 0
  mov al, 0

  fill_map.jump:  
  mov esi, punt_map.fill
  mov [esi + ebx + 3], al
  mov [esi + ebx + 2], ah
  mov [esi + ebx + 1], byte 2
  mov [esi + ebx], byte 0
  
  add ebx, 4
  cmp ebx, 8000
  je fill_map.end
  inc al
  cmp al, 80
  je fill_map.incfil
  jmp fill_map.jump

  fill_map.incfil:
  mov al, 0
  inc ah
  cmp ah, 25
  je fill_map.end
  jmp fill_map.jump

  fill_map.end:
  END
  %undef punt_map.fill
  ret
