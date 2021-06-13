%include "video.mac"
%include "keyboard.mac"
%include "map.mac"
%include "move.mac"
%include "shot.mac"
%include "puntuation.mac"
%include "sound.mac"
%include "lethal_line.mac"

section .data
ship_shots_amount db 3
alien_shots_amount db 10
aliens_amount dd 30
weapons_amount db 4
eternal_shot_amount db 1
ultrashots_amount db 3
cartel db "\
@******************************************************************************@\
*                                    _                           _             *\
*  ___  _ __    __ _   ___   ___    (_) _ __  __   __  __ _   __| |  ___  _ __ *\
* / __|| '_ \  / _` | / __| / _ \   | || '_ \ \ \ / / / _` | / _` | / _ \| '__|*\
* \__ \| |_) || (_| || (__ |  __/   | || | | | \ v / | (_| || (_| ||  __/| |   *\
* |___/| .__/  \__,_| \___| \___|   |_||_| |_|  \_/   \__,_| \__,_| \___||_|   *\
*      |_|                                                                     *\
*                                                                              *\
*                                  EASY MODE                                   *\
*                                                                              *\
*                                 NORMAL MODE                                  *\
*                                                                              *\
*                                  HARD MODE                                   *\
*                                                                              *\
*                                 CRAZY  MODE                                  *\
*                                                                              *\
*                                SPACE SHOOTER             Produced by:        *\
*                                                                              *\
*                                   ARCADE             Carmen Irene Cabrera    *\
*                                                                              *\
*                                 MULTIPLAYER          Enrique Martinez Glez   *\
*                                                                              *\
*                                 MIRROR MODE                 C-212            *\
*                                                                              *\
@******************************************************************************@", 0
cartel_game_over db "\
@******************************************************************************@\
*                                                                              *\
*                                                                              *\
*           ***********   ***********   *         *   ***********              *\
*           *             *         *   **       **   *                        *\
*           *             *         *   *  *   *  *   *                        *\
*           *             *         *   *    *    *   *                        *\
*           *    ******   ***********   *         *   ***********              *\
*           *         *   *         *   *         *   *                        *\
*           *         *   *         *   *         *   *                        *\
*           ***********   *         *   *         *   ***********              *\
*                                                                              *\
*           ***********   *         *   ***********   ***********              *\
*           *         *   *         *   *             *         *              *\
*           *         *   *         *   *             *         *              *\
*           *         *   *         *   *             *         *              *\
*           *         *     *     *     ***********   ***********              *\
*           *         *      *   *      *             *       *                *\
*           *         *       * *       *             *        *               *\
*           ***********        *        ***********   *         *              *\
*                                                                              *\
*                                                                              *\
*                        ENTER YOUR NAME: ___ POINTS:                          *\
*                                                                              *\
@******************************************************************************@", 0
pause_cartel db "\
@******************************************************************************@\
*                                    _                           _             *\
*  ___  _ __    __ _   ___   ___    (_) _ __  __   __  __ _   __| |  ___  _ __ *\
* / __|| '_ \  / _` | / __| / _ \   | || '_ \ \ \ / / / _` | / _` | / _ \| '__|*\
* \__ \| |_) || (_| || (__ |  __/   | || | | | \ v / | (_| || (_| ||  __/| |   *\
* |___/| .__/  \__,_| \___| \___|   |_||_| |_|  \_/   \__,_| \__,_| \___||_|   *\
*      |_|                                                                     *\
*                                                                              *\
*                                   RESUME                                     *\
*                                                                              *\
*                                END THIS GAME                                 *\
*                                                                              *\
*                                    EXIT                                      *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
*                                                                              *\
@******************************************************************************@", 0


section .bss
map resb 8000
ship resd 2
ship2 resd 2
alien resd 90
points resd 2
lives resd 3

surprise_box resd 2
drop_box resb 1 ;bool for dropping the surprise box
timer_box resd 2 ; timer to move the surprise box
timer_for_dropping resd 2 ; timer to drop the box

timer_line resd 2

special_weapons resd 4
current_weapon resd 1
box_destroyed resb 1 ; 0 not destroyed, 1 destroyed
bool_current resb 1 ; 0 there is no current weapon, 1 there is one

;dword function to paint, byte(shield + 6) 0-activated 1-notactivated, dword function to create
shield resd 6 ;ship, ship2
ultrashot resd 6; shots (3), ship
shots resd 6
eternal_shot resd 6
bool_eternal resb 1 ; bool to know whether the eternal shot is activated
lethal_line resd 6

ini_fill_screen resd 2
index_cartel resd 2
ini_wallpaper resd 3
ini_drawables resd 5
index resd 1

end_wallpaper resd 5
name resd 1
punctuation resd 20
new_puntation resd 2
fill_punctuation resd 2
punctuation_drawables resd 5
end_drawables resd 5

