#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Feb 22 11:14:28 2023

@author: wzheng
"""

import os
import sys
import glob
import argparse
import pandas as pd
import csv

def neb_sample_sheet(library, indexs, output, eln):
    df = pd.read_excel(library, skiprows=[0,1,3])
    index_well = df[['Index well used', 'Sample Name', 'Index plate']].dropna().apply(list, axis=1).tolist()
    for i in index_well:
        #set1
        if i[2] == 'NEBNext Multiplex Oligos for Illumina (96 UDI) set1':
            if i[0][1] == '0':
                used_index = i[0][0]+i[0][-1]
            else:
                used_index = i[0]
            #print(used_index)
            df2 = pd.read_excel(indexs, skiprows=2, sheet_name = 'set1')
            i7=df2.loc[df2['WELL POSITION'] == used_index]['Unnamed: 2'].to_string(index=False).strip()
            i5=df2.loc[df2['WELL POSITION'] == used_index]['FORWARD STRAND WORKFLOW*'].to_string(index=False).strip()
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
    neb_sample_sheet('$library', '$indexs', '$eln')

if __name__ == "__main__":
    main()


