package{
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import flash.events.MouseEvent;
	import flash.events.Event;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import flash.geom.Point;
	
	import com.blitzagency.filters.PolarCoordinates;

	import br.com.promosapiens.geraImagem;
	import br.com.promosapiens.resetMovie;
	import br.com.promosapiens.PKeyBoard;
	import br.com.promosapiens.operacoesClasse;	
	
	import com.dannyburbol.partialClone;
	
	public class Main extends MovieClip{
		//Arrays de dados
		private var arrayLabelNames:Array;
		private var arrayTituloSecao:Array;
		private var arrayDescritivoSecao:Array;
		private var arrayObjsSubMenu:Array;
		
		//Arrays de elementos
		private var arrayPlanoFundo:Array = new Array();
		private var arrayElementoBase:Array;
		private var arrayElementosPrimeiroPlano:Array;
		private var arrayElementosSegundoPlano:Array;
		
		//Elementos
		private var movieBG1:BG1 = new BG1();
		private var movieBG2:BG2 = new BG2();
		private var movieBG3:BG3 = new BG3();
		
		private var movieElmtBase1:ElmtBase1 = new ElmtBase1();
		private var movieElmtBase2:ElmtBase2 = new ElmtBase2();
		private var movieElmtBase3:ElmtBase3 = new ElmtBase3();
		private var movieElmtBase4:ElmtBase4 = new ElmtBase4();
		
		private var movieSegundoPlano1:SegundoPlano1 = new SegundoPlano1();
		private var movieSegundoPlano2:SegundoPlano2 = new SegundoPlano2();
		private var movieSegundoPlano3:SegundoPlano3 = new SegundoPlano3();
		
		private var moviePrimeiroPlano1:PrimeiroPlano1 = new PrimeiroPlano1();
		private var moviePrimeiroPlano2:PrimeiroPlano2 = new PrimeiroPlano2();
		private var moviePrimeiroPlano3:PrimeiroPlano3 = new PrimeiroPlano3();
		private var moviePrimeiroPlano4:PrimeiroPlano4 = new PrimeiroPlano4();
		private var moviePrimeiroPlano5:PrimeiroPlano5 = new PrimeiroPlano5();
		
		//Teste Polar Coordinates
		private var polarBitmap:Bitmap;
		private var imgTesteFoto:TesteFoto;
		
		//Variaveis subMenu
		private var opcaoAtiva:MovieClip = new MovieClip();
		private var txtNumeroMenuAtivo:TextField = new TextField();
		private var txtTituloMenuAtivo:TextField = new TextField(); 
		
		private var indiceLabel:int = 0;
		private var labelAtivo:String;
		
		private var animationComplete:Boolean = true;
				
		// Para salvar a imagem
//		private var geracaoImagem = new geraImagem("http://192.168.0.210/samsung/little_planet/amf/gateway.php");
		private var geracaoImagem = new geraImagem("http://127.0.0.1/samsung/little_planet/amf/gateway.php");
		
		// Para reset do movie
		private var reset:resetMovie;
		
		private var frameAnterior=0;
		
		//PkeyBorad
		private var arrayBtnsTeclado:Array;
		private var pTeclado:PKeyBoard = new PKeyBoard();
		private var textFieldAtivo:TextField = new TextField();
		private var primeiraVezAddText:Boolean = true;
		private var planetName:String;

		private var elementoAtualDragAndDrop:int = 0;
		private var arrayElementosAtual:Array;
		
		private var posicaoXMascaraDragAndDrop = 134.5;
		private var posicaoYMascaraDragAndDrop = 289.5;		
		
		private var x1DestinoDrag = 647;
		private var x2DestinoDrag = 1227.2;
		private var y1DestinoDrag = 288;
		private var y2DestinoDrag = 541.6;
		private var widthDestinoDrag  = x2DestinoDrag - x1DestinoDrag;
		private var heightDestinoDrag  = y2DestinoDrag - y1DestinoDrag;		
		
		
		private var cloneElementoAtualDrag;
		
		private var arrayPlanosFundoSelecionados:Array = new Array();
		private var arrayElementosBaseSelecionados:Array = new Array();		
		private var arrayPrimeirosPlanosSelecionados:Array = new Array();
		private var arraySegundosPlanosSelecionados:Array = new Array();		
		
//		private var
		
//___________________________________________________________
//												  constructor

		public function Main(){
			//Carregando array com labels dos Frames			
			this.carregarArrays();
			
			//this.addEventListener ( Event.ENTER_FRAME, traceFrame );
			
			//iniciando o carregamento do multimidia
			init();
			
			//montarMascaraElementosDragAndDrop();
		}
		
/*
		private function montarMascaraElementosDragAndDrop(){
			mascaraElementosDragAndDrop.graphics.beginFill(0xFFFFFF,1);
			mascaraElementosDragAndDrop.graphics.drawRect(0,0,300,250);
			mascaraElementosDragAndDrop.x = 0;//134.5;
			mascaraElementosDragAndDrop.y = 0;//289.5;			
			
			mascaraElementosDragAndDrop.graphics.endFill()
			addChild(mascaraElementosDragAndDrop)
		}
*/		
		
		private function traceFrame ( e : Event ) : void {
			if (frameAnterior != e.target.currentFrame){
				trace ( e.target.currentFrame )				
			}
			frameAnterior = e.target.currentFrame 
		}
		
		private function init(){
			btnVoltar.visible = false;
			
			telaDeEspera.visible = false;
			
			this.labelAtivo = arrayLabelNames[indiceLabel];
			
			this.montarInteracao();
			
			this.configurarResetMovie();
			
			teclado.visible = false;
		}

//___________________________________________________________
//												   resetMovie

		private function configurarResetMovie(){
			reset = new resetMovie(stage, resetar);
			reset.mostrarTrace = true;
			//reset.setarAlphaBotoes(100);
		}
		
		private function resetar(){
			this.indiceLabel = 0;
			
			//Primeiro desmonta a interação ativa, depois executa o filme
			desmontarInteracao();
			
			this.limparSubMenu();
			
			//Monta a interação da próxima tela	
			this.labelAtivo = "home";
			montarInteracao();
			
			gotoAndPlay(1);
		}	
		
//___________________________________________________________
//											carregando arrays
		
		private function carregarArrays(){
			//Array com frameLabels
			this.arrayLabelNames = [
				"home",
				"pag1",
				"pag2",
				"pag3",
				"pag4",
				"pag5",
				"teclado",
				"pag6"
			];
			
			//array Titulo Secao
			this.arrayTituloSecao = [
				"",					 
				"Plano de Fundo",
				"Elemento de Base",
				"Segundo Plano",
				"Primeiro Plano",
				"Concluir",
				"",
				""
			];
			
			//array Descritivo Secao
			this.arrayDescritivoSecao = [
				"",					 
				"Escolha um plano de fundo.",
				"Escolha um elemento de base arrastando-o para o quadro.",
				"Escolha um elemento de segundo plano arrastando-o para o quadro.",
				"Escolha um elemento de primeiro plano arrastando-o para o quadro.",
				"Aguarde seu planeta ser fotografado.",
				"",
				""
			];
			
			//arrayObjsSubMenu
			this.arrayObjsSubMenu = [
				mcSubMenu.opMenu1,
				mcSubMenu.opMenu2,
				mcSubMenu.opMenu3,
				mcSubMenu.opMenu4,
				mcSubMenu.opMenu5,
			];
		

		/*
			//array Plano Fundo
			this.arrayPlanoFundo = [
				movieBG1,
				movieBG2,
				movieBG3
			];
		*/
			this.arrayPlanoFundo = operacoesClasse.instanciarSerieSeDisponivel("planoDeFundo", 1);
			
/*			
			//array Plano Fundo
			this.arrayElementoBase = [
				movieElmtBase1,
				movieElmtBase2,
				movieElmtBase3,
				movieElmtBase4 
			];
*/
			this.arrayElementoBase = operacoesClasse.instanciarSerieSeDisponivel("elementoDeBase", 1);
			
/*
			//array Elementos Segundo Plano
			this.arrayElementosSegundoPlano = [
				movieSegundoPlano1,
				movieSegundoPlano2,
				movieSegundoPlano3
			];
*/
			this.arrayElementosSegundoPlano = operacoesClasse.instanciarSerieSeDisponivel("segundoPlano", 1);
			
			
/*			
			//array Elementos Primeiro Plano
			this.arrayElementosPrimeiroPlano = [
				
			];
*/
			this.arrayElementosPrimeiroPlano = operacoesClasse.instanciarSerieSeDisponivel("primeiroPlano", 1);
			
			
			//Array btns Teclado
			this.arrayBtnsTeclado = [
				teclado.mcTecladoInt.botao_1,
				teclado.mcTecladoInt.botao_2,
				teclado.mcTecladoInt.botao_3,
				teclado.mcTecladoInt.botao_4,
				teclado.mcTecladoInt.botao_5,
				teclado.mcTecladoInt.botao_6,
				teclado.mcTecladoInt.botao_7,
				teclado.mcTecladoInt.botao_8,
				teclado.mcTecladoInt.botao_9,
				
				teclado.mcTecladoInt.botao_0,
				teclado.mcTecladoInt.botao_Q,
				teclado.mcTecladoInt.botao_W,
				teclado.mcTecladoInt.botao_E,
				teclado.mcTecladoInt.botao_R,
				teclado.mcTecladoInt.botao_T,
				teclado.mcTecladoInt.botao_Y,
				teclado.mcTecladoInt.botao_U,
				teclado.mcTecladoInt.botao_I,
				teclado.mcTecladoInt.botao_O,
				teclado.mcTecladoInt.botao_P,
				teclado.mcTecladoInt.botao_A,
				teclado.mcTecladoInt.botao_S,
				teclado.mcTecladoInt.botao_D,
				teclado.mcTecladoInt.botao_F,
				teclado.mcTecladoInt.botao_G,
				teclado.mcTecladoInt.botao_H,
				teclado.mcTecladoInt.botao_J,
				teclado.mcTecladoInt.botao_K,
				teclado.mcTecladoInt.botao_L,
				teclado.mcTecladoInt.botao_Z,
				teclado.mcTecladoInt.botao_X,
				teclado.mcTecladoInt.botao_C,
				teclado.mcTecladoInt.botao_V,
				teclado.mcTecladoInt.botao_B,
				teclado.mcTecladoInt.botao_N,
				teclado.mcTecladoInt.botao_M,
				
				teclado.mcTecladoInt.botao_Ç,
				
				teclado.mcTecladoInt.botao_BACKSPACE,
				teclado.mcTecladoInt.botao_SPACE,
				teclado.mcTecladoInt.botao_ARROBA,
				teclado.mcTecladoInt.botao_TRAVESSAO,
				teclado.mcTecladoInt.botao_PONTO
			];
		}
						
//___________________________________________________________
//										   controle navagação

		private function xbtnFake_clickHandler(event:MouseEvent){
			this.mudarPagina();
		}
				
		private function mudarPagina(){
			if (validarTrocaDeTela()) {
				//verificando o indice
				if(this.indiceLabel + 1 == this.arrayLabelNames.length){
					this.indiceLabel = 0;
				} else {
					this.indiceLabel++;
				}
				
				//trocando de tela
				if(this.arrayLabelNames[this.indiceLabel] != this.labelAtivo){
					//Monta a tela de template de 1 a 5
					if(this.arrayLabelNames[this.indiceLabel] != "pag6"){
						//Altera o conteúdo das caixas de texto dinamicas de titulo das páginas
						alterarDadosDinamicos();
					}
					
					//Primeiro desmonta a interação ativa, depois executa o filme
					desmontarInteracao();
					play();
									
					//Monta a interação da próxima tela				
					this.labelAtivo = this.arrayLabelNames[this.indiceLabel];
					montarInteracao();
				}
			}
		}
		
		private function validarTrocaDeTela(){
			if(this.labelAtivo == "pag1" && arrayPlanosFundoSelecionados.length==0){
				return false;
			}
			else if(this.labelAtivo == "pag2" && arrayElementosBaseSelecionados.length==0){
				return false;				
			}
			else if(this.labelAtivo == "pag3" && arraySegundosPlanosSelecionados.length == 0){
				return false;				
			}
			else if(this.labelAtivo == "pag4" && arrayPrimeirosPlanosSelecionados.length==0){
                                  				return false;				
			}
			
			return true;
		}
		
		//--> Montar		
		private function montarInteracao(){
			switch(this.labelAtivo){
				case "home":				
					alterarDadosDinamicos();
					
					if(!xbtnFake.hasEventListener(MouseEvent.CLICK)){
						xbtnFake.addEventListener(MouseEvent.CLICK, xbtnFake_clickHandler);
					}
					
				break;
				case "pag1":
					xbtnFake.removeEventListener(MouseEvent.CLICK, xbtnFake_clickHandler);
					adicionandoEventosBtnNavegacao();
					limparArrayElementosDragAndDrop();
					montarDragAndDrop(arrayPlanoFundo);//, this.labelAtivo);
				break;
				case "pag2":
					montarDragAndDrop(arrayElementoBase);
                    				break;
				case "pag3":
					montarDragAndDrop(arrayElementosSegundoPlano);
				break;
				case "pag4":
					montarDragAndDrop(arrayElementosPrimeiroPlano);
				break;
				case "pag5":				
					ocultarElementosDragAndDrop();
					enquadrarLittlePlanetMontado();
				break;
				case "teclado":
					this.addPKeyBoard();
				break;
				case "pag6": 
					//A função "this.montarPolarCoord()" é chamada no frame 138 
					
					//O evento xbtnFake2.addEventListener(MouseEvent.CLICK, xbtnFake_clickHandler), no mesmo frame
				break;
			}
		}
		
		//--> desMontar		
		private function desmontarInteracao(){
			switch(this.labelAtivo){
				case "home":
					trace("Home - desMontar Interação");
				break;
				case "pag1":
					desmontarDragAndDrop();
				break;
				case "pag2":
					desmontarDragAndDrop();
				break;
				case "pag3":
					desmontarDragAndDrop();
				break;
				case "pag4":
					desmontarDragAndDrop();
				break;
				case "pag5":
					trace("pag5 - desMontar Interação");
				break;
				case "teclado":
				//Neste caso a animação teve que ser removida antes de mudar de tela.
					//this.removePKeyBoard();
				break;
				case "pag6":
					desmontarPolarCoord();
				break;
			}
		}
		
		//--> NAVEGAÇÃO	events	
		private function xbtn_clickFoto(event:MouseEvent){
			play();
		}

		private function adicionandoEventosBtnNavegacao(){
			btnAvancar.addEventListener(MouseEvent.CLICK, xbtnFake_clickHandler);
		}
		
//___________________________________________________________
//												      subMenu

		private function montarSubMenu(){
			var i:Number;
			
			for(i = 0; i < arrayObjsSubMenu.length; i++){
				arrayObjsSubMenu[i].txtNumeroMenu.text = i + 1;
				arrayObjsSubMenu[i].txtTituloMenu.text = arrayTituloSecao[i + 1]
			}
		}
		
		private function limparSubMenu(){
			var i:Number;
			
			for(i = 0; i < arrayObjsSubMenu.length; i++){
				this.arrayObjsSubMenu[i].txtNumeroMenu.text = "";
				this.arrayObjsSubMenu[i].txtTituloMenu.text = "";
			}
			
			mcSubMenu.gotoAndPlay("fechar");
		}
		
		private function ativarSubMenu(indice:*){
			var indiceInt:* = indice - 1;
			
			if(this.labelAtivo == "home"){
				//Ligando a animação
				mcSubMenu.gotoAndPlay("abrir");
			}
			
			//Retornando para o estado normal
			this.opcaoAtiva.gotoAndStop(1);
			this.txtNumeroMenuAtivo.textColor = 0x666666;
			this.txtTituloMenuAtivo.textColor = 0x666666; 
			
			//Mudando a forma do novo MovieClip
			this.arrayObjsSubMenu[indiceInt].bolinhaSubMenu.gotoAndStop(2);
			this.arrayObjsSubMenu[indiceInt].txtNumeroMenu.textColor = 0xFFFFFF;
			this.arrayObjsSubMenu[indiceInt].txtTituloMenu.textColor = 0xFFFFFF; 
			
			//Informando que está ativo para apagar na próxima etapa
			this.opcaoAtiva = this.arrayObjsSubMenu[indiceInt].bolinhaSubMenu;
			this.txtNumeroMenuAtivo = this.arrayObjsSubMenu[indiceInt].txtNumeroMenu;
			this.txtTituloMenuAtivo = this.arrayObjsSubMenu[indiceInt].txtTituloMenu; 
		}
		
		private function alterarDadosDinamicos(){			
			if(this.indiceLabel == 0 ||this.indiceLabel == 6){
				limparTexts();

				mcNumeroSecao.alpha = 0;
			} else {
				//Numero da seção
				mcNumeroSecao.alpha = 1;
				
				inserirInformacoesText();
				
				ativarSubMenu(this.indiceLabel);
			}
		}
				
		private function limparTexts(){
			mcNumeroSecao.txtNumero.text = "";
			dynamicTextGroup.txtTiuloSecao.text = "";
			dynamicTextGroup.txtDescritivoSecao.text = "";
		}
		
		private function inserirInformacoesText(){
			//Numero da seção
			mcNumeroSecao.txtNumero.text = this.indiceLabel;
			
			//Titúlo da seção
			dynamicTextGroup.txtTiuloSecao.text = this.arrayTituloSecao[this.indiceLabel];
			dynamicTextGroup.txtTiuloSecao.width = dynamicTextGroup.txtTiuloSecao.length * 20;
			
			//Descritivo da seção
			dynamicTextGroup.txtDescritivoSecao.x = dynamicTextGroup.txtTiuloSecao.x + dynamicTextGroup.txtTiuloSecao.width + 5;
			dynamicTextGroup.txtDescritivoSecao.text = this.arrayDescritivoSecao[this.indiceLabel];
		}
		
//___________________________________________________________
//										        drag and drop

		private function montarDragAndDrop(arrayElementosAtuais, arrayElementosAnteriores=null){
			var i:String;
			arrayElementosAtual = arrayElementosAtuais;
			elementoAtualDragAndDrop = 0;

			ocultarElementosDragAndDrop();

			for (i in arrayElementosAtuais){
				posicionarElementoDragAndDrop(arrayElementosAtuais[i]);
				addChild(arrayElementosAtuais[i]);
				arrayElementosAtuais[i].addEventListener(MouseEvent.MOUSE_DOWN, startDragElemento);
			}
			
			arrayElementosAtuais[0].mask = senderOut[this.labelAtivo];				
			arrayElementosAtuais[0].visible = true;
			
			
			//Em cada tela tem um senderElemntos abaixo segue o nome de cada sender de elementos
				// -> senderOut.pag1
				// -> senderOut.pag2
				// -> senderOut.pag3
				// -> senderOut.pag4
			
			// *** Setas Controladoras *** //
				// -> setaUpElementos
				// -> setaDownElementos
			
			//O nome do movie que recebe os elementos é 
				//-> receptorElementos
			setaUpElementos.addEventListener(MouseEvent.CLICK, hdlrClickSetaUpDragAndDrop);
			setaDownElementos.addEventListener(MouseEvent.CLICK, hdlrClickSetaDownDragAndDrop);			
		}
		

		private function limparArrayElementosDragAndDrop(){
			arrayPlanosFundoSelecionados = new Array();
			arrayElementosBaseSelecionados = new Array();		
			arrayPrimeirosPlanosSelecionados = new Array();
			arraySegundosPlanosSelecionados = new Array();		
		}
		
		// São "ocultos" pois assim vale tanto se o usuário estiver avançando ou voltando uma tela
		private function ocultarElementosDragAndDrop(){
			var i:String;
			
			for (i in this.arrayPlanoFundo){
				this.arrayPlanoFundo[i].visible = false;
			}

			for (i in this.arrayElementoBase){
				this.arrayElementoBase[i].visible = false;
			}

		
			for (i in this.arrayElementosSegundoPlano){
				this.arrayElementosSegundoPlano[i].visible = false;
			}

			for (i in this.arrayElementosPrimeiroPlano){
				this.arrayElementosPrimeiroPlano[i].visible = false;
			}
		}
		
		private function posicionarElementoDragAndDrop(elemento){
			// Posicionamento em x. Fica centralizado
			var posX = (senderOut[this.labelAtivo].width - elemento.width) / 2 ;
			if (posX < 0) posX = 0 ;
			elemento.x = posicaoXMascaraDragAndDrop + posX;
			
			// Posicionamento em Y: Fica na base
			var posY = senderOut[this.labelAtivo].height - elemento.height;
			if (posY<0) posY=0;
			elemento.y = posicaoYMascaraDragAndDrop + posY;			
		}

		private function hdlrClickSetaUpDragAndDrop(evt:MouseEvent){
			arrayElementosAtual[elementoAtualDragAndDrop].visible = false;
			elementoAtualDragAndDrop++;

			if (arrayElementosAtual.length <= elementoAtualDragAndDrop) elementoAtualDragAndDrop = 0;
			arrayElementosAtual[elementoAtualDragAndDrop].visible = true;
			arrayElementosAtual[elementoAtualDragAndDrop].mask = senderOut[this.labelAtivo];
		}
		
		
		private function hdlrClickSetaDownDragAndDrop(evt:MouseEvent){
			arrayElementosAtual[elementoAtualDragAndDrop].visible = false;
			elementoAtualDragAndDrop--;

			if (elementoAtualDragAndDrop < 0) elementoAtualDragAndDrop = arrayElementosAtual.length-1;
			arrayElementosAtual[elementoAtualDragAndDrop].visible = true;
			arrayElementosAtual[elementoAtualDragAndDrop].mask = senderOut[this.labelAtivo];
		}
		

		private function desmontarDragAndDrop(){
			
		}
		
				
		private function startDragElemento(evt:MouseEvent){
			cloneElementoAtualDrag = partialClone.duplicateDisplayObject(arrayElementosAtual[elementoAtualDragAndDrop]);
			addChild(cloneElementoAtualDrag);
  		 	cloneElementoAtualDrag.addEventListener(MouseEvent.MOUSE_UP,stopDragElemento); 
			cloneElementoAtualDrag.mask = null;
			cloneElementoAtualDrag.startDrag();
		}

		private function stopDragElemento(evt:MouseEvent){
			if (verificarElementoAreaDestinoDrag(cloneElementoAtualDrag)){				
				posicionarElementoDragAndDropDestino(cloneElementoAtualDrag);
			}
			else {
				// Será sobrescrito quando for selecionado outro elemento, então só será "ocultado"
				cloneElementoAtualDrag.visible = false;
			}
			
			cloneElementoAtualDrag.stopDrag();
			cloneElementoAtualDrag.removeEventListener(MouseEvent.MOUSE_UP,stopDragElemento);
			cloneElementoAtualDrag.addEventListener(MouseEvent.MOUSE_DOWN, startDragElementoPosicionado);
			cloneElementoAtualDrag.addEventListener(MouseEvent.MOUSE_UP, stopDragElementoPosicionado);
		}

		private function startDragElementoPosicionado(evt:MouseEvent){
			trace(this.labelAtivo);
			
			// Só deixa arrastar o elemento que é da própria tela
			if (this.labelAtivo == "pag1" && evt.target.name.indexOf("planoDeFundo") > -1){
				evt.target.startDrag();
			}
			else if (this.labelAtivo == "pag2" && evt.target.name.indexOf("elementoDeBase") > -1){
				evt.target.startDrag();				
			}
			else if (this.labelAtivo == "pag3" && evt.target.name.indexOf("segundoPlano") > -1){
				evt.target.startDrag();				
			}
			else if (this.labelAtivo == "pag4" && evt.target.name.indexOf("primeiroPlano") > -1){
				evt.target.startDrag();				
			}
		}

		private function stopDragElementoPosicionado(evt:MouseEvent){
//			if (verificarElementoAreaDestinoDrag(cloneElementoAtualDrag)){				
//				posicionarElementoDragAndDropDestino(cloneElementoAtualDrag, true);
			if (verificarElementoAreaDestinoDrag(evt.target)){				
				posicionarElementoDragAndDropDestino(evt.target, true);
			}
			else {
				// Será sobrescrito quando for selecionado outro elemento, então só será "ocultado"
				evt.target.visible = false;
//				cloneElementoAtualDrag.visible = false;

				
//				if (cloneElementoAtualDrag.name.indexOf("planoDeFundo") >= 0){
				if (evt.target.name.indexOf("planoDeFundo") >= 0){	
//					arrayPlanosFundoSelecionados.pop();
					retirarElementoDragAndDropEliminado(arrayPlanosFundoSelecionados, evt.target);

				}
//				else if (cloneElementoAtualDrag.name.indexOf("elementoDeBase") >= 0){
				else if (evt.target.name.indexOf("elementoDeBase") >= 0){					
//					arrayElementosBaseSelecionados.pop();
					retirarElementoDragAndDropEliminado(arrayElementosBaseSelecionados, evt.target);
				}
//				else if (cloneElementoAtualDrag.name.indexOf("segundoPlano") >= 0){
				else if (evt.target.name.indexOf("segundoPlano") >= 0){			
					trace("A: " + arraySegundosPlanosSelecionados);
					retirarElementoDragAndDropEliminado(arraySegundosPlanosSelecionados, evt.target);
//					arraySegundosPlanosSelecionados.pop();
					trace("B: " + arraySegundosPlanosSelecionados);

				}
//				else if (cloneElementoAtualDrag.name.indexOf("primeiroPlano") >= 0){
				else if (evt.target.name.indexOf("primeiroPlano") >= 0){					
//					arrayPrimeirosPlanosSelecionados.pop();
					retirarElementoDragAndDropEliminado(arrayPrimeirosPlanosSelecionados, evt.target);
				}
			}
			
			evt.target.stopDrag();
		}
		
		private function retirarElementoDragAndDropEliminado(arrayElementos, elemento){
			for (var i:String in arrayElementos){
				if (arrayElementos[i]==elemento){
					arrayElementos.splice(i,1);
				}
			}

			/*
			if (cloneElementoAtualDrag.name.indexOf("planoDeFundo") >= 0){
				arrayPlanosFundoSelecionados.pop();
			}
			else if (cloneElementoAtualDrag.name.indexOf("elementoDeBase") >= 0){
				arrayElementosBaseSelecionados.pop();
			}
			else if (cloneElementoAtualDrag.name.indexOf("segundoPlano") >= 0){
				arraySegundosPlanosSelecionados.pop();											
			}
			else if (cloneElementoAtualDrag.name.indexOf("primeiroPlano") >= 0){
				arrayPrimeirosPlanosSelecionados.pop();
			}	
			*/
		}
		
		
		private function verificarElementoAreaDestinoDrag(elemento){
			if (stage.mouseX >= x1DestinoDrag && stage.mouseX <= x2DestinoDrag && stage.mouseY >= y1DestinoDrag && stage.mouseY <= y2DestinoDrag){
				return true;
			}
			else {
				return false;
			}
		}
		

		private function posicionarElementoDragAndDropDestino(elemento, reposicionamento = false){
			var tmp;
			if (elemento.name.indexOf("planoDeFundo") >= 0){
				if (reposicionamento == false){
					// Excluindo o elemento de base anterior
					if (arrayPlanosFundoSelecionados.length > 0){
						trace("1- " + arrayPlanosFundoSelecionados);
						tmp = arrayPlanosFundoSelecionados.shift();
						removeChild(tmp);
					}
					arrayPlanosFundoSelecionados.push(elemento);					
				}
				// Posicionando o novo elemento em X
				elemento.x = x1DestinoDrag;
				
				// Posicionando o novo elemento em Y				
				elemento.y = y1DestinoDrag;
				
				/*
					Testanbdo inserir aqui mesmo no movie clip receptor e não no final
					removeChild(elemento);
					receptorElementos.addChild(elemento);
					elemento.x=0;
					elemento.y=0;				
				*/				
			}
			else if (elemento.name.indexOf("elementoDeBase") >= 0){
				if (reposicionamento == false){
					// Excluindo o elemento de base anterior
					if (arrayElementosBaseSelecionados.length > 0){
						tmp = arrayElementosBaseSelecionados.shift();
						removeChild(tmp);
					}
					arrayElementosBaseSelecionados.push(elemento);
				}
				
				// Posicionando o novo elemento em x
				elemento.x = x1DestinoDrag;
				
				// Posicionando o novo elemento em y
				var posY = heightDestinoDrag - elemento.height;
				if (posY<0) posY=0;
				elemento.y = posY + y1DestinoDrag;
			}
			else if (elemento.name.indexOf("segundoPlano") >= 0){
				if (reposicionamento == false){
					arraySegundosPlanosSelecionados.push(elemento);											
				}
				
				// Posicionando o elemento em X
				if (elemento.x < x1DestinoDrag) {
					elemento.x = x1DestinoDrag
				}
				else if (elemento.x + elemento.width > x2DestinoDrag){
					elemento.x = x2DestinoDrag - elemento.width ;
				}
				
				// Posicionando o novo elemento em y
				elemento.y = arrayElementosBaseSelecionados[0].y - elemento.height + 5;
			}
			else if (elemento.name.indexOf("primeiroPlano") >= 0){
				if (reposicionamento == false){
					arrayPrimeirosPlanosSelecionados.push(elemento);
				}
				
				// O elemento já sai posicionado corretamente em X
				if (elemento.x < x1DestinoDrag) {
					elemento.x = x1DestinoDrag;
				}
				else if (elemento.x + elemento.width > x2DestinoDrag){
					elemento.x = x2DestinoDrag - elemento.width;
				}
				
				// Posicionando o novo elemento em y
				if (elemento.y < y1DestinoDrag) {
					elemento.y = y1DestinoDrag;
				}
				else if (elemento.y + elemento.height > y2DestinoDrag){
					elemento.y = y2DestinoDrag - elemento.height;
				}
			}
		}
		
		private function enquadrarLittlePlanetMontado(){
			var i:String;
			
//			receptorElementos.visible = false;

/*
			trace("arrayPlanosFundoSelecionados: " + arrayPlanosFundoSelecionados.length);
			trace("arrayElementosBaseSelecionados: " + arrayElementosBaseSelecionados.length);
			trace("arrayPrimeirosPlanosSelecionados: " + arrayPrimeirosPlanosSelecionados.length);
			trace("arraySegundosPlanosSelecionados: " + arraySegundosPlanosSelecionados.length);
*/			
			
			for (i in arrayPlanosFundoSelecionados){
				removeChild(arrayPlanosFundoSelecionados[i]);
				receptorElementos.addChild(arrayPlanosFundoSelecionados[i]);
				reposicionarElementosDragAndDropDestino(arrayPlanosFundoSelecionados[i]);
/*
				arrayPlanosFundoSelecionados[i].x=0
				arrayPlanosFundoSelecionados[i].y=0				
*/				
			}

			for (i in arrayElementosBaseSelecionados){
				removeChild(arrayElementosBaseSelecionados[i])
				receptorElementos.addChild(arrayElementosBaseSelecionados[i]);
				reposicionarElementosDragAndDropDestino(arrayElementosBaseSelecionados[i]);
/*
				arrayElementosBaseSelecionados[i].x = 0;
				arrayElementosBaseSelecionados[i].y = 0;
*/				
			}
			
			for (i in arraySegundosPlanosSelecionados){
				removeChild(arraySegundosPlanosSelecionados[i]);
				receptorElementos.addChild(arraySegundosPlanosSelecionados[i]);				
				reposicionarElementosDragAndDropDestino(arraySegundosPlanosSelecionados[i]);
				/*
				arraySegundosPlanosSelecionados[i].x = 0
				arraySegundosPlanosSelecionados[i].y = 0;			
*/				
			}
			
			for (i in arrayPrimeirosPlanosSelecionados){
				removeChild(arrayPrimeirosPlanosSelecionados[i])
				receptorElementos.addChild(arrayPrimeirosPlanosSelecionados[i]);
				reposicionarElementosDragAndDropDestino(arrayPrimeirosPlanosSelecionados[i]);
				/*				
				arrayPrimeirosPlanosSelecionados[i].x = 0
				arrayPrimeirosPlanosSelecionados[i].y = 0
*/				
			}			
		}
		
		private function reposicionarElementosDragAndDropDestino(elemento){
			elemento.x = elemento.x - x1DestinoDrag;
			elemento.y = elemento.y - y1DestinoDrag;
		}
//___________________________________________________________
//										              teclado
		
		//-->Adicionando
		private function addPKeyBoard(){
			//visibilidade
			teclado.visible = true;
			teclado.gotoAndPlay("abrir");
			
			//Informando quem vai receber o conteúdo
			this.textFieldAtivo = teclado.mcTecladoInt.txtDynamico;
			
			//adicionando eventos
			this.addEventsToPKeyBoard();
		}		

		private function addEventsToPKeyBoard():void{
			var i:String;
			
			//Adicionando evento ao Botão OK
			teclado.mcTecladoInt.botao_OK.addEventListener(MouseEvent.CLICK, botao_OK_clickHandler);
			
			//Adicionando evento as demais teclas			
			for(i in this.arrayBtnsTeclado){
				var labelTmp:String = arrayBtnsTeclado[i].name;
				labelTmp = labelTmp.substring(labelTmp.indexOf("_") + 1, labelTmp.length)
							
				pTeclado.addKey(arrayBtnsTeclado[i], labelTmp);
			}
			
			teclado.addEventListener(MouseEvent.CLICK, pTeclado_clickHandler);
		}
		
		private function botao_OK_clickHandler(event:MouseEvent){
			this.removePKeyBoard();
		}
		
		private function pTeclado_clickHandler(event:MouseEvent) {
			this.addTextToTextField(pTeclado.text as String);
		}
		
		private function addTextToTextField(tmpMsg:String) {
				if(tmpMsg == "BACKSPACE"){
					if(this.textFieldAtivo.text.length > 0 && this.textFieldAtivo.text != ""){
						this.textFieldAtivo.text = this.textFieldAtivo.text.substring(0,this.textFieldAtivo.text.length - 1);
					}
				} else {
					if(this.textFieldAtivo.text.length < 21){
						/* Estava com um bug que ao adicionar ele pulava uma linha 
						mas se desse um backspace ele funcionava essa condição 
						é apenas para isso. */
						if(primeiraVezAddText){
							this.textFieldAtivo.text = this.textFieldAtivo.text.substring(0,this.textFieldAtivo.text.length - 1);
							primeiraVezAddText = !primeiraVezAddText;
						}
						
						//Primeiro faz um filtro para ver se é uma tecla especial para substituir
						switch(tmpMsg){
							case "SPACE":
								tmpMsg = " ";
								break;
							case "VIRGULA":
								tmpMsg = ",";
								break;
							case "PONTO":
								tmpMsg = ".";
								break;
							case "ASPAS":
								tmpMsg = "'";
								break;
							case"ENTER":
								tmpMsg = "\n";
								break;
							case"ARROBA":
								tmpMsg = "@";
								break;
							case"TRAVESSAO":
								tmpMsg = "-";
								break;
						}
						
						//adicionando o texto
						this.textFieldAtivo.appendText(tmpMsg);
						
						pTeclado.textFieldAtivo.text = "";
					}
				}
		}								
				
		//-->Removendo		
		private function removePKeyBoard(){
			//Guardando o nome do planeta
			this.planetName = this.textFieldAtivo.text;
			
			//removendo eventos
			this.removeEventsToPKeyBoard();
			
			//o visible = false do teclado está no final da animação
			teclado.gotoAndPlay("fechar");
			
			//Dispara um evento que aguarda a animação terminar para continuar a interação
			stage.addEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
		}
		
		private function stage_enterFrameHandler(event:Event){
			if(teclado.currentFrame == 1){
				//Removendo o listener
				telaDeEspera.visible = true;
				
				stage.removeEventListener(Event.ENTER_FRAME, stage_enterFrameHandler);
				this.mudarPagina();
			}
		}
		
		private function removeEventsToPKeyBoard():void{
			var i:String;
			
			//Removento evento ao Botão OK
			teclado.mcTecladoInt.botao_OK.removeEventListener(MouseEvent.CLICK, botao_OK_clickHandler);
			
			//Removento evento as demais teclas			
			for(i in this.arrayBtnsTeclado){							
				pTeclado.removeKey(arrayBtnsTeclado[i]);
			}
			
			//Removento evento as demais teclas			
			teclado.removeEventListener(MouseEvent.CLICK, pTeclado_clickHandler);
		}
		
//___________________________________________________________
//										    polar coordinates

		private function montarPolarCoord(){
			var comprimentoPadrao:Number = 580;			
			
			//Tem que jogar o movie que deseja desenhar em um intermedário para que funcione
			var gambisMovie:MovieClip = new MovieClip;
			gambisMovie.addChild(receptorElementos);
			
			//Escalando o quadrado
			receptorElementos.width = receptorElementos.height = comprimentoPadrao;			
			
			//Adapitando as propriedades do receptor de elementos para poder calcular o polar coordinates
			receptorElementos.rotation = 180;
			receptorElementos.x = receptorElementos.width;
			receptorElementos.y = receptorElementos.height;
			receptorElementos.alpha = 1;
						
			//Desenhando a tela
			var bitmapData2:BitmapData = new BitmapData(comprimentoPadrao,comprimentoPadrao,false,0x646567);
			bitmapData2.draw(gambisMovie);
			
			//Fazendo os calculos para transformar o quadrado em Circulo
			var polarBitmapData:BitmapData = PolarCoordinates.convertBitmapData(bitmapData2);
			
			//Criando uma nova instancia com o resultado do polar coordinates
			polarBitmap = new Bitmap(polarBitmapData);
			
			//Adicionando a imagem do polar na cena
			receptorPag6.addChildAt(polarBitmap,0);
			receptorPag6.txtPlanetName.text = this.planetName;
			
			//Gerando uma imagem do planeta com o nome
			var imgPlanet:Bitmap = this.gerarImagem(receptorPag6);
			
			//Salvando a imagem
			this.salvarImagem(imgPlanet);
			
			//Mostrar o planeta...tirando a tela d e descanço
			telaDeEspera.visible = false;
		}
		
		private function gerarImagem(movie:MovieClip, comprimento:Number = 580, alphaImg:Boolean = false){
			//Desenhando a tela
			var bitmapData:BitmapData = new BitmapData(comprimento,comprimento,alphaImg,0x646567);
			bitmapData.draw(movie);
			
			var bitmap = new Bitmap(bitmapData);
			
			return bitmap;
		}
			
		private function desmontarPolarCoord(){			
			receptorPag6.removeChild(polarBitmap);
		}		
		
//___________________________________________________________
//										        salvar imagem

		private function salvarImagem(img:Bitmap){			
			geracaoImagem.setarQualidadeImagem(100);
			geracaoImagem.encode(img);			
		}	
	}
}