#Welcome packages into the script
library(tidyr)
library(dplyr)

#Load in both spreadsheets (taxa and metadata) don't forget actions!

metadata <- read.csv("~/Desktop/Bogar Lab/metadatawlocations.csv")

taxa <- read.csv("~/Desktop/Bogar Lab/FinalSTtaxon.csv")
taxa1 = separate(taxa, tip.ID, into = c("treetreatment",  "tip"), sep = "-")

taxa2 = separate(taxa1, treetreatment, into = c("nothing", "tree", "treatment", "silicatreatment"), sep = "")

taxa3 = select(taxa2, (!(nothing)))
taxa3$silicatreatment = replace_na(taxa3$silicatreatment, "")
taxa3 = taxa3 %>%unite("silicatreatment", 3:4, sep = "")
taxa4 = taxa3 %>%unite("tip.ID", 2:4, sep = "-")

md.w.Loc = full_join(metadata, taxa4, by = "tip.ID")

write.csv(md.w.Loc, "~/Desktop/Bogar Lab/Meta Data with ST taxa.csv")
