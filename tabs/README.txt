Para serem usados tanto no modo de apresentação como para inversão das bases

Tabelas de UPPER CASE e ASCII Valido

-ASCII CODE PAGE 437 (CP437)
ac437.tab Caracteres válidos do conjunto ASCII CP437
ac437n.tab Caracteres válidos do conjunto ASCII CP437 incl. 0-9
ac437XT.tab Caracteres válidos do conjunto ASCII CP437 incl. 0-9 e #&'-./:=?@_~
ac437UT.tab Caracteres válidos do conjunto ASCII CP437 incl. 0-9 e !#&',-./:;<=>?@\_`{}~
ma437.tab Conversão dos caracteres para maiúsculas (com acento)
mi437.tab Conversão dos caracteres para minúsculas (com acento)
na437.tab Elimina acentos dos caracteres, mantendo maiúsculas/minúsculas
uc437.tab Conversão dos caracteres para maiúsculas (sem acentos)
lc437.tab Conversão dos caracteres para minúsculas (sem acentos)

-ASCII CODE PAGE 850 (CP850)
ac850.tab Caracteres válidos do conjunto ASCII CP850
ac850n.tab Caracteres válidos do conjunto ASCII CP850 incl. 0-9
ac850XT.tab Caracteres válidos do conjunto ASCII CP850 incl. 0-9 e #&'-./:=?@_~
ac850UT.tab Caracteres válidos do conjunto ASCII CP850 incl. 0-9 e !#&',-./:;<=>?@\_`{}~¿¡
ma850.tab Conversão dos caracteres para maiúsculas (com acento)
mi850.tab Conversão dos caracteres para minúsculas (com acento)
na850.tab Elimina acentos dos caracteres, mantendo maiúsculas/minúsculas
uc850.tab Conversão dos caracteres para maiúsculas (sem acentos)
lc850.tab Conversão dos caracteres para minúsculas (sem acentos)

-ANSI (Windows)
acans.tab Caracteres válidos do conjunto ANSI
acansn.tab Caracteres válidos do conjunto ANSI incl. 0-9
acansXT.tab Caracteres válidos do conjunto ANSI incl. 0-9 e #&'-./:=?@_~
acansUT.tab Caracteres válidos do conjunto ANSI incl. 0-9 e !#&',-./:;<=>?@\_`{}~¿¡
maans.tab Conversão dos caracteres para maiúsculas (com acento)
mians.tab Conversão dos caracteres para minúsculas (com acento)
naans.tab Elimina acentos dos caracteres, mantendo maúsculas/minúsculas
ucans.tab Conversão dos caracteres para maiúsculas (sem acentos)
lcans.tab Conversão dos caracteres para minúsculas (sem acentos)

Toda e qualquer tabela tem 32 elementos de largura com um espaço de separação
Todas as linhas devem ser temrinadas por CR+LF (DOS) ou LF (Unix/Linux)


GIZMOs disponíveis para conversão do conteúdo de bases de dados

-Conversão do conjunto de caracteres
g437ans  Conversão de ASCII CODE PAGE 437 para ANSI
gans437  Conversão de ANSI para ASCII CODE PAGE 437
g850ans  Conversão de ASCII CODE PAGE 850 para ANSI
gans850  Conversão de ANSI para ASCII CODE PAGE 850
gutf8850 Conversao de UTF-8 para ASCII CODE PAGE 850
gutf8ans Conversão de UTF-8 para ANSI
g437utf8 Conversao de ASCII CODE PAGE 437 para UTF-8
g850utf8 Conversao de ASCII CODE PAGE 850 para UTF-8
gansutf8 Conversão de ANSI para UFT-8

-ASCII CODE PAGE 437 (CP437)
g437ma Conversão para maiúsculas acentuadas
g437mi Conversão para minúsculas acentuadas
g437na Retira acentos mantendo maiúsculas/minúsculas
g437uc Conversão para maiúsculas sem acento (Upper case)
g437lc Conversão para minúsculas sem acento (Lower case)

