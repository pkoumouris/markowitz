import re
import threading
import urllib.request

stocks = ["ANZ", "BHP", "BSL", "CBA", "CSL", "FMG", "MQG", "NAB", "RIO", "SUN", "TLS", "VCX", "WBC", "WES", "WPL"]

def quote(stock):
    url = "https://au.finance.yahoo.com/quote/" + stock + ".AX/"
    html = urllib.request.urlopen(url).read()

    p = re.compile(b'"currentPrice":{"raw":(\d*\.\d*)')
    quote = p.search(html).group(1).decode()
    print("ASX:" + stock + " " + quote)

threads = [threading.Thread(target=quote, args=(stock,)) for stock in stocks]
for thread in threads:
    thread.start()
for thread in threads:
    thread.join()