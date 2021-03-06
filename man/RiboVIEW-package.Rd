\docType{package}
\name{RiboVIEW-package}
\alias{RiboVIEW}
\alias{RiboVIEW-package}
\title{Visualization, quality control and statistical analysis of ribosome profiling data}
\description{
Tools to visualize ribosome profiling (RiboMine) and to perform robust 
  statistic and quality control of the data (RiboQC). We offer the user a webpage 
  view to scan own data on the following aspects: periodicity, ligation and 
  digestion of footprints; reproducibility and batch effects of replicates; 
  drugs-related artifacts; codon enrichment including variability observed between 
  mRNAs/positions for A, P and E sites; mining of causal or confounding factors.
  
This is a template workflow corresponding to the package vignette Intro_RiboVIEW.pdf.
  The package vignette contains additional information such as command results, 
  plots, and explanations. The following R command :
  
  'vignette("Intro_RiboVIEW")'
  
  can be used to display the vignette.
  
}
\examples{
\donttest{

# Sequenced reads aligned to mRNA (and containing no rRNA, depleted previously),
#   in bam format
readsBAM.1.1  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                              "/extdata/Cond1-Rep1.bam",sep="")
readsBAM.1.2  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                              "/extdata/Cond1-Rep2.bam",sep="")
readsBAM.1.3  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                              "/extdata/Cond1-Rep3.bam",sep="")
readsBAM.2.1  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                              "/extdata/Cond2-Rep1.bam",sep="")
readsBAM.2.2  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                              "/extdata/Cond2-Rep2.bam",sep="")
readsBAM.2.3  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                              "/extdata/Cond2-Rep3.bam",sep="")

list.bam <- list(readsBAM.1.1, readsBAM.1.2, readsBAM.1.3, 
                 readsBAM.2.1, readsBAM.2.2, readsBAM.2.3)


#
## Experimental conditions, in text and as indicators :
#    0 for control
#    1 for a condition, treatment, case, etc...
#    2, 3, etc. for further conditions

XP.conditions   <- c("cond1","cond1","cond1","cond2", "cond2","cond2")
XP.conditions.i <- c( 1,1,1,2,2,2)
XP.names        <- c("C1.R1", "C1.R2", "C1.R3", 
                     "C2.R1", "C2.R2", "C2.R3")

#
## Reference annotation for mRNAs' CDS.
#

refCDS <- paste(system.file(package="RiboVIEW", mustWork = TRUE), "/extdata/synth.tsv", sep="")
# Note : CDS annotation can be obtained from a GTF file, 
#        using gtf2table(my-gtf-file, outfile = my-cds-file)
#        (for example GTF file as provided by Ensembl.org work well with gtf2table)

#
## Reference sequences for mRNAs.
#

refFASTA <- paste(system.file(package="RiboVIEW", mustWork = TRUE), "/extdata/synth.fasta", sep="")

#
## Work and output folder.
#

pathout  <-  paste(tempdir(),"/", sep="")
  ## !! This is a temporary directory, which will be erased when you leave R !!
  ##   For your own analyses you would probably prefer to point to a permanent repository :
  #      pathout <- /home/me/address-to-my-output-repository/ # Define address, 
  #                                                   #including a final slash.
  #      system(paste('mkdir',pathout)) # Create folder at said address.
  #      setwd(pathout)  # Go to this directory. This is useful if you want to 
  #                                         #save additional tables or figures.

# 
## A-site coverage periodicity by length
#

periodicity(list.bam, refCDS, refFASTA, pathout, XP.names, versionStrip = FALSE)

# 
## Select footprint length with sufficient periodicity
#

attach(listminmax <- select.FPlen(list.bam, pathout, XP.names))

#
## Codon occupancy, codon enrichment.
# 

enrichmentNoccupancy(list.bam, refCDS, refFASTA, mini, maxi, XP.names,  
                       pathout, versionStrip = FALSE)
 
#
## Visualisation.
#

generate.m.s(XP.conditions, XP.names, pathout, B=1000)

visu.m.s.enrichmnt.res <- visu.m.s.enrichmnt(XP.conditions, XP.names, pathout)
visu.m.s.enrichmnt.res

