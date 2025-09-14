//adds to account menu

void main(){
buffer results;
results.append(visit_url());

results.replace_string("</head>","<style>li > img {  display: inline-block;\
  vertical-align: middle;\
  width: 30px;\
  height: 30px;\
  border: 0;\
  padding-right: 10px;}\
  li {text-decoration: underline;};</style>\
  </head>");

//pass if a regular tab, load our tabs through filling a div (w/ guts id)
if ( form_field("action")=="loadtab" && $strings[interface,inventory,chat,combat,account,profile,privacy] contains form_field("value") );
else if (form_field("action")=="loadtab"){
	write("<script>$('#guts').load('account."+form_field("value")+".php');</script>");
	}
string newThing;

//a "bad" tab id is an account.php tab. a link to a bad tab isn't
newThing="\
	<li id=chatplus> <img src=images/itemimages/stuffzmo.gif>Chat+</li>\
	<li id=mafia> <img src=images/itemimages/wine.gif>Mafia</li>\
	";

results.replace_string("</ul>",newThing+"</ul>");

results.write();
}
