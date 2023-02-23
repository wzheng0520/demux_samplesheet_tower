#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  2 14:32:34 2022

@author: wzheng
"""
import os
import sys
import glob
import argparse
import pandas as pd
import csv
import re


def sequencing_only_samplesheet(library, output, eln, type, override):
    df = pd.read_excel(library, skiprows=[0,1,3])    
    #print(df)
    #samplesheet_df=df[['Sample Name(s)', 'Index 1 (i7) sequences', 'index 2 (i5) sequences        (Forward)                    MiSeq']].fillna('')
    samplesheet_df=df[['Sample Name(s)', 'Index 1 (i7) sequences', 'index 2 (i5) sequences']].fillna('')
    samplesheet_list=samplesheet_df.dropna().apply(list, axis=1).tolist()
    samplesheet_data=[]
    
    for i in samplesheet_list:
        print(i)
        #match the provided 10x Multiome_ATAC format NNNNNNNN	NNNNNNNN	NNNNNNNN	NNNNNNNN
        if re.match('[A-Z]{8} [A-Z]{8} [A-Z]{8} ', i[1], flags=0):
            #Not provide ELN, the sample_project column will not be on there
            if eln is None:
                i.remove('')    #remove empty index 2
                i[1]=i[1].split("	")
                for a in i[1]:
                    samplesheet_data.append([i[0],a])
                if ['Sample_ID', 'index'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index'])
            #ELN are provided
            else:
                i.append(eln)
                i.remove('')
                i[1]=i[1].split("	")
                for a in i[1]:
                    samplesheet_data.append([i[0],a, i[2]])
                if ['Sample_ID', 'index','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index','Sample_Project'])
        
        #10x Multiome_GEX, Illumina, copy from provided samplesheet
        else:
            #Not provide ELN, the sample_project column will not be on there
            if eln is None:
                samplesheet_data.append(i)
                #print(samplesheet_data)
                if ['Sample_ID', 'index', 'index2'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index', 'index2'])
            #ELN are provided
            else:
                i.append(eln)
                samplesheet_data.append(i)
                print(samplesheet_data)
                if ['Sample_ID', 'index', 'index2','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index', 'index2','Sample_Project'])
    #print(samplesheet_data)
    if type=='illumina':
        head = ['[Header]', None, None, None]
        head_contain=['FileFormatVersion', '2', None, None]
        empty_row=['',None, None, None]
        bclsetting=['[BCLConvert_Settings]', None, None, None]
        bclsetting1=['BarcodeMismatchesIndex1', '0', None, None]
        bclsetting2=['BarcodeMismatchesIndex2', '0', None, None]
        bclsetting3=['NoLaneSplitting', 'true', None, None]
        bcldata=['[BCLConvert_Data]', None, None, None]
        with open(output, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(head)
            writer.writerow(head_contain)
            writer.writerow(empty_row)
            writer.writerow(bclsetting)
            writer.writerow(bclsetting1)
            writer.writerow(bclsetting2)
            writer.writerow(bclsetting3)
            writer.writerow(empty_row)
            writer.writerow(bcldata)
            for i in samplesheet_data:
                print(i)
                writer.writerow(i)
    elif type=='10X':
        head = ['[Header]', None, None, None]
        head_contain=['FileFormatVersion', '2', None, None]
        empty_row=['',None, None, None]
        bclsetting=['[BCLConvert_Settings]', None, None, None]
        bclsetting1=['CreateFastqForIndexReads', '1', None, None]
        bclsetting2=['OverrideCycles', override, None, None]
        bclsetting3=['MinimumTrimmedReadLength', '8', None, None]
        bclsetting4=['MaskShortReads', '8', None, None]
        bcldata=['[BCLConvert_Data]', None, None, None]
        with open(output, 'w') as f:
            writer = csv.writer(f)
            writer.writerow(head)
            writer.writerow(head_contain)
            writer.writerow(empty_row)
            writer.writerow(bclsetting)
            writer.writerow(bclsetting1)
            writer.writerow(bclsetting2)
            writer.writerow(bclsetting3)
            writer.writerow(bclsetting4)
            writer.writerow(empty_row)
            writer.writerow(bcldata)
            for i in samplesheet_data:
                writer.writerow(i)
    else:
        raise Exception('Sorry, we do not support this library type')

def main():
    sequencing_only_samplesheet('20230127_SEQonly_SDI-IGH.xlsx', 'test.csv', 'EXP', '10X', 'Y9;I9')
if __name__ == "__main__":
    main()
