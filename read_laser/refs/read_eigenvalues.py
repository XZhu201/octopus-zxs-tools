# -*- coding: utf-8 -*-
"""
Created on Sun Jun 28 08:16:16 2020

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

########## import date ##########
filename = './static/eigenvalues'

state, energy = np.loadtxt(filename, dtype='double', skiprows=5, usecols=(0,2), unpack=True)

########## plot ##########

## Plot a normal figure
plt.plot(state,energy,color='g',linestyle='none', marker='.', linewidth=2.5, label=r'eigenvalues')
plt.xlabel('State number', fontsize=16, fontweight='normal')
plt.ylabel('Energy [H]', fontsize=16, fontweight='normal')

## set the marker


## Set polt limits of the xlabel and ylabel

# plt.xlim(0,80)
# plt.ylim(-9,-1)
# plt.xticks(np.linspace(0,80, 5))
# plt.yticks(np.linspace(-9,1, 6))


## Set ticks by plt.tick_params and plt.gca
## ax = plt.gca()
## ax.spines['right'].set_color('k') we can control the parameter of set_color to remove the line of top 
## and right frame

plt.minorticks_on()
plt.tick_params(which='major', length=10, width=1.5, labelsize=18, direction='in')
plt.tick_params(which='minor', length=5, width=1.5, direction='in')
plt.tick_params(which='both', bottom=True, top=True, left=True, right=True)

## set the frame
## plt.rcParams["axes.linewidth"]=2.0          #why doesn't this statement work?
## plt.rcParams['xtick.labelsize'] = 46        #why doesn't this statement work?
## plt.rcParams['ytick.labelsize'] = 46        #why doesn't this statement work?

plt.rcParams['legend.fontsize'] = 18         # but it works well.
ax = plt.gca()
for axis in ['top','bottom','left','right']:
  ax.spines[axis].set_linewidth(1.5)
  
## Adding grids
## plt.grid(which='both')
## set the format of legend with plt.legend
plt.legend(frameon=False)

## save the figure
# plt.show()
plt.savefig(filename+'.png',dpi=50,bbox_inches='tight')
plt.close()

########## save data ##########
sio.savemat(filename+'.mat', {'state': state,'energy': energy}) 
