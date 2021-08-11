// SCRIPT TO GENERATE DEFORESTATION MASKS FROM A COLLECTION OF MAPBIOMAS (eg. col 6.0) 
// For any issue/bug, please write to <edriano.souza@ipam.org.br>;<dhemerson.costa@ipam.org.br>;<barbara.zimbres@ipam.org.br> 
// Developed by: IPAM, SEEG and OC
// Citing: SEEG/Observatório do Clima and IPAM


// Set assets

// Asset Biomes brazilian
var Bioma = ee.FeatureCollection("users/SEEGMapBiomas/bioma_1milhao_uf2015_250mil_IBGE_geo_v4_revisao_pampa_lagoas"); 

//// brazilian biomes?
var biomes = ee.Image('projects/mapbiomas-workspace/AUXILIAR/biomas-2019-raster');

// Add ImageCollection Mapbiomas 6.0
var colecao6 = ee.ImageCollection("projects/mapbiomas-workspace/COLECAO5/mapbiomas-collection60-integration-v0-12").mosaic();

//1 Forest
var f = ['3','4','5', '6', '49'];

//10 Non Forest Natural Formation
var nf = ['11','12','32', '29', '13]; 

//14 Farming
var afolu = ['15', '18', '19','39','20','40','41','36','46','47','48','9','21'];
var afoluO = ['9','15', '18', '19','20','21','36','39','40','41','46','47','48'];
var afoluOp = ['18', '19','39','20','40','41','36','46','47','48','9','15', '21'];

  
//22 Non vegetated area
var nav = ['23', '24', '30', '25'];
// order prevalence <> 30,23,24,25}

//26 Water
var water = ['33', '31'];
      
// 27 Non Observed
var nonO = ['27'];


'3','4','5', '6', '49',
0  

11,12,32,29,13
0,0,9,9,0
//Range General prevalence Cerrado Biome 30,23,5,31,32,24,9,20,39,40,41,36,46,47,48,19,29,25,33,3,4,11,12,15,21
// Order  
//Remap layers for native vegetation in 1985 to 1; what is anthropic, is 0; and what does not apply, is 9
var col5antrop85 = colecao6.select('classification_1985').remap(
                  [3, 4, 5, 9, 12, 13, 15, 18, 19, 20, 21, 22, 23, 24, 25, 26, 29,30,31,32,33]
                  [0, 0, 0, 1,  0,  0,  1,  1,  1,  1,  1,  9,  9,  1,  1,  1,  9,  1,  1,  9,  9, 1, 1, 1, 1, 1, 1, 1, 1
  
                  [3, 4, 5, 11, 12, 13, 9,15,20,21,23,24,25,27, 29, 30, 31, 32, 33,36,39,40,41,42,43,44,45],
                  [0, 0, 0,  0,  0,  0, 1, 1, 1, 1, 9, 1, 1, 9,  9,  1,  1,  9,  9, 1, 1, 1, 1, 1, 1, 1, 1]);

//Changing names of bands 
col5antrop85 = col5antrop85.select([0],['desmat1985']).int8();

// List years
var anos = ['1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'];


// Complete doing the same thing for the other years 
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
