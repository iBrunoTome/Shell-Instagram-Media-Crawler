# Shell-Instagram-Media-Crawler

Implementação de um crawler de mídias no Instagram. Trabalho realizado no 8º período de Ciência da Computação no Instituto Federal de Minas Gerais (IFMG) - Campus Formiga para a disciplina de Desenvolvimento Rápido em Linux.

## Objetivo
Realizar um curl de um perfil público no Instagram e salvar todas mídias publicadas deste perfil.

## Utilizando as ferramentas
	- curl
	- wget
	- awk
	- sed
	- mkdir
	- mv
	- API pública do Instagram
	
## Modo de uso
Rode o script ./crawler com as seguintes opções
- Nenhum parâmetro: será requisitado o nome de usuário no Instagram e a quantidade de mídias para que o download das imagens se inicie.
- Primeiro parâmetro: Seu nome de usuário no Instagram.
- Segundo parâmetro: Quantidade de mídias para baixar, se não for passado, baixará todas as mídias.
