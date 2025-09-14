//puts a table displaying floors, with links

import account.chatplus.ash;

void BoardRank(buffer page){

//(modified) LostCalPolyDude's board rankings https://kolmafia.us/threads/challenge-path-leaderboard-rank-labels.11386/
	matcher player = create_matcher( "(<a class=nounder href=\"showplayer.php\\?who=[\\d]+\">)<b>(.+?)</b>", page );
	int i = 0;
	boolean std=( to_int( form_field("whichboard") ) >= 900 );
	while ( player.find() ){
		i = 1 + (std ? i % 50 : i % 35);
		string place =  i < 10 ? "&nbsp; "+i : std && i>20 ? "" : i ;
		int start = page.index_of( player.group(0) );
		int end = start + player.group(0).length();
		string color = i == 1 ? "#DAA520" : i <= 12 ? "#909090" : "#B87333";
		replace( page, start, end, "<span style='font-weight:700;color:" + color + "'>"+place+"&nbsp;</span>" + player.group(1) + player.group(2));		
		}
}

void zeroFloor(buffer page){
//an empty-sh floor for a dumb joke
write("<html><centeR><map name=elemap><area shape=\"rect\" coords=\"29,23,48,41\" href=\"museum.php?floor=1\" alt=\"Up Button\" title=\"Up Button\"><area shape=\"rect\" coords=\"29,41,48,59\" alt=\"Down Button\" title=\"Down Button\"></map><table  width=95%  cellspacing=0 cellpadding=0><tr><td style=\"background-color: blue\" align=center ><b style=\"color: white\">The Museum, Basement</b></td></tr><tr><td style=\"padding: 5px; border: 1px solid blue;\"><center><table><tr><td><center><table cellpadding=0 cellspacing=0><tr><td colspan=6 width=500 height=100><img src=/images/otherimages/museum/museum_top.gif width=500 height=100 border=0></td></tr> <tr><td width=50 height=400 rowspan=4><img src=/images/otherimages/museum/museum_left.gif width=50 height=400></td><td width=300 height=100 colspan=3></td><td width=100 height=100><img src=/images/otherimages/museum/museum_elevator.gif width=100 height=100 border=0 usemap=\"#elemap\"></td><td width=50 height=400 rowspan=4><img src=/images/otherimages/museum/museum_right.gif width=50 height=400></td></tr> <tr><td width=200 height=100 colspan=2></td><td width=100 height=100> \
<img id=lies src=images/itemimages/cake1.gif style=\"cursor: pointer;\"> \
</td><td width=100 height=100></a></td></tr><tr><td width=400 height=100 colspan=4></td></tr><tr><td width=400 height=100 colspan=4></td></tr><tr><td colspan=6 height=100 width=500><img src=/images/otherimages/museum/museum_bottomwindow.gif width=500 height=100 border=0></td></tr></table><p><a href=town.php style=\"color:black;\">Back to Seaside Town</a></center></td></tr></table></center></td></tr><tr><td height=4></td></tr></table></center> \
<script> document.getElementById('lies').onclick = function() { alert(\'You found an oyster egg!\');     this.src = 'images/itemimages/eggplain.gif'; }; </script>\
</body><script src=\"/onfocus.1.js\"></script></html>");
}

void main(){
buffer page=visit_url();

//"secret" basement
if ( form_field("floor") == "0" ){
	zeroFloor(page);
	exit;
	}

string [int] floors = {
  1: "Current & Recent, Misc.",
  2: "Older Paths",
  3: "Very Old Paths",
  4: "Ancient Paths 🪦",
  5: "Content, Statistics",
  6: "World Events",
  7: "Old Standard Leaderboards",
};

//make table overflow cell when it's "too big"
string quick="<table border=1px width=175px bgcolor=white style=\"position:absolute; left:-25px; top:-50px; z-index:10;\">";
foreach a,b in floors
	quick+="<tr><td><a href=museum.php?floor="+a+">"+a+"</td><td>"+b+"</td></tr>";
quick+="</table>";

string a="museum_right.gif width=50 height=400></td>";
page.replace_string(a,a+"<td style=\"position: relative;\">"+quick+"</td>");


page.replace_string("var notchat = true;","var notchat = false;\nvar pwdhash=\""+my_hash()+"\";\n");
rcm_fix(page); //from account.chatplus.ash

if ( to_int( form_field( "whichboard" ) ) >= 9 )
	BoardRank(page);

write(page);
}
