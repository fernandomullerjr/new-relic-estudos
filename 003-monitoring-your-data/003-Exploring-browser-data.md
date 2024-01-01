
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





https://github.com/do-community/travellist-laravel-demo/tree/main
docker-compose build app
docker-compose up -d

- ERRO

~~~~BASH
                                                                                                                                                                                             0.0s
 => => extracting sha256:8efd93cef2cf149b81400aff0a11b7294bc336566f9b97fa5e399e11a31156bd                                                                                                                                                                                                0.0s
 => ERROR [stage-0 2/8] RUN apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip                                                                                                                                       4.2s
------
 > [stage-0 2/8] RUN apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip:
1.009 Get:1 http://deb.debian.org/debian bullseye InRelease [116 kB]
1.096 Get:2 http://deb.debian.org/debian-security bullseye-security InRelease [48.4 kB]
1.154 Get:3 http://deb.debian.org/debian bullseye-updates InRelease [44.1 kB]
1.226 Get:4 http://deb.debian.org/debian bullseye/main amd64 Packages [8062 kB]
2.260 Get:5 http://deb.debian.org/debian-security bullseye-security/main amd64 Packages [263 kB]
2.961 Reading package lists...
3.309 E: Release file for http://deb.debian.org/debian/dists/bullseye-updates/InRelease is not valid yet (invalid for another 1h 28min 18s). Updates for this repository will not be applied.
------
Dockerfile:8
--------------------
   7 |     # Install system dependencies
   8 | >>> RUN apt-get update && apt-get install -y \
   9 | >>>     git \
  10 | >>>     curl \
  11 | >>>     libpng-dev \
  12 | >>>     libonig-dev \
  13 | >>>     libxml2-dev \
  14 | >>>     zip \
  15 | >>>     unzip
  16 |
--------------------
ERROR: failed to solve: process "/bin/sh -c apt-get update && apt-get install -y     git     curl     libpng-dev     libonig-dev     libxml2-dev     zip     unzip" did not complete successfully: exit code: 100
ERROR: Service 'app' failed to build : Build failed
You have new mail in /var/mail/fernando

~~~~








## Check your knowledge

This screenshot below shows 10 of the "Coupon failed validation check" error message. How many of those occurrences took place between 4:11-4:20?

8 
Correctly selected

6
Correctly unselected

9
Correctly unselected

1O
Correctly unselected

Correct





Which chart on the browser summary screen will tell us the amount of user traffic on your site?

Largest Contentful Paint
Correctly unselected

Page view load time
Correctly unselected

Front end vs. back end
Correctly unselected

Throughput
Correctly selected

Correct

The definition of throughput can be found in the New Relic glossary of terms(opens in a new tab). Review the summary screen overview page video again if you have any remaining questions




The screenshot below shows us a session trace for the FoodMe homepage. Which of the following statements is true based on this information (check all that apply)?

The user was capable of interacting with elements on this page after 2.01 seconds
Incorrectly unchecked

The user was capable of interacting with elements on this page after 3.56 seconds
Incorrectly checked

The page loaded on the user's browser in its entirety after 13.8 seconds
Correctly unchecked

    The page loaded on the user's browser in its entirety after 3.41 seconds
    Correctly checked


Incorrect

Page load time refers to the amount of time it takes for a user to be able to interact with ANY element of the page. First interaction measures when a user first started to interact with an element on the page.


Largest contentful paint measures the amount of time it takes for the largest element on the page to load completely. Total duration measures the amount of time a user spent on that page.








## PENDENTE
- Ler
https://docs.newrelic.com/docs/errors-inbox/errors-inbox/
- Subir um TravelList via Docker no Debian:
https://dev.to/vumdao/5-minutes-travellist-laravel-demo-2fcj
https://devpress.csdn.net/cicd/62eca52b19c509286f41776b.html