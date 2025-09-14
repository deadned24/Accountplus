//
import account.chatplus.ash;

void main(){
buffer page = visit_url();

page.replace_string("var notchat = true;","var notchat = false;\nvar pwdhash=\""+my_hash()+"\";\n");
rcm_fix(page); //from account.chatplus.ash

page.write();
}
