# load packages
library(dplyr)
library(tidyr)

# loading in tip metadata. Dowload the "Dry Root Sanger 1st test tip metadata" sheet from the lab drive, update the file path here to reflect where it is on your computer
metadata <- read.csv("~/Bogar Lab/Dry root trial/Dry Root Sanger 1st test tip metadata - Sheet1 (1).csv")

# make a new table, that only includes tips that we sequenced
selected = filter(metadata, metadata$Sequencing == 1)
View(selected)

################ analyses we used to confirm our choice of which to sequence:
# calculate the % of selected tips that we had high conf. in their mycorrhizal identity
high = count(selected, selected$mycorrhiza.confidence. == "high")
perc.high = high / (length(selected$mycorrhiza.confidence.))

# same for low conf.
low = count(selected, selected$mycorrhiza.confidence. == "low")
perc.low = low / (length(selected$mycorrhiza.confidence.))

# same for medium conf. 
medium = count(selected, selected$mycorrhiza.confidence. == "medium")
perc.medium = medium / (length(selected$mycorrhiza.confidence.))

###################################### spreadsheet wrangling! 
# loading in the sequencing order form, which contains sequencing plate locations
MCLab.order <- read.csv("~/Bogar Lab/Dry root trial/MCLab Sanger Order 7_8_2024, Bogar Lab, Dustin-Nate-Anna - 5-EW-DL-AG.csv", header=FALSE, comment.char="#")

# drt = dry root trial, Locs = locations. create a table that only has the samples from the dry root trial, not nate's and dustin's samples
drtLocs = filter(MCLab.order, substr(V3, 1,2)=="AG")
# just include the columns that have relevant info
drtLocs = select(drtLocs, V2, V3)

# parse the sample names by the dash separator to remove the "AG"
drtLocs = separate(drtLocs, 2, into = c("me", "tree-storage", "tip.."), sep = "-")

# reunite the storage method and tip number identifiers into a unique "tip.ID"
drtLocs = drtLocs %>% unite("tip.ID", 3:4, sep = "-")

# give the sequencing plate location column a real name
drtLocs = rename(drtLocs, seqPlateLoc = V2)

# actually get rid of the "me" column
drtLocs = drtLocs %>% select(seqPlateLoc, tip.ID)

# for the bigger metatdata sheet: unite the storage method and tip number identifiers into a unique "tip.ID"
metadata = metadata %>% unite("tip.ID", c(1, 2, 4), sep = "-")

# NOW we can join the two tables based on the uniqe tip.ID!! yay
md.w.Loc = full_join(metadata, drtLocs, by = "tip.ID")

# prints out joined CSV
write.csv(md.w.Loc, "~/Bogar Lab/Dry root trial/metadata with ST sequencing plate locations.csv")

# print out a simpler version for inputing sequence data into
write.csv(drtLocs, "~/Bogar Lab/Dry root trial/ST sequencing plate locations.csv")
