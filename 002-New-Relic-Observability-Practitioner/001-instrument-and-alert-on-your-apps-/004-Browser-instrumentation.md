
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 4 - Browser instrumentation"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Browser instrumentation

Video Notes and URLs

    Please note: some ad-blockers and privacy browsers may impact your ability to query and view browser agent data. We recommend using Google Chrome for this lesson.
        For more information on ad-blockers as it relates to browser monitoring, see this doc(opens in a new tab).(opens in a new tab)(opens in a new tab)



Add data
Browser
Browser monitoring
    Choose your instrumentation method
        Place a JavaScript snippet in frontend code
        Choose this method if you're not monitoring your application with New Relic yet.


Name your application

This creates an entity in New Relic that represents your application. Once you save a name, you can't change it or use it for other entities.
What do you want to call it?*

Nome escolhido:
FoodMe-Browser

Na parte "Configure the browser agent", deixar tudo marcado como está:

~~~~bash
Configure the browser agent

Your application will use Pro + SPA instrumentation by default, which provides the most page timing data about users' interactions with your site.
Distributed tracing

This enables distributed tracing for same-origin requests made by this application. To configure cross-origin requests after you install the agent, see our docs

.
Session tracking

Turn this on if you want to distinguish or filter browser event data by session. See our docs
~~~~





Add snippet to <HEAD> tag

Copy the snippet of code below and paste it as close to the top of the HEAD as possible, but after any position-sensitive META tags (X-UA-Compatible and charset).

~~~~javascript
<script type="text/javascript">
;window.NREUM||(NREUM={});NREUM.init={distributed_tracing:{enabled:true},privacy:{cookies_enabled:true},ajax:{deny_list:["bam.nr-data.net"]}};

[...] restante do código omitido

interaction(){(0,e.Z)("Call to agent api interaction failed. The spa feature is not currently initialized.")}}({features:[K,p,O,class extends f{static featureName=ne;constructor(e,t){if(super(e,t,ne,!(arguments.length>2&&void 0!==arguments[2])||arguments[2]),!l.il)return;const n=this.ee;let i;(0,B.QU)(n),this.eventsEE=(0,B.em)(n),this.eventsEE.on(oe,(function(e,t){this.bstStart=(0,D.z)()})),this.eventsEE.on(ie,(function(e,t){(0,T.p)("bst",[e[0],t,this.bstStart,(0,D.z)()],void 0,r.D.sessionTrace,n)})),n.on(ae+te,(function(e){this.time=(0,D.z)(),this.startPath=location.pathname+location.hash})),n.on(ae+re,(function(e){(0,T.p)("bstHist",[location.pathname+location.hash,this.startPath,this.time],void 0,r.D.sessionTrace,n)}));try{i=new PerformanceObserver((e=>{const t=e.getEntries();(0,T.p)(Q,[t],void 0,r.D.sessionTrace,n)})),i.observe({type:ee,buffered:!0})}catch(e){}this.importAggregator({resourceObserver:i})}},ue,C,xe,k,class extends f{static featureName=le;constructor(e,t){if(super(e,t,le,!(arguments.length>2&&void 0!==arguments[2])||arguments[2]),!l.il)return;if(!(0,n.OP)(e).xhrWrappable)return;try{this.removeOnAbort=new AbortController}catch(e){}let r,i=0;const o=this.ee.get("tracer"),a=(0,B._L)(this.ee),s=(0,B.Lg)(this.ee),c=(0,B.BV)(this.ee),u=(0,B.Kf)(this.ee),d=this.ee.get("events"),f=(0,B.u5)(this.ee),h=(0,B.QU)(this.ee),p=(0,B.Gm)(this.ee);function g(e,t){h.emit("newURL",[""+window.location,t])}function m(){i++,r=window.location.hash,this[be]=(0,D.z)()}function v(){i--,window.location.hash!==r&&g(0,!0);var e=(0,D.z)();this[me]=~~this[me]+e-this[be],this[we]=e}function b(e,t){e.on(t,(function(){this[t]=(0,D.z)()}))}this.ee.on(be,m),s.on(ye,m),a.on(ye,m),this.ee.on(we,v),s.on(ge,v),a.on(ge,v),this.ee.buffer([be,we,"xhr-resolved"],this.featureName),d.buffer([be],this.featureName),c.buffer(["setTimeout"+he,"clearTimeout"+fe,be],this.featureName),u.buffer([be,"new-xhr","send-xhr"+fe],this.featureName),f.buffer([ve+fe,ve+"-done",ve+pe+fe,ve+pe+he],this.featureName),h.buffer(["newURL"],this.featureName),p.buffer([be],this.featureName),s.buffer(["propagate",ye,ge,"executor-err","resolve"+fe],this.featureName),o.buffer([be,"no-"+be],this.featureName),a.buffer(["new-jsonp","cb-start","jsonp-error","jsonp-end"],this.featureName),b(f,ve+fe),b(f,ve+"-done"),b(a,"new-jsonp"),b(a,"jsonp-end"),b(a,"cb-start"),h.on("pushState-end",g),h.on("replaceState-end",g),window.addEventListener("hashchange",g,(0,R.m$)(!0,this.removeOnAbort?.signal)),window.addEventListener("load",g,(0,R.m$)(!0,this.removeOnAbort?.signal)),window.addEventListener("popstate",(function(){g(0,i>1)}),(0,R.m$)(!0,this.removeOnAbort?.signal)),this.abortHandler=this.#o,this.importAggregator()}#o(){this.removeOnAbort?.abort(),this.abortHandler=void 0}}],loaderType:"spa"})})()})();
</script>
~~~~

Deploy your updated code & see your data

Wait a couple of minutes to give your users time to visit your site and generate data. When you're ready, click below to see your data.



- Copiar o código js
ir no Glitch
acessar a pasta app/index.html
<https://glitch.com/edit/#!/titanium-water-wind?path=app%2Findex.html%3A1%3A0>

- Adicionar no começo do Head, após o primeiro meta.


- Acessar a página do FoodMe e fazer novo pedido:
<https://titanium-water-wind.glitch.me/#/>
visa
5482078545167852
06/2024
994


Thank you for your order!

Our chefs are getting your food ready. It will be on its way shortly.

Your order ID is 1705794897200.





Query your data


- OBS
Podem levar uns 5minutos até mostrar dados na entidade Browser


~~~~sql
SELECT count(*) FROM PageView FACET appName
~~~~