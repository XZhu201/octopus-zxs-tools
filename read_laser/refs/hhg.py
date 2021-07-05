import matplotlib.pyplot as plt
import matplotlib as mpl
import math
import numpy as np
from IPython.core.pylabtools import figsize
plt.rcParams['text.usetex'] = True
plt.rcParams['axes.linewidth'] = True
plt.rc('text',usetex=True)
f = open('harmonic.txt','r+')
x, y = [], []
#########################################################################################################
#Read a filename.txt
#########################################################################################################
for line in f.readlines():
	hhg = line.split()
	x.append(float(hhg[0]))
	y.append(float(hhg[1]))
f.close()


#########################################################################################################
#Plot a normal figure
#########################################################################################################
plt.plot(x,y,color='r',linestyle='-', linewidth=2.5, label=r'$\mathrm{H^{+}_{2}}$')
plt.xlabel('Harmonic order', fontsize=26, fontweight='bold')
plt.ylabel('Intensity (arb. unit)', fontsize=26, fontweight='bold')


#########################################################################################################
#Set polt limits of the xlabel and ylabel
#########################################################################################################
plt.xlim(0,80)
plt.ylim(-9,-1)
plt.xticks(np.linspace(0,80, 5))
plt.yticks(np.linspace(-9,1, 6))


#########################################################################################################
#Set ticks by plt.tick_params and plt.gca
#ax = plt.gca()
#ax.spines['right'].set_color('k') we can control the parameter of set_color to remove the line of top 
# and right frame
#########################################################################################################
plt.minorticks_on()
plt.tick_params(which='major', length=10, width=1.5, labelsize=18, direction='in')
plt.tick_params(which='minor', length=5, width=1.5, direction='in')
plt.tick_params(which='both', bottom=True, top=True, left=True, right=True)


#########################################################################################################
#set the frame
#########################################################################################################
#plt.rcParams["axes.linewidth"]=2.0          #why doesn't this statement work?
#plt.rcParams['xtick.labelsize'] = 46        #why doesn't this statement work?
#plt.rcParams['ytick.labelsize'] = 46        #why doesn't this statement work?
#########################################################################################################
plt.rcParams['legend.fontsize'] = 18         # but it works well.
ax = plt.gca()
for axis in ['top','bottom','left','right']:
  ax.spines[axis].set_linewidth(1.5)
  
  
#########################################################################################################
#Adding grids
#plt.grid(which='both')
#set the format of legend with plt.legend
#save the figure
#########################################################################################################
plt.legend(frameon=False)
#plt.show()
plt.savefig('Figure1.png',dpi=150,bbox_inches='tight')
plt.close()
