// Rectfy CT of QCN Forest that are Grassland in Mapbiomas and export as an GEE asset 
// For any issue/bug, please write to dhemerson.costa@ipam.org.br or edriano.souza@ipam.org.br
// Developed by: IPAM, SEEG and OC
// Citing: SEEG/Observatório do Clima and IPAM
// Processing time <2h> in Google Earth Engine

// @. UPDATE HISTORIC //
  // 1:   Count pixel by design
// 1.1: Perform correction of QCN by following rules
// 1.2 Perform correction from 1985 to 2020 (cumulative and static)
// @. ~~~~~~~~~~~~~~ // 
  
  /* @. Set user parameters */// eg.
var dir_output = 'projects/mapbiomas-workspace/SEEG/2021/QCN_stp2_v1/';
var version = '1';

// Define classes to be assesed as 'reference class' into QCN
var list_classes = [3, 4, 5, 12];
// List class Antropic in region Amazon

// Define years of Mapbiomas to be compared with QCN reference class
var list_mapb_years = [1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997,
                       1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010,
                       2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019];

// Define reclassification matrix
var raw_mapbiomas = [3, 4, 5, 9, 10, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 23, 24, 25, 26, 29, 30, 31, 32, 33, 36, 39, 41];   // Palets add other new classes 
var design5 =       [3, 4, 5, 0,  0, 0,  12,  0, 0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0];     // Ungroup {Forest) + Grass  

///////////////////////////////////////
  /* @. Don't change below this line *///
///////////////////////////////////////

// Get color-ramp module
var vis = {
    'min': 0,
    'max': 49,
    'palette': require('users/mapbiomas/modules:Palettes.js').get('classification6')
};

// pre-definied palletes
var pal = require('users/gena/packages:palettes');
var palt = pal.matplotlib.viridis[7];
var pala = pal.kovesi.rainbow_bgyr_35_85_c72[7];

// total stock
var am_tot = ee.Image('users/edrianosouza/QCN/am_ctotal4inv');
//var soc = ee.Image('users/edrianosouza/soil_co2/BR_SOCstock_0-30_t_ha');

// brazilian states
var states = ee.Image('projects/mapbiomas-workspace/AUXILIAR/estados-2016-raster');
Map.addLayer(states.randomVisualizer(), {}, 'states', false);


// Import LCLUC data
var qcnF = ee.Image("projects/mapbiomas-workspace/SEEG/2021/QCN_stp1/am_3_v1");
var qcnS = ee.Image("projects/mapbiomas-workspace/SEEG/2021/QCN_stp1/am_4_v1");
var qcnC = ee.Image("projects/mapbiomas-workspace/SEEG/2021/QCN_stp1/am_12_v1");
var qcnM = ee.Image("projects/mapbiomas-workspace/SEEG/2021/QCN_stp1/am_5_v1");

// reclassificiar
var qcnF = qcnF.remap([0, 1], [0, 3]);
var qcnS = qcnS.remap([0, 1], [0, 4]);
var qcnC = qcnC.remap([0, 1], [0, 12]);
var qcnM = qcnM.remap([0, 1], [0, 5]);

Map.addLayer(qcnF, vis, 'QCN_1.1. Forest Formation', false);
Map.addLayer(qcnS, vis, 'QCN_1.2. Savanna Formation', false);
Map.addLayer(qcnM, vis, 'QCN_1.3. Mangrove', false);
Map.addLayer(qcnC, vis, 'QCN_2.2. Grassland', false);

// fazer o blend só com as classes - descartar quando value == 0
var qcn = qcnF.updateMask(qcnF.eq(3)).blend(qcnS.updateMask(qcnS.eq(4)).blend(qcnC.updateMask(qcnC.eq(12).blend(qcnM.updateMask(qcnM.eq(5))))));

// Inspector
Map.addLayer(qcn, vis, 'QCN_Reclass_QGIS');

var colecao5 = ee.ImageCollection("projects/mapbiomas-workspace/COLECAO5/mapbiomas-collection50-integration-v8").mosaic();

// Plot inspection
Map.addLayer(am_tot, {min: 0, max: 168, palette: palt}, 'QCN_STK_Biomass');

// create empty recipes
var image_static = ee.Image([]);
var image_accumm = ee.Image([]);
var temp = ee.Image([]);
var temp2 = ee.Image([]);

