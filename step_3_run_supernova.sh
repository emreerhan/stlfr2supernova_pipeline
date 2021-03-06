#!/bin/bash

source ./profile

export PATH=$SUPERNOVA:$PATH

if [[  ! -f $SUPERNOVA_R1 || ! -f $SUPERNOVA_R2 || ! -f $SUPERNOVA_I1 ]] ; then
    echo "ERROR : $SUPERNOVA_R1 or $SUPERNOVA_R2 or $SUPERNOVA_I1 not exsist !!! Exit ... "
    exit 1; 
fi
#ln -s read-I1_si-TTCACGCG_lane-001-chunk-001.fastq.gz sample_S1_L001_I1_001.fastq.gz
#ln -s read-R1_si-TTCACGCG_lane-001-chunk-001.fastq.gz sample_S1_L001_R1_001.fastq.gz
#ln -s read-R2_si-TTCACGCG_lane-001-chunk-001.fastq.gz sample_S1_L001_R2_001.fastq.gz

ln -s $SUPERNOVA_I1  sample_S1_L001_I1_001.fastq.gz
ln -s $SUPERNOVA_R1  sample_S1_L001_R1_001.fastq.gz
ln -s $SUPERNOVA_R2  sample_S1_L001_R2_001.fastq.gz

echo "supernova run step , this will take a long time ..."
date
tag=`date +_%m_%d_%H_%M_%S`
supernova run --id=$PROJECT_NAME --maxreads=$MAX_READS  --fastqs=./ --localcores=$THREADS --localmem=$MEMORY --nopreflight >supernova_run_"$tag".log 2>supernova_run_"$tag".err || exit 1
echo "supernova mkoutput"
date
tag=`date +_%m_%d_%H_%M_%S`
supernova mkoutput  --minsize=$MINSIZE --style=pseudohap --asmdir="./"$PROJECT_NAME"/outs/assembly" --outprefix="$PROJECT_NAME""_output"  >supernova_mkoutput_"$tag".log  2>supernova_mkoutput_"$tag".err || exit 1
echo "done step 3 ..."
date


