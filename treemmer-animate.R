library(tidyverse)
library(ape)
library(ggtree)
library(gganimate)

# read meta data
meta <- read_csv("treemmer-lm.csv") %>%
  rename(label=ID) %>%
  separate(treemmer, c("Clade", "Type"), extra="merge", sep="_") %>%
  mutate(Clade = ifelse(Clade == "NA", NA, Clade))

# read trees in right order
tree_files <- list.files("frames/", "*.nwk_trimmed_tree_*", full.names=TRUE)
tree_files <- tree_files[order(nchar(tree_files), tree_files)]
tree_files <- rev(tree_files)
tree_files

trees <- purrr:::map(tree_files, function(x){
  read.tree(x) %>%
    fortify(x) %>%
    left_join(meta)
})
class(trees) <- "multiPhylo"


ggt <- ggtree(trees, aes(frame = .id), layout="fan") +
     geom_tippoint(aes(color=Clade, shape=Type), size=3) +
     scale_shape_manual(values= c(19, 2, 1)) +
     theme(legend.position="left") 

# plot as facets
ggt + facet_wrap(~.id)

# save as gif
gga <- gganimate(ggt, "treemmer.gif", interval=.2, ani.width = 1024, ani.height=1024)
