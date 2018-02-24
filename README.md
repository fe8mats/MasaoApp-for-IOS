# MasaoApp for iOS - build 1.0.6
Developer: Tex (Tetsuya Matsuda),
* Official Website - <http://tm.774music.com/>
* Super Masao MY - <http://tex1.symphonic-net.com/>
* Twitter - [@393mats](https://twitter.com/393Mats)

<img src="https://github.com/393mats/MasaoApp-for-IOS/blob/master/PR_Image/MasaoApp_mu_1.png" width="50%">
<img src="https://github.com/393mats/MasaoApp-for-IOS/blob/master/PR_Image/MasaoApp_mu_2.png" width="50%">


MasaoApp is the project of smartphone application for the very ~~famous~~ traditional parody web game __"SuperMasao"__. Original Masao Construction for Java is developed by [Naoto Fukuda](http://www.t3.rim.or.jp/~naoto/naoto.html), and JSMasao is ported by [Ryo](http://ryo-9399.github.io/).  

The base of game editor is the new version of  [BAMP](http://tex1.symphonic-net.com/bamp/about.html) which has been developed using HTML5 and CSS3. So in this app, Webview component is put full-page. Thanks to that, MasaoApp is easy to port to other system if developer write the program for connection with native application. Also background layer and some other functions are excluded from the app. There are 2 reasons why I did that. One is in order to fascinate some people who wants to make more original Masao game, through the MasaoApp limited game functions. And another reason is I was just lazy to implement. The app can handle JSON file based on the masao-json-format, and can export basic HTML param data. Therefore it has good compatibility for other editor or service, except some excluded functions. 

# MasaoQR
A big feature in this app is the QR scanning and sharing. It is for the first time in the Masao history. Creators can share their new stage data using MasaoQR. When creators uploaded stage data, stage ID is issued, and then the app output QR code including the ID. They can share that QR code on Twitter, Instagram and whatever SNS they uses. Users scan these QR codes, and can play their game. Of course QR code is "image". People can print, and share with a paper or others. 

MasaoQR code includes this information.
```
ms_app://<STAGE ID>
```
The app's QR reader ignore QR code if "ms_app://" is not included. This is a trigger. User who scanned QR code access the stage data through the STAGE ID.

**Now in this version (Build 1.0.6), QRsharing is not supported yet.**

---
# Files not included in git
- Icons, certificate, etc...
- Main_html/
    - CanvasMasao.js
    - css/
        - materialize.min.css
        - mtf/
            - MaterialIcons-Regular.eot
            - MaterialIcons-Regular.ttf
            - MaterialIcons-Regular.woff
            - MaterialIcons-Regular.woff2
    - js/
        - materialize.min.js
        - jquery-3.2.1.min.js

# Used libraries and formats
* [mc_canvas](http://ryo-9399.github.io/) - JSMasao main program
* [masao-json-format](https://spec.masao.space/masao-json-format/) - Masao gamedata format
* [Firebase](https://firebase.google.com/) - Server side system
* [Materialize](http://materializecss.com/) - CSS framework
* [Material icons]() - Good icons
* jQuery
---
# License
MIT, but licenses of used libraries and formats are depending on their original license.

Copyright (c) 2018 Tex (Tetsuya Matsuda)
https://msapp.fe8works.com/

Permission is hereby granted, free of charge, to any person obtaining a 
copy of this software and associated documentation files (the 
"Software"), to deal in the Software without restriction, including 
without limitation the rights to use, copy, modify, merge, publish, 
distribute, sublicense, and/or sell copies of the Software, and to 
permit persons to whom the Software is furnished to do so, subject to 
the following conditions:

The above copyright notice and this permission notice shall be 
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE 
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION 
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
