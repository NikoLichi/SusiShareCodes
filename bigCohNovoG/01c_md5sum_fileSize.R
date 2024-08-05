.libPaths(c("/lustre/groups/itg/shared/Rlib/nicolas.lichilin/r_432/", .libPaths()))
.libPaths()

library(tidyverse)


##### Test first file size
# load NOVOGENE file size
# novFsiz <- read_table("yfv/bigCohortNovoG/data/01stBatch/F004_1/Data-X208SC24052197-Z01-F004_1/checkSize.xls", col_names = FALSE)
novFsiz_01 <- read_table("yfv/bigCohortNovoG/data/01stBatch/F004_1/Data-X208SC24052197-Z01-F004_1/checkSize.xls", col_names = FALSE)
novFsiz_02 <- read_table("yfv/bigCohortNovoG/data/01stBatch/F004_2/Data-X208SC24052197-Z01-F004_2/checkSize.xls", col_names = FALSE)
novFsiz <- rbind(novFsiz_01, novFsiz_02) 
colnames(novFsiz) <- c("size","Fname")

# remove ./ from file 
novFsiz$Fname <- gsub("^./","",novFsiz$Fname)


# Loading fileSize Helmholtz
helFsiz <- read_table("yfv/bigCohortNovoG/data/01stBatch/fileSizeToCheck.txt", col_names = FALSE)
colnames(helFsiz) <- c("size","Fname")

# remove pr tof name to make it compatible as key
helFsiz$Fname[1]
# helFsiz$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/X204SC23120804-Z01-F001/","",helFsiz$Fname)
# helFsiz$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/","",helFsiz$Fname)
helFsiz$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/F004_1/Data-X208SC24052197-Z01-F004_1/","",helFsiz$Fname)
helFsiz$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/F004_2/Data-X208SC24052197-Z01-F004_2/","",helFsiz$Fname)



# Remove the last component in entries with four components separated by "/"
helFsiz$Fname <- gsub("(/[^/]+)$", "", helFsiz$Fname)

# Merge lines in both files
Fsize <- left_join(helFsiz, novFsiz, by = c("Fname"))

# Compare size.x and size.y and print the message
Fsize$SameSize <- ifelse(Fsize$size.x == Fsize$size.y, "Same", "NO")




###################### 
# Now testing md5sum #
###################### 

##### Test first md5sum
# load NOVOGENE md5sum
novmd5sum_1 <- read_table("yfv/bigCohortNovoG/data/01stBatch/F004_1/Data-X208SC24052197-Z01-F004_1/md5sum.txt", col_names = FALSE)
novmd5sum_2 <- read_table("yfv/bigCohortNovoG/data/01stBatch/F004_2/Data-X208SC24052197-Z01-F004_2/md5sum.txt", col_names = FALSE)
# novmd5sum <- read_table("yfv/bigCohortNovoG/data/01stBatch/md5sum.txt", col_names = FALSE)
novmd5sum <- rbind(novmd5sum_1, novmd5sum_2)
colnames(novmd5sum) <- c("md5SUM","Fname")


# Loading fileSize Helmholtz
helmd5sum <- read_table("yfv/bigCohortNovoG/data/01stBatch/md5sumtoCheck.txt", col_names = FALSE)
colnames(helmd5sum) <- c("md5SUM","Fname")

# remove pr tof name to make it compatible as key
helmd5sum$Fname[1]
helmd5sum$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/F004_1/Data-X208SC24052197-Z01-F004_1/","",helmd5sum$Fname)
helmd5sum$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/F004_2/Data-X208SC24052197-Z01-F004_2/","",helmd5sum$Fname)
# helmd5sum$Fname <- gsub("^/lustre/groups/itg/teams/kim-hellmuth/projects/yfv/bigCohortNovoG/data/01stBatch/","",helmd5sum$Fname)


## Remove the last component in entries with four components separated by "/" - NOT needed
# helmd5sum$Fname <- gsub("(/[^/]+)$", "", helmd5sum$Fname)

# Merge lines in both files
md5sume <- left_join(helmd5sum, novmd5sum, by = c("Fname"))

# Compare md5SUM.x and md5SUM.y and print the message
md5sume$SameSize <- ifelse(md5sume$md5SUM.x == md5sume$md5SUM.y, "Same", "NO")




