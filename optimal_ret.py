import numpy as np
import math
from scipy.optimize import minimize
import scipy
import csv
import sys

np.set_printoptions(formatter={'float': lambda x: "{0:0.6f}".format(x)})

target = float(sys.argv[1])	#Standard Deviation Target

R = np.genfromtxt("retTemp.csv",delimiter=",")
C = np.genfromtxt("covTemp.csv",delimiter=",")

with open('sec_names.csv','rU') as f:
	reader = csv.reader(f)
	names = list(reader)

#myNameFile = open('sec_names.csv',"rb")
#names = csv.reader(myNameFile,delimiter=",")
#for row in names:
#	print row

R = np.matrix(R)
R = R.transpose()
C = np.matrix(C)

numsecs = len(C)

W = np.ones(numsecs)
W = (1.0/numsecs)*W

myBounds = ()
q = ((0.0,1.0),)

for i in range(0,numsecs):
	myBounds = myBounds + q

def ret(W):
	W = np.matrix(W)
	W = W.transpose()
	return 1.0/((W.transpose()*R)[0,0])

def SD(W):
	W = np.matrix(W)
	W = W.transpose()
	return math.sqrt((W.transpose()*C*W)[0,0])

def con(W):
	W = np.matrix(W)
	return W.sum() - 1

def con2(W):
	W = np.matrix(W)
	return W.min() - math.fabs(W.min())

def con3(W):
	return SD(W) - target

cons = [{'type':'eq', 'fun': con},
		{'type':'eq', 'fun': con3}]

res = scipy.optimize.minimize(ret,W,bounds=myBounds,constraints=cons)
#print res
#print res.x

for i in xrange(len(res.x)):
	print names[i][0] + ' ' + str(res.x[i])

#print 1.0/ret(res.x)
print 'stddev ' + str(SD(res.x))
print 'ret ' + str(1.0/ret(res.x))
#print res.x.sum()