// For each year of MapBiomas
 list_mapb_years.forEach(function(year_j){
// For each QCN reference class [i]
   list_classes.forEach(function(class_i) {
  // Mask QCN only to reference class
   var qcn_i = qcn.updateMask(qcn.eq(class_i));
  
  // Mask MapBiomas by QCN
    var mapb_qcn_ij = colecao5.select(['classification_' + year_j]).updateMask(qcn_i.eq(class_i));
    // Perform reclassification according definied matrix
    var mapb_qcn_ij_d5 = mapb_qcn_ij.remap(raw_mapbiomas, design5);
    
    // perform QCN correction by brazilian state - static //
    var am_tot_rect = am_tot.where(states.eq(11).and(mapb_qcn_ij_d5.eq(3)), 79.80779548); // RO
        am_tot_rect = am_tot_rect.where(states.eq(17).and(mapb_qcn_ij_d5.eq(3)), 64.27657895); // TO
        am_tot_rect = am_tot_rect.where(states.eq(21).and(mapb_qcn_ij_d5.eq(3)), 63.91879963); // MA
        am_tot_rect = am_tot_rect.where(states.eq(22).and(mapb_qcn_ij_d5.eq(3)), 66.068241);   // PI
        am_tot_rect = am_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(3)), 67.18329178); // BA
        am_tot_rect = am_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(3)), 70.08654663); // MG
        am_tot_rect = am_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(3)), 84.98800092); // SP
        am_tot_rect = am_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(3)), 74.98246537); // PR
        am_tot_rect = am_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(3)), 99.27158356); // MS
        am_tot_rect = am_tot_rect.where(states.eq(51).and(mapb_qcn_ij_d5.eq(3)), 93.55501847); // MT
        am_tot_rect = am_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(3)), 70.01143121); // GO
        am_tot_rect = am_tot_rect.where(states.eq(53).and(mapb_qcn_ij_d5.eq(3)), 66.8596976);  // DF
        am_tot_rect = am_tot_rect.rename('rect_' + year_j);
    
    // perform QCN correction by brazilian state - static //
        am_tot_rect = am_tot_rect.where(states.eq(11).and(mapb_qcn_ij_d5.eq(4)), 39.99); // RO
        am_tot_rect = am_tot_rect.where(states.eq(17).and(mapb_qcn_ij_d5.eq(4)), 39.99); // TO
        am_tot_rect = am_tot_rect.where(states.eq(21).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MA
        am_tot_rect = am_tot_rect.where(states.eq(22).and(mapb_qcn_ij_d5.eq(4)), 39.99);   // PI
        am_tot_rect = am_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(4)), 39.99); // BA
        am_tot_rect = am_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MG
        am_tot_rect = am_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(4)), 39.99); // SP
        am_tot_rect = am_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(4)), 39.99); // PR
        am_tot_rect = am_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MS
        am_tot_rect = am_tot_rect.where(states.eq(51).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MT
        am_tot_rect = am_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(4)), 39.99); // GO
        am_tot_rect = am_tot_rect.where(states.eq(53).and(mapb_qcn_ij_d5.eq(4)), 39.99);  // DF
        am_tot_rect = am_tot_rect.rename('rect_' + year_j);
        
         // perform QCN correction by brazilian state - static //
        am_tot_rect = am_tot_rect.where(states.eq(11).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // RO
        am_tot_rect = am_tot_rect.where(states.eq(17).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // TO
        am_tot_rect = am_tot_rect.where(states.eq(21).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MA
        am_tot_rect = am_tot_rect.where(states.eq(22).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);   // PI
        am_tot_rect = am_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // BA
        am_tot_rect = am_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MG
        am_tot_rect = am_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // SP
        am_tot_rect = am_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // PR
        am_tot_rect = am_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MS
        am_tot_rect = am_tot_rect.where(states.eq(51).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MT
        am_tot_rect = am_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // GO
        am_tot_rect = am_tot_rect.where(states.eq(53).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);  // DF
        am_tot_rect = am_tot_rect.rename('rect_' + year_j);
    
    // perform QCN correction by brazilian state - static //
        am_tot_rect = am_tot_rect.where(states.eq(11).and(mapb_qcn_ij_d5.eq(5)), 38.26); // RO
        am_tot_rect = am_tot_rect.where(states.eq(17).and(mapb_qcn_ij_d5.eq(5)), 38.26); // TO
        am_tot_rect = am_tot_rect.where(states.eq(21).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MA
        am_tot_rect = am_tot_rect.where(states.eq(22).and(mapb_qcn_ij_d5.eq(5)), 38.26);   // PI
        am_tot_rect = am_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(5)), 38.26); // BA
        am_tot_rect = am_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MG
        am_tot_rect = am_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(5)), 38.26); // SP
        am_tot_rect = am_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(5)), 38.26); // PR
        am_tot_rect = am_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MS
        am_tot_rect = am_tot_rect.where(states.eq(51).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MT
        am_tot_rect = am_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(5)), 38.26); // GO
        am_tot_rect = am_tot_rect.where(states.eq(53).and(mapb_qcn_ij_d5.eq(5)), 38.26);  // DF
        am_tot_rect = am_tot_rect.rename('rect_' + year_j);
        
    // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
      var am_tot_rect2 = am_tot.where(states.eq(11).and(mapb_qcn_ij_d5.eq(3)), 79.80779548); // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(3)), 64.27657895); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(3)), 63.91879963); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(3)), 66.068241);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(3)), 67.18329178); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(3)), 70.08654663); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(3)), 84.98800092); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(3)), 74.98246537); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(3)), 99.27158356); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(3)), 93.55501847); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(3)), 70.01143121); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(3)), 66.8596976);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
     // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
          am_tot_rect2 = am_tot_rect2.where(states.eq(11).and(mapb_qcn_ij_d5.eq(4)), 39.99); // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(4)), 39.99); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(4)), 39.99);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(4)), 39.99); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(4)), 39.99); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(4)), 39.99); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(4)), 39.99); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(4)), 39.99);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
   // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
          am_tot_rect2 = am_tot_rect2.where(states.eq(11).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
   // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
          am_tot_rect2 = am_tot_rect2.where(states.eq(11).and(mapb_qcn_ij_d5.eq(5)), 38.26); // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(5)), 38.26); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(5)), 38.26);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(5)), 38.26); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(5)), 38.26); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(5)), 38.26); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(5)), 38.26); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(5)), 38.26);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
   
    // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
      var r_last_year = image_accumm.select(['rect_' + (year_j -1)]);
      var am_tot_rect2 = r_last_year.where(states.eq(11).and(mapb_qcn_ij_d5.eq(3)), 79.80779548);   // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(3)), 64.27657895); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(3)), 63.91879963); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(3)), 66.068241);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(3)), 67.18329178); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(3)), 70.08654663); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(3)), 84.98800092); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(3)), 74.98246537); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(3)), 99.27158356); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(3)), 93.55501847); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(3)), 70.01143121); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(3)), 66.8596976);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
     // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
          am_tot_rect2 = am_tot_rect2.where(states.eq(11).and(mapb_qcn_ij_d5.eq(4)), 39.99);   // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(4)), 39.99); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(4)), 39.99);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(4)), 39.99); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(4)), 39.99); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(4)), 39.99); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(4)), 39.99); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(4)), 39.99); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(4)), 39.99);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
     // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
          am_tot_rect2 = am_tot_rect2.where(states.eq(11).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);   // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(12)), 24.75375483); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(12)), 24.75375483);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
     // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
          am_tot_rect2 = am_tot_rect2.where(states.eq(11).and(mapb_qcn_ij_d5.eq(5)), 38.26);   // RO
          am_tot_rect2 = am_tot_rect2.where(states.eq(17).and(mapb_qcn_ij_d5.eq(5)), 38.26); // TO
          am_tot_rect2 = am_tot_rect2.where(states.eq(21).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MA
          am_tot_rect2 = am_tot_rect2.where(states.eq(22).and(mapb_qcn_ij_d5.eq(5)), 38.26);   // PI
          am_tot_rect2 = am_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(5)), 38.26); // BA
          am_tot_rect2 = am_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MG
          am_tot_rect2 = am_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(5)), 38.26); // SP
          am_tot_rect2 = am_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(5)), 38.26); // PR
          am_tot_rect2 = am_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MS
          am_tot_rect2 = am_tot_rect2.where(states.eq(51).and(mapb_qcn_ij_d5.eq(5)), 38.26); // MT
          am_tot_rect2 = am_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(5)), 38.26); // GO
          am_tot_rect2 = am_tot_rect2.where(states.eq(53).and(mapb_qcn_ij_d5.eq(5)), 38.26);  // DF
          am_tot_rect2 = am_tot_rect2.rename('rect_' + year_j);
    }
    
