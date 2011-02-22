Obfuscator = {

  extractUrl: function(url) {
    pattern = /#(.+)$/
    if (url.match(pattern)) {
      return "/" + RegExp.$1.replace(/%23/g,'/');
    }
  },
  
  decode: function(elem){

    var text = Obfuscator.extractUrl(elem.href);
    var dst = '';
    var len = text.length;

    if  (text.length > 0) {
     for(var i=0; i < text.length ; i++) {
       b = text.charCodeAt(i)
       if( ( (b>64) && (b<78) ) || ( (b>96) && (b<110) ) ) {
          b=b+13;
      } else {
        if( ( (b>77) && (b<91) ) || ( (b>109) && (b<123) ) ) { b=b-13; }
      }
      t=String.fromCharCode(b);
      dst=dst.concat(t);
     }
    }
   elem.href = dst;
  }
}

