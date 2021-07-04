# -*- coding: utf-8 -*-
"""
Created on 2021-07-04

@author: zxs

Two jobs:
    1. plot the figure so that it is easier to check remotely;
    2. extract and save the data for matlab
    
TODO：
    1. Automatically detect for skiprows
"""

import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio 
from mpl_toolkits.mplot3d import Axes3D

########## input ##########
Nfields = 2   # number of fields
Nhead = 6     # number of rows of the head

########## import date ##########
filename = 'laser'
savename = filename + '.mat'

# read time
t = np.loadtxt(filename, dtype='double', skiprows=6, usecols=(1), unpack=True)   # load the data in columns
Lt = np.size(t)

# read Ex,Ey,Ez
mxEx = np.zeros((Lt,Nfields))
mxEy = np.zeros((Lt,Nfields))
mxEz = np.zeros((Lt,Nfields))

for n in np.arange(0,Nfields):
    col_x = 2+(n)*3
    col_y = 3+(n)*3
    col_z = 4+(n)*3
    
    mxEx[:,n] = np.loadtxt(filename, dtype='double', skiprows=6, usecols=(col_x), unpack=True) 
    mxEy[:,n] = np.loadtxt(filename, dtype='double', skiprows=6, usecols=(col_y), unpack=True) 
    mxEz[:,n] = np.loadtxt(filename, dtype='double', skiprows=6, usecols=(col_z), unpack=True) 

Ex = np.sum(mxEx,axis=1)
Ey = np.sum(mxEy,axis=1)
Ey = np.sum(mxEy,axis=1)

########## plot ##########

## Plot a normal figure
fig=plt.figure()
ax = Axes3D(fig)

ax.plot3D(t,Ex,Ey,color='g',linestyle='-', linewidth=1, label=r'E(t)')
ax.set_xlabel("t [a.u.]",labelpad=11,fontsize=15,color='g')
ax.set_ylabel("Ex [a.u.]",labelpad=11,fontsize=15,color='g')
ax.set_zlabel("Ey [a.u.]",labelpad=6,fontsize=15,color='g')

plt.minorticks_on()
plt.tick_params(which='major', length=10, width=1.5, labelsize=18, direction='in')
plt.tick_params(which='minor', length=5, width=1.5, direction='in')
plt.tick_params(which='both', bottom=True, top=True, left=True, right=True)


plt.rcParams['legend.fontsize'] = 18         # but it works well.
ax = plt.gca()
for axis in ['top','bottom','left','right']:
  ax.spines[axis].set_linewidth(1.5)
  
plt.legend(frameon=False)

## save the figure
# plt.show()
plt.savefig('Figure1.png',dpi=100,bbox_inches='tight')
plt.close()

########## save data ##########
sio.savemat(savename, {'t': t,'Ex': Ex}) 