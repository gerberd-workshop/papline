<!DOCTYPE html>

<html>

<head>

<meta charset="utf-8" />
<meta name="generator" content="pandoc" />
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

<!-- code folding -->




</head>

<body>


<div class="container-fluid main-container">




<div id="header">




</div>


<div id="overall-description-of-papline" class="section level1">
<h1>Overall description of PAPline</h1>
<div id="introduction" class="section level2">
<h2>Introduction</h2>
<p>PAPline is an abbreviation for “Performing Archaeogenetic Pipeline”, it can be downloaded from <a href="www.github.com/gerberd-workshop/papline">here</a> and used freely under Debian based Linux distributions. This pipeline was written in bash and is supplemented by scripts written in R and python v3.8.10 programming languages. The program aims to analyse raw sequencing data and perform read alignment, apply various data filtering methods, and finally provide summary tables about the run with additional haplogroup assessments, genetic sex determinations, aneuploidies, etc. The concept of ‘PAPline’ is highly similar to the <a href="https://paleomix.readthedocs.io/en/stable/">Paleomix</a> and the <a href="https://eager.readthedocs.io/en/latest/">EAGER</a> softwares, however, we aimed to create a program that needs only a few adjustments before actual application, and is also user friendly. Regular updates are planned for PAPline in the future by releasing new versions every second year.</p>
</div>
<div id="dependencies-prerequisites" class="section level2">
<h2>Dependencies &amp; prerequisites</h2>
<p>The following tools and softwares are required for PAPline:</p>
<table>
<thead>
<tr class="header">
<th><strong>Name</strong></th>
<th><strong>Available from</strong></th>
<th><strong>Ubuntu repository</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>ANGSD</td>
<td><a href="http://www.popgen.dk/angsd/index.php/ANGSD" class="uri">http://www.popgen.dk/angsd/index.php/ANGSD</a> </td>
<td></td>
</tr>
<tr class="even">
<td>bamtools</td>
<td><a href="https://github.com/pezmaster31/bamtools" class="uri">https://github.com/pezmaster31/bamtools</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>bamUtil</td>
<td><a href="https://github.com/statgen/bamUtil" class="uri">https://github.com/statgen/bamUtil</a> </td>
<td></td>
</tr>
<tr class="even">
<td>bedtools</td>
<td><a href="https://bedtools.readthedocs.io/en/latest/" class="uri">https://bedtools.readthedocs.io/en/latest/</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>Bowtie2</td>
<td><a href="http://bowtie-bio.sourceforge.net/bowtie2/index.shtml" class="uri">http://bowtie-bio.sourceforge.net/bowtie2/index.shtml</a> </td>
<td>✔</td>
</tr>
<tr class="even">
<td>BWA</td>
<td><a href="https://github.com/lh3/bwa" class="uri">https://github.com/lh3/bwa</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>ContamMix</td>
<td>contact Philip L.F. Johnson <a href="mailto:plfj@umd.edu">plfj@umd.edu</a> </td>
<td></td>
</tr>
<tr class="even">
<td>cutadapt</td>
<td><a href="https://github.com/marcelm/cutadapt" class="uri">https://github.com/marcelm/cutadapt</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>FastQC</td>
<td><a href="https://github.com/s-andrews/FastQC" class="uri">https://github.com/s-andrews/FastQC</a> </td>
<td>✔</td>
</tr>
<tr class="even">
<td>Haplogrep2</td>
<td><a href="https://github.com/seppinho/haplogrep-cmd" class="uri">https://github.com/seppinho/haplogrep-cmd</a> </td>
<td></td>
</tr>
<tr class="odd">
<td>Mafft</td>
<td><a href="https://mafft.cbrc.jp/alignment/software/" class="uri">https://mafft.cbrc.jp/alignment/software/</a> </td>
<td>✔</td>
</tr>
<tr class="even">
<td>MapDamage</td>
<td><a href="https://ginolhac.github.io/mapDamage/" class="uri">https://ginolhac.github.io/mapDamage/</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>plink1.9</td>
<td><a href="https://www.cog-genomics.org/plink2" class="uri">https://www.cog-genomics.org/plink2</a> </td>
<td>✔</td>
</tr>
<tr class="even">
<td>preseq</td>
<td><a href="https://github.com/smithlabcode/preseq" class="uri">https://github.com/smithlabcode/preseq</a> </td>
<td></td>
</tr>
<tr class="odd">
<td>samtools</td>
<td><a href="https://github.com/samtools/samtools" class="uri">https://github.com/samtools/samtools</a> </td>
<td>✔</td>
</tr>
<tr class="even">
<td>SeqPrep</td>
<td><a href="https://github.com/jstjohn/SeqPrep" class="uri">https://github.com/jstjohn/SeqPrep</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>SequenceTools</td>
<td><a href="https://github.com/stschiff/sequenceTools" class="uri">https://github.com/stschiff/sequenceTools</a> </td>
<td></td>
</tr>
<tr class="even">
<td>vcftools</td>
<td><a href="https://vcftools.github.io/index.html" class="uri">https://vcftools.github.io/index.html</a> </td>
<td>✔</td>
</tr>
<tr class="odd">
<td>yLeaf2</td>
<td><a href="https://github.com/genid/Yleaf" class="uri">https://github.com/genid/Yleaf</a> </td>
<td></td>
</tr>
<tr class="even">
<td>admixr</td>
<td>R package at CRAN</td>
<td></td>
</tr>
<tr class="odd">
<td>admixtools</td>
<td>R package at <a href="https://github.com/uqrmaie1/admixtools" class="uri">https://github.com/uqrmaie1/admixtools</a> </td>
<td></td>
</tr>
<tr class="even">
<td>dplyr</td>
<td>R package at CRAN</td>
<td>✔</td>
</tr>
<tr class="odd">
<td>ggplot2</td>
<td>R package at CRAN</td>
<td>✔</td>
</tr>
<tr class="even">
<td>ggrepel</td>
<td>R package at CRAN</td>
<td>✔</td>
</tr>
<tr class="odd">
<td>seqinr</td>
<td>R package at CRAN</td>
<td>✔</td>
</tr>
<tr class="even">
<td>stringr</td>
<td>R package at CRAN</td>
<td>✔</td>
</tr>
<tr class="odd">
<td>tibble</td>
<td>R package at CRAN</td>
<td>✔</td>
</tr>
<tr class="even">
<td>yad</td>
<td>Man page at <a href="https://www.mankier.com/1/yad" class="uri">https://www.mankier.com/1/yad</a> </td>
<td>✔</td>
</tr>
</tbody>
</table>
<p>Also, be sure that your system is up to date. PAPline was mainly written under Ubuntu 18.04 and 20.04, accordingly system updates are recommended to be not older than 2018 versions.</p>
<p>The following parameters are needed to run the PAPline:</p>
<ul>
<li><p>parameter file</p></li>
<li><p>input directory</p></li>
<li><p>output directory</p></li>
<li><p>sample list file</p></li>
</ul>
<p>The parameter file contains information about the run parameters, it can be created by using text editor or the graphical interface of the PAPline. Input and output directories are straightforwardly can be used, while the sample list file needs special attention. This latter file is a csv file of sample names and inner barcodes (when absent, leave this field empty), where each line represents one sample and the corresponding inner barcode sequence, see example:</p>
<table>
<thead>
<tr class="header">
<th><strong>SampleID</strong></th>
<th><strong>P5 barcode</strong></th>
<th><strong>P7 barcode</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>S001</td>
<td>AGTCTAG</td>
<td>AGATCGA</td>
</tr>
<tr class="even">
<td>S002</td>
<td>GGCCTAG</td>
<td>TACAGTA</td>
</tr>
<tr class="odd">
<td>S003</td>
<td>CCAGATA</td>
<td>TTACAGA</td>
</tr>
</tbody>
</table>
<p>However, <strong>the header must be excluded from the actual csv file</strong> and the first line has to be the first sample! After installing PAPline an example sample list file (named as list.csv) is provided in the folder /xmp. No varying columns are allowed in the csv file to avoid mixing samples with one, two or without barcodes.</p>
</div>
<div id="installation" class="section level2">
<h2>Installation</h2>
<p>PAPline does not need to be installed besides, only the above listed softwares are needed to be installed to your PATH. When downloaded, it can be directly run from directory, or can be added to your PATH. Also, you don’t need to install all listed softwares to run PAPline, only those that you are going to use inside a session.</p>
</div>
<div id="options" class="section level2">
<h2>Options</h2>
<p>PAPline is available in the CLI version with a graphical interface panel. for creating the parameter file. When starting a PAPline session from the Terminal by typing <code>papline</code> the following options should appear:</p>
<pre class="console"><code>-a    Auto mode, provide parameterfile, see README
-h    Print this message
-g    Start GUI version</code></pre>
<p>The “auto mode” expects a parameter file, for which an example is available under the /xmp folder in the installed version of the ‘PAPline’, and besides the GUI panel it can be created manually. The parameter file may contain the following options, *marked are essential:</p>
<table>
<colgroup>
<col width="1%" />
<col width="2%" />
<col width="95%" />
</colgroup>
<thead>
<tr class="header">
<th><strong>Name</strong></th>
<th><strong>Type</strong></th>
<th><strong>Description</strong></th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td><code>*workf</code></td>
<td>Multiple choice</td>
<td><p>Setting up the main workflow:</p>
<p><code>FQ</code> (fastq) starts the full pipeline and expects a directory where either gzipped or unzipped <em>fastq</em> files are present. Paired end (PE) read files must contain <strong>R1</strong> and <strong>R2</strong> in the file names and the file extensions must be either <strong><em>fq</em></strong>, <strong><em>fq.gz</em></strong>, <strong><em>fastq</em></strong> or <strong><em>fastq.gz</em></strong>. Single end (SE) read files are expected with <strong>no</strong> <strong>R1</strong> or <strong>R2</strong> present in filenames. Also, <code>FQ</code> option allows more than 2 <em>fastq</em> files per sample, i.e. if a sequencing run resulted in e.g. 3 pairs of <em>fastq</em> files per sample then PAPline can process these as a single sample, but correct formatting is needed for this.</p>
<p><code>BAM</code> expects bam files. </p>
<p><code>PAPLINE</code> indicates the usage of PAPline library structure, i.e. if a run was started and subfolders are created but for some reason the run was interrupted or need to be rerunned, PAPline continues from the last interrupted step instead of deleting all existing libraries, however, fails when expected files to continue with are missing or were being relocated. It uses a <em>papli_log</em> file saved to the <code>indir</code> folder, further described below, that lists out finished steps, and can be maintained manually. </p></td>
</tr>
<tr class="even">
<td><code>*runam</code></td>
<td>STR</td>
<td>The name of the run, if <code>workf=FQ/BAM</code> a folder with the same name will be created at the <code>endir</code> path, or the <code>indir</code> path in case the <code>endir</code> is missing. </td>
</tr>
<tr class="odd">
<td><code>*indir</code></td>
<td>PATH</td>
<td>Path to the input folder containing <em>fastq</em> or <em>bam</em> files or the PAPline file structure, according to <code>workf</code>.</td>
</tr>
<tr class="even">
<td><code>endir</code> </td>
<td>PATH</td>
<td>Path to the output folder, where directory will be created under a name provided in <code>runam</code> when <code>workf=FQ/BAM</code>. Existing directories under the same name will be deleted and re-created, except when the <code>PAPLINE</code> option is <code>TRUE</code>, in which case the <code>endir</code> option will be ignored. </td>
</tr>
<tr class="odd">
<td><code>*listf</code></td>
<td>FILE</td>
<td>The name of the comma separated (<em>csv</em>) file containing samples and corresponding barcodes, without header. Example is given in the /xmp folder. If no barcodes are given, the PAPline automatically skips the <code>btrim</code> and the <code>bdisc</code> options. When the <code>workf=BAM</code> no other columns are considered besides the first with the sample names. No varying columns are allowed in the <em>csv</em> to avoid mixing samples with one, two or without barcodes. PAPline can only process a single data type (PE (paired end), SE (single end), barcoded, or non-barcoded) in a single run. </td>
</tr>
<tr class="even">
<td><code>thred</code></td>
<td>INT</td>
<td>Number of threads used by the PAPline. The default value is <code>24</code>.</td>
</tr>
<tr class="odd">
<td><code>fstqc</code></td>
<td>TRUE/FALSE</td>
<td>When <code>fstgc=TRUE</code> (default option) the PAPline will perform quality checks on each <em>fastq</em> file by using the <code>FastQC</code> software. </td>
</tr>
<tr class="even">
<td><code>bqthr</code></td>
<td>INT</td>
<td>Base quality (BQ) threshold (PHRED score, Illumina based value range 0-62) to be considered in analyses, default is <code>30</code>, if <code>0</code>, no BQ check or filtering will be applied during analyses.</td>
</tr>
<tr class="odd">
<td><code>atrim</code></td>
<td>TRUE/FALSE</td>
<td>Argument to set if Illumina adapters from the end of the sequencing reads should be trimmed off by the PAPline. The default value is <code>FALSE</code>.</td>
</tr>
<tr class="even">
<td><code>p5ada</code></td>
<td>STR</td>
<td>Defines the P5 adapter sequence when <code>workf=FQ</code>.</td>
</tr>
<tr class="odd">
<td><code>p7ada</code></td>
<td>STR</td>
<td>Defines the P7 adapter sequence when <code>workf=FQ</code>.</td>
</tr>
<tr class="even">
<td><code>btrim</code></td>
<td>TRUE/FALSE</td>
<td>When <code>workf=FQ</code> and <code>btrim=TRUE</code> (default option) the PAPline trims off inner barcodes provided in the <em>csv</em> file.</td>
</tr>
<tr class="odd">
<td><code>bdisc</code></td>
<td>TRUE/FALSE</td>
<td>When <code>workf=FQ</code> and <code>bdisc=TRUE</code> (default option) the PAPline discards reads lacking a barcode sequence.</td>
</tr>
<tr class="even">
<td><code>seeds</code></td>
<td>INT</td>
<td>Sets maximum differences in seed for the <code>atrim</code> and the <code>btrim</code> options, as well as the <code>BWA ALN</code> mapping method. The default value is <code>2</code>.</td>
</tr>
<tr class="odd">
<td><code>overl</code></td>
<td>INT</td>
<td>When <code>workf=FQ</code> and <code>overl&gt;0</code>, paired end (PE) reads will be merged to single fragments and saved to a <em>fastq</em> file to create an input for the read mapping. The <code>overl</code> INT parameter gives the number of basepairs to overlap between read pairs. The default value is <code>5</code>. </td>
</tr>
<tr class="even">
<td><code>minle</code></td>
<td>INT</td>
<td>When <code>workf=FQ</code> <code>minle</code> will define the minimum read length of reads to be considered. Shorter reads will be discarded from further analyses. The default value is <code>15</code>.</td>
</tr>
<tr class="odd">
<td><code>*refer</code></td>
<td>FILE</td>
<td>The name of the reference <em>fasta</em> file, which has to be indexed with <code>samtools</code> and <code>BWA</code>.</td>
</tr>
<tr class="even">
<td><code>befer</code></td>
<td>FILE</td>
<td>Filename of the <code>Bowtie2</code> indexed reference file. When using the <code>Bowtie2</code> reference in the graphical interface mode, one has to select one of the indexed reference genome files, and PAPline will automatically trim off the unnecessary tags. When the parameter file is being created manually, the path still has to point to an existing file, i.e. the <code>Bowtie2</code> tag must remain or the PAPline will provide an error message regarding the <code>Bowtie2</code> indexing error. </td>
</tr>
<tr class="odd">
<td><code>align</code></td>
<td>Multiple choice</td>
<td>When <code>workf=FQ</code> the alignment method can be selected using this argument. The available methods are: <code>BWA_Aln</code>, <code>BWA_Mem</code>, <code>Bowtie2_EVF</code> (end-to-end very fast), <code>Bowtie2_EF</code> (end-to-end fast), <code>Bowtie2_ES</code> (end-to-end sensitive), <code>Bowtie2_EVS</code> (end-to-end very sensitive), <code>Bowtie2_LVF</code> (local very fast), <code>Bowtie2_LF</code> (local fast), <code>Bowtie2_LS</code> (local sensitive), and <code>Bowtie2_LVS</code> (local very sensitive). The default method is <code>Bowtie2_EVF</code>. The parameter setted to <code>runam</code> will be added as read groups to <code>Bowtie2</code> mappings.</td>
</tr>
<tr class="even">
<td><code>krbam</code></td>
<td>TRUE/FALSE</td>
<td>When <code>krbam=TRUE</code> the PAPline will keep the initial raw <em>BAM</em> files after various filters were applied. The default is <code>FALSE</code>.</td>
</tr>
<tr class="odd">
<td><code>rmdup</code></td>
<td>TRUE/FALSE</td>
<td>Remove PCR duplicates from the <em>BAM</em> file. The default value is <code>TRUE</code>.</td>
</tr>
<tr class="even">
<td><code>mapqt</code></td>
<td>INT</td>
<td>Mapping quality (MQ) threshold (PHRED score, Illumina based value range 0-62) to be considered in analyses, default is <code>30</code>, if <code>0</code>, no MQ check or filtering will be applied during analyses.</td>
</tr>
<tr class="odd">
<td><code>mapda</code></td>
<td>TRUE/FALSE</td>
<td>Run the <code>MapDamage</code> software to check damage patterns. The default value is <code>TRUE</code>.</td>
</tr>
<tr class="even">
<td><code>cntmx</code></td>
<td>TRUE/FALSE</td>
<td>Run the <code>ContaMix</code> software to assess contamination levels. The default value is <code>FALSE</code>. (It is really slow.)</td>
</tr>
<tr class="odd">
<td><code>ctrim</code></td>
<td>INT</td>
<td>The number of base pairs to be trimmed from both ends of the reads, if <code>ctrim=0</code> this step will be skipped. The default value is <code>2</code>. </td>
</tr>
<tr class="even">
<td><code>mtfas</code></td>
<td>Multiple choice</td>
<td><p>Defines the mode for base calling method to create a mitochondrial DNA <em>fasta</em> file. The available options are:</p>
<p><code>Permissive</code>: At positions where the coverage is equal to the value given by the <code>mtcov</code> argument a base is only called when all reads contain the same base. Below this given threshold no bases are called, above this given threshold the majority rule will be applied. This option is default.</p>
<p><code>Majority rule</code>: The majority rule is applied to call a base, minimum coverage is given by <code>mtcov</code> argument.</p>
<p><code>Random</code>: Calls the base from a randomly selected read if the position is covered at least by the number given in the <code>mtcov</code> argument.</p>
<p><code>None</code>: No <em>fasta</em> file will be created.</p></td>
</tr>
<tr class="odd">
<td><code>mtcov</code></td>
<td>INT</td>
<td>Coverage threshold for calling a base when creating the mitochondrial DNA <em>fasta</em> file. The default value is <code>2</code>. </td>
</tr>
<tr class="even">
<td><code>cotrv</code></td>
<td>TRUE/FALSE</td>
<td>When <code>cotrv=TRUE</code> the PAPline calls only transversions for nuclear genome even if the BED file contains transitions as well, and considers only transversions when assigning the Y chromosome haplogroup. The default value is <code>FALSE</code></td>
</tr>
<tr class="odd">
<td><code>psudo</code></td>
<td>TRUE/FALSE</td>
<td>When <code>psudo=TRUE</code> the PAPline calls pseudohaploid genome. The default value is <code>TRUE</code></td>
</tr>
<tr class="even">
<td><code>disis</code></td>
<td>INT</td>
<td>Indicates the variant quality for calling SNPs of clinical significance. It is similarly calculated as the BQ or MQ, i.e. <code>bqthr=10</code> equals to <code>disis=10</code>. Also, only heterozygous calls are made when <code>disis&gt;0</code> (the default value is <code>30</code>). <code>disis=0</code> indicates skipping this step.</td>
</tr>
<tr class="odd">
<td><code>pigme</code></td>
<td>INT</td>
<td>Indicates the variant quality for calling SNP-s of pigmentation. It is similarly calculated as the BQ or MQ, i.e. <code>bqthr=10</code> equals to <code>pigme=10</code>. Also, only heterozygous calls are made when <code>pigme&gt;0</code> (the default value is <code>4</code>). <code>pigme=0</code> indicates skipping this step.</td>
</tr>
<tr class="even">
<td><code>glqua</code></td>
<td>INT</td>
<td>Defines the genotype likelihood quality. It is similarly calculated as <code>pigme</code> quality. The default value is <code>1</code>. <code>glqua=0</code> indicates skipping this step, only when <code>psudo=FALSE</code></td>
</tr>
<tr class="odd">
<td><code>eigen</code></td>
<td>TRUE/FALSE</td>
<td>When <code>eigen=TRUE</code> the PAPline calls the genotypes and transforms data into EIGENSTRAT format. The default value is <code>FALSE</code></td>
</tr>
<tr class="even">
<td><code>plink</code></td>
<td>TRUE/FALSE</td>
<td>When <code>plink=TRUE</code> the PAPline calls genotypes and transforms data into PLINK format. The default value is <code>FALSE</code></td>
</tr>
</tbody>
</table>
<p>The graphical interface version opens a panel where all of the options listed above can be adjusted and saved.</p>
</div>
<div id="library-structure-of-the-papline" class="section level2">
<h2>Library structure of the PAPline</h2>
<p>The <code>endir</code> option creates a working directory. Under this working directory subdirectories of samples will be created. Besides, PAPline places the final report file and the individual result files here. The final report file contains all the information most frequently needed for an ancient NGS data analysis, <em>e.g.</em> number of reads entered the pipeline, number of reads mapped, average genomic coverage, mitochondrial DNA haplogroup, <em>etc</em>. This report file is formatted in a supplementary-ready format, thus exhaustive manual labour can be saved. Also, the <em>papli_log</em> file is placed here which contains information about the run, i.e. each line represent run step tags marked as true or false, <em>e.g.</em>:</p>
<pre class="console"><code>fstqc_run=T
bqtrm_run=T
atrim_run=F
...</code></pre>
<p>This <em>papli_log</em> file enables the user to take full control over workflow steps, when the <code>papli=TRUE</code>. It switches on and off workflow steps, i.e. all steps set to be <code>F</code> will be processed, whereas steps set to be <code>T</code> or missing from list will be skipped. However, when <code>workf=PAPLINE</code> <code>fastqc_run</code> and <code>bqtrim_run</code> logs files will be ignored because the input for these are raw <em>bam</em> files from outside of the PAPline library structure.</p>
<p><br />
In the sample folders a number of files and other sub-folders can be found, each one contains various files produced by steps of the workflow, <em>e.g.</em> <em>ALNFILES</em> folder contains the finalised <em>bam</em> file(s), <em>etc</em>. Files in the sample folder consist of a number of files, <em>e.g.</em> results of <code>MapDamage</code> run, or the results of coverage calculations.</p>
</div>
<div id="running-papline" class="section level2">
<h2>Running PAPline</h2>
<p>Finally, when everything is set, ‘PAPline’ can be run by using the following command:</p>
<p><code>./papline -a /path/to/parameterfile</code></p>
<p>The running time depends on the hardware, the size of the input files, and the workflow settings. If the parameter file contains discrepancies, the program shuts down and asks for revision. Eigenstrat and PLINK formatted <em>bed</em> and SNP files can be found under the /references folder. The pre-formatted <em>bed</em> files used for the pigmentation and disease essays are located in the same folder. These files can be modified if needed. Besides the basic default pre-formatted <em>bed</em> files contain the dbSNP IDs, the positions of the hg19 chromosomes, the reference and alternate allele, as well as the phenotype of the variants, which data table can be extended or modified at will by new data, except headers.</p>
</div>
<div id="formatting-requirements" class="section level2">
<h2>Formatting requirements</h2>
<p>Since PAPline offers multiple input processing, certain requirements are needed when naming the input files. First, when analysing paired end (PE) reads, each <em>fastq</em> file <strong>must contain r1/R1 and r2/R2 in their names</strong> to distinguish p5 and p7 pairs. Second, when more than two pairs of <em>fastq</em> files exist per sample, the correct filename should look like the following:</p>
<p><code>SAMPLEID_someinfo_otherinfo_PAIRID_someinfo_R1/2_someinfo.fastq</code></p>
<p>Where the <em>SAMPLEID</em> is the ID of the sample, <em>someinfo</em> and <em>otherinfo</em> can be anything while <em>PAIRID</em> also can be anything but these have to be unique for the pair of <em>fastq</em> files. When the filenames are correct the PAPline can do the pairing of the files. Parts of the file name, like <em>SAMPLEID</em>, <em>someinfo</em>, <em>etc</em>. must be separated by single underscores “_”, since PAPline only considers underscore separated parts of the filename for pairing.</p>
</div>
<div id="add-on-tools-provided-within-papline" class="section level2">
<h2>Add-on tools provided within PAPline</h2>
<p>A few independent scripts are available within papline/tools folder. In the future similar scripts may be added to PAPline.</p>
<div id="pcaplot.r" class="section level4">
<h4>PCAplot.r</h4>
<p>This script eases PCA plotting. User have to provide the <em>evec</em> file obtained from Eigensoft’s <code>smartpca</code>, background population and selected population <em>csv</em> files. Each file have to be logically linked within the script. <em>Evec</em> file must remain untouched, while through the <em>csv</em> files the user can manipulate the visualisation of the PCA. The two <em>csv</em> files’ structure is the same, background shall contain populations that the user want to use as background populations on the plot, while selected population file contains the samples or groups/populations to be highlighted. Given this <em>evec</em> file:</p>
<pre class="console"><code>           #eigvals:     7.893     3.939     2.438     1.871 
               I1836     0.0014      0.0042     -0.0001     -0.0007        Iberia_BA
               I1838     0.0013      0.0065     -0.0001     -0.0013         Iberia_C
               I1840     0.0024      0.0038      0.0001      0.0004        Iberia_BA
               I1843     0.0020      0.0063     -0.0000     -0.0006         Iberia_C
               I1851     0.0031     -0.0030      0.0002     -0.0007  Russia_MLBA_Krasnoyarsk
               I1852     0.0032     -0.0023      0.0005     -0.0007  Russia_MLBA_Krasnoyarsk
               I1853     0.0034     -0.0028      0.0002      0.0015  Russia_MLBA_Krasnoyarsk
               I1856     0.0033     -0.0026      0.0001     -0.0002  Russia_MLBA_Krasnoyarsk
               I1887    -0.0025      0.0056      0.0000     -0.0016  Hungary_MN_Vinca
               I1888    -0.0011      0.0010     -0.0006     -0.0000  Hungary_Medieval
               I1889    -0.0025      0.0058     -0.0004     -0.0009  Hungary_MN_Vinca
               I1890    -0.0008      0.0046     -0.0003      0.0006  Hungary_LN_Sopot
               I1891    -0.0013      0.0052      0.0000     -0.0000  Hungary_LN_Sopot
               I1892    -0.0017      0.0028     -0.0004     -0.0000  Hungary_AvarPeriod_German
               I1894    -0.0039      0.0051     -0.0004     -0.0003  Hungary_MN_Vinca
               I1896    -0.0025      0.0058     -0.0003     -0.0005  Hungary_MN_Vinca
               I1899    -0.0018      0.0053     -0.0001     -0.0007  Hungary_LN_Lengyel
               I1900    -0.0021      0.0057     -0.0003      0.0003  Hungary_LN_Lengyel
               I1901    -0.0016      0.0051     -0.0001     -0.0003  Hungary_LN_Lengyel</code></pre>
