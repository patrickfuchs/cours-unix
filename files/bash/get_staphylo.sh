#! /usr/bin/env bash

# Pierre Poulain 2018

# define directories with data
dir_input="genomes"
dir_output="staphylo"

# uncompress initial file
tar zxf genomes.tgz

# create empty directory for Staphylococcus genomes
mkdir ${dir_output}

# loop on all genbank files
for name in $(ls ${dir_input}/*.gbk)
do
    # get organism name
    orga=$(awk '/ORGANISM/{print $2}' ${name})

    # select Staphylococcus files only
    if [[ ${orga} = "Staphylococcus" ]]
    then
        # print filename with Staphylococcus
        echo "${name} is a Staphylococcus"
        # copy Staphylococcus files into staphylo directory
        cp ${name} ${dir_output}
    fi
done

# create final archive
tar zcf staphylo.tgz ${dir_output}/

# delete data directories
rm -rf ${dir_input} ${dir_output}
