#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Dec  2 13:24:21 2022

@author: wzheng
"""

import os
import sys
import glob
import argparse
import pandas as pd
import csv


def illumina_sample_sheet(library, indexs, output, eln):
    # make library sheet into list -> index_well with column Index well used, sample name and Index plate
    df = pd.read_excel(library, skiprows=4)
    index_well = df[['Index well used', 'Sample Name', 'Index plate']].dropna().apply(list, axis=1).tolist()
    
    # match the index well's Index plate into index form
    for i in index_well:
        
        #Plate A
        if i[2] == 'IDT for Illumina UD Indexes Plate A':
            df2 = pd.read_excel(indexs, skiprows=1, sheet_name = 'Plate A')
            i7=df2.loc[df2['Well ID'] == i[0]]['i7 Bases for Sample Sheet'].to_string(index=False).strip()
            i5=df2.loc[df2['Well ID'] == i[0]]['i5 Bases for Sample Sheet NovaSeq 6000 with v1.0 reagent kits, MiSeq, HiSeq 2000/2500, NextSeq 2000 (Sample Sheet v2)'].to_string(index=False).strip()
       
        #Plate B
        elif i[2] == 'IDT for Illumina UD Indexes Plate B':
            df2 = pd.read_excel(indexs, skiprows=1, sheet_name = 'Plate B')
            print(df2)
            i7=df2.loc[df2['Well ID'] == i[0]]['i7 Bases for Sample Sheet'].to_string(index=False).strip()
            i5=df2.loc[df2['Well ID'] == i[0]]['i5 Bases for Sample Sheet NovaSeq 6000 with v1.0 reagent kits, MiSeq, HiSeq 2000/2500, NextSeq 2000 (Sample Sheet v2)'].to_string(index=False).strip()
        #Plate C
        elif i[2] == 'IDT for Illumina UD Indexes Plate C':
            df2 = pd.read_excel(indexs, skiprows=2, sheet_name = 'Plate C')
            i7=df2.loc[df2['Well ID'] == i[0]]['i7 Bases for Sample Sheet'].to_string(index=False).strip()
            i5=df2.loc[df2['Well ID'] == i[0]]['i5 Bases for Sample Sheet NovaSeq 6000 with v1.0 reagent kits, MiSeq, HiSeq 2000/2500, NextSeq 2000 (Sample Sheet v2)'].to_string(index=False).strip()
        
        #Plate D
        else:
            df2 = pd.read_excel(indexs, skiprows=2, sheet_name = 'Plate D')
            i7=df2.loc[df2['Well ID'] == i[0]]['i7 Bases for Sample Sheet'].to_string(index=False).strip()
            i5=df2.loc[df2['Well ID'] == i[0]]['i5 Bases for Sample Sheet NovaSeq 6000 with v1.0 reagent kits, MiSeq, HiSeq 2000/2500, NextSeq 2000 (Sample Sheet v2)'].to_string(index=False).strip()
        i.append(i7)
        i.append(i5)
        i.append(eln)
        i.remove(i[0])
        i.remove(i[1])
    
    #if eln does not be provided
    if eln is None:
            index_well.insert(0, ['Sample_ID', 'index', 'index2'])
    else:
        index_well.insert(0, ['Sample_ID', 'index', 'index2', 'Sample_Project'])
    
    # Write header and bclsetting into samplesheet
    head = ["[Header]", None, None, None]
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
        for i in index_well:
            writer.writerow(i)

def main():
    illumina_sample_sheet('Library_QC_and_pooling.xlsx', 'UD\\Index\\Plates\\A\\-\\D.xlsx', 'samplesheet_demux.csv', 'EXP200230012')
if __name__ == "__main__":
    main()
