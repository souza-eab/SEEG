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
var dir_output = 'projects/mapbiomas-workspace/SEEG/2021/QCN_stp2/';
var version = '1';

// Define classes to be assesed as 'reference class' into QCN
var list_classes = [1];
// Define years of Mapbiomas to be compared with QCN reference class
var list_mapb_years = [1985, 1986, 1987, 1988, 1989, 1990, 1991, 1992, 1993, 1994, 1995, 1996, 1997,
                       1998, 1999, 2000, 2001, 2002, 2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010,
                       2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019];

// Define reclassification matrix
var raw_mapbiomas = [3, 4, 5, 9, 10, 11, 12, 13, 14, 15, 18, 19, 20, 21, 22, 23, 24, 25, 26, 29, 30, 31, 32, 33, 36, 39, 41];   // Palets add other new classes 
var design5 =       [3, 4, 0, 0,  0, 0,  12,  0, 0,   0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0, 0];     // Ungroup {Forest) + Grass  

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
var ma_tot = ee.Image('users/edrianosouza/QCN/ma_ctotal4inv');
var soc = ee.Image('users/edrianosouza/soil_co2/BR_SOCstock_0-30_t_ha');

// brazilian states
var states = ee.Image('projects/mapbiomas-workspace/AUXILIAR/estados-2016-raster');
Map.addLayer(states.randomVisualizer(), {}, 'states', false);

// Import LCLUC data
var qcn = ee.Image("projects/mapbiomas-workspace/SEEG/2021/QCN_stp1/mat_3");
var colecao5 = ee.ImageCollection("projects/mapbiomas-workspace/COLECAO5/mapbiomas-collection50-integration-v8").mosaic();

// Plot inspection
Map.addLayer(qcn, {color:'blue'}, "QCN 1985", false);
Map.addLayer(ma_tot, {min: 0, max: 168, palette: palt}, 'CT 1985');

// Import vectorial data
//var eco_regions = ee.FeatureCollection('users/dhconciani/base/ECORREGIOES_CERRADO_V7');

// create empty recipes
var image_static = ee.Image([]);
var image_accumm = ee.Image([]);

