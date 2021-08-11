

//////////////////////////////////////////////////////////////////////////////////////////
//GERAR AS MASCARAS DE DESMATAMENTO COM A COLEÇÃO DO MAPBIOMAS (exemplo com a coleção 5.0)


//Reclassifica tudo o que for uso antrópico em 1985 para 1; o que for vegetação nativa, para 0; e o que não se aplica, para 9
var col5antrop85 = colecao5.select('classification_1985').remap(
                  [3, 4, 5, 11, 12, 13, 9,15,20,21,23,24,25,27, 29, 30, 31, 32, 33,36,39,40,41,42,43,44,45],
                  [0, 0, 0,  0,  0,  0, 1, 1, 1, 1, 9, 1, 1, 9,  9,  1,  1,  9,  9, 1, 1, 1, 1, 1, 1, 1, 1]);
//Muda o nome da banda
col5antrop85 = col5antrop85.select([0],['desmat1985']).int8();

//Completa fazendo a mesma coisa para os demais anos
for (var i_ano=0;i_ano<anos.length; i_ano++){
  var ano = anos[i_ano];

  var col5uso = colecao5.select('classification_'+ano).remap(
                  [3, 4, 5, 11, 12, 13, 9,15,20,21,23,24,25,27, 29, 30, 31, 32, 33,36,39,40,41,42,43,44,45],
                  [0, 0, 0,  0,  0,  0, 1, 1, 1, 1, 9, 1, 1, 9,  9,  1,  1,  9,  9, 1, 1, 1, 1, 1, 1, 1, 1]);
                    
  col5antrop85 = col5antrop85.addBands(col5uso.select([0],['desm'+ano])).int8();
}

//Gera a função que aplica a regra geral do filtro temporal (3 anos antes e 2 depois da transição)
var geraMask3_3 = function(ano){
  var mask =  col5antrop85.select('desm'+(ano - 3)).eq(0)
              .and(col5antrop85.select('desm'+(ano - 2)).eq(0))
              .and(col5antrop85.select('desm'+(ano - 1)).eq(0))
              .and(col5antrop85.select('desm'+(ano    )).eq(1))
              .and(col5antrop85.select('desm'+(ano + 1)).eq(1))
              .and(col5antrop85.select('desm'+(ano + 2)).eq(1));
  mask = mask.mask(mask.eq(1));
  return mask;
};

//Aplica as exceções das regras nos dois primeiros (1986 e 1987) e dois últimos anos (2017 e 2018) da série temporal
var mask86 =  col5antrop85.select('desm'+(1986 - 1)).eq(0)
              .and(col5antrop85.select('desm'+(1986    )).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 1)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 2)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 3)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 4)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 5)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 6)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 7)).eq(1))
              .and(col5antrop85.select('desm'+(1986 + 8)).eq(1));
              
  mask86 = mask86.mask(mask86.eq(1));
  mask86 = mask86.unmask(imageZero);  
  mask86 = mask86.updateMask(mask86.neq(0));
  mask86 = mask86.select([0], ['desm1986']);

  var mask87 =  col5antrop85.select('desm'+(1987 - 2)).eq(0)
              .and(col5antrop85.select('desm'+(1987 - 1)).eq(0))
              .and(col5antrop85.select('desm'+(1987    )).eq(1))
              .and(col5antrop85.select('desm'+(1987 + 1)).eq(1))
              .and(col5antrop85.select('desm'+(1987 + 2)).eq(1))
              .and(col5antrop85.select('desm'+(1987 + 3)).eq(1))
              .and(col5antrop85.select('desm'+(1987 + 4)).eq(1));
              
  mask87 = mask87.mask(mask87.eq(1));
  mask87 = mask87.unmask(imageZero);  
  mask87 = mask87.updateMask(mask87.neq(0));
  mask87 = mask87.select([0], ['desm1987']);
  
  
  var mask18 =  col5antrop85.select('desm'+(2018 - 6)).eq(0)
            .and(col5antrop85.select('desm'+(2018 - 5)).eq(0))
            .and(col5antrop85.select('desm'+(2018 - 4)).eq(0))
            .and(col5antrop85.select('desm'+(2018 - 3)).eq(0))
            .and(col5antrop85.select('desm'+(2018 - 2)).eq(0))
            .and(col5antrop85.select('desm'+(2018 - 1)).eq(0))
            .and(col5antrop85.select('desm'+(2018    )).eq(1))
            .and(col5antrop85.select('desm'+(2018 + 1)).eq(1));
              
  mask18 = mask18.mask(mask18.eq(1));
  mask18 = mask18.unmask(imageZero);  
  mask18 = mask18.updateMask(mask18.neq(0));
  mask18 = mask18.select([0], ['desm2018']);
  
  var mask19 =  col5antrop85.select('desm'+(2019 - 8)).eq(0)
            .and(col5antrop85.select('desm'+(2019 - 7)).eq(0))
            .and(col5antrop85.select('desm'+(2019 - 6)).eq(0))
            .and(col5antrop85.select('desm'+(2019 - 5)).eq(0))
            .and(col5antrop85.select('desm'+(2019 - 4)).eq(0))
            .and(col5antrop85.select('desm'+(2019 - 3)).eq(0))
            .and(col5antrop85.select('desm'+(2019 - 2)).eq(0))             
            .and(col5antrop85.select('desm'+(2019 - 1)).eq(0))
            .and(col5antrop85.select('desm'+(2019    )).eq(1));
            
  mask19 = mask19.mask(mask19.eq(1));
  mask19 = mask19.unmask(imageZero);  
  mask19 = mask19.updateMask(mask19.neq(0));
  mask19 = mask19.select([0], ['desm2019']);

//Soma as bandas dos dois primeiros anos
var desm = mask86.addBands(mask87);

//Cria uma banda do primeiro ano da regra geral
var desm88 = geraMask3_3(1988);
desm88 = desm88.unmask(imageZero);  
desm88 = desm88.updateMask(desm88.neq(0));
desm88 = desm88.select(['desm1985'],['desm1988']);

//Soma as bandas
desm = desm.addBands(desm88);

//Gera as bandas aplicando o filtro para todos os demais anos da regra geral (no caso, até 2016)
for (var i = 1989; i < 2018; i++) {
 
  var desm_geral = geraMask3_3(i);
      desm_geral = desm_geral.unmask(imageZero);
      desm_geral = desm_geral.updateMask(desm_geral.neq(0));
  desm = desm.addBands(desm_geral.select([0],['desm'+ i]));
}

//Adiciona os dois últimos anos
desm = desm.addBands(mask18).addBands(mask19);
print(desm);

Map.addLayer(desm.select('desm2019'), {'min': 0,'max': 1, 'palette': 'red'},"Desm_2019");

  Export.image.toAsset({
    "image": desm.unmask(0).uint8(),
    "description": 'desmSEEGc5',
    "assetId": 'users/edrianosouza/SEEG8_2020/desmSEEGc5', //inserir aqui o endereço e o nome do Asset a ser exportado
    "scale": 30,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": Bioma.geometry().bounds() //alterar aqui para o nome da região usada
});    