pause_drawables resd 5
pause_wallpaper resd 3

living_aliens resd 1

bool_for_random resb 1
random resd 1

;0 easy, 1 medium, 2 hard
;3 crazy_aliens, 4 space_shooter, 5 arcade
;6 two players, 7 mirror_mode
mode resb 1

; shots: function to paint
; shots+4: row, shots+5:col
; shots + 6: bool for crashed
; shots + 7:direction of movement(0 down, 1 up, 2 dru, 3 dlu, 4 right, 5 left)
ship_shots resd 6
ship2_shots resd 6
alien_shots resd 20

wallpaper resd 2
drawables resd 57

actual_power resd 3

timer_alien resd 2
timer_shot resd 2
timer_alien_shooting resd 2
timer_wallpaper_ini resd 2
timer_wallpaper_end resd 2

game_start resb 1




extern clear
extern putc
extern scan
extern calibrate
extern delay

; Bind a key to a procedure
%macro bind 2
  cmp byte [esp], %1
  jne %%next
  call %2
  %%next:
%endmacro

;%1 tecla, %2 macro that move, %3object to move
%macro bind_move 3
  cmp byte [esp], %1
  jne %%next
  %2 %3
  %%next:
%endmacro

%macro bind_input_letter 2
  cmp byte [esp], %1
  jne %%next
  push name
  push word %1
  %2
  add esp, 6
  %%next:
%endmacro


; Fill the screen with the given background color
%macro FILL_SCREEN 1
  push word %1
  call clear
  add esp, 2
%endmacro





section .text



global game
game:
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

  mov ecx, 10
  ini_punctuation:
    mov eax, ecx
    mov ebx, 8
    mul ebx
    mov [punctuation + eax - 8], dword 0
    mov [punctuation + eax - 4], dword 0
  loop ini_punctuation

    mov [punctuation], dword ' YO '
    mov [punctuation + 4], dword 66666
    mov [punctuation + 8], dword ' Y  '
    mov [punctuation + 12], dword 55555
    mov [punctuation + 16], dword ' TU '
    mov [punctuation + 20], dword 44444
    mov [punctuation + 24], dword ' NO!'
    mov [punctuation + 28], dword 33333


  start_game:
  mov [name], dword 0

  ; Initialize game

  FILL_SCREEN BG.BLACK

  ; Calibrate the timing
  call calibrate

  ;jmp punctuation_screen

  mov [game_start], byte 0

  mov [ini_fill_screen], dword fill_map

  mov [ini_wallpaper], dword fill_ini_screen
  mov [ini_wallpaper + 4], dword cartel
  mov [ini_wallpaper + 8], byte 1

  mov [index_cartel], dword paint_cartel
  mov [index_cartel + 4], dword index
  mov [index], byte 8
  mov [index + 1], byte 8
  mov [index + 2], byte 22

  mov [ini_drawables], dword ini_fill_screen
  mov [ini_drawables + 4], dword index_cartel
  mov [ini_drawables + 8], dword ini_wallpaper

  intro_game_loop:
  call get_input_first_screen

  cmp [game_start], byte 1
  je game_loop_beging

  push dword 1000
  push timer_wallpaper_ini
  call delay
  add esp, 8
  cmp eax, 0
  jne change_wallpaper_ini
  ret_change_walpaper_ini:


  REFRESH_MAP map, ini_drawables, 3
  PAINT_MAP map

  jmp intro_game_loop
  game_loop_beging:

  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx
  xor esi, esi
  xor edi, edi


  mov [living_aliens], dword 30
  mov [bool_for_random], byte 1

  mov al, byte [index]
  mov ebx, 2
  div ebx
  sub eax, 4
  mov [mode], al

  xor eax, eax
  xor ebx, ebx
  xor edx, edx


;initializing aliens of type 1
  mov ecx, 10
  mov eax, alien
  mov dl, 3
  ciclo:
  mov [eax], dword paint_alien
  mov [eax + 4], byte 3
  mov [eax + 5], dl
  mov [eax + 6], byte 0
  mov [eax + 7], byte 1
  mov [eax + 8], byte 1
  mov [eax + 9], word 300
  add edx, 8
  add eax, 12
  loop ciclo

  xor edx, edx
  xor eax, eax

;initializing aliens of type 2
  mov ecx, 10
  mov eax, alien
  add eax, 120
  mov dl, 3
  ciclo4:
  mov [eax], dword paint_alien
  mov [eax + 4], byte 5
  mov [eax + 5], dl
  mov [eax + 6], byte 0
  mov [eax + 7], byte 1
  mov [eax + 8], byte 2
  mov [eax + 9], word 200
  add edx, 8
  add eax, 12
  loop ciclo4

  xor edx, edx
  xor eax, eax