visu.tracks.res <- visu.tracks(XP.conditions, XP.names, pathout, refCDS, 
                               mRNA="random", 
                               codon.labels=FALSE, codon.col="darkslateblue")
visu.tracks.res

Venn.all.res <- Venn.all(XP.names, pathout)
Venn.all.res

enricht.aroundA.res <- enricht.aroundA(XP.conditions, 
  XP.names, pathout)
enricht.aroundA.res


#
## Replicates.
#

repl.correl.counts.Venn.res <- repl.correl.counts.Venn(XP.conditions, XP.names, 
                                                       pathout)
repl.correl.counts.Venn.res

repl.correl.gene.res <- repl.correl.gene(XP.conditions, XP.names, pathout)
repl.correl.gene.res

repl.correl.codon.res <- repl.correl.codon(list.bam, refCDS, refFASTA, 
                                           mini, maxi, 
                                           XP.names, XP.conditions, pathout)
repl.correl.codon.res

repl.correl.heatmap.res <- repl.correl.heatmap(XP.conditions.i, XP.names, pathout)
repl.correl.heatmap.res

#
## Potential artefacts due to Cycloheximide or other drugs
#

chx.artefacts.res <- chx.artefacts(XP.conditions, XP.names, pathout)
chx.artefacts.res

#
## Nucleotide and codon frequency at footprint boundaries.
#

ntcodon.freq.nt.res <- ntcodon.freq.nt(XP.conditions, XP.names, pathout)
ntcodon.freq.nt.res

ntcodon.freq.cod.res <- ntcodon.freq.cod(XP.conditions, XP.names, pathout)
ntcodon.freq.cod.res

#
## Batch effects
#

batch.effects.lm.e.res <- batch.effects.lm.e(XP.conditions, XP.names, pathout)
batch.effects.lm.e.res

batch.effects.pca.res <- batch.effects.pca(XP.conditions, XP.names, pathout)
batch.effects.pca.res

#
## Metagene
#

metagene.res <- metagene.all(XP.conditions, XP.names, pathout) 

##   Efficacy of monosome selection

metagene.monosome.res <- metagene.res[[1]]
metagene.monosome.res

##   Inflation of CDS-start codons coverage

metagene.inflation.res <- metagene.res[[2]]
metagene.inflation.res

##   Leakage of start and stop codons,

metagene.leakage.res <- metagene.res[[3]]
metagene.leakage.res

#
## Output Page in Html, readable in firefox, brave, chrome, safari or internet explorer.
#

outputQc(pathout, XP.conditions)

