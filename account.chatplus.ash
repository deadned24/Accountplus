// "library" / adds emojis to chat* after people's names
/*
BIG PICTURE is we're generating CSS rules: (a[href=*matcher*]::after{content:*emoji*}
	matcher is player id
	CSS rules are inserted into the page through relay scripts (those scripts call this one)

	
CSS rules are generated in this script and stored to 2 data files [name]_Stars.txt and [name]_TAG_RULES.txt
	these rules are also used to generate JS for Right Click Menu (rcm)
	Doesn't add rcm to pages that don't have them, just fixing it for pages that do
		* We're overwriting a function in rcm.20160406.js called 'launch' to do this
	if data/extraChatRules.txt exists, will load it in pages as CSS (for advanced users)

To add to a page:
	import account.chatplus.ash;
	void main(){
		buffer page = visit_url();
		page.replace_string("var notchat = true;","var notchat = false;\nvar pwdhash=\""+my_hash()+"\";\n");//only for not-chat pages with rcm
		rcm_fix(page); //from account.chatplus.ash 
	page.write();
	}

CSS rules can be added to any page (but wont trigger unless there are links to player profiles) by doing:
	import account.chatplus.ash;
	void main() {
		buffer page=visit_url();
		CSSRules(page);//from account.chatplus.ash for CSS rules
		page.write();
	}

NOTE: only one emoji per person! they're scarce and our map/css rule generator doesn't support 2+ tags on a person
Also, Commands cant have spaces, because they're also map keys and that's a problem?
*/

record rec2 {string cmd; string glyph; };
string [string] star1map;

file_to_map(to_lower_case(my_name())+"_TAG_RULES.txt", star1map); //name:emoji

void modJS(buffer page){
//overwrite Launch(e,t,n) used in rcm.20160406.js and add in "toggleRule" function used in our Launch
string myJS="<script language=\"Javascript\"> \
function toggleRule(e,t){const s=`a[href=\"showplayer.php?who=${e}\"]::before { content: '${t}'; }`,l=document.styleSheets;for(let t=0;t<l.length;t++){const s=l[t].cssRules||l[t].rules;for(let o=0;o<s.length;o++)if(s[o].cssText.startsWith(`a[href=\"showplayer.php?who=${e}\"]::before`))return void l[t].deleteRule(o)}l[0].insertRule(s,l[0].cssRules.length)};\n\
	function launch(e,t,n){var o=actions[e];if(o){var c=o.query;switch(c&&(c=c.replace(/%/,n)),force(),o.action<5&&this.top&&top.chatpane&&top.chatpane.cycles&&(top.chatpane.cycles=0),o.action){\
	case -1:\
		fetch('"+__FILE__+"', { method: 'POST', body: `action=star&rule=${e}&name=${t}&ign=${n}` });";
myJS+="switch(e) {\n";
foreach a,b in star1map
	myJS+="case \""+a+"\": toggleRule(t,'"+b+"');break;\n";
myJS+="}break;\
	case 2:o.submit?submitchat(e+\" \"+(o.useid?t:n)):(document.chatform.graf.value=e+\" \"+(o.useid?t:n),document.chatform.graf.focus&&document.chatform.graf.focus());break;case 3:var a=prompt(c);a&&submitchat(e+\" \"+(o.useid?t:n)+\" \"+a);break;case 4:confirm(c)&&submitchat(e+\" \"+(o.useid?t:n));break;case 5:var r=window.open(e+t,\"playerviewer\",\"scrollbars=yes,resizable=yes,height=780,width=900\");r.focus&&r.focus()}}}</script>\n";

//addon for colored text in chat fix (rainbow text, V, ???) - cant do with CSS

if (contains_text(get_property("dn_chatplus"),"c:1;")){
myJS+="<script>\
function fixFontColors(root){\
  $(document).find('font[color]').filter(function(){\
return $(this).text().length === 1;\
  }).css('color','#000');\
}\
function fixFontColors(root){\
  $(document).find('font[color]').filter(function(){\
return $(this).text().length === 1;\
  }).css('color','#000');\
}\
function fixItalics(root){\
var el = document.querySelector('i[title]');\
if (el) el.textContent = el.title;\
}\
$(document).ajaxComplete(function(){\
  fixFontColors();\
  fixItalics();\
});\
</script>\n";
}

page.replace_string("</html>",myJS+"</html>");
}

