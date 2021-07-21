# -*- coding: utf-8 -*-
"""
Created on Mon Dec  3 22:57:25 2018

@author: Xiaosong Zhu
"""

import sys
sys.path.append('/bigwork/nhbbzhux/Tools/mypip/lib/python3.5/site-packages')

import numpy as np
import linecache
import matplotlib.pyplot as plt


##### input #####
filename = input("Input the file name to read. No need to type .xsf: ")
filename = filename+'.xsf'

##### prepare to read data #####

# number of atom 
natom = input('Input the number of atoms (Directly press Enter for 1): ')
if natom=='':
	natom='1'
natom = int(natom)

begin_gridinfo = 5+natom       # the grid information begins from this line  (Line number starts from 1!)
begin_data = 10+natom    # the data begins from this line (Line number starts from 0!)

##### Read the spatial grid  #####
with open(filename, "r") as f:
	print('Open',filename)
	
	# number of grids, like  "101    121     81"
	head0 = linecache.getline(filename,begin_gridinfo)  
	head0 = head0.split()
	Lx = int(head0[0])
	Ly = int(head0[1])
	Lz = int(head0[2])
	print('\nLx, Ly, Lz = \n',Lx,Ly,Lz)
	
	# xmax
	head2 = linecache.getline(filename,begin_gridinfo+2) 
	head2 = head2.split()
	Rx = float(head2[0])/2          # don't forget /2
	
	# ymax
	head3 = linecache.getline(filename,begin_gridinfo+3) 
	head3 = head3.split()
	Ry = float(head3[1])/2
	
	# zmax
	head4 = linecache.getline(filename,begin_gridinfo+4) 
	head4 = head4.split()
	Rz = float(head4[2])/2

	print('Rx, Ry, Rz = \n',Rx,Ry,Rz)
	
	dx = 2*Rx/(Lx-1)
	dy = 2*Ry/(Ly-1)
	dz = 2*Rz/(Lz-1)
    
	print('dx, dy, dz = \n',dx,dy,dz,'\n')    

    
##### Read the data  #####
vec = np.loadtxt(filename,skiprows=begin_data-1,dtype=bytes)  # ??!!
vec = vec[:-2].astype(float)    # remove the last two non-data lines

norm = np.sum( np.abs(vec) * np.abs(vec) )*dx*dy*dz
print('The norm of the inital state is',norm,'\n')

assert len(vec)==Lx*Ly*Lz

# 接下来可以尝试用np.reshape来把读入的向量变成矩阵
# a = np.linspace(1,27,27)
#  b = a.reshape((3,3,3),order='F')  看究竟是C还是F