outputMine(pathout, XP.conditions)



}
\dontshow{

  # Sequenced reads aligned to mRNA (and containing no rRNA, depleted previously),
  #   in bam format
  readsBAM.1.1  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                                "/extdata/Cond1-Rep1.bam",sep="")
  readsBAM.1.2  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                                "/extdata/Cond1-Rep2.bam",sep="")
  readsBAM.1.3  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                                "/extdata/Cond1-Rep3.bam",sep="")
  readsBAM.2.1  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                                "/extdata/Cond2-Rep1.bam",sep="")
  readsBAM.2.2  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                                "/extdata/Cond2-Rep2.bam",sep="")
  readsBAM.2.3  <- paste(system.file(package="RiboVIEW", mustWork = TRUE), 
                                                "/extdata/Cond2-Rep3.bam",sep="")

  list.bam <- list(readsBAM.1.1, readsBAM.1.2, readsBAM.1.3, 
                   readsBAM.2.1, readsBAM.2.2, readsBAM.2.3)


  #
  ## Experimental conditions, in text and as indicators :
  #    0 for control
  #    1 for a condition, treatment, case, etc...
  #    2, 3, etc. for further conditions

  XP.conditions   <- c("cond1","cond1","cond1","cond2", "cond2","cond2")
  XP.conditions.i <- c( 1,1,1,2,2,2)
  XP.names        <- c("C1.R1", "C1.R2", "C1.R3", 
                       "C2.R1", "C2.R2", "C2.R3")

  #
  ## Reference annotation for mRNAs' CDS.
  #

  refCDS <- paste(system.file(package="RiboVIEW", mustWork = TRUE), "/extdata/synth.tsv", sep="")
  # Note : CDS annotation can be obtained from a GTF file, 
  #        using gtf2table(my-gtf-file, outfile = my-cds-file)
  #        (for example GTF file as provided by Ensembl.org work well with gtf2table)

  #
  ## Reference sequences for mRNAs.
  #

  refFASTA <- paste(system.file(package="RiboVIEW", mustWork = TRUE), "/extdata/synth.fasta", sep="")

  #
  ## Work and output folder.
  #

  pathout  <-  paste(tempdir(),"/", sep="")
    ## !! This is a temporary directory, which will be erased when you leave R !!
    ##   For your own analyses you would probably prefer to point to a permanent repository :
    #      pathout <- /home/me/address-to-my-output-repository/ # Define address, 
    #                                                   #including a final slash.
    #      system(paste('mkdir',pathout)) # Create folder at said address.
    #      setwd(pathout)  # Go to this directory. This is useful if you want to 
    #                                         #save additional tables or figures.

  # 
  ## A-site coverage periodicity by length
  #

  suppressMessages(periodicity(list.bam, refCDS, refFASTA, pathout, XP.names, 
                               versionStrip = FALSE,
                               python.messages=FALSE))

  # 
  ## Select footprint length with sufficient periodicity
  #

  attach(listminmax <- select.FPlen(list.bam, pathout, XP.names))

  #
  ## Codon occupancy, codon enrichment.
  # 

  enrichmentNoccupancy(list.bam, refCDS, refFASTA, mini, maxi, XP.names,  
                         pathout, versionStrip = FALSE,
                         r.messages=FALSE,
                         python.messages=FALSE)
   
  #
  ## Visualisation.
  #

  generate.m.s(XP.conditions, XP.names, pathout, B=1000)

  visu.m.s.enrichmnt.res <- visu.m.s.enrichmnt(XP.conditions, XP.names, pathout)
  
  visu.tracks.res <- visu.tracks(XP.conditions, XP.names, pathout, refCDS, 
                                 mRNA="random", 
                                 codon.labels=FALSE, codon.col="darkslateblue")
  
  Venn.all.res <- Venn.all(XP.names, pathout, r.messages=FALSE)
 
  enricht.aroundA.res <- enricht.aroundA(XP.conditions, 
    XP.names, pathout)


  #
  ## Replicates.
  #

  repl.correl.counts.Venn.res <- repl.correl.counts.Venn(XP.conditions, XP.names, 
                                                         pathout, r.messages=FALSE)
 
  repl.correl.gene.res <- repl.correl.gene(XP.conditions, XP.names, pathout)
 
  repl.correl.codon.res <- repl.correl.codon(list.bam, refCDS, refFASTA, 
                                             mini, maxi, 
                                             XP.names, XP.conditions, pathout)

  repl.correl.heatmap.res <- repl.correl.heatmap(XP.conditions.i, XP.names, pathout)

  #
  ## Potential artefacts due to Cycloheximide or other drugs
  #

  chx.artefacts.res <- chx.artefacts(XP.conditions, XP.names, pathout)

  #
  ## Nucleotide and codon frequency at footprint boundaries.
  #

  ntcodon.freq.nt.res <- ntcodon.freq.nt(XP.conditions, XP.names, pathout)

  ntcodon.freq.cod.res <- ntcodon.freq.cod(XP.conditions, XP.names, pathout)

  #
  ## Batch effects
  #

  batch.effects.lm.e.res <- batch.effects.lm.e(XP.conditions, XP.names, pathout)
 
  batch.effects.pca.res <- batch.effects.pca(XP.conditions, XP.names, pathout)
 
  #
  ## Metagene
  #

  metagene.res <- metagene.all(XP.conditions, XP.names, pathout) 

  ##   Efficacy of monosome selection

  metagene.monosome.res <- metagene.res[[1]]

  ##   Inflation of CDS-start codons coverage

  metagene.inflation.res <- metagene.res[[2]]

  ##   Leakage of start and stop codons,

  metagene.leakage.res <- metagene.res[[3]]

  #
  ## Output Page in Html, readable in firefox, brave, chrome, safari or internet explorer.
  #

  outputQc(pathout, XP.conditions)

  outputMine(pathout, XP.conditions)

}
}


