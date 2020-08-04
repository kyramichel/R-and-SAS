The Problem of Ranking in 2020

https://www.consumeraffairs.com/online/consumer_reports.htm

Question

What is the most accurate way to evaluate customer reviews?

Answer 

A simple way to answer this question is to look at all the reviews for each product and rank them according to which one has more likes than dislikes.
That is, using the difference (sum of positive ratings) - (sum of negative ratings). 

Understanding consumer ratings and reviews
A review has a thumb up/thumb down rating or a 1-5-star rating as well as a text comment. 
We need to do sentiment analysis for customer star ratings with text to classify them into positive versus negative. An example of Sentiment Analysis - see
https://github.com/kyramichel/NLP/blob/master/NLP_TextBlob.ipynb

In the popular article https://www.evanmiller.org/how-not-to-sort-by-average-rating.html 
the author provides an example that illustrates the limitation of using the difference between likes and dislikes for ranking products. 

We argue that all ranking solutions are biased. First, the name average ranking to represent the percentage of positive ratings is misleading.
The problem with average ranking is that there is a big difference in the number of ratings i.e., an imbalance dataset.

A new solution to the ranking problem involves the use of percent of positive ratings relative to negatives (pos) - (neg) /(neg) 
along with the difference between likes and dislikes (pos) – (neg). The new rating model works fine when the average rating fails! 

For illustration, I use a similar dataset that shows the exploratory ratings analysis for nine items based on which we will rank the products.

The geometric interpretation and more details are provided in the article below.

https://www.amazon.com/Problem-Solution-Ranking-Consumer-Reviews-ebook/dp/B08F45B41F/ref=sr_1_1?dchild=1&qid=1596506199&refinements=p_27%3AKyra+Michel&s=digital-text&sr=1-1&text=Kyra+Michel
