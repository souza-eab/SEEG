
Map.setCenter(-64.529,-2.746, 5);
//Import Bullock data
var bull_deg = ee.Image("users/bullocke/amazon/public/Bullock_Amazon_Condensed");
//open Bullock dataset, print metadata in console and add for visualization
 print(bull_deg);
//select type of change 1=degradation; 2=deforestation
 var degrad = bull_deg.select('Type1');
 
// Create a binary mask for deforestation
 var mask = degrad.eq(1);
// Update the type 1 band mask with the deforestation mask.
 var masked_deg = degrad.updateMask(mask);
// add map for visualization
 Map.addLayer(masked_deg, {
 palette: ['#FFFF00' ]}, 'Bullocke' );