// mix corrections
        // static
        if (class_i == 3) {
          temp = am_tot_rect;
        }
        if (class_i == 4) {
          temp = temp.blend(am_tot_rect.updateMask(qcn_i.eq(class_i)));
        }
        if (class_i == 12) {
          temp = temp.blend(am_tot_rect.updateMask(qcn_i.eq(class_i)));
        }
        if (class_i == 5) {
          temp = temp.blend(am_tot_rect.updateMask(qcn_i.eq(class_i)));
        // paste as band
          image_static = image_static.addBands(temp);
        }
        
        // accumulated
        if (class_i == 3) {
          temp2 = am_tot_rect2;
        }
        if (class_i == 4) {
          temp2 = temp2.blend(am_tot_rect2.updateMask(qcn_i.eq(class_i)));
        }
        if (class_i == 12) {
          temp2 = temp2.blend(am_tot_rect2.updateMask(qcn_i.eq(class_i)));
        }
        if (class_i == 5) {
          temp2 = temp2.blend(am_tot_rect2.updateMask(qcn_i.eq(class_i)));
          // paste as band
          image_accumm = image_accumm.addBands(am_tot_rect2);
        }
    
    });

  });
    
print('static', image_static);
print('accumulated', image_accumm);

// plot inspection
Map.addLayer(image_static.select(['rect_2019']),  {min: 0, max: 168, palette: palt}, 'QCN_STK_Biomass_Static 2019');
Map.addLayer(image_accumm.select(['rect_2019']),  {min: 0, max: 168, palette: palt}, 'QCN_STK_Biomass_Accumm 2019', false);

// export as GEE asset
Export.image.toAsset({
    "image": image_static.toFloat(),
    "description": 'am_pclass_static',
    "assetId": dir_output + 'am_pclas_static',
    "scale": 30,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": image_static.geometry()
});  


// export as GEE asset
Export.image.toAsset({
    "image": image_accumm.toFloat(),
    "description": 'am_pclass_accumm',
    "assetId": dir_output + 'am_pclas_accum',
    "scale": 30,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": image_accumm.geometry()
});  


