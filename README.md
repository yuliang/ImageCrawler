#### ImageCrawler
This is a PoC or programming exercise I did one weekend. It starts with a URL you specify to crawl. Then it parses the html to gather img and href links. It puts img links in a mutable set for later to display. It puts href links in another mutable set to make sure the same url doesn't get visited twice. It then recursively does the same with the unvisited href links in the html in a depth first or breath first way.

It deals with cases such as:
* Relative path
* With or without '/' at the end
* Double or single quotes in the tags
* Making sure sets and queues are thread safe
* Set limits such as number of total web pages to crawl to depth first or number of levels to go down for breath first otherwise for most urls it will go on forever

![screenshot 1](http://www-personal.umich.edu/~yuliang/wp-content/crawler1.png "screenshot 1")

![screenshot 2](http://www-personal.umich.edu/~yuliang/wp-content/crawler1.png "screenshot 2")