;initializing aliens of type 3
  mov ecx, 10
  mov eax, alien
  add eax, 240
  mov dl, 3
  ciclo5:
  mov [eax], dword paint_alien
  mov [eax + 4], byte 7
  mov [eax + 5], dl
  mov [eax + 6], byte 0
  mov [eax + 7], byte 1
  mov [eax + 8], byte 3
  mov [eax + 9], word 100
  add edx, 8
  add eax, 12
  loop ciclo5


  xor edx, edx
  xor eax, eax
  xor ecx, ecx

;initializing ship_shots and alien_shots
  mov eax, ship_shots
  mov ebx, ship2_shots
  mov cl, [ship_shots_amount]
  init_ship_shots:
    mov [eax], dword paint_shot
    mov [ebx], dword paint_shot
    mov [eax + 6], byte 1
    mov [ebx + 6], byte 1
    add eax, 8
    add ebx, 8
    loop init_ship_shots

  xor ecx, ecx
  xor eax, eax
  xor ebx, ebx

  mov eax, alien_shots
  mov cl, [alien_shots_amount]
  init_alien_shots:
    mov [eax], dword paint_shot
    mov [eax + 6], byte 1
    add eax, 8
    loop init_alien_shots


  mov [drawables], dword wallpaper
  mov [drawables + 4], dword ship

;moving aliens to drawables
  mov ecx, 30
  mov edx, drawables
  add edx, 8
  mov eax, alien
  mov ebx, 0
  ciclo3:
  mov [edx + ebx], dword eax
  add eax, 12
  add ebx, 4
  loop ciclo3

  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx


;moving shots to drawables
  mov eax, ship_shots
  mov ebx, drawables
  mov edx, 128
  mov cl, [ship_shots_amount]
  m_ship_shots:
  mov [ebx + edx], eax
  add eax, 8
  add edx, 4
  loop m_ship_shots

  mov eax, ship2_shots
  mov ebx, drawables
  xor ecx, ecx
  mov cl, [ship_shots_amount]
  m_ship2_shots:
  mov [ebx + edx], eax
  add eax, 8
  add edx, 4
  loop m_ship2_shots

  xor ecx, ecx
  mov eax, alien_shots
  mov cl, [alien_shots_amount]
  m_alien_shots:
  mov [ebx + edx], eax
  add eax, 8
  add edx, 4
  loop m_alien_shots

;initializing other things
  mov [wallpaper], dword fill_map

  mov [ship], dword paint_ship
  mov [ship + 4], byte 0b0001_1000
  mov [ship + 5], byte 0b0011_0010

  mov [ship2], dword paint_ship2
  mov [ship2 + 4], byte 0b0001_1000
  mov [ship2 + 5], byte 0b0001_0100

  call decide_mode_lives

  mov [points], dword paint_points
  mov [points + 4], dword 0
  mov [drawables + 192], dword points

  mov [lives], dword paint_lives
  mov [lives + 4], dword ship
  mov [lives + 8], dword ship2
  mov [drawables + 196], dword lives

  mov [drawables + 200], dword ship2

  mov [surprise_box], dword paint_box
  mov [surprise_box + 6], byte 1
  mov [drawables + 204], dword surprise_box
  mov [drop_box], byte 1
  mov [box_destroyed], byte 0

  mov [shield], dword paint_shield
  mov [shield + 6], byte 1
  mov [shield + 20], byte 'S'
  mov [shield + 21], byte 8
  mov [shield + 8], dword create_shield
  mov [shield + 12], dword ship
  mov [shield + 16], dword ship2

  mov [ultrashot], dword paint_ultrashot
  mov [ultrashot + 6], byte 1
  mov [ultrashot + 20], byte 'U'
  mov [ultrashot + 21], byte 5
  mov [ultrashot + 8], dword create_ultrashot
  mov [ultrashot + 12], dword shots
  mov [ultrashot + 16], dword ship
  mov [shots], dword paint_shot
  mov [shots + 8], dword paint_shot
  mov [shots + 16], dword paint_shot

  mov [eternal_shot], dword paint_eternal_shot
  mov [eternal_shot + 6], byte 1
  mov [eternal_shot + 20], byte 'E'
  mov [eternal_shot + 21], byte 4
  mov [eternal_shot + 8], dword create_eternal_shot
  mov [eternal_shot + 12], dword ship
  mov byte [bool_eternal], 0

  mov [lethal_line], dword paint_lethal_line
  mov [lethal_line + 6], byte 1
  mov [lethal_line + 8], dword create_lethal_line
  mov [lethal_line + 20], byte 'L'
  mov [lethal_line + 21], byte 3

  mov [special_weapons], dword shield
  mov [special_weapons + 4], dword ultrashot
  ; mov [special_weapons], dword ultrashot
  ; mov [special_weapons + 4], dword ultrashot
  mov [special_weapons + 8], dword eternal_shot
  ; mov [special_weapons + 8], dword ultrashot
  mov [special_weapons + 12], dword lethal_line
  mov [bool_current], byte 0

  mov [drawables + 208], dword shield
  mov [drawables + 212], dword ultrashot
  mov [drawables + 216], dword eternal_shot
  mov [drawables + 220], dword lethal_line
  mov [drawables + 224], dword actual_power

  mov [actual_power], dword paint_actual_power
  mov [actual_power + 4], dword current_weapon
  mov [actual_power + 8], dword bool_current

  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx

