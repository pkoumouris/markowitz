import csv
import glob
import os

os.chdir("/Users/parriskoumouris/Documents/stock_analysis/concatenated")

txtfile = list(csv.reader(open('20170103.txt','rb'),delimiter=','))

ticker = ["CBA","RIO","BHP","FMG","ANZ","WBC","NAB","MQG","CSL","TLS","SUN","WPL","VCX","WES","BSL"]

matrix = []

price = []

for i in range(0,len(ticker)):

	for file in glob.glob('201*'):

		txtfile = list(csv.reader(open(file,'rb'),delimiter=','))

		for j in range(0,len(txtfile)):

			if txtfile[j][0] == ticker[i]:
				print 'ASX:'+txtfile[j][0]+' '+txtfile[j][1][0:4]+'-'+txtfile[j][1][4:6]+'-'+txtfile[j][1][6:8]+' '+txtfile[j][2]+' '+txtfile[j][3]+' '+txtfile[j][4]+' '+txtfile[j][5]

