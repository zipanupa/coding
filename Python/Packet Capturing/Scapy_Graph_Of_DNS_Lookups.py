#!/usr/bin/env python3.7
#Scapy_Graph_Of_DNS_Lookups.py - Version 1.0 - By Joe McManus - Modified By MMC - 31st March 2019
#import section - scapy, collections and plotly.
#step 1: Imports.
from scapy.all import *
from collections import Counter
import plotly

#Step 2: Read and append.
packets = rdpcap('/home/mark/coding/Python/Packet Capturing/2ndCapture-full.pcapng')
lookups = []
for pkt in packets:
    if IP in pkt:
        try:
            if pkt.haslayer(DNS) and pkt.getlayer(DNS).qr == 0:
                lookup=(pkt.getlayer(DNS).qd.qname).decode("utf-8")
                lookups.append(lookup)
        except:
            pass

#Step 3: Count up the totals of each source IP.
cnt = Counter()
for lookup in lookups:
    cnt[lookup] +=1

#Step 4 Version 2.0: Add lists for x and y and graph it.
xData = []
yData = []

for lookup, count in cnt.most_common():
    xData.append(lookup)
    yData.append(count)

#Step 5: Plot graph.
plotly.offline.plot({
    "data":[plotly.graph_objs.Bar(x=xData, y=yData)]
    })




