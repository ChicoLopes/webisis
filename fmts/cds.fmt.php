				<div class="campos">
					<!-- Grupo de dados de titulo edição -->
					<fieldset><legend>Titulo / Edição</legend>
						<div class="w50">
							<div class="dummy">
								<div class="eLegM">
									<label for=v024>Título [024]: </label>
								</div><!-- eLeg -->
								<div class="eSelM">
									<input type="text" name="v024" id="v024" value="<?php echo $v024; ?>" placeholder="sub-z">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="dummy">
								<div class="eLegM">
									<label for=v026>Imprenta [026]: </label>
								</div><!-- eLeg -->
								<div class="eSelM">
									<input type="text" name="v026" id="v026" value="<?php echo $v026; ?>" placeholder="sub-a b c">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="dummy">
								<div class="eLegM">
									<label for=v030>Chamada [030]: </label>
								</div><!-- eLeg -->
								<div class="eSelM">
									<input type="text" name="v030" id="v030" value="<?php echo $v030; ?>" placeholder="Núm Chamada - sub-a b c">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="clear"></div>
							<div class="dummy">
								<div class="eLegM">
									<label for=v069>Palavras chave [069]: </label>
								</div><!-- eLeg -->
								<div class="eSelM">
									<input type="text" name="v069" id="v069" value="<?php echo $v069; ?>" placeholder="Palavras chave separadas por ; ">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
						</div><!-- w50 -->
						<div class="w50">
							<div class="dummy">
								<div class="eLegM">
									<label for=v012>Conferência (main entry) [012]: </label>
								</div><!-- eLeg -->
								<div class="eSelM">
									<input type="text" name="v012" id="v012" value="<?php echo $v012; ?>" placeholder="Nome da conferência - sub-npdz">
								</div><!-- eLeg -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="dummy">
								<div class="eLegM">
									<label for=v025>Edição [025]: </label>
								</div><!-- eLeg -->	
								<div class="eSelM">
									<input type="text" name="v025" id="v025" value="<?php echo $v025; ?>" placeholder="Insira a edição">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="dummy">
								<div class="eLegM">
									<label for=v050>Notas [050]: </label>
								</div><!-- eLeg -->
								<div class="eSelM">
									<input type="text" name="v050" id="v050" value="<?php echo $v050; ?>" placeholder="Insira a nota">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
						</div><!-- w50 -->
						<div class="clear"></div>
					</fieldset><!-- Suporte -->
					<!-- Grupo de dados de iutoria -->
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
								<label for=v044>Série [044]: </label>
							</div><!-- eLegP -->
							<div class="eSelG">
								<textarea class="curto" name="v044" id="v044" placeholder="None do série (uma por linha) - sub-v z"><?php echo $v044; ?></textarea>
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
								<label for=v072>Encontros [072]: </label>
							</div><!-- eLegP -->
							<div class="eSelG">
								<textarea class="curto" name="v072" id="v072" placeholder="None dos encontros (um por linha) - sub-n p d z"><?php echo $v072; ?></textarea>
							</div><!-- eSelG -->
							<div class="clear"></div>
						</div><!-- dummy -->
						<div class="dummy">
							<div class="eLegP">
								<label for=v074>Título(s) adicionado(s) [074]: </label>
							</div><!-- eLegP -->
							<div class="eSelG">
								<textarea class="curto" name="v074" id="v074" placeholder="Título adicionado (um por linha) - sub-z"><?php echo $v074; ?></textarea>
							</div><!-- eSelG -->
							<div class="clear"></div>
						</div><!-- dummy -->
						<div class="dummy">
							<div class="eLegP">
								<label for=v076>Título (outros idiomas) [076]: </label>
							</div><!-- eLegP -->
							<div class="eSelG">
								<textarea class="curto" name="v076" id="v076" placeholder="Título em outro idioma (uma por linha) - sub-z"><?php echo $v076; ?></textarea>
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
								</div><!-- eLeg -->
								<div class="eSelM">
						<input type="date" name="v610" id="v610" placeholder="dd/mm/yyyy" value="<?php echo substr($v610,0,10); ?>" />
								</div><!-- eSel -->
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