;jmp game_over_screen

; Main loop
  game.loop:

    .input:
      call get_input
      cmp [game_start], byte 11;pause
      je pause_screen
      return_from_pause:

      xor eax, eax
      xor ebx, ebx
      xor ecx, ecx
      xor edx, edx

;moving all the shots
      push dword 70
      push timer_shot
      call delay
      add esp, 8
      cmp eax, 0
      jne move_all_shots
      move_shots_ret:
      DESTROY_SHOTS bool_eternal, points, alien_shots_amount, ship_shots_amount, alien_shots, ship_shots
      DESTROY_SHOTS bool_eternal, points, alien_shots_amount, ship_shots_amount, alien_shots, ship2_shots
      DESTROY_SHOTS bool_eternal, points, alien_shots_amount, ultrashots_amount, alien_shots, shots
      DESTROY_ALIEN bool_eternal, points, living_aliens, alien, ship_shots, ship_shots_amount
      DESTROY_ALIEN bool_eternal, points, living_aliens, alien, ship2_shots, ship_shots_amount
      DESTROY_ALIEN bool_eternal, points, living_aliens, alien, shots, ultrashots_amount
      DESTROY_SHIP shield, alien_shots_amount, alien_shots, ship
      DESTROY_SHIP shield, alien_shots_amount, alien_shots, ship2
      ANNIHILATE living_aliens, alien, lethal_line

      cmp byte [eternal_shot + 6], 1
      je not_eternal
      mov byte [bool_eternal], 1
      DESTROY_ALIEN bool_eternal, points, living_aliens, alien, eternal_shot, eternal_shot_amount
      DESTROY_SHOTS bool_eternal, points, alien_shots_amount, eternal_shot_amount, alien_shots, eternal_shot
      DESTROY_BOX bool_eternal, box_destroyed, eternal_shot_amount, eternal_shot, surprise_box
      mov byte [bool_eternal], 0
      not_eternal:

      cmp [ship + 6], byte 0
      je ship1_dead
      ret_ship1_dead:
      cmp [living_aliens], dword 0
      je game_over_screen

      pusha
      mov ecx, 30
      mov esi, alien

      check_last_row_aliens:
        cmp [esi + 6], byte 1
        je next_check
        cmp [esi + 4], byte 24
        je game_over_screen
        next_check:
        add esi, 12
      loop check_last_row_aliens
      popa

; aliens velocity of movement
      xor eax, eax
      call decide_aliens_velocity
      push eax
      push timer_alien
      call delay
      add esp, 8

      mov ecx, 30
      mov esi, alien
      cmp eax, 0
      jne decide_alien_movement
      move_alien_ret:

      call infinite_move

      xor eax, eax
      xor ebx, ebx
      xor ecx, ecx
      xor edx, edx

; lethal line activity
      cmp byte [lethal_line + 6], 0
      jne not_line
      push dword 3000
      push timer_line
      call delay
      add esp, 8

      cmp eax, 0
      jne deactivate
      deactivate_ret:

      not_line:


; random shots for the aliens

      cmp byte[bool_for_random], 1
      jne timer

      rdtsc
      xor edx, edx
      mov [bool_for_random], byte 0
      xor ebx, ebx
      mov bl, [living_aliens]
      div ebx
      mov [random], edx

      push dword [random]
      call alien_shooting
      add esp, 4

      cmp byte [mode], 4
      je intelligent_aliens

      xor edx, edx
      mov dl, [alien_shots_amount]
      CREATE_SHOT edx, alien_shots, dword 0, eax

      intelligent_aliens_ret:


      timer:
      xor eax, eax
      call timer_for_shooting
      push eax
      push timer_alien_shooting
      call delay
      add esp, 8
      cmp eax, 0
      je continue3

      mov [bool_for_random], byte 1

      continue3:

; random for dropping the surprise boxes
      cmp byte [drop_box], 1
      je random_dropping
      random_dropping_end:

      push dword 500
      push timer_box
      call delay
      add esp, 8
      cmp eax, 0
      jne move_box
      move_box_end:
      DESTROY_BOX bool_eternal, box_destroyed, ship_shots_amount, ship_shots, surprise_box
      DESTROY_BOX bool_eternal, box_destroyed, ship_shots_amount, ship2_shots, surprise_box
      DESTROY_BOX bool_eternal, box_destroyed, ultrashots_amount, shots, surprise_box

      cmp byte [drop_box], 0
      je check_status
      check_end:

      cmp byte [box_destroyed], 1
      je generate_weapon
      generate_weapon_end:

      REFRESH_MAP map, drawables, 57


      PAINT_MAP map

      ;call draw.green

      xor eax, eax
      xor ebx, ebx
      xor ecx, ecx
      xor edx, edx

    ; Main loop.

    ; Here is where you will place your game logic.
    ; Develop procedures like paint_map and update_content,
    ; declare it extern and use here.

    jmp game.loop

