var assets = ee.List.sequence(6,6,1).getInfo();

var address =   'projects/mapbiomas-workspace/SEEG/2021/QCN/tile_id_';

var tiles = [
  // 1,11,14,15,16,18,19,2,20,21,22,23,24,27,28,3,32,4,6,7,8,9 // desordenado
  1,2,3,4,6,7,8,9,11,12,13,14,15,16,17,18,19,20,21,22,23,24,27,28,32 // Total de tiles 25 // Exclusion

  ];


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
var propertieNames = ['cagb','cbgb','clitter','cdw','MAPBIOMAS'];


var visParams = {
  'cagb':{
    min:38,
    max:139,
  },
  'cbgb':{
    min:-1,
    max:1,
  },
  'clitter':{
    min:-1,
    max:1,
  },
  'cdw':{
    min:-1,
    max:1,
  },
  'MAPBIOMAS':{
    min:-1,
    max:1,
  },
};


propertieNames.forEach(function(propertie){
  
  var bandName = 'past_vegetation_'+propertie;

  pastVegetation = pastVegetation.addBands(ee.Image(0).mask(0).paint(featureCollection,propertie)
    .rename(bandName)
    .float()
    );
    
  Map.addLayer(pastVegetation.select(bandName),visParams[propertie],bandName);
});

print('pastVegetation',pastVegetation);