-ASCII CODE PAGE 850 (CP850)
g850ma Conversão para maiúsculas acentuadas
g850mi Conversão para minúsculas acentuadas
g850na Retira acentos mantendo maiúsculas/minúsculas
g850uc Conversão para maiúsculas sem acento (Upper case)
g850lc Conversão para minúsculas sem acento (Lower case)

-ANSI (Windows)
gansma Conversão para maiúsculas acentuadas
gansmi Conversão para minúsculas acentuadas
gansna Retira acentos mantendo maiúsculas/minúsculas
gansuc Conversão para maiúsculas sem acento (Upper case)
ganslc Conversão para minúsculas sem acento (Lower case)

-Conversão auxiliar de caracteres de marcação
gentit Conversão de caracteres pela entidade HTML correspondente ("&'<>)
gchar Conversão para a entidade HTML pelos caracteres correspondentes ("&'<>)

-Conversão auxiliar de e para entidades HTML
ghtmlans Converte entidades HTML em caracteres ANSI
ganshtml Converte caracteres ANSI em entidades HTML
ghtml850 Converte entidades HTML em caracteres ASCII CP850
g850html Converte caracteres ASCII CP850 em entidades HTML
ghtml437 Converte entidades HTML em caracteres ASCII CP437
g437html Converte caracteres ASCII CP437 em entidades HTML


Nas bases gizmo o campo 59 do primeiro registro define a versão do gizmo

Os campos tem as seguintes funções:
001 | Codicação do caractere procurado
002 | Codificação do caractere substituto
011 | especificacao do codigo do campo 1 (asc / hex / ...)
021 | especificacao do codigo do campo 2 (asc / hex / ...)
041 | entidade html numerica da representação do caractere
042 | entidade html textual da representação do caractere
050 | Comentário sobre o elemento sendo operado neste registro
051 | Comentário sobre o elemento sendo operado neste registro (normalmente em portugues)
052 | Comentário sobre o elemento sendo operado neste registro (normalmente em ingles)
059 | Indicador de versão


Como reconhecer o conjunto de caracteres em que está uma base CDS/ISIS
-Se na distribuição de caracteres oferecida pelo MXF0 houver AUSENCIA de caracteres
com códigos entre 127(0x7f) e 159(0x9f) (inclusive), então pertencem ao conjunto ANSI.
-Se na distribuição de caracteres oferecida pelo MXF0 houver uma forte concentração
entre os códigos 128(0x80) até 167(0xa7) (inclusive) é muito provável que seja Code Page 437.
-Se na distribuição de caracteres oferecida pelo MXF0 houver presença de elementos em
algum dos seguintes códigos: 181(0xb5), 182, 183, 198, 199, 210, 211, 212, 214, 215, 216,
222, 224, 226, 227, 228, 229, 233, 234, 235, 236, 237 é muito provável que seja Code Page 850.

É importante a presença como caracteres discriminadores do código de página: o
198(0xc6) e 199(0xc6), que são ã e Ã, e também 228(0xe4) e 229(0xe5) que são õ e Õ.
! Os caracteres 198 e 199 dos conjuntos ANSI e ASCII
850 são imprimíveis, sendo Æ (AElig) e Ç em ANSI
e ã e Ã em ASC850, além destes 228 e 229 também
são imprimíveis, sendo ä e å (Aring) em ANSI e õ e Õ em ASCII-850.

Elemento de complicação: Windows 95 e 98 utilizam codificação diferente de
Windows 98SE e posteriores.
OBSERVAÇÕES
Os gizmos de conversão entre os conjuntos de caracteres: ANSI; ASCII CP437; e ASCII CP850,
têm como objetivo obter caracteres gráficos similares.
Os gizmos de CONVERSÃO AUXILIAR abrangem só os caracteres acentuados.
