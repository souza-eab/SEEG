// SCRIPT PARA FILTRAR AS MÁSCARAS DE DESMATAMENTO E REGENERAÇÃO PARA EXCLUIR PIXELS ISOLADOS E REDUZIR RUÍDO
// SEGUNDO PASSO PARA O MÉTODO DE CÁLCULOS DO SEEG, SETOR MUT

////////////////////////////////////////////////////////////////////////////////////////
// Organização responsável: IPAM (Instituto de Pesquisa Ambiental da Amazônia)
// Criado por: Felipe Lenti e Bárbara Zimbres (barbara.zimbres@ipam.org.br)
// Citação: referenciar o SEEG/Observatório do Clima e o IPAM ao usar esse script
////////////////////////////////////////////////////////////////////////////////////////

//Definição das funções utilizadas

//Função que transforma uma image collection em uma única imagem com várias bandas
var collection2multiband = function (collection) {

    var imageList = collection.toList(collection.size()).slice(1);

    var multiBand = imageList.iterate(
        function (band, image) {

            return ee.Image(image).addBands(ee.Image(band));
        },
        ee.Image(collection.first())
    );

    return ee.Image(multiBand);
};

//Função que aplica o Majority Filter (square Kernel)
var PostClassification = function(image) {

    this.init = function(image) {

        this.image = image;

    };

    this._majorityFilter = function(params) {

        // Generate a mask from the class value
        var classMask = this.image.eq(params.classValue);

        // Labeling the group of pixels until 100 pixels connected
        var labeled = classMask.mask(classMask).connectedPixelCount(100, true);

        // Select some groups of connected pixels
        var region = labeled.lt(params.maxSize);

        // Squared kernel with size shift 1
        var kernel = ee.Kernel.square(1);

        // Find neighborhood
        var neighs = this.image.neighborhoodToBands(kernel).mask(region);

        // Reduce to majority pixel in neighborhood
        var majority = neighs.reduce(ee.Reducer.mode());

        // Replace original values for new values
        var filtered = this.image.where(region, majority);

        return filtered.byte();

    };

    this.spatialFilter = function(filterParams) {

        for (var params in filterParams) {

            this.image = this._majorityFilter(filterParams[params]);

        }

        return this.image;

    };

    this.init(image);

};


//Agora aplicamos as funções definidas anteriormente
 
//Feature da região de interesse, no caso, todos os biomas do Brasil
var Bioma = ee.FeatureCollection("users/SEEGMapBiomas/bioma_1milhao_uf2015_250mil_IBGE_geo_v4_revisao_pampa_lagoas");

//Parametros do filtro espacial
var filterParams = [
   {classValue: 1, maxSize: 5}, // o tamanho maximo que o mapbiomas está usando é 5, valor definido em reunião (kernel de 5 pixels)
   {classValue: 0, maxSize: 5}
];

//A partir daqui trabalhamos apenas a partir de 1990, que é o período inicial apresentado pelo Inventário Nacional
var anos = ['1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995','1996','1997','1998','1999','2000','2001','2002','2003','2004','2005','2006','2007','2008','2009','2010','2011','2012','2013','2014','2015','2016','2017','2018','2019'];

var eeAnos = ee.List(anos);

/////Chama o asset da máscara de REGENERAÇÃO exportado a partir do script 1
var inputImage_regen = ee.Image('users/edrianosouza/Colecao_9_2021/Regen_SEEGc9'); // alterar para o asset salvo por vocês no script anterior

//Aplica as funções
var result_regen = eeAnos.map(function(ano){
  filterParams;
  PostClassification;
    var image = inputImage_regen.select(ee.String('regen').cat(ee.String(ano)));
    var pc = new PostClassification(image);
    var filtered2 = pc.spatialFilter(filterParams); 
    return(filtered2.int8());
});

// Salva o resultado como uma imagem multi-bandas
 result_regen = collection2multiband(ee.ImageCollection.fromImages(result_regen));
print(result_regen);

Export.image.toAsset({
    "image": result_regen.uint8(),
    "description": 'regenSEEGc5_filter_certo',
    "assetId": 'users/edrianosouza/Colecao_9_2021/Regen_SEEGc9_2', //insere o endereço para onde vai exportar a máscara filtrada
    "scale": 30,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": Bioma.geometry().convexHull() //altera para a região utilizada por vocês
});



/////Chama o asset da máscara de DESMATAMENTO exportado a partir do script 1
var inputImage_desm = ee.Image('users/edrianosouza/Colecao_9_2021/Desm_SEEGc9'); // alterar para o asset salvo por vocês no script anterior

//Aplica as funções
var result_desm = eeAnos.map(function(ano){
  filterParams;
  PostClassification;
    var image = inputImage_desm.select(ee.String('desm').cat(ee.String(ano)));
    var pc = new PostClassification(image);
    var filtered2 = pc.spatialFilter(filterParams); 
    return(filtered2.int8());
});

// Salva o resultado como uma imagem multi-bandas
 result_desm = collection2multiband(ee.ImageCollection.fromImages(result_desm));
print(result_desm);

Export.image.toAsset({
    "image": result_desm.uint8(),
    "description": 'desmSEEGc5_filter_certo',
    "assetId": 'users/edrianosouza/Colecao_9_2021/DesmSEEGc9_2', //insere o endereço para onde vai exportar a máscara filtrada
    "scale": 30,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": Bioma.geometry().convexHull() //altera para a região utilizada por vocês
});
