#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Aug 14 15:36:01 2022

@author: jahirju30
"""

import glob
import os
import shutil


# func: converts hour:min:sec:millisec to SECONDS
def time_in_sec(time_as_string):
    # time_as_string = "00:00:03,030"
    hms, ms = time_as_string.split(',')
    h,m,s = hms.split(':')
    total_sec = (int(h) * 3600) + (int(m) * 60) + int(s) + (int(ms)/1000)
    return total_sec

# get paths for all files in a folder
dir_path = r'speech_to_text_results/*.*' # *.* means file name with any extension
files = glob.glob(dir_path)
files = sorted(files)

path = 'processed_speech_to_text_results'
if os.path.exists(path):     # Check Folder is exists or Not
    shutil.rmtree(path)         # Delete Folder code
os.makedirs(path) # create a new folder

for f in files:
    print(f)
    fname_prefix = f.split('/')[-1].replace('.txt', '')

    with open(f, mode = 'r') as f:
        lines = f.readlines()

    results = []
    i = 1
    while i < len(lines):
        time_string = lines[i].strip()

        onset = time_string.split('-->')[0]
        results.append(time_in_sec(onset))

        offset = time_string.split('-->')[1]
        results.append(time_in_sec(offset))

        results.append(lines[i+1].strip())
        i = i + 4

    # write the output in text files
    with open(path + '/' + fname_prefix + '_onset_offset_labels.txt', 'w') as output_file:
        for item in results:
            output_file.write(str(item) + '\n')