ship1_dead:
  cmp [ship2 + 6], byte 0
  je game_over_screen
  jmp ret_ship1_dead

pause_screen:
  mov [ini_fill_screen], dword fill_map

  mov [pause_wallpaper], dword fill_ini_screen
  mov [pause_wallpaper + 4], dword pause_cartel
  mov [pause_wallpaper + 8], byte 1

  mov [index_cartel], dword paint_cartel
  mov [index_cartel + 4], dword index
  mov [index], byte 8
  mov [index + 1], byte 8
  mov [index + 2], byte 12

  mov [pause_drawables], dword ini_fill_screen
  mov [pause_drawables + 4], dword index_cartel
  mov [pause_drawables + 8], dword pause_wallpaper

  pause_screen_loop:
  call get_input_pause_screen

  cmp [game_start], byte 20
  je decide_pause

  push dword 1000
  push timer_wallpaper_ini
  call delay
  cmp eax, 0
  jne change_wallpaper_ini2
  ret_change_walpaper_ini2:

  add esp, 8

  REFRESH_MAP map, pause_drawables, 3
  PAINT_MAP map

  jmp pause_screen_loop

decide_pause:
  cmp [index], byte 8
  je return_from_pause
  cmp [index], byte 10
  je game_over_screen
  cmp [index], byte 12
  je start_game

punctuation_screen:
  mov [ini_fill_screen], dword fill_map
  mov [fill_punctuation], dword paint_punctuation
  mov [fill_punctuation + 4], dword punctuation
  mov [punctuation_drawables], dword ini_fill_screen
  mov [punctuation_drawables + 4], dword fill_punctuation

  punctuation_screen_loop:
    call get_input_puntation_screen
    cmp [game_start], byte 10
    je start_game
    REFRESH_MAP map, punctuation_drawables, 2
    PAINT_MAP map
  jmp punctuation_screen_loop


game_over_screen:
  mov [ini_fill_screen], dword fill_map
  mov [end_wallpaper], dword fill_end_screen
  mov [end_wallpaper + 4], dword cartel_game_over
  mov [end_wallpaper + 8], byte 1
  mov [end_wallpaper + 12], dword name
  mov [end_wallpaper + 16], dword points
  mov [end_drawables], dword ini_fill_screen
  mov [end_drawables + 4], dword end_wallpaper

  game_over_screen_loop:
  call get_input_game_over_screen
  cmp [game_start], byte 0
  je punctuation_screen

  push dword 1000
  push dword timer_wallpaper_end
  call delay
  cmp eax, 0
  jne change_wallpaper_end
  ret_change_walpaper_end:

  add esp, 8

  REFRESH_MAP map, end_drawables, 2
  PAINT_MAP map

  jmp game_over_screen_loop

; the movement of the aliens depends on the chosen mode
decide_alien_movement:
  cmp [mode], byte 0
    je move_alien
  cmp [mode], byte 1
    je move_alien
  cmp [mode], byte 2
    je move_alien
  cmp [mode], byte 7
    je move_alien
  cmp [mode], byte 3
    je move_alien_randomly
  cmp [mode], byte 4
    je move_alien_randomly
  cmp [mode], byte 5
    je move_alien_randomly
  cmp [mode], byte 6
    je move_alien

change_wallpaper_end:
  inc byte [end_wallpaper + 8]
  cmp byte [end_wallpaper + 8], 16
  je  mod_16_end
  ret_mod_16_end:
  jmp ret_change_walpaper_end

change_wallpaper_ini2:
  inc byte [pause_wallpaper + 8]
  cmp byte [pause_wallpaper + 8], 16
  je  mod_16_ini2
  ret_mod_16_ini2:
  jmp ret_change_walpaper_ini2

mod_16_end:
  mov [end_wallpaper + 8], byte 1
  jmp ret_mod_16_end

change_wallpaper_ini:
  inc byte [ini_wallpaper + 8]
  cmp byte [ini_wallpaper + 8], 16
  je  mod_16_ini
  ret_mod_16_ini:
  jmp ret_change_walpaper_ini

mod_16_ini2:
  mov [pause_wallpaper + 8], byte 1
  jmp ret_mod_16_ini2

mod_16_ini:
  mov [ini_wallpaper + 8], byte 1
  jmp ret_mod_16_ini


