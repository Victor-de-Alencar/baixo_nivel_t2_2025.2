; menu_string.asm - NASM 32 bits Linux
section .data
menu_msg db 0xA,'=== MENU PRINCIPAL ===',0xA
         db '1. Inverter String',0xA
         db '2. Verificar Palindromo',0xA
         db '3. Contar Palavras',0xA
         db '4. Criptografar (Cifra de Cesar)',0xA
         db '5. Descriptografar (Cifra de Cesar)',0xA
         db '6. Sair',0xA
         db 'Escolha uma opcao: ',0
menu_len equ $ - menu_msg

input_msg db 'Digite uma string (max 255): ',0
input_len equ $ - input_msg

msg_yes db 'A string E um palindromo.',0xA,0
msg_yes_len equ $ - msg_yes

msg_no  db 'A string NAO E um palindromo.',0xA,0
msg_no_len equ $ - msg_no

newline db 0xA,0

section .bss
buffer resb 256
choice resb 2
temp_char resb 1

section .text
global _start

_start:
menu_loop:
    ; Exibe menu
    mov eax,4
    mov ebx,1
    mov ecx,menu_msg
    mov edx,menu_len
    int 0x80

    ; Lê opção
    mov eax,3
    mov ebx,0
    mov ecx,choice
    mov edx,2
    int 0x80

    mov al,[choice]
    cmp al,'1'
    je opcao_inverter
    cmp al,'2'
    je opcao_palindromo
    cmp al,'3'
    je opcao_contar
    cmp al,'4'
    je opcao_criptografar
    cmp al,'5'
    je opcao_descriptografar
    cmp al,'6'
    je opcao_sair

    jmp menu_loop

; ===================== Sub-rotina: ler string =====================
get_string:
    ; Exibe mensagem
    mov eax,4
    mov ebx,1
    mov ecx,input_msg
    mov edx,input_len
    int 0x80

    ; Lê string
    mov eax,3
    mov ebx,0
    mov ecx,buffer
    mov edx,255
    int 0x80
    ret

; ===================== Inverter String =====================
opcao_inverter:
    call get_string
    mov ecx,eax       ; tamanho
    dec ecx           ; remove newline
    mov esi,buffer
    add esi,ecx
    dec esi
print_reverse_loop:
    cmp ecx,0
    je print_reverse_done
    mov al,[esi]
    mov [temp_char],al
    mov eax,4
    mov ebx,1
    mov ecx,temp_char
    mov edx,1
    int 0x80
    dec esi
    dec ecx
    jmp print_reverse_loop
print_reverse_done:
    mov eax,4
    mov ebx,1
    mov ecx,newline
    mov edx,1
    int 0x80
    jmp menu_loop

; ===================== Verificar Palíndromo =====================
opcao_palindromo:
    call get_string
    mov ecx,eax
    dec ecx
    mov esi,buffer
    mov edi,buffer
    add edi,ecx
check_palindrome:
    cmp esi,edi
    jge pal_yes
    mov al,[esi]
    mov bl,[edi]
    call lower_case
    cmp al,bl
    jne pal_no
    inc esi
    dec edi
    jmp check_palindrome
pal_yes:
    mov eax,4
    mov ebx,1
    mov ecx,msg_yes
    mov edx,msg_yes_len
    int 0x80
    jmp menu_loop
pal_no:
    mov eax,4
    mov ebx,1
    mov ecx,msg_no
    mov edx,msg_no_len
    int 0x80
    jmp menu_loop

lower_case:
    cmp al,'A'
    jb skip1
    cmp al,'Z'
    ja skip1
    add al,32
skip1:
    cmp bl,'A'
    jb skip2
    cmp bl,'Z'
    ja skip2
    add bl,32
skip2:
    ret

; ===================== Contar Palavras =====================
opcao_contar:
    call get_string
    mov esi,buffer
    mov ecx,0        ; contador de palavras
    mov edi,0        ; flag espaço
count_loop:
    mov al,[esi]
    cmp al,0xA
    je count_done
    cmp al,' '
    je space_found
    cmp edi,0
    je new_word
    jmp next_char
space_found:
    mov edi,0
    jmp next_char
new_word:
    inc ecx
    mov edi,1
next_char:
    inc esi
    jmp count_loop
count_done:
    ; exibe contagem
    mov eax,4
    mov ebx,1
    mov edx,ecx
    ; suporta até 9 palavras
    add dl,'0'
    mov [temp_char],dl
    mov ecx,temp_char
    mov edx,1
    int 0x80
    mov eax,4
    mov ebx,1
    mov ecx,newline
    mov edx,1
    int 0x80
    jmp menu_loop

; ===================== Criptografar =====================
opcao_criptografar:
    call get_string
    mov esi,buffer
crypt_loop:
    mov al,[esi]
    cmp al,0xA
    je crypt_done
    cmp al,'A'
    jb skip_crypt
    cmp al,'Z'
    ja check_lower
    add al,3
    cmp al,'Z'
    jle skip_crypt
    sub al,26
    jmp skip_crypt
check_lower:
    cmp al,'a'
    jb skip_crypt
    cmp al,'z'
    ja skip_crypt
    add al,3
    cmp al,'z'
    jle skip_crypt
    sub al,26
skip_crypt:
    mov [esi],al
    inc esi
    jmp crypt_loop
crypt_done:
    mov esi,buffer
print_buffer:
    mov al,[esi]
    cmp al,0xA
    je menu_loop
    mov [temp_char],al
    mov eax,4
    mov ebx,1
    mov ecx,temp_char
    mov edx,1
    int 0x80
    inc esi
    jmp print_buffer

; ===================== Descriptografar =====================
opcao_descriptografar:
    call get_string
    mov esi,buffer
decrypt_loop:
    mov al,[esi]
    cmp al,0xA
    je decrypt_done
    cmp al,'A'
    jb skip_decrypt
    cmp al,'Z'
    ja check_lower2
    sub al,3
    cmp al,'A'
    jge skip_decrypt
    add al,26
    jmp skip_decrypt
check_lower2:
    cmp al,'a'
    jb skip_decrypt
    cmp al,'z'
    ja skip_decrypt
    sub al,3
    cmp al,'a'
    jge skip_decrypt
    add al,26
skip_decrypt:
    mov [esi],al
    inc esi
    jmp decrypt_loop
decrypt_done:
    mov esi,buffer
print_buffer_dec:
    mov al,[esi]
    cmp al,0xA
    je menu_loop
    mov [temp_char],al
    mov eax,4
    mov ebx,1
    mov ecx,temp_char
    mov edx,1
    int 0x80
    inc esi
    jmp print_buffer_dec

; ===================== Sair =====================
opcao_sair:
    mov eax,1
    xor ebx,ebx
    int 0x80
