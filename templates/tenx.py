#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Dec 12 12:33:25 2022

@author: wzheng
"""

#import os
#import sys
#import glob
#import argparse
import pandas as pd
import csv


def tenx_sample_sheet(library, indexs, output, eln, override):
    # make library sheet into list -> index_well with column Index well used, sample name and Index plate
    df = pd.read_excel(library, skiprows=4)
    index_well = df[['Index well used', 'Sample Name', 'Index plate']].dropna().apply(list, axis=1).tolist()
    
    samplesheet_data=[]
    # match the index well's Index plate into index form
    for i in index_well:        
        
        #Dual Index Kit NN Set A
        if i[2] == '10X Dual Index Kit NN Set A':
            df2 = pd.read_excel(indexs, skiprows=3, sheet_name = 'Dual_Index_Kit_NN_Set_A')
            
            i7=df2.loc[df2['index_name'] == i[0]]['index(i7)'].to_string(index=False).strip()
            i5=df2.loc[df2['index_name'] == i[0]]['index2_workflow_a(i5)'].to_string(index=False).strip()
            i.append(i7)
            i.append(i5)
            i.append(eln)
            i.remove(i[0])
            i.remove(i[1])
            samplesheet_data.append(i)
            if eln is None:
                if ['Sample_ID', 'index', 'index2'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index', 'index2'])
            else:
                if ['Sample_ID', 'index','index2','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index','index2','Sample_Project'])

        #10X Dual Index Kit NT Set A
        elif i[2] == '10X Dual Index Kit NT Set A':
            df2 = pd.read_excel(indexs, skiprows=3, sheet_name = 'Dual_Index_Kit_NT_Set_A')
            i7=df2.loc[df2['index_name'] == i[0]]['index(i7)'].to_string(index=False).strip()
            i5=df2.loc[df2['index_name'] == i[0]]['index2_workflow_a(i5)'].to_string(index=False).strip()
            i.append(i7)
            i.append(i5)
            i.append(eln)
            i.remove(i[0])
            i.remove(i[1])
            samplesheet_data.append(i)
            if eln is None:
                if ['Sample_ID', 'index', 'index2'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index', 'index2'])
            else:
                if ['Sample_ID', 'index','index2','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index','index2','Sample_Project'])

        #10X Dual Index Kit TT Set A
        elif i[2] == '10X Dual Index Kit TT Set A':
            df2 = pd.read_excel(indexs, skiprows=3, sheet_name = 'Dual_Index_Kit_TT_Set_A')
            i7=df2.loc[df2['index_name'] == i[0]]['index(i7)'].to_string(index=False).strip()
            i5=df2.loc[df2['index_name'] == i[0]]['index2_workflow_a(i5)'].to_string(index=False).strip()
            i.append(i7)
            i.append(i5)
            i.append(eln)
            i.remove(i[0])
            i.remove(i[1])
            samplesheet_data.append(i)
            if eln is None:
                if ['Sample_ID', 'index', 'index2'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index', 'index2'])
            else:
                if ['Sample_ID', 'index','index2','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index','index2','Sample_Project'])
            
            
        
        
        #10X Single Index Kit N Set A
        elif i[2] == '10X Single Index Kit N Set A':
            df2 = pd.read_excel(indexs, sheet_name = 'Single_Index_Kit_N_Set_A')
            index=df2.loc[df2['index_name'] == i[0]].iloc[:,1:].to_string(index=False, header = False).strip()
            i.append(index)
            i.append(eln)
            i.remove(i[0])
            i.remove(i[1])
            #Not provide ELN, the sample_project column will not be on there
            if eln is None:
                i[1]=i[1].split(" ")
                for a in i[1]:
                    samplesheet_data.append([i[0],a])
                if ['Sample_ID', 'index'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index'])
            
            else:
                i[1]=i[1].split(" ")
                for a in i[1]:
                    samplesheet_data.append([i[0],a, i[2]])
                if ['Sample_ID', 'index','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index','Sample_Project'])
       
        #10X Single Index Kit T Set A
        elif i[2] == '10X Single Index Kit T Set A':
            df2 = pd.read_excel(indexs, sheet_name = 'Single_Index_Kit_T_Set_A')
            index=df2.loc[df2['index_name'] == i[0]].iloc[:,1:].to_string(index=False, header = False).strip()
            i.append(index)
            i.append(eln)
            i.remove(i[0])
            i.remove(i[1])
            
            #Not provide ELN, the sample_project column will not be on there
            if eln is None:
                i[1]=i[1].split(" ")
                for a in i[1]:
                    samplesheet_data.append([i[0],a])
                if ['Sample_ID', 'index'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index'])
            
            else:
                i[1]=i[1].split(" ")
                for a in i[1]:
                    samplesheet_data.append([i[0],a, i[2]])
                if ['Sample_ID', 'index','Sample_Project'] not in samplesheet_data:
                    samplesheet_data.insert(0, ['Sample_ID', 'index','Sample_Project'])
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

def main():
    tenx_sample_sheet('$library', '$indexs', '$output', '$eln', '$override')
if __name__ == "__main__":
    main()