<p>The <em>csv</em> file should look like this, if we want to highlight all groups, but <em>Hungary_AvarPeriod_German</em>, and also if we want to merge all Hungarian Neolithic samples:</p>
<table>
<thead>
<tr class="header">
<th>pca_pop</th>
<th>name_pop</th>
<th>col_pop</th>
<th>fill_pop</th>
<th>shape_pop</th>
<th>stroke_pop</th>
<th>size_pop</th>
<th>label_pop</th>
<th>label2</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td>Iberia_BA</td>
<td>a</td>
<td>deepskyblue</td>
<td>black</td>
<td>1</td>
<td>0.7</td>
<td>3</td>
<td>Ibérian</td>
<td></td>
</tr>
<tr class="even">
<td>Iberia_C</td>
<td>b</td>
<td>darkslategray</td>
<td>black</td>
<td>7</td>
<td>0.3</td>
<td>3</td>
<td>español</td>
<td></td>
</tr>
<tr class="odd">
<td>Russia_MLBA_Krasnoyarsk</td>
<td>c</td>
<td>olivedrab3</td>
<td>black</td>
<td>12</td>
<td>0.4</td>
<td>3</td>
<td>Россия</td>
<td></td>
</tr>
<tr class="even">
<td>Hungary_MN_Vinca</td>
<td>d</td>
<td>indianred</td>
<td>black</td>
<td>16</td>
<td>0.5</td>
<td>4</td>
<td>Őskori magyar</td>
<td>group1</td>
</tr>
<tr class="odd">
<td>Hungary_LN_Sopot</td>
<td>d</td>
<td>indianred</td>
<td>black</td>
<td>16</td>
<td>0.5</td>
<td>4</td>
<td>Őskori magyar</td>
<td>group2</td>
</tr>
<tr class="even">
<td>Hungary_LN_Lengyel</td>
<td>d</td>
<td>indianred</td>
<td>black</td>
<td>16</td>
<td>0.5</td>
<td>4</td>
<td>Őskori magyar</td>
<td>group3</td>
</tr>
<tr class="odd">
<td>Hungary_Medieval</td>
<td>e</td>
<td>black</td>
<td>firebrick3</td>
<td>21</td>
<td>0.5</td>
<td>3</td>
<td>Medieval_hun</td>
<td></td>
</tr>
</tbody>
</table>
<p>The header names must remain intact, pca_pop have to be the group name within the <em>evec</em> file, name_pop reflects grouping and plotting order during visualisation, col_pop, fill_pop, shape_pop, stroke_pop, size_pop have to be filled logically, while label_pop can be filled with anything while many character types can be used, these names will appear in the legend of the plot. Label2 is yet under construction, it can be left as blank, or be filled with comments. Example files are provided within the folder.</p>
</div>
<div id="str.r" class="section level4">
<h4>str.r</h4>
<p>This script works with Y chromosome STR data, and it provides a subselection of samples depending on step distance. This tool is useful, when samples of interest are “lost” for the high number of samples and high complexity of the STR network. The user shall provide two <em>csv</em> files, one with the database data, and one with the sample(s) of interest, both having the exact same structure. The user can specify the maximum STR step distance, meaning that the script select the samples from the database <em>csv</em> that are within the given step distance of the provided sample <em>csv</em>, thus excluding database samples of too much step distance, i.e. getting rid of unnecessarily distant samples. At the end, the script saves all samples into a <em>ych</em> file, which is the standard input for the <a href="https://www.fluxus-engineering.com/nwpub.htm">Network</a> software. Example for input <em>csv</em> is provided within the folder.</p>
</div>
<div id="supervised_admix_source_selection.r" class="section level4">
<h4>supervised_admix_source_selection.r</h4>
<p>This script helps to create input files for supervised <a href="https://dalexander.github.io/admixture/download.html">Admixture</a> analysis. It needs three input files, the <em>fam</em> file (for details, see <code>Admixture</code> description), an <em>ind</em> file (for details, see Eigensoft description), and a <em>csv</em> file, where the user specifies the source labels and populations. The <em>csv</em> file must <strong>NOT</strong> contain a header, the first column shall contain all selected <strong>source</strong> groups from <em>ind</em> file, the second an arbitrary grouping of these, see example file provided in directory. The script outputs the input for <code>Admixture</code> right away.</p>
</div>
</div>
</div>




</div>

</body>
</html>
