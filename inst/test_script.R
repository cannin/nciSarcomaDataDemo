library(nciSarcomaDataDemo)

# DRUG DATA ----
drugAct <- exprs(getAct(nciSarcomaData::drugData))
drugAnnot <- getFeatureAnnot(nciSarcomaData::drugData)[["drug"]]

# MOLECULAR DATA ----
expData <- exprs(nciSarcomaData::molData[["exp"]])
mirData <- exprs(nciSarcomaData::molData[["mir"]])

expAnnot <- getFeatureAnnot(nciSarcomaData::molData)[["exp"]]
mirAnnot <- getFeatureAnnot(nciSarcomaData::molData)[["mir"]]

# SAMPLE DATA ----
sampleAnnot <- getSampleData(nciSarcomaData::molData)

# WRITE TO FILE ----
write.csv(drugAnnot, "inst/extdata/drugAnnot.csv", row.names = FALSE)
write.csv(drugAct, "inst/extdata/drugAct.csv", row.names = FALSE)

write.csv(expData, "inst/extdata/expData.csv", row.names = FALSE)
write.csv(mirData, "inst/extdata/mirData.csv", row.names = FALSE)
write.csv(expAnnot, "inst/extdata/expAnnot.csv", row.names = FALSE)
write.csv(mirAnnot, "inst/extdata/mirAnnot.csv", row.names = FALSE)

write.csv(sampleAnnot, "inst/extdata/sampleAnnot.csv", row.names = FALSE)
