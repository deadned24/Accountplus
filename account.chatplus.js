var url_form="account.chatplus.ash";

//Add a item to rcm (happy: 😃 )
$('span#dn_star').bind('click', function(e) {
e.preventDefault();
$.ajax({
    url: url_form,//'test_form.ash',
    type: 'POST',
    data: $('form#dn_star').serialize(),
    success: function(response) {
        setTimeout(function() {
            $('#guts').load(url_form);
        }, 200);
    }
});
  return false;
});

//special chat css
$('span#dn_specials').bind('click', function(f) {
f.preventDefault();
$.ajax({
    url: url_form,//'test_form.ash',
    type: 'POST',
    data: $('form#dn_specials').serialize(),
    success: function(response) {
        setTimeout(function() {
            $('#guts').load(url_form);
        }, 200);
    }
});
  return false;
});

function removePerson(e,t){const s=`a[href="showplayer.php?who=${e}"]::before { content: '${t}'; }`,l=top.chatpane.document.styleSheets;for(let t=0;t<l.length;t++){const s=l[t].cssRules||l[t].rules;for(let o=0;o<s.length;o++)if(s[o].cssText.startsWith(`a[href="showplayer.php?who=${e}"]::before`)) return void l[t].deleteRule(o) }};

//for the removable list items
$(".obliterate").bind('click',function(g){
g.preventDefault();
var it=$(this);
	var todo = it.attr('data-action');
	var value = it.attr('data-value');

  $.ajax({
    url: url_form,
    type: 'POST',
    data: { action: todo, name: value,},
    success: function() {
      it.closest('dd').remove();
      if (todo="remove_person")
	      removePerson(value,'x');
    },
    timeout:1000
  });

  return false;
});
