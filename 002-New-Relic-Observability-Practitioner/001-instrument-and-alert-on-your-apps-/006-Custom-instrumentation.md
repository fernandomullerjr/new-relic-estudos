
# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
#  push

git status
git add .
git commit -m "aula 6 - Custom instrumentation"
eval $(ssh-agent -s)
ssh-add /home/fernando/.ssh/chave-debian10-github
git push
git status



# ###################################################################################################################### 
# ###################################################################################################################### 
# ###################################################################################################################### 
# Custom instrumentation

Video Notes and URLs

    index.js(opens in a new tab) solution code, 
<https://drive.google.com/file/d/1fmXAlt_QTqaIfMOKo4IqiVj14F0CHfOz/view?usp=sharing>

    cart.js(opens in a new tab) solution code
<https://drive.google.com/file/d/1Pg350jH2UAPvD5nsXwQUuYQqCXNv7AQo/view?usp=sharing>




Acessar "Query your data"
SELECT count(*) FROM Transaction FACET restaurant
Isto não retorna nada, porque não temos este atributo para poder consultar por restaurante.

Acessar o Glitch
pasta server/
arquivo index.js
https://glitch.com/edit/#!/titanium-water-wind?path=server%2Findex.js%3A1%3A0

Arquivo disponivel na pagina da aula.
Porém o código já está inserido, basta descomentar as linhas 64 e 78

~~~~js
    var order = req.body;
    var itemCount = 0;
    var orderTotal = 0;
    order.items.forEach(function(item) { 
      itemCount += item.qty;
      orderTotal += item.price * item.qty;
    });
    newrelic.addCustomAttributes({
      'customer': order.deliverTo.name,
      'restaurant': order.restaurant.name,
      'itemCount': itemCount,
      'orderTotal': orderTotal
    });
    
    return res.status(201).send({ orderId: Date.now() });
  });
~~~~



video -6:02