; generate aliens so the game will never end
generate_aliens:
  mov ecx, [aliens_amount]
  mov edi, alien
  ciclo7:
    cmp byte [edi + 6], 0
    je continue7
    rdtsc
    xor edx, edx
    mov ebx, 75
    div ebx
    add edx, 2
    mov [edi + 4], byte 1
    mov [edi + 5], dl
    mov [edi + 6], byte 0
    inc dword [living_aliens]
    continue7:
    add edi, 12
    loop ciclo7
  jmp generate_aliens_ret


move_all_shots:
  MOVE_SHOTS alien_shots_amount, alien_shots
  MOVE_SHOTS ship_shots_amount, ship2_shots
  MOVE_SHOTS ship_shots_amount, ship_shots
  MOVE_ULTRASHOT ultrashot
  MOVE_SHOTS eternal_shot_amount, eternal_shot
  jmp move_shots_ret



;moving aliens in a line
;esi aliens
;ecx amount of aliens
move_alien:
  cmp byte [esi + 5], 77
  je jump_change_direction
  cmp byte [esi + 5], 2
  je jump_change_direction
  jump:
  cmp byte [esi + 7], 1
  je jump_move_right
  cmp byte [esi + 7], 0
  je jump_move_left

  ciclo2:
  add esi, 12
  loop move_alien
  xor esi, esi
  jmp move_alien_ret
  ret

  jump_change_direction:
  CHANGE_DIRECTION esi
  inc byte [esi + 4]
  jmp jump

  jump_move_right:
  MOVE_RIGHT esi
  jmp ciclo2

  jump_move_left:
  MOVE_LEFT esi
  jmp ciclo2




;moving aliens randomly
; esi pointer to aliens
; ecx total amount of aliens
move_alien_randomly:
  pusha
  xor eax, eax
  xor ebx, ebx
  xor edx, edx
  mov ebx, 4
  rdtsc
  xor edx, edx

  foreach:
    cmp byte [esi + 6], 1
    je continue5
    div ebx
    cmp edx, 0
    je try_move_down
    cmp edx, 1
    je try_move_up
    cmp edx, 2
    je try_move_right
    cmp edx, 3
    je try_move_left
    continue5:
    add esi, 12
  loop foreach

  popa
  jmp move_alien_ret

  try_move_down:
    cmp byte [esi + 4], 22
    je not_possible_down
    MOVE_DOWN esi
    jmp continue5
    not_possible_down:
    cmp byte [mode], 4
    je alien_disappears
    jmp try_move_up

  try_move_up:
    cmp byte [esi + 4], 1
    je not_possible_up
    MOVE_UP esi
    jmp continue5
    not_possible_up:
    jmp try_move_down

  try_move_right:
    cmp byte [esi + 5], 77
    je not_possible_right
    MOVE_RIGHT esi
    jmp continue5
    not_possible_right:
    jmp try_move_down

  try_move_left:
    cmp byte [esi + 5], 2
    je not_possible_left
    MOVE_LEFT esi
    jmp continue5
    not_possible_left:
    jmp try_move_down

  alien_disappears:
    mov [esi + 6], byte 1
    dec dword [living_aliens]
    cmp dword [points + 4], 100
    jb not_enough_points
    sub dword [points + 4], 100
    jmp continue5
    not_enough_points:
    mov [points + 4], dword 0
    jmp continue5





;alien_shooting(esp + 4: pos of the alien who shot)
;returns the memory direction of the alien
alien_shooting:
  mov ecx, [esp + 4]
  inc ecx
  mov eax, alien
  mov ebx, 0
  ciclo6:
    cmp byte [eax + ebx + 6], 0
    jne continue4
    dec ecx
    continue4:
    add ebx, 12
    cmp ecx, 0
    ja ciclo6
  sub ebx, 12
  add eax, ebx
  ret


;this method tells the aliens where to shoot in space_shooter mode
intelligent_aliens:
  xor ebx, ebx
  mov bl, [alien_shots_amount]
  xor edx, edx
  mov dl, [ship + 4]
  cmp [eax + 4], dl
  ja shoot_up
  jb shoot_down
  xor edx, edx
  mov dl, [ship + 5]
  cmp [eax + 5], dl
  ja shoot_left
  jmp shoot_right
  .end:
  xor ebx, ebx
  xor edx, edx
  jmp intelligent_aliens_ret

  shoot_up:
  CREATE_SHOT ebx, alien_shots, dword 1, eax
  jmp intelligent_aliens.end

  shoot_down:
  CREATE_SHOT ebx, alien_shots, dword 0, eax
  jmp intelligent_aliens.end

  shoot_right:
  CREATE_SHOT ebx, alien_shots, dword 4, eax
  jmp intelligent_aliens.end

  shoot_left:
  CREATE_SHOT ebx, alien_shots, dword 5, eax
  jmp intelligent_aliens.end





