clean.sp <- function(x = x, sp.list = s){
  if(length(sp.list) != length(unique(x$species))){
    W <- x[!(x$species %in% sp.list),]
    WW <- unique(W$species)
    WWM <- match(W$species, WW)
    matched <- WorldFlora::WFO.match(spec.data = WW, WFO.data = back)
    W$species <- matched$scientificName[WWM]
    x[!(x$species %in% sp.list),] <- W
    return(x)
  } else {print('Taxonomy OK!')}
}