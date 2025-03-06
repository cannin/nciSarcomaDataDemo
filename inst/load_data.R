library(rcellminer)

# LOAD DATA ----
## Load drug activity data, gene expression, and miRNA expression data along with 
## corresponding annotations. Also, load sample (i.e., cell line) annotation data.
## 
## NOTE: 
## check.names=FALSE prevents R from modifying column names; modification 
## may cause issues if it introduces mismatches with sample annotation information.
## header=TRUE reads in the file headers as column names.
##
## drugAct, expData, and mirData are expected to be matrices of numbers
## *Annot variables are expected to be data.frames

## Data
### Contains "negative log[IC50(molar)]" values for drug activity from PMID: 26351324
drugAct <- read.csv("inst/extdata/drugAct.csv", header=TRUE, check.names=FALSE)
### Contains data source identifier and Pubchem Compound IDs (CID); (pubchem.ncbi.nlm.nih.gov/docs/compounds)
drugAnnot <- read.csv("inst/extdata/drugAnnot.csv", header=TRUE, check.names=FALSE)

### Contains "microarray log2 intensity" values using the Affymetrix Exon array taken from PMID: 26351324
expData <- read.csv("inst/extdata/expData.csv", header=TRUE, check.names=FALSE)
### Contains HGNC gene symbol (genenames.org) and Entrez ID (ncbi.nlm.nih.gov/gene/)
expAnnot <- read.csv("inst/extdata/expAnnot.csv", header=TRUE, check.names=FALSE)

### Contains "log2 normalized counts" values using the NanoString microRNA array taken from PMID: 26351324
mirData <- read.csv("inst/extdata/mirData.csv", header=TRUE, check.names=FALSE)
## Contains miRNA ID (e.g., hsa-let-7a-5p) and mirBase Accession (mirbase.org)
mirAnnot <- read.csv("inst/extdata/mirAnnot.csv", header=TRUE, check.names=FALSE)

### Contains sample name (i.e., cell line name) and OncoTree terms (oncotree.mskcc.org)
sampleAnnot <- read.csv("inst/extdata/sampleAnnot.csv", header=TRUE, check.names=FALSE)

# CREATE SAMPLE ANNOTATION ----
## Define sample annotation using the MIAME (Minimum Information About a Microarray Experiment) object
## NOTE: OncoTree terms are manually curated
## 
## sampleData name provides a name for the sample collection
sampleData <- new("MIAME", 
                  name="NCI/DTP Sarcoma Project",
                  samples=list(Name=sampleAnnot$Name,
                               OncoTree1=sampleAnnot$OncoTree1,
                               OncoTree2=sampleAnnot$OncoTree2,
                               OncoTree3=sampleAnnot$OncoTree3,
                               OncoTree4=sampleAnnot$OncoTree4))

# MAKE INDIVIDUAL DATA OBJECTS WITH ExpressionSet ----
## Make ExpressionSet objects for drug activity, gene/miRNA expression data
## NOTE: ExpressionSet objects must be generated from matrices not data.frames
actData <- ExpressionSet(as.matrix(drugAct))
expData <- ExpressionSet(as.matrix(expData))
mirData <- ExpressionSet(as.matrix(mirData))

# ADD ANNOTATIONS TO DATA WITH AnnotatedDataFrame ----
featureData(actData) <- new("AnnotatedDataFrame", data=drugAnnot)
featureData(expData) <- new("AnnotatedDataFrame", data=expAnnot)
featureData(mirData) <- new("AnnotatedDataFrame", data=mirAnnot)

# MERGE INDIVIDUAL MOLECULAR DATA OBJECTS WITH eSetList ----
eSetList <- list()

eSetList[["exp"]] <- expData
eSetList[["mir"]] <- mirData

# MAKE DRUG AND MOLECULAR DATA OBJECTS ----
## NOTE: repeatAct allows the addition of a secondary drug activity data
## We set it to actData as there is a single drug activity data set
drugData <- new("DrugData", act=actData, repeatAct=actData, sampleData=sampleData)
molData <- new("MolData", eSetList=eSetList, sampleData=sampleData)

# SAVE DRUG AND MOLECULAR DATA ----
save(drugData, file="data/drugData.RData")
save(molData, file="data/molData.RData")
