# Menu String - NASM 32 bits Linux

Este repositório contém um programa em **Assembly (NASM 32 bits para Linux)** que implementa um menu interativo de manipulação de strings. O usuário pode realizar várias operações em strings, como inverter, verificar palíndromos, contar palavras e aplicar a cifra de César.

---

## Funcionalidades

O programa apresenta um menu principal com as seguintes opções:

1. **Inverter String**
   Inverte a string digitada pelo usuário e exibe o resultado.

2. **Verificar Palíndromo**
   Verifica se a string digitada é um palíndromo (desconsiderando maiúsculas e minúsculas) e informa ao usuário.

3. **Contar Palavras**
   Conta o número de palavras na string fornecida (palavras separadas por espaços).

4. **Criptografar (Cifra de César)**
   Aplica a cifra de César (+3) na string digitada, mantendo letras maiúsculas e minúsculas.

5. **Descriptografar (Cifra de César)**
   Desfaz a cifra de César (-3).

6. **Sair**
   Encerra o programa.

---

## Requisitos

* Linux (x86, 32 bits)
* NASM instalado
* Terminal com suporte a chamadas de sistema 32 bits

---

## Como Compilar

```bash
nasm -f elf32 menu_string.asm -o menu_string.o
ld -m elf_i386 menu_string.o -o menu_string
```

---

## Como Executar

```bash
./menu_string
```

Após a execução, o menu será exibido. O usuário deve digitar a opção desejada e, quando solicitado, a string a ser manipulada.

**Observação:** Cada operação retorna ao menu principal após sua execução.

---

## Estrutura do Código

* **.data**: Contém mensagens do menu, mensagens de saída e strings fixas.
* **.bss**: Buffer de entrada e variáveis temporárias.
* **.text**: Contém todas as rotinas e o fluxo principal (`_start`).
* **Sub-rotinas**:

  * `get_string`: Lê a string do usuário.
  * `opcao_inverter`: Inverte a string.
  * `opcao_palindromo`: Verifica palíndromo.
  * `opcao_contar`: Conta palavras.
  * `opcao_criptografar`: Aplica cifra de César.
  * `opcao_descriptografar`: Desfaz cifra de César.
  * `opcao_sair`: Encerra o programa.
  * `lower_case`: Converte letras para minúsculas temporariamente.

---

## Observações

* O programa trabalha com strings de até **255 caracteres**.
* A contagem de palavras considera apenas espaços como separadores.
* O programa utiliza chamadas de sistema Linux (`int 0x80`) e não depende de bibliotecas externas.
* Foi desenvolvido e testado em **NASM 32 bits** no Linux.
