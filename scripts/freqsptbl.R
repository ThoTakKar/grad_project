freq.sp.tbl <- function(x = x, y = 5){
  tbl <- as.data.frame(table(x$species)); tbl <- tbl[order(tbl$Freq),]
  tbl <- tbl[tbl$Freq > y,]; tbl$Var1 <- as.character(tbl$Var1)
  # Here I make a new column with just genus ID
  tbl$genus <- gsub(' .*', "", tbl$Var1)
  return(tbl)
}