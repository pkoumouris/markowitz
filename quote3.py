import queue
import re
import socket
import threading
import urllib.request

stocks = ["ANZ", "BHP", "BSL", "CBA", "CSL", "FMG", "MQG", "NAB", "RIO", "SUN", "TLS", "VCX", "WBC", "WES", "WPL"]

def get_quote(stock, q):
    url = "https://au.finance.yahoo.com/quote/" + stock + ".AX/"
    try:
        html = urllib.request.urlopen(url, timeout=10).read()
    except socket.timeout:
        q.put("ASX:" + stock + " TIMEOUT")

    p = re.compile(b'"currentPrice":\s?{"raw":(\d*\.\d*)')
    quote = p.search(html)
    if quote is not None:
        q.put("ASX:" + stock + " " + quote.group(1).decode())
    else:
        q.put("ASX:" + stock + " ERROR")

quotes = queue.Queue()
threads = [threading.Thread(target=get_quote, name=stock, args=(stock, quotes)) for stock in stocks]
for thread in threads:
    thread.start()
for thread in threads:
    thread.join()
for quote in list(quotes.queue):
    print(quote)