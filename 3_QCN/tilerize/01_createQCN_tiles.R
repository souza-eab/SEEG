## rasterize QCN vectors 
## dhemerson.costa@ipam.org.br

## read libraries
library(sf)
library(st)
library(stars)
library(raster)

## user parameters
## path with QCN vectors 
root <- "../vector/qcn_veg_pret"

## define filename of vector to be rasterized
vector  <- st_make_valid(read_sf(dsn= root, layer= "merge_biomes"))

## define tiles file
tiles <- read_sf(dsn= root, layer='tiles_biomes')

####### end of user parameters, don't change after this line ########
## rasterize fieldnames per tile and stack bands 
for (i in 1:nrow(tiles)) {
  print(paste0('processing tile ', i, ' from ', nrow(tiles)))
  ## read tile i
  tile_i <- tiles[i,]
  ## clip vector for the tile i
  vec_i <- st_intersection(vector, tile_i)
  ## create mask
  mask <- raster(crs=projection(vec_i), ext= extent(vec_i)); res(mask) = 0.00025
  ## convert to stars
  mask <- st_as_stars(mask)
  
  ## rasterize each field
  r_cagb <- st_rasterize(vec_i['cagb'], template= mask)
  r_cbgb <- st_rasterize(vec_i['cbgb'], template= mask)
  r_cdw  <- st_rasterize(vec_i['cdw'], template= mask)
  r_clitter <- st_rasterize(vec_i['clitter'], template= mask)
  r_total <- st_rasterize(vec_i['ctotal4inv'], template= mask)
  
  ## exportar
  write_stars(r_cagb, paste0('./output/cagb/', 'tile_', i, '_cagb.tif'), type="Float32", drive="GTiff")
  write_stars(r_cbgb, paste0('./output/cbgb/', 'tile_', i, '_cbgb.tif'), type="Float32", drive="GTiff")
  write_stars(r_cdw, paste0('./output/cdw/', 'tile_', i, '_cdw.tif'), type="Float32", drive="GTiff")
  write_stars(r_clitter, paste0('./output/clitter/', 'tile_', i, '_clitter.tif'), type="Float32", drive="GTiff")
  write_stars(r_cagb, paste0('./output/total/', 'tile_', i, '_total.tif'), type="Float32", drive="GTiff")
  
  ## clean cache
  rm(tile_i, vec_i, mask, r_cagb, r_cbgb, r_cdw, r_clitter, r_total)
  gc()
  
}
