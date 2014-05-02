#### ImageCrawler
This is a PoC or programming exercise I did one weekend. It starts with a URL you specify to crawl. Then it parses the html to gather img and href links. It puts img links in a mutable set for later to display. It puts href links in another mutable set to make sure the same url doesn't get visited twice. It then recursively does the same with the unvisited href links in the html in a depth first or breath first way.

It deals with cases such as:
* Relative path
* With or without '/' at the end
* Double or single quotes in the tags
* Making sure sets and queues are thread safe

![screenshot 1](http://mayuliang.com/documents/images/crawler1.png "screenshot 1")

![screenshot 2](http://mayuliang.com/documents/images/crawler2.png "screenshot 2")