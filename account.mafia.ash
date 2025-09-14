//sub form of account.ash

void main() {
int [string] mafiaVals;
string menuName=to_lower_case(my_name())+"_Menu.txt";
file_to_map(menuName, mafiaVals);

string dn_action = form_field("action");
string dn_task = form_field("addKey");
string dn_value = form_field("value");

switch (dn_action){
	case "NEW" :
		mafiaVals[dn_value]=to_int(form_field("bool"));
		map_to_file( mafiaVals, menuName );
		break;
	case "destory" :
		remove mafiaVals[form_field("value")];
		map_to_file( mafiaVals, menuName );
		break;
	case "update" :
		set_property(dn_value, form_field("update"));
		break;
}

string page = "<html><head><title>Mafia Preferences</title>\n\
<link rel=\"stylesheet\" type=\"text/css\" href=\"account.mafia.css\">";
page+="<link rel=\"stylesheet\" type=\"text/css\" href=\"//images.kingdomofloathing.com/styles.20150113.css\">";
page+="\n<style type=\"text/css\">input.button {\n	border: 2px black solid;\n	font-family: Arial, Helvetica, sans-serif;\n	font-size: 10pt;\n	font-weight: bold;\n	background-color: #FFFFFF;\n	color: #000000;\n	-webkit-appearance: none;\n	-webkit-border-radius: 0;\n}\n</style></head>\n";

page+="<div class=\"scaffold\"></div><div class=\"subhead\">Mafia Preferences:</div><div class=indent>";
page+="A <strike>convenient</strike> way to see and change user variables<p>";

foreach a,b in mafiaVals {
	page+="\
		<div class=\"item\" data-value=\""+a+"\">\
		<span class=\"destroy\" data-value=\""+a+"\" role=button>x</span>\
		<span class=strong class=\"key\">"+a+"</span>"+
		(b==1?
		"<span class=valueF>True:<input type=\"checkbox\" class=\"update-checkbox\" "+(to_boolean(get_property(a))?" checked":" ")+"></span>":
		"<input type=\"text\" class=\"valueF update-input\" value=\""+get_property(a)+"\">")+
		"<span class=\"btn-like update\" id=\"sendRequest\" role=\"button\" data-value=\""+a+"\">change</span>\
		 <div class=\"sav\" style=\"display:inline-block;margin-left:8px;\"></div>\
		</div>";
	}
page+="<p><div>\
<input type=\"text\" id=addvalue placeholder=\"Add property\">\
<span class=valueF>bool:\
<input type=\"checkbox\" id=addcheck value=\"0\">\
</span>\
<span class=\"btn-like\" id=\"ADD\" role=\"button\" style=\"width:60px;\">Add</span>\
</div>";

page+=" <script src=account.mafia.js></script>\
<script>var url_form='account.mafia.ash';</script></body></html>";

write(page);
}
