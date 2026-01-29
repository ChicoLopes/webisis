1 0 (if v1>'' then 'NOVA ORTOGRAFIA' fi/)	/* Acordo ortografico de 2010 */

50 4 (v50^*/)								/* Autoria */
50 0 (mhu,|-|V50/,mpl)

51 4 (v51^*/)								/* Adaptador */
51 0 (mhu,|-|v51^*/,mpl)

70 4 (v70^*/)								/* Ilustrador */
70 0 (mhu,|-|v70^*/,mpl)

71 4 (v71^*/)								/* Fotografo */
71 0 (mhu,|-|v71^*/,mpl)

30 4 (v30^*/)								/* Tradutor */
30 0 (v30^*/)

60 4 (v60^*/)								/* Titulo */
60 0 (mhu,|-|v60^*/,mpl)

200 4 (v200^*/)								/* Titulo Original */
200 0 (v200^*/)

210 0 (v210^e/)                             /* Editora Original */
210 4 (v210^e/)

120 0 v120									/* ANO de lancamento */
121 0 if v220^e>'' then (if v220^f='' then 'ED.'v220^e,' ',v220^d else if v220^f='1' then 'ED.',v220^e,' ',v220^d fi fi/)fi	/* DT LCTO de Edicao */


220 0 (v220^d/)								/* Data de impressao */
230 0 (v230^l/)                             /* Local impressao */

190 0 (v190^*/)								/* ISBN-10 */
196 0 (v196^*/)								/* ISBN-13 */
20  0 (v20^*/)                              	/* Codigo (Localizacao) */
10  0 (v10^*/)                              	/* Tombo */

242 0 (v242^*/)								/* STATUS */
240 0 (v240^*/)								/* Cat. Infantil */
241 0 (v241^*/)								/* Cat. Juvenil  */

40 0 (v40^*/)								/* SERIE */
41 0 (v41^*/)								/* Linha editorial */

171 0 (v171^*/)								/* Indicacoes */
244 0 (v244^*/)                             /* Inscritos  */
173 0 (v173^*/)								/* Premiacoes */

90 0 (v90^*/)                               /* Assunto - CDD adaptada */
