# Account+
Relay override script for Kingdom of Loathing's account menu to add new options

## New Menu Items
Adds 2 new options to the account menu ("options"), "Mafia" and "Chat+"

<img width="1076" height="442" alt="extraoptions" src="https://github.com/user-attachments/assets/894b6800-5d40-4fd5-86e1-e35f870efc07" />

### Mafia
Another way to interact with kolmafia variables (user preferences). Useful for toggling properties for scripts or simply viewing variables you wish to watch.  

### Chat+
Enhances chat by adding user created content to the right click menu, allowing "tags" to other players with emojis or short bits of text. Also includes (optioanl) filters for chat, such as reducing excessive colors or reversing /hardcore's occasional right-to-left text. 
The underlying principle is CSS rules are being inserted into chat. These visual changes are **local only** and will not be seen by others. `lchat.ash` and `mchat.ash` relay scripts are needed to insert the modified CSS. 

<img width="226" height="246" alt="rcm" src="https://github.com/user-attachments/assets/a01b311f-b142-4b2f-a9f2-9c4e871ac1a8" />

Other relay scripts can import the modified CSS, such as `museum.ash` if one wishes to see tags there.

# Install
Extract the contents of relay.zip to your mafia's relay folder. 