//"special" CSS rules (settings)
/*
c     Reduce chat colors +effects
L    Only have Left-to-Right text 
S    Ignore annoying snowmen & safaris 
m    Add 🖂 to message notifications 
record rec2 {string cmd; string glyph; }; (cmd=CSS rule, glyph=label)

// add more to this map and prefs+page will update accordingly

reduces V mask Vs but also hits System Message:
  font[color=\"red\"] b {color: black !important; font-weight:normal !important;}\ 
*/
rec2 [string] CSS_RULES = {
"c":new rec2("span[style*=\"color:\"] {color: black !important;	font-weight: normal !important;}\n \
  font[color=\"darkred\"]{ color:black !important;}\n \
  font[color=\"#E6B426\"]{ color:black !important;}\n\
  font[color=\"purple\"]{color:black !important;}\n","Reduce chat colors & effects"),
"L":new rec2("span[style=\"direction: rtl; unicode-bidi: bidi-override\"] {\
  direction: ltr !important; \
  unicode-bidi: normal !important;\
  }\n","Only have Left-to-Right text"),
"S":new rec2("img[src=\"/images/otherimages/12x12snowman.gif\"] + font[color=\"blue\"] { \
  display: inline-block; /* so max-width can be set */\
  max-width: 0;\
  overflow: clip;\
  white-space: nowrap; \
	}\n","Ignore annoying snowmen text"),
"m":new rec2("a[href=\"messages.php\"]::before{content: '🖂';}\n","Add 🖂 to message notifications"),
"p":new rec2("a[href*=\"peevpee.php\"]::before{content: ' 🥊 ';}\n","Add 🥊 to pvp notifications"),
  };
  
void CSSRules(buffer page){
//reads data ("_Stars") to generates CSS rules (emojis for people) in relay scripts

if (get_property("_dn_chatplus")==""){
	set_property("_dn_chatplus","1"); 
	print("You are using Chat+ KOL's #1 chat add-on");
	}

string myCSS = "\n<style type=text/css>\n";

//reads <name>_stars.txt data
string [string] myStars;
file_to_map(to_lower_case(my_name())+"_Stars.txt", myStars); //eg "deadned_Stars.txt"

//CSS rule builder
foreach c,d in myStars{
	myCSS+="a[href=\"showplayer.php?who="+c+"\"]::before {content: '"+star1map[d]+"';}\n";
	}
myCSS+="</style>\n";
myCSS+="<script language=Javascript src=\"/images/scripts/jquery-1.3.1.min.js\"></script>";
page.replace_string("</head>",myCSS+"</head>");
}

void CSSRules2(buffer page){
//generates CSS rules in relay scripts for "specials" and extraChatRules (for chat)

string myCSS = "\n<style type=text/css>\n";

int [string]checkMap;
string Specials=get_property("dn_chatplus");
if (Specials != "")//split_string will fail if pref isn't set (eg 1st time run)
	foreach _,b in split_string(Specials,";")
		checkMap[split_string(b,":")[0]]=to_int(split_string(b,":")[1]);

foreach key in CSS_RULES
	myCSS+=(checkMap[key]==1?CSS_RULES[key].cmd:"");

//reads <name>_stars.txt data
string [string] myStars;
file_to_map(to_lower_case(my_name())+"_Stars.txt", myStars); //eg "deadned_Stars.txt"

//extraChatRules.txt is an arbitrary file to load in more CSS rules. it could be any CSS
foreach _,rule in file_to_array("extraChatRules.txt")
	myCSS+=rule+"\n";
	
myCSS+="</style>\n";
myCSS+="<script language=Javascript src=\"/images/scripts/jquery-1.3.1.min.js\"></script>";
page.replace_string("</head>",myCSS+"</head>");
}

void actionGen(buffer page){
//adds "actions" to chat's rcm

string aActions;
foreach a,b in star1map
	   aActions += "\""+a+"\" : { \"action\" : -1, \"useid\" : true, \"arg\" : \""+b+"\" },";

page.replace_string("actions = {","actions = {"+aActions);
}


