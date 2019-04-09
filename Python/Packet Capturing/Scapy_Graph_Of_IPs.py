#!/usr/bin/env python3.7
#Scapy_Graph_Of_IPs.py - Version 1.0 - By Joe McManus - Modified By MMC - 31st March 2019
#import section - scapy, prettytable, collections and plotly.
#step 1: Imports.
from scapy.all import *
from prettytable import PrettyTable
from collections import Counter
import plotly

#Step 2: Read and append.
packets = rdpcap('/home/mark/coding/Python/Packet Capturing/2ndCapture-full.pcapng')
srcIP = []
for pkt in packets:
    if IP in pkt:
        try:
            srcIP.append(pkt[IP].src)
        except:
            pass

#Step 3: Count up the totals of each source IP.
cnt = Counter()
for ip in srcIP:
    cnt[ip] += 1

#Step 4: Put results in a table and print.
#table = PrettyTable(["IP","Count"])
#for ip, count in cnt.most_common():
#    table.add_row([ip,count])
#print(table)

#Step 4 Version 2.0: Add lists for x and y and graph it.
xData = []
yData = []
for ip, count in cnt.most_common():
    xData.append(ip)
    yData.append(count)

#Step 5: Plot graph in local web browser.
plotly.offline.plot({
    "data":[plotly.graph_objs.Bar(x=xData, y=yData)]
    })




