
var f = ee.Image('users/edrianosouza/qcn/3b'); 

var s = ee.Image('users/edrianosouza/qcn/4'); 

var m = ee.Image('users/edrianosouza/qcn/5'); 

var c = ee.Image('users/edrianosouza/qcn/12b'); 

var no = ee.Image('users/edrianosouza/qcn/27b'); 


///// Terceiro passo: Exportação local para seu drive 
Export.image.toAsset({
    "image": no.uint8(),
    "description": 'cer_12', //
    "assetId": 'projects/mapbiomas-workspace/SEEG/2021/QCN_stp1/cer_12', //insere o endereço para onde vai exportar ou via tasks
    "scale": 250,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": no.geometry().convexHull() //altera para a região (var) utilizada
});
