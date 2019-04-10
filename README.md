# spaceshell
Guide for analysis of spatial transcriptomic data

## Pre-requisites

We start with a bare Ubuntu Ubuntu Server 18.04 LTS (HVM) instance, 
ami-01b60a3259250381b. Our first step is just to create the conda 
environment, but also to index the genome, so we will begin with just a 
m4.4xlarge instance type with 32GB of storage.

We will create our usual build environment, with everything going into 
`~/local` and building occuring in `~/build` such that root access would 
not be necessary (assuming someone has created a sane build environment). 
After setting up the directory structure, we install 
miniconda to encapsulate the rest of our installation and maintain sanity

```bash
# if not already done
sudo apt-get update
sudo apt-get install -y build-essential zlib1g-dev libbz2-dev liblzma-dev \
      libssl-dev libcurl4-openssl-dev libgfortran-8-dev


# if you don't have these already
mkdir ~/local
mkdir ~/local/share
mkdir ~/local/share/genomes

mkdir ~/build

# download a genome
cd ~/local/share/genomes
wget ftp://ftp.ensembl.org/pub/release-96/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa.gz
wget ftp://ftp.ensembl.org/pub/release-96/gtf/mus_musculus/Mus_musculus.GRCm38.96.gtf.gz
gunzip *.gz

# Install miniconda (NOT miniconda2) into ~/local/share/miniconda
cd ~/build
wget https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
chmod 755 Miniconda-latest-Linux-x86_64.sh
# run the installer. When prompted, tell it to install into 
~/local/share/miniconda, and agree to add it to your PATH
./Miniconda-latest-Linux-x86_64.sh

# start a new bash to pickup the updated PATH from the Miniconda install
bash
conda config --add envs_dirs '~/local/share/miniconda/envs'

```

Now we can create our environment.

```bash

# TO DO: Some of these dependencies may be unnecessary
conda create -p ~/local/share/miniconda/envs/spaceshell python numpy \
    scipy pandas pyyaml matplotlib pip 

source activate spaceshell
pip install --upgrade pip
conda install libgfortran==1
conda install -c bioconda star

```

And install the pipeline

```pip 
pip install stpipeline

```
Next we need to generate a STAR index for the genome
```bash
STAR --runThreadN 15 \
    --runMode genomeGenerate \
    --genomeDir ~/local/share/genomes \
    --genomeFastaFiles ~/local/share/genomes/Mus_musculus.GRCm38.dna_sm.primary_assembly.fa \
    --sjdbGTFfile ~/local/share/genomes/Mus_musculus.GRCm38.96.gtf 

```
