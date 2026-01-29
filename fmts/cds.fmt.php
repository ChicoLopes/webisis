<div class="campos">
  <!-- Grupo de dados de titulo edição -->
  <fieldset><legend>Titulo / Edição</legend>
    <div class="w50">
      <div class="dummy">
        <div class="eLegM">
          <label for=v024>Título [024]: </label>
        </div><!-- eLegM -->
        <div class="eSelm"> <!-- entrada de dados monovalorada por partes -->
          <div class="mono-wrapper" data-var="v024" data-prefixo="total">
            <div class="mono-wrapper-l">
              <p class="leg-part">título:</p><p class="leg-part">idioma:</p>
            </div>
            <div class="mono-wrapper-r">
              <input type="text" class="part" data-prefixo="" placeholder="Título" />
              <input type="text" class="part" data-prefixo="^z" placeholder="sub-z" />
            </div> <!-- mono-wrapper-r -->
            <div class="clear"></div>
          </div> <!-- mono-wrapper -->
          <input type="hidden" name="v024" id="v024" value="<?php echo $v024; ?>" />
        </div><!-- eSelm -->
        <div class="clear"></div>
      </div><!-- dummy -->
      <div class="dummy">
        <div class="eLegM">
          <label for=v026>Imprenta [026]: </label>
        </div><!-- eLegM -->
        <div class="eSelm"> <!-- entrada de dados monovalorada por partes -->
          <div class="mono-wrapper" data-var="v026" data-prefixo="total">
            <div class="mono-wrapper-l">
              <p class="leg-part">cidade:</p><p class="leg-part">editora:</p><p class="leg-part">ano:</p>
            </div>
            <div class="mono-wrapper-r">
              <input type="text" class="part" data-prefixo="^a" placeholder="sub-a" />
              <input type="text" class="part" data-prefixo="^b" placeholder="sub-b" />
              <input type="text" class="part" data-prefixo="^c" placeholder="sub-c" />
            </div> <!-- mono-wrapper-r -->
            <div class="clear"></div>
          </div> <!-- mono-wrapper -->
          <input type="hidden" name="v026" id="v026" value="<?php echo $v026; ?>" />
        </div><!-- eSelm -->
        <div class="clear"></div>
      </div><!-- dummy -->
      <div class="dummy">
        <div class="eLegM">
          <label for=v030>Chamada [030]: </label>
        </div><!-- eLegM -->
        <div class="eSelM">
          <div class="mono-wrapper" data-var="v030" data-prefixo="total">
            <div class="mono-wrapper-l">
              <p class="leg-part">pág:</p><p class="leg-part">inf. descr:</p><p class="leg-part">tamanho:</p>
            </div> <!-- mono-wrapper-l -->
            <div class="mono-wrapper-r">
              <input type="text" class="part" data-prefixo="^a" placeholder="sub-a" />
              <input type="text" class="part" data-prefixo="^b" placeholder="sub-b" />
              <input type="text" class="part" data-prefixo="^c" placeholder="sub-c" />
            </div> <!-- mono-wrapper-r -->
          </div> <!-- mono-wrapper -->
          <input type="hidden" name="v030" id="v030" value="<?php echo $v030; ?>" />
        </div><!-- eSelM -->
        <div class="clear"></div>
      </div><!-- dummy -->
      <div class="clear"></div>
      <div class="dummy">
        <div class="eLegM">
          <label for=v069>Palavras chave [069]: </label>
        </div><!-- eLegM -->
        <div class="eSelM">
          <input type="text" name="v069" id="v069" value="<?php echo $v069; ?>" placeholder="Palavras chave separadas por ; ">
        </div><!-- eSelM -->
        <div class="clear"></div>
      </div><!-- dummy -->
    </div><!-- w50 -->
    <div class="w50">
      <div class="dummy">
        <div class="eLegM">
          <label for=v012>Conferência (main entry) [012]: </label>
        </div><!-- eLegM -->
        <div class="eSelM">
          <div class="mono-wrapper" data-var="v012" data-prefixo="parcial">
            <div class="mono-wrapper-l">
              <p class="leg-part">nome:</p>
              <p class="leg-part">núm.:</p>
              <p class="leg-part">país:</p>
              <p class="leg-part">data:</p>
              <p class="leg-part">idioma:</p>
            </div> <!-- mono-wrapper-l -->
            <div class="mono-wrapper-r">
              <input type="text" class="part" data-prefixo="" placeholder="Nome" />
              <input type="text" class="part" data-prefixo="^n" placeholder="sub-n" />
              <input type="text" class="part" data-prefixo="^p" placeholder="sub-p" />
              <input type="text" class="part" data-prefixo="^d" placeholder="sub-d" />
              <input type="text" class="part" data-prefixo="^z" placeholder="sub-z" />
            </div> <!-- mono-wrapper-l -->
          </div> <!-- mono-wrapper -->
          <input type="hidden" name="v012" id="v012" value="<?php echo $v012; ?>" />
        </div><!-- eLegM -->
        <div class="clear"></div>
      </div><!-- dummy -->
      <div class="dummy">
        <div class="eLegM">
          <label for=v025>Edição [025]: </label>
        </div><!-- eLegM -->	
        <div class="eSelM">
          <input type="text" name="v025" id="v025" value="<?php echo $v025; ?>" placeholder="Insira a edição">
        </div><!-- eSelM -->
        <div class="clear"></div>
      </div><!-- dummy -->
      <div class="dummy">
        <div class="eLegM">
          <label for=v050>Notas [050]: </label>
        </div><!-- eLegM -->
        <div class="eSelM">
          <input type="text" name="v050" id="v050" value="<?php echo $v050; ?>" placeholder="Insira a nota">
        </div><!-- eSelM -->
        <div class="clear"></div>
      </div><!-- dummy -->
    </div><!-- w50 -->
    <div class="clear"></div>
  </fieldset><!-- Suporte -->
  <!-- Grupo de dados de autoria -->
  <fieldset><legend>Autoria</legend>
    <div class="dummy">
      <div class="eLegP">
        <label for=v070>Autor(es) [070]: </label>
      </div><!-- eLegP -->
      <div class="eSelG">
        <textarea class="curto" name="v070" id="v070" placeholder="None do autor (um por linha)"><?php echo $v070; ?></textarea>
      </div><!-- eSelG -->
      <div class="clear"></div>
    </div><!-- dummy -->
    <div class="dummy">
      <div class="eLegP">
        <label for="v044">Série [v044]:<br>(título | volume | idioma)&nbsp;</label>
      </div><!-- eLegP -->
      <div class="eSelG">
        <textarea class="parted-textarea" data-var="v044" data-prefixo="parcial" data-prefixos=",^v,^z" placeholder="Linha por linha, partes separadas por |"></textarea>
        <textarea name="v044" id="v044" hidden><?php echo $v044; ?></textarea>
      </div><!-- eSelG -->
      <div class="clear"></div>
    </div><!-- dummy -->
    <div class="dummy">
      <div class="eLegP">
        <label for=v071>Órgãos Corporativos [071]: </label>
      </div><!-- eLegP -->
      <div class="eSelG">
        <textarea class="curto" name="v071" id="v071" placeholder="Um por linha"><?php echo $v071; ?></textarea>
      </div><!-- eSelG -->
      <div class="clear"></div>
    </div><!-- dummy -->
    <div class="dummy">
      <div class="eLegP">
        <label for=v072>Encontros [072]:<br>
