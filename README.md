# Repro_PMID_29795788
Reproducing Viromic Analysis of Wastewater Input to a River Catchment Reveals a Diverse Assemblage of RNA Viruses

## Install Docker on AWS VM
```
sudo apt-get update 
sudo apt-get install docker-ce
sudo groupadd docker 
sudo usermod -aG docker ubuntu 
sudo service docker restart 
Restart VM
```

## Replication pipeline:
- Pipeline written in Snakemake (pythonic workflow language)
- Located on AWS instance at scripts/Snakefile_replication_PMID29795788
- Requirements to run:
    - Sample file (see sample_manifest)
      - Space-separated file consisting of: 
      `sample_name read1.fastq read2.fastq`
    - Paths (set up in the snakefile - should probably be moved to a config file at some point):
      ```
      adapterFile = 'refs/contaminating_primers.fasta'
      sampleFile = '/home/ubuntu/sample_manifest'
      inDir = '/home/ubuntu/data/'
      dt = datetime.datetime.now().strftime('%Y%m%d%H%M%S')
      outDir = '/home/ubuntu/pipeline_' + dt + '/'
      ```
- To run: 
  `snakemake -s scripts/Snakefile_replication_PMID29795788 --use-singularity --cores 16`
- After running, look for output in pipeline_<datetime>