;this function is only called when our ship was the one who shot
the_ship_shot:
  cmp byte [ship + 6], 0
  je .end
  xor edx, edx
  mov dl, [ship_shots_amount]
  CREATE_SHOT edx, ship_shots, dword 1, ship
  .end:
  ret

the_ship_shot_down:
  cmp byte [ship + 6], 0
  je .end
  xor edx, edx
  mov dl, [ship_shots_amount]
  CREATE_SHOT edx, ship_shots, dword 0, ship
  .end:
  ret

the_ship_shot_left:
  cmp byte [ship + 6], 0
  je .end
  xor edx, edx
  mov dl, [ship_shots_amount]
  CREATE_SHOT edx, ship_shots, dword 5, ship
  .end:
  ret

the_ship_shot_right:
  cmp byte [ship + 6], 0
  je .end
  xor edx, edx
  mov dl, [ship_shots_amount]
  CREATE_SHOT edx, ship_shots, dword 4, ship
  .end:
  ret

;this function will only be called in the two_players mode
the_ship2_shot:
  cmp byte [ship2 + 6], 0
  je .end
  xor edx, edx
  mov dl, [ship_shots_amount]
  CREATE_SHOT edx, ship2_shots, dword 1, ship2
  .end:
  ret


;this is for cheating
add_lives:
  cmp byte [ship + 6], 10
  jae .end
  add [ship + 6], byte 3
  .end:
  ret


deactivate:
  mov [lethal_line + 6], byte 1
  jmp deactivate_ret

decide_mode_lives:
  cmp byte [mode], 0 ; easy mode
  je easy_lives
  cmp byte [mode], 1 ; medium mode
  je medium_lives
  cmp byte [mode], 2 ; hard mode
  je hard_lives
  cmp byte [mode], 3 ; crazy aliens mode
  je medium_lives
  cmp byte [mode], 4 ; space_shooter
  je medium_lives
  cmp byte [mode], 5 ; arcade mode
  je medium_lives
  cmp byte [mode], 6 ; two players mode
  je two_players_lives
  cmp byte [mode], 7 ; mirror mode
  je two_players_lives
  .end:
  ret

  easy_lives:
  mov [ship + 6], byte 5
  mov [ship2 + 6], byte 0
  jmp decide_mode_lives.end

  medium_lives:
  mov [ship + 6], byte 3
  mov [ship2 + 6], byte 0
  jmp decide_mode_lives.end

  hard_lives:
  mov [ship + 6], byte 1
  mov [ship2 + 6], byte 0
  jmp decide_mode_lives.end

  two_players_lives:
  mov [ship + 6], byte 3
  mov [ship2 + 6], byte 3


decide_aliens_velocity:
  cmp byte [mode], 0 ; easy mode
  je easy_velocity
  cmp byte [mode], 1 ; medium mode
  je medium_velocity
  cmp byte [mode], 2 ; hard mode
  je hard_velocity
  cmp byte [mode], 3 ; crazy aliens mode
  je medium_velocity
  cmp byte [mode], 4 ; space_shooter
  je easy_velocity
  cmp byte [mode], 5 ; arcade mode
  je easy_velocity
  cmp byte [mode], 6 ; two players mode
  je hard_velocity
  cmp byte [mode], 7 ; mirror mode
  je hard_velocity
  .end:
  ret

  easy_velocity:
  mov eax, 250
  jmp decide_aliens_velocity.end

  medium_velocity:
  mov eax, 250
  cmp dword [living_aliens], 20
  ja .continue
  mov eax, 100
  cmp dword [living_aliens], 8
  ja .continue
  mov eax, 50
  cmp dword [living_aliens], 3
  ja .continue
  mov eax, 25
  .continue:
  jmp decide_aliens_velocity.end

  hard_velocity:
  mov eax, 50
  cmp dword [living_aliens], 8
  ja .continue
  mov eax, 25
  .continue:
  jmp decide_aliens_velocity.end


timer_for_shooting:
  cmp byte [mode], 0 ; easy mode
  je easy_shot
  cmp byte [mode], 1 ; medium mode
  je easy_shot
  cmp byte [mode], 2 ; hard mode
  je hard_shot
  cmp byte [mode], 3 ; crazy aliens mode
  je hard_shot
  cmp byte [mode], 4 ; space_shooter
  je arcade_shot
  cmp byte [mode], 5 ; arcade mode
  je arcade_shot
  cmp byte [mode], 6 ; two players mode
  je hard_shot
  cmp byte [mode], 7 ; mirror mode
  je hard_shot
  .end:
  ret

  easy_shot:
  mov eax, 1000
  jmp timer_for_shooting.end

  hard_shot:
  mov eax, [random]
  inc eax; just in case random is 0
  shl eax, 7
  jmp timer_for_shooting.end

  arcade_shot:
  mov eax, 500
  jmp timer_for_shooting.end