void rcm_fix(buffer page){
//all of the above functions in 1 for easy import.
actionGen(page);
CSSRules(page);
CSSRules2(page);
modJS(page);
}

//<<<<<<<<<<< ~~~~~~~~~~ LIBRARY END ~~~~~~~~~~ >>>>>>>>>>>>>>>\\

void ADD_Rule(string RULE, string GLYPH){

//mafia cant store spaces in keys?
if (contains_text(RULE," "))
	RULE=split_string(RULE," ")[0];

string [string] myRules;
file_to_map(to_lower_case(my_name())+"_TAG_RULES.txt", myRules);

myRules[RULE]= GLYPH;//'star' is the name of the script that adds users to CSS rule map

map_to_file( myRules , to_lower_case(my_name())+"_TAG_RULES.txt");

}

void REM_Rule(string RULE){
string [string] myRules;
file_to_map(to_lower_case(my_name())+"_TAG_RULES.txt", myRules);

remove myRules[RULE];

map_to_file( myRules , to_lower_case(my_name())+"_TAG_RULES.txt");
}

void STARS(string PID, string NAME, string RULE){

record rec1 { string g; string n;};
rec1 [string] myStars;
// 1909053	happy	deadned

file_to_map(to_lower_case(my_name())+"_Stars.txt", myStars);

// add or remove  person to map
if (myStars[PID].g == "")//ANY glyph, not just the one they have
	myStars[PID]=new rec1(RULE, NAME);
else
	remove myStars[PID];
	
map_to_file( myStars, to_lower_case(my_name())+"_Stars.txt");
}

void STARS(string PID){
//only removes from list
 STARS(PID,"","");
 }

//<<<<<<<<<<< ~~~~~~~~~~ relay script begins ~~~~~~~~~~ >>>>>>>>>>>>>>>\\

