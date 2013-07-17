##
##Fetch weather forecast from www.cwb.gov.tw
##Author: Stanley Ding
##Email: stanley811213@gmail.com
##

import urllib.request
from html.parser import HTMLParser
request = urllib.request.urlopen('http://www.cwb.gov.tw/V7/forecast/f_index.htm')
html = request.read().decode('utf-8')

class MyParser(HTMLParser):
    def __init__(self):
        HTMLParser.__init__(self)
        self.tag_tr = False
        self.tag_a = False
        self.cities = []
        self.city = []
    def handle_starttag(self, tag, attrs):
        if tag == 'tr' and len(attrs) != 0:
            self.tag_tr = True
            self.city.append(attrs[0][1][:-4])
        if self.tag_tr == True:
            if tag == 'a':
                self.tag_a = True
        if self.tag_tr == True and tag == 'img':
            self.city.append(attrs[5][1])
    def handle_endtag(self, tag):
        if tag == 'tr' and self.tag_tr == True:
            self.tag_tr = False
            self.cities.append(self.city)
            self.city = []
        if tag == 'a':
            self.tag_a = False
    def handle_data(self, cities):
        if self.tag_a == True:
            self.city.append(cities)

parser = MyParser()
parser.feed(html)
parser.cities.sort()
for city in parser.cities:
    print('{0}  {1}C  {2}%  {3}'.format(city[1], city[2], city[3], city[5]))
