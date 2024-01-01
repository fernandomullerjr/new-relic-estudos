
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 3 - Exploring browser data"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  Exploring browser data

Using demo data

In this lesson, we will take a close look at data being reported to the NRU Training demo New Relic account. You'll be familiar with this account if you have taken previous courses in this learning path. 

In this account, we'll look at the data collected by two applications. Each application is comprised of multiple entities with traffic running through them 24/7. Before moving forward in this lesson, sign into the NRU Training account using the credentials below:

    one.newrelic.com(opens in a new tab) (you must open this account in a private or incognito window) 
    Username: readonly@newrelicuniversity.com
    Password: o11y-as-code

Demo app 2 - Acme Telco (WebPortal)

In addition to the FoodMe application we explored in the previous lesson, we'll also explore data in this course from another fictitious app reporting to the NRU Training account called "Acme Telco". Unlike FoodMe, Acme Telco is a microservice architecture application. This will allow us to explore more capabilities of the New Relic Platform during this course.  

    Acme Telco's home page can be found here(opens in a new tab).
    http://webportal.telco.nrdemo.com/
<http://webportal.telco.nrdemo.com/>

    Acme Telco's browser entity in the NRU Training account (called WebPortal) can be found here(opens in a new tab).
https://onenr.io/0ZQWJAPL9jW
<https://onenr.io/0ZQWJAPL9jW>

Browser labs

Continue with this lesson by watching each of the videos below and completing any tasks that are asked of you using the NRU Training account. After you are complete, answer the knowledge check questions and then move on to the next lesson.





## LAB

- Erros que mais ocorrem para usuários de Los Angeles

Total occurrences
125 occurrences and 125 stack traces
Search
Timed out loading source ./js/couponSpecial.js
Session replays
0
70
Dec 31, 11:20pm
Jan 1, 10:01pm
Unexpected JS Error
Session replays
0
22
Dec 31, 10:27pm
Jan 1, 8:55pm
Coupon failed validation check
Session replays
0
10
Dec 31, 11:55pm
Jan 1, 5:19pm
Unknown reference
Session replays
0
5
Jan 1, 4:41am
Jan 1, 2:19pm
Function call error in jquery
Session replays
0
5
Jan 1, 2:48am
Jan 1, 1:54pm
Unknown type






## Resources

    Session Replay Preview(opens in a new tab)
    https://newrelic.com/platform/session-replay
<https://newrelic.com/platform/session-replay>    

    Get Early Access to Session Replay(opens in a new tab)
    https://newrelic.com/platform/session-replay-early-access
    
    Tracking and managing error groups