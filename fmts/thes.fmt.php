				<div class="campos">
					<!-- Grupo de dados de titulo edição -->
					<fieldset><legend>Termo</legend>
							<div class="dummy">
								<div class="eLegP">
									<label for=v001>Termo [001]: </label>
								</div><!-- eLeg -->
								<div class="eSelG">
									<input type="text" name="v001" id="v001" value="<?php echo $v001; ?>" placeholder="Termo">
								</div><!-- eSel -->
								<div class="clear"></div>
							</div><!-- dummy -->
					</fieldset><!-- Termo -->
					<fieldset><legend>Substitutos</legend>
						<div class="w50">
							<div class="dummy">
								<div class="eLegP">
									<label for=v002>Use [002]: </label>
								</div><!-- eLegP -->
								<div class="eSelG">
									<input type="text" name="v002" id="v002" value="<?php echo $v001; ?>" placeholder=" Informe o autorizado">
								</div><!-- eSelG -->
								<div class="clear"></div>
							</div><!-- dummy -->
						</div><!-- w50 -->
						<div class="w50">
							<div class="dummy">
								<div class="eLegP">
									<label for=v003>Usado para [003]: </label>
								</div><!-- eLegP -->
								<div class="eSelG">
									<textarea class="curto" name="v003" id="v003" placeholder="Termos para os quais é usado"><?php echo $v003; ?></textarea>
								</div><!-- eSelG -->
								<div class="clear"></div>
							</div><!-- dummy -->
						</div><!-- w50 -->
						<div class="clear"></div>
					</fieldset><!-- Substitutos -->
					<fieldset><legend>Relações</legend>
						<div class="w50">
							<div class="dummy">
								<div class="eLegP">
									<label for=v004>Usado para (UF) [004]: </label>
								</div><!-- eLegP -->
								<div class="eSelG">
									<textarea name="v004" id="v004" placeholder="Termos para os quais é usado"><?php echo $v004; ?></textarea>
								</div><!-- eSelG -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="dummy">
								<div class="eLegP">
									<label for=v007>Termo relacionado (RT) [007]: </label>
								</div><!-- eLegP -->
								<div class="eSelG">
									<textarea name="v007" id="v007" placeholder="Termos relacionados (um por linha)"><?php echo $v004; ?></textarea>
								</div><!-- eSelG -->
								<div class="clear"></div>
							</div><!-- dummy -->
						</div><!-- w50 -->
						<div class="w50">
							<div class="dummy">
								<div class="eLegP">
									<label for=v005>Superior (BT) [005]: </label>
								</div><!-- eLegP -->
								<div class="eSelG">
									<textarea name="v005" id="v005" placeholder="Termos de hierarquia superior (um por linha)"><?php echo $v005; ?></textarea>
								</div><!-- eSelG -->
								<div class="clear"></div>
							</div><!-- dummy -->
							<div class="dummy">
								<div class="eLegP">
									<label for=v007>Inferior (NT) [006]: </label>
								</div><!-- eLegP -->
								<div class="eSelG">
									<textarea name="v006" id="v006" placeholder="Termos de hierarquia inferior (um por linha)"><?php echo $v006; ?></textarea>
								</div><!-- eSelG -->
								<div class="clear"></div>
							</div><!-- dummy -->
						</div><!-- w50 -->
						<div class="clear"></div>
					</fieldset><!-- Relações -->
					<fieldset><legend>Notas</legend>
						<div class="dummy">
							<div class="eLegP">
								<label for=v002>Nota de Escopo (SN) [002]: </label>
							</div><!-- eLegP -->
							<div class="eSelG">
								<textarea name="v002" id="v002" placeholder="Notas (uma por linha)"><?php echo $v002; ?></textarea>
							</div><!-- eSelG -->
							<div class="clear"></div>
						</div><!-- dummy -->
					</fieldset>
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

