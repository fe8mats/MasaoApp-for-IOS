# MasaoApp for iOS
MasaoApp is the project of smartphone application for the very ~~famous~~ tradtional parody web game __"SuperMasao"__. Original Masao Construction for Java is developed by [Naoto Fukuda](http://www.t3.rim.or.jp/~naoto/naoto.html), and JSMasao is ported by [Ryo](http://ryo-9399.github.io/).  

The base of game editor is the new version of  [BAMP](http://tex1.symphonic-net.com/bamp/about.html) which has been developed using HTML5 and CSS3. In this app, Webview component is put full-page for that. Also background layer and some other functions are excluded from app. There are 2 reasons why I did that. One is in order to fascinate some people who wants to make more original Masao game, through the MasaoApp limited game functions. And another reason is I was just lazy to implement. The app can handle JSON file based on the masao-json-format, and can export basic HTML param data. Therefore it has good compatibility for other editor or service, except some excluded functions. 

# MasaoQR
A big feature in this app is the QR scanning and sharing. It is for the first time in Masao history. Creators can share their original game stage using MasaoQR.

# Used library and format
* [mc_canvas](http://ryo-9399.github.io/) - JSMasao main program
* [masao-json-format](https://spec.masao.space/masao-json-format/) - Masao gamedata format
* [Firebase](https://firebase.google.com/) - Server side system
* [Materialize](http://materializecss.com/) - CSS framework
* [Material icons]() - Good icons
* jQuery