void main(){

//asked a chatbot to name my project. lol
string [int] AI_SLOP=split_string("EmojiPing, ChatTags, CustomMention, EmojiMention, Taggo, ChatDecor, MentionMe, EmojiAlerts, ChatBuddy, TagIt, CustomTags, EmojiNotifier, PingPals, ChatMarks, UserTags, EmojiNotes, MentionMaster, ChatFlags, TagAlong, EmojiLabels, TagChat, NameNack, EmojiBoost, CharmTags",", ");
string title=""+AI_SLOP[(gameday_to_int() % count(AI_SLOP))]+" Chat+";
string dn_name = form_field("name");
string dn_glyph = form_field("glyph");
string dn_action = form_field("action");

if (dn_action == "remove_rule" && dn_name != "")
	REM_Rule(dn_name);
else if (dn_action == "remove_person" && dn_name != "")
	STARS( dn_name );
else if (dn_action == "add_rule" && dn_name != "" && dn_glyph !="")
	ADD_Rule(dn_name,dn_glyph);
else if (dn_action == "special"){
	foreach key in CSS_RULES
		dn_name+=key+":"+(form_field(key)=="on"?"1":"0")+";";//build a string of c:1;L0; etc to store as a property for later
	set_property("dn_chatplus",dn_name);
	}
else if (dn_action == "star" && dn_name != "")
	STARS( dn_name,form_field("ign"),form_field("rule") );

record rec1 { string glyph; string name;};
rec1 [int] myStars;

//start building page
buffer page;// = visit_url();

page.append("<!DOCTYPE html><head><title>"+title+"</title>\n<style>a{text-decoration: none;color:black;}\
.container {display: grid;grid-template-columns: 1fr 1fr;}\
</style><link rel=\"stylesheet\" type=\"text/css\" href=account.chatplus.css></style>\
<script>$(document).die('change', 'input[type=\"checkbox\"]');</script>\
\n</head>\n<body>");
page.append("<div class=subhead>"+title+"</div><p>\n");

actionGen(page);
CSSRules(page);

//ADD css rule (adds to rcm)
page.append("<div class=container><div><dl><dt><b>Add Rule:</b></dt>");
string input1=" \
<dd><form id=dn_star action="+__FILE__+" method=\"POST\" > \
<input type=\"text\" id=\"name\" placeholder=\"rule name\" name=\"name\" maxlength=\"10\" size=\"10\">\
<input type=\"text\" id=\"glyph\" placeholder=\"emoji\" name=\"glyph\" maxlength=\"4\" size=\"4\">\
<input type=\"hidden\" id=\"action\" name=\"action\" value=\"add_rule\">\
<span id=dn_star class=btn-like>submit</span>\
</form></dd></dl></div>\n";
page.append(input1);

//Rules (css rules we've added to rcm)
page.append("<div><form id=dn_rules action="+__FILE__+" method=\"POST\">");
page.append("\n<dl><dt><b>Rules:</b></dt>\n");
page.append("<input type=\"hidden\" id=\"action\" name=\"action\" value=\"remove_rule\">");
string butt;
foreach a,b in star1map{
	page.append("<dd><span id=rules class=\"obliterate\" data-action=\"remove_rule\" data-value=\""+a+"\" class= style=\"cursor:pointer;\" data-butts=rulez>x</span> "+b+": "+a+"</dd>");
	}
page.append("</dl></form></div></div>");
page.append("<hr color=blue width=90%>");

//SHOW people w/ css rules (people we've tagged)
page.append("<div class=container><div>");
file_to_map(to_lower_case(my_name())+"_Stars.txt", myStars);
page.append("<form id=dn_people action="+__FILE__+" method=\"POST\">");
page.append("\n<dl><dt><b>People:</b></dt>\n");
page.append("<input type=\"hidden\" id=\"action\" name=\"action\" value=\"remove_person\">");
foreach PID,b in myStars {
	page.append("<dd><span id=dn_people class=\"obliterate\" data-value=\""+PID+"\" data-action=remove_person>x</span>\
	<a href=\"showplayer.php?who="+PID+"\">"+b.name+"</a></dd>");
	}
page.append("</dl></form></div>");


//Special Chat css Rules
page.append("\n<div> <dl><dt><b>Special Chat Preferences:</b></dt>\n");

int [string]checkMap;
string specialsString=get_property("dn_chatplus");
if (specialsString != "")//split_string will fail if pref isn't set (eg 1st time run)
	foreach _,b in split_string(specialsString,";")
		checkMap[split_string(b,":")[0]]=to_int(split_string(b,":")[1]);

string specials=" \
  <form id=dn_specials action="+__FILE__+" method=\"post\">\
  <input type=\"hidden\" id=\"action\" name=\"action\" value=\"special\">";
foreach a in CSS_RULES
	specials+="<dd><input type=checkbox name="+a+" "+(checkMap[a]==1?"checked":"")+">\
  "+CSS_RULES[a].glyph+"\
  </dd>";
specials+="\
<dd>  <span id=dn_specials class=btn-like>Update Chat Preferences</span></dd>\
 </form></dl></div></div>";

//display the CSS in extraChatRules.txt (user created file) if it exists
if (file_to_array("extraChatRules.txt")[1]!=""){
	specials+="<hr color=blue width=90%><b>extraChatRules.txt:</b>\
<div style=\"background-color:#f0f0f0;border:1px solid #000;max-height:12em;overflow:auto;\" class=nes >";
	foreach _,rule in file_to_array("extraChatRules.txt")
		specials+=rule+"<br>";
	specials+="</div>";
	}
 
specials+="<hr color=blue width=90%>\
 <center><h6>Chat must be reloaded for changes to apply</h6></center>";
page.append(specials);



//random-ish emoji
string [int] e=split_string("😂,👍,❤️,😍,🤣,😊,👫,🚀,👀,💕",",");
string f=e[(gameday_to_int() % count(e))];

//write ~2000 emojis to the page when you push the button. some wont display? 127744 - 129767
page.append("<p><div id=\"ec\"><center><button onclick=\"we()\" style=\"width: 500px;height: 50px;\">Show Emojis "+f+"</button></center></div>\
<script>function we(){let e=\"<hr><font size=7>\";for(let n=127744;n<129768;n++)n%100==0&&(e+=\"<hr>\"),e+=String.fromCodePoint(n)+\" \";document.getElementById(\"ec\").innerHTML=e+\"</font>\"}</script>");

page.append("<script src=account.chatplus.js></script>");
page.append("\n</body>\n</html>");
page.write();
}