(título | número | país | data ISO | idioma)&nbsp;</label>
      </div><!-- eLegP -->
      <div class="eSelG">
        <textarea class="parted-textarea" data-var="v072" data-prefixo="parcial" data-prefixos=",^n,^p,^d,^z" placeholder="Partes separadas por |"></textarea>
        <textarea name="v072" id="v072" hidden><?php echo $v072; ?></textarea>
      </div><!-- eSelG -->
      <div class="clear"></div>
    </div><!-- dummy -->
    <div class="dummy">
      <div class="eLegP">
        <label for=v074>Título(s) Adicionado(s) [v074]:<br>(título | idioma)&nbsp;</label>
      </div><!-- eLegP -->
      <div class="eSelG">
        <textarea class="parted-textarea" data-var="v074" data-prefixo="parcial" data-prefixos=",^z" placeholder="Partes separadas por |"></textarea>
        <textarea name="v074" id="v074" hidden><?php echo $v074; ?></textarea>
      </div><!-- eSelG -->
      <div class="clear"></div>
    </div><!-- dummy -->
    <div class="dummy">
      <div class="eLegP">
        <label for=v076>Título (outros idiomas) [v076]:<br>(título | idioma)&nbsp;</label>
      </div><!-- eLegP -->
      <div class="eSelG">
        <textarea class="parted-textarea" data-var="v076" data-prefixo="parcial" data-prefixos=",^z" placeholder="Partes separadas por |"></textarea>
        <textarea name="v076" id="v076" hidden><?php echo $v076; ?></textarea>
      </div><!-- eSelG -->
      <div class="clear"></div>
    </div><!-- dummy -->
    <div class="clear"></div>
  </fieldset><!-- Dados Individuais -->
  <!-- Grupo de dados de administração -->
  <fieldset><legend>Administração de dados</legend>
    <div class="w50">
      <div class="dummy">
        <div class="eLegM">
          <label for=v610>Data de publicação [610]: </label>
        </div><!-- eLegM -->
        <div class="eSelM">
          <input type="date" name="v610" id="v610" placeholder="dd/mm/yyyy" value="<?php echo substr($v610,0,10); ?>" />
        </div><!-- eSelM -->
        <div class="clear"></div>
      </div><!-- dummy -->
    </div><!-- w50 -->
  </fieldset><!-- Administração de dados -->
  <?php
    // Tratamento para os campos administrativos automáticos
    /*
    Formato padrão seria data ISO Y-m-d\TH:i:sP -> 2020-08-01T17:10:58-03:00
    Usaremos no Centro de Memoria da Casa Melhoramentos o formato Y-m-d -> 2020-08-21

    v610 tem conteúdo o registro está aprovado se não tem v612 preenche-o com o v610
    v611 já tem conteúdo adiciona ocorrencia em v613
    v616 tem conteúdo ok se não tem coloca $basename
    v617 tem conteúdo ok se não tem coloca ENTGESTORA (CMEMORIA)
    v611 sem conteúdo o registro está em criação usa curr_date ou v610 o mais anterior
    */
    if ($v610 != '' and $v612 == '') { $v612 = $v610; }
    if ($v611 != '') { $v613 .= "\n" . date('Y-m-d') . "^n$usuario"; }
    if ($v616 == '') { $v616 = $basename; }
    if ($v617 == '') { $v617 = "CMEMORIA"; }
    if ($v611 == '') { if ($v610 != '') { $v611 = $v610; } else { $v611 = date('Y-m-d') . "^n$usuario"; } }
  ?>
  <input type="hidden" name="v611" id="v611" value="<?php echo $v611; ?>" /><!-- DT Cadas -->
  <input type="hidden" name="v612" id="v612" value="<?php echo $v612; ?>" /><!-- DT Aprov -->
  <input type="hidden" name="v613" id="v613" value="<?php echo $v613; ?>" /><!-- DT Alter -->
  <input type="hidden" name="v614" id="v614" value="<?php echo $v614; ?>" /><!-- DT Proib -->
  <input type="hidden" name="v615" id="v615" value="<?php echo $v615; ?>" /><!-- DT Audit -->
  <input type="hidden" name="v616" id="v616" value="<?php echo $v616; ?>" /><!-- BS Origi -->
  <input type="hidden" name="v617" id="v617" value="<?php echo $v617; ?>" /><!-- Ent Gest -->
</div><!-- campos -->