infinite_move:
 cmp byte [mode], 5
 je infinite_mode
 cmp byte [mode], 4
 je infinite_mode
 .end:
 ret

 infinite_mode:
 cmp eax, 0
 jne generate_aliens
 generate_aliens_ret:
 jmp infinite_move.end



random_dropping:
  rdtsc
  xor edx, edx
  mov ebx, 1000
  div ebx
  ;mov edx, 34
  cmp edx, 10
  jb drop_it
  drop_it_end:
  mov [drop_box], byte 0
  jmp random_dropping_end


drop_it:
  push dword surprise_box
  call create_box
  add esp, 4
  jmp drop_it_end

move_box:
  MOVE_BOX surprise_box
  jmp move_box_end


check_status:
  cmp byte [surprise_box + 6], 1
  jne check_end
  mov byte [drop_box], 1
  jmp check_end


generate_weapon:
  mov byte [box_destroyed], 0 ;restore bool to false
  rdtsc
  xor edx, edx
  xor ebx, ebx
  mov bl, [weapons_amount]
  div ebx
  xor eax, eax
  mov eax, edx
  mov edx, 4
  mul edx
  mov ecx, [special_weapons + eax]
  mov [current_weapon], ecx
  mov [bool_current], byte 1
  xor eax, eax
  xor ebx, ebx
  xor ecx, ecx
  xor edx, edx
  jmp generate_weapon_end

use_weapon:
  cmp byte [bool_current], 0
  je not_used
  mov eax, [current_weapon]
  CREATE_ESPECIAL_SHOTS eax, [eax + 8]
  mov [bool_current], byte 0
  not_used:
  ret


enter_game:
  mov [game_start], byte 1
  ret

restart_game:
 mov [game_start], byte 0
 ret

name_taked:
  mov eax, [name]
  mov [new_puntation], eax

  mov eax, [points + 4]
  mov [new_puntation + 4], eax

  ADD_PUNCTUATION new_puntation, punctuation
  mov [game_start], byte 0
  ret

make_pause:
  mov [game_start], byte 11
  ret

exit_puntation:
  mov [game_start], byte 10
  ret

exit_pause:
  mov [game_start], byte 20
  ret

get_input_puntation_screen:
  call scan
  push ax
  bind KEY.ENTER, exit_puntation
  add esp, 2
  ret

get_input_game_over_screen:
  call scan
  push ax
  TAKE_NAME name, ax

  bind KEY.ENTER,name_taked
  add esp, 2
  ret

get_input_pause_screen:
  call scan
  push ax
  bind_move KEY.UP, MOVE_UP_CARTEL, index
  bind_move KEY.DOWN, MOVE_DOWN_CARTEL, index
  bind KEY.ENTER, exit_pause
  add esp, 2
  ret

get_input_first_screen:
  call scan
  push ax

  bind_move KEY.UP, MOVE_UP_CARTEL, index
  bind_move KEY.DOWN, MOVE_DOWN_CARTEL, index
  bind KEY.ENTER, enter_game
  add esp, 2

  ret

get_input:
    call scan
    push ax
    ; The value of the input is on 'word [esp]'
    ; Your bindings here

    bind KEY.Esc, make_pause
    ; bind_move KEY.UP, MOVE_UP, ship
    ; bind_move KEY.DOWN, MOVE_DOWN, ship
    bind_move KEY.RIGHT, MOVE_RIGHT, ship
    bind_move KEY.LEFT, MOVE_LEFT, ship

    cmp byte [mode], 7
    jne not_mirror_mode
    ;bind_move KEY.UP, MOVE_UP, ship2
    ;bind_move KEY.DOWN, MOVE_DOWN, ship2
    bind_move KEY.RIGHT, MOVE_LEFT, ship2
    bind_move KEY.LEFT, MOVE_RIGHT, ship2

    bind KEY.Spc, the_ship2_shot

    not_mirror_mode:

    cmp byte [mode], 4
    jne not_space_shooter_mode
    bind_move KEY.UP, MOVE_UP, ship
    bind_move KEY.DOWN, MOVE_DOWN, ship
    bind KEY.W, the_ship_shot
    bind KEY.S, the_ship_shot_down
    bind KEY.D, the_ship_shot_right
    bind KEY.A, the_ship_shot_left
    jmp it_was_ss_mode


    not_space_shooter_mode:
    bind KEY.Spc, the_ship_shot

    it_was_ss_mode:
    bind KEY.Q, use_weapon
    bind KEY.1, add_lives

    cmp byte [mode], 6
    jne not_two_players_mode

    ;this will only happen if it is two_players mode
    ;bind_move KEY.W, MOVE_UP, ship2
    ;bind_move KEY.S, MOVE_DOWN, ship2
    bind_move KEY.D, MOVE_RIGHT, ship2
    bind_move KEY.A, MOVE_LEFT, ship2

    bind KEY.E, the_ship2_shot

    not_two_players_mode:

    add esp, 2 ; free the stack

    ret
