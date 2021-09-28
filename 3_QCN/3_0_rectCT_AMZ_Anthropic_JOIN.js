// Perform join tiles and Rasterize variables AGB, BGB, LITTER, CDW, TOTAL and Mapbiomas Reclass with 4° Comunication Nacional (QCN)
// For any issue/bug, please write to edriano.souza@ipam.org.br or dhemerson.costa@ipam.org.br 
// Developed by: IPAM, SEEG and OC
// Citing: SEEG/Observatório do Clima and IPAM

// @. UPDATE HISTORIC //
// 1:   Insert tiles 
// 1.1: Perform correction of QCN by following rules
// @. ~~~~~~~~~~~~~~ // 
 
/* @. Set user parameters *///

// Insert list sequence
var assets = ee.List.sequence(6,6,1).getInfo();

// Insert Acsess 
var address =   'projects/mapbiomas-workspace/SEEG/2021/QCN/tile_id_';

// Id for tiles
var tiles = [
  // 1,11,12, 14,15,16,17,18,19,2,20,21,22,23,24,27,28,3,32,4,6,7,8,9, // desordenado
  1,2,3,4,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,27,28,32 // Total de tiles 25 // Exclusion
];

// 1,2,3,4,  5,  6,7,8,9,  10,    11,12,13,14,15,16,17,18,19,20,21,22,23,24,   25;26,    27,28,     29;30;31;   32, 33,34,35
/// tiles not insert = 5,10,25,26,29,30 e 31 7 Classes 

///////////////////////////////////////
/* @. Don't change below this line *///
///////////////////////////////////////


// pre-definied palletes
var pal = require('users/gena/packages:palettes');
var palt = pal.matplotlib.viridis[7]; // AGB e TOTAL
var pala = pal.kovesi.rainbow_bgyr_35_85_c72[7];



var featureCollection = tiles.map(function(i){
  
  var asset = address + i;
  
  var name = asset.split()[5];
  
  return ee.FeatureCollection(asset).set('name',name);

  
});

featureCollection = ee.FeatureCollection(featureCollection).flatten();


print(featureCollection,'featureCollection');

Map.addLayer(featureCollection,{},'featureCollection',false);

print(featureCollection.first(),'featureCollection');

Map.addLayer(ee.FeatureCollection([featureCollection.first()]),{},'featureCollection.first()',false);
Map.centerObject(featureCollection.first());


var pastVegetation = ee.Image().select();
var propertieNames = ['cagb','cbgb','clitter','cdw','MAPBIOMAS','ctotal4inv'];

var visParams = {
  'cagb':{
    min:38,
    max:139,
  },
  'cbgb':{
    min:0,
    max:100,
  },
  'clitter':{
    min:0,
    max:1,
  },
  'cdw':{
    min:-1,
    max:1,
  },
  'MAPBIOMAS':{
    min:3,
    max:12,
  },
};



propertieNames.forEach(function(propertie){
  
  var bandName = 'past_vegetation_'+propertie;

  pastVegetation = pastVegetation.addBands(ee.Image(0).mask(0).paint(featureCollection,propertie)
    .rename(bandName)
    .float()
    );
    
  Map.addLayer(pastVegetation.select(bandName),palt[propertie],bandName);
});

print('pastVegetation',pastVegetation);