// For each QCN reference class [i]
list_classes.forEach(function(class_i) {
  // Mask QCN only to reference class
  var qcn_i = qcn.updateMask(qcn.eq(class_i));
  
  // For each year of MapBiomas
  list_mapb_years.forEach(function(year_j){
    // Mask MapBiomas by QCN
    var mapb_qcn_ij = colecao5.select(['classification_' + year_j]).updateMask(qcn_i.eq(class_i));
    // Perform reclassification according definied matrix
    var mapb_qcn_ij_d5 = mapb_qcn_ij.remap(raw_mapbiomas, design5);
    
    // perform QCN correction by brazilian state - static //
    var ma_tot_rect = ma_tot.where(states.eq(24).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RN
        ma_tot_rect = ma_tot_rect.where(states.eq(25).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PB
        ma_tot_rect = ma_tot_rect.where(states.eq(26).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PE
        ma_tot_rect = ma_tot_rect.where(states.eq(27).and(mapb_qcn_ij_d5.eq(3)), 127.8127795);   // AL
        ma_tot_rect = ma_tot_rect.where(states.eq(28).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SE
        ma_tot_rect = ma_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // BA
        ma_tot_rect = ma_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // MG
        ma_tot_rect = ma_tot_rect.where(states.eq(32).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // ES
        ma_tot_rect = ma_tot_rect.where(states.eq(33).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RJ
        ma_tot_rect = ma_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SP
        ma_tot_rect = ma_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PR
        ma_tot_rect = ma_tot_rect.where(states.eq(42).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SC
        ma_tot_rect = ma_tot_rect.where(states.eq(43).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RS
        ma_tot_rect = ma_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // MS
        ma_tot_rect = ma_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // GO
        ma_tot_rect = ma_tot_rect.rename('rect_' + year_j);
    
    // perform QCN correction by brazilian state - static //
    var ma_tot_rect = ma_tot.where(states.eq(24).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RN
        ma_tot_rect = ma_tot_rect.where(states.eq(25).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PB
        ma_tot_rect = ma_tot_rect.where(states.eq(26).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PE
        ma_tot_rect = ma_tot_rect.where(states.eq(27).and(mapb_qcn_ij_d5.eq(4)), 48.2497191);   // AL
        ma_tot_rect = ma_tot_rect.where(states.eq(28).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SE
        ma_tot_rect = ma_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // BA
        ma_tot_rect = ma_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // MG
        ma_tot_rect = ma_tot_rect.where(states.eq(32).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // ES
        ma_tot_rect = ma_tot_rect.where(states.eq(33).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RJ
        ma_tot_rect = ma_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SP
        ma_tot_rect = ma_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PR
        ma_tot_rect = ma_tot_rect.where(states.eq(42).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SC
        ma_tot_rect = ma_tot_rect.where(states.eq(43).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RS
        ma_tot_rect = ma_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // MS
        ma_tot_rect = ma_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // GO
        ma_tot_rect = ma_tot_rect.rename('rect_' + year_j);
        
         // perform QCN correction by brazilian state - static //
    var ma_tot_rect = ma_tot.where(states.eq(24).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RN
        ma_tot_rect = ma_tot_rect.where(states.eq(25).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PB
        ma_tot_rect = ma_tot_rect.where(states.eq(26).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PE
        ma_tot_rect = ma_tot_rect.where(states.eq(27).and(mapb_qcn_ij_d5.eq(12)), 13.89369925);   // AL
        ma_tot_rect = ma_tot_rect.where(states.eq(28).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SE
        ma_tot_rect = ma_tot_rect.where(states.eq(29).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // BA
        ma_tot_rect = ma_tot_rect.where(states.eq(31).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // MG
        ma_tot_rect = ma_tot_rect.where(states.eq(32).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // ES
        ma_tot_rect = ma_tot_rect.where(states.eq(33).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RJ
        ma_tot_rect = ma_tot_rect.where(states.eq(35).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SP
        ma_tot_rect = ma_tot_rect.where(states.eq(41).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PR
        ma_tot_rect = ma_tot_rect.where(states.eq(42).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SC
        ma_tot_rect = ma_tot_rect.where(states.eq(43).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RS
        ma_tot_rect = ma_tot_rect.where(states.eq(50).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // MS
        ma_tot_rect = ma_tot_rect.where(states.eq(52).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // GO
        ma_tot_rect = ma_tot_rect.rename('rect_' + year_j);
        
    // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
      var ma_tot_rect2 = ma_tot.where(states.eq(24).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RN
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(25).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PB
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(26).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(27).and(mapb_qcn_ij_d5.eq(3)), 127.8127795);   // AL
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(28).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // BA
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // MG
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(32).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // ES
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(33).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RJ
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SP
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PR
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(42).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SC
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(43).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // MS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // GO
          ma_tot_rect2 = ma_tot_rect2.rename('rect_' + year_j);
    }
     // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
      var ma_tot_rect2 = ma_tot.where(states.eq(24).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RN
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(25).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PB
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(26).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(27).and(mapb_qcn_ij_d5.eq(4)), 48.2497191);   // AL
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(28).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // BA
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // MG
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(32).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // ES
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(33).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RJ
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SP
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PR
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(42).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SC
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(43).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // MS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // GO
          ma_tot_rect2 = ma_tot_rect2.rename('rect_' + year_j);
    }
   // perform QCN correction by brazilian state - cumulative - considers the rect of the last year //
    // first year dont have previous year
    if (year_j == 1985) {
      var ma_tot_rect2 = ma_tot.where(states.eq(24).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RN
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(25).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PB
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(26).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(27).and(mapb_qcn_ij_d5.eq(12)), 13.89369925);   // AL
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(28).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // BA
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // MG
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(32).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // ES
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(33).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RJ
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SP
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PR
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(42).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SC
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(43).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // MS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // GO
          ma_tot_rect2 = ma_tot_rect2.rename('rect_' + year_j);
    }
   
    // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
      var r_last_year = image_accumm.select(['rect_' + (year_j -1)]);
      var ma_tot_rect2 = r_last_year.where(states.eq(24).and(mapb_qcn_ij_d5.eq(3)), 127.8127795);   // RN
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(25).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PB
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(26).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(27).and(mapb_qcn_ij_d5.eq(3)), 127.8127795);   // AL
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(28).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // BA
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // MG
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(32).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // ES
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(33).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RJ
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SP
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // PR
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(42).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // SC
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(43).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // RS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // MS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(3)), 127.8127795); // GO
          ma_tot_rect2 = ma_tot_rect2.rename('rect_' + year_j);
    }
     // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
      var r_last_year = image_accumm.select(['rect_' + (year_j -1)]);
      var ma_tot_rect2 = r_last_year.where(states.eq(24).and(mapb_qcn_ij_d5.eq(4)), 48.2497191);   // RN
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(25).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PB
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(26).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(27).and(mapb_qcn_ij_d5.eq(4)), 48.2497191);   // AL
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(28).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // BA
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // MG
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(32).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // ES
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(33).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RJ
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SP
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // PR
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(42).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // SC
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(43).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // RS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // MS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(4)), 48.2497191); // GO
          ma_tot_rect2 = ma_tot_rect2.rename('rect_' + year_j);
    }
     // if year is greater than 1985, considers the previous year
    if (year_j > 1985) {
      var r_last_year = image_accumm.select(['rect_' + (year_j -1)]);
      var ma_tot_rect2 = r_last_year.where(states.eq(24).and(mapb_qcn_ij_d5.eq(12)), 13.89369925);   // RN
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(25).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PB
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(26).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(27).and(mapb_qcn_ij_d5.eq(12)), 13.89369925);   // AL
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(28).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SE
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(29).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // BA
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(31).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // MG
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(32).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // ES
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(33).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RJ
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(35).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SP
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(41).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // PR
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(42).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // SC
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(43).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // RS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(50).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // MS
          ma_tot_rect2 = ma_tot_rect2.where(states.eq(52).and(mapb_qcn_ij_d5.eq(12)), 13.89369925); // GO
          ma_tot_rect2 = ma_tot_rect2.rename('rect_' + year_j);
    }
    
    // add results as a band 
    image_static = image_static.addBands(ma_tot_rect);
    image_accumm = image_accumm.addBands(ma_tot_rect2);
    
  });
});

print('static', image_static);
print('accumulated', image_accumm);

// plot inspection
Map.addLayer(image_static.select(['rect_2019']),  {min: 0, max: 168, palette: palt}, 'static 2019');
Map.addLayer(image_accumm.select(['rect_2019']),  {min: 0, max: 168, palette: palt}, 'accumm 2019');

// export as GEE asset
Export.image.toAsset({
    "image": image_static.toFloat(),
    "description": 'ma_pclass_static_3_all',
    "assetId": dir_output + 'ma_pclas_static_3_all',
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
    "description": 'ma_pclass_accumm_3_all',
    "assetId": dir_output + 'ma_pclas_accum_3_all',
    "scale": 30,
    "pyramidingPolicy": {
        '.default': 'mode'
    },
    "maxPixels": 1e13,
    "region": image_accumm.geometry()
});  
