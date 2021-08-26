// export parameters
var gfolder = 'TEMP';                // google drive folder 
var assetId = 'insert-here-a-asset'; // asset link

// define data path
var dir = 'projects/mapbiomas-workspace/SEEG/2020/cobertura-c5-v1-classe19';

// define filenames prefix
var prefix = 'SEEG_2020_c6_';

// define years to be processed
var listYears = [1989, 1990, 1991, 1992, 1993, 1994, 1995, 
                 1996, 1997, 1998, 1999, 2000, 2001, 2002,
                 2003, 2004, 2005, 2006, 2007, 2008, 2009, 
                 2010, 2011, 2012, 2013, 2014, 2015, 2016,
                 2017, 2018, 2019,2020];

// create empty recipe to receive each image and stack as a new band
var recipe = ee.Image([]);

// for each year
listYears.forEach(function(stack_img){
  // read image for the year i
  var image_i = ee.Image(dir + '/' + prefix + stack_img);
  // stack into recipe
  recipe = recipe.addBands(image_i);
});

// print stacked data
print(recipe);

// export as gdrive file
    Export.image.toDrive({
    image: recipe,
    description: prefix + 'stacked',
    folder: gfolder,
    scale: 30,
    fileFormat: 'GeoTIFF',
    region: recipe.geometry(),
    maxPixels: 1e13
    });

// export as GEE asset 
/*
Export.image.toAsset({
    'image': recipe,
    'description': prefix + 'stacked',
    'assetId': assetId + prefix + 'stacked',
    'pyramidingPolicy': {
        '.default': 'mode'
    },
    'region': recipe.geometry(),
    'scale': 30,
    'maxPixels': 1e13
});
*/


