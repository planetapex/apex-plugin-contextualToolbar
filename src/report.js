function meFunc(ola){
alert($v('P21_ATOM'));
}

function openStandardPage() {
   console.log($v('P5_ATOM'));    
   var l_url = 'f?p=&APP_ID.:28:&SESSION.::&DEBUG.::P28_ITEM:' + $v('P21_ATOM');
   console.log(l_url);  
    apex.server.process('PREPARE_URL', { "x01": l_url }, {
        "dataType": "text",
        async: false,
        "success": function(pData) {
            console.log(pData);
            if (pData === 'INVALID') {
                console.log('The data you have entered is invalid');
            };
        }
   });
   apex.navigation.redirect(l_url);  

   
}

function openDialog(elm) {
    console.log(elm);
    console.log($v('P21_ATOM'));        

// open dialog page 3 for the specific department
        // the dialog url including checksum is in the data-link attribute 
        // on the button that opens the menu

   var l_url = 'f?p=&APP_ID.:29:&SESSION.::&DEBUG.::P29_ITEM:' + $v('P21_ATOM');
   
    apex.server.process('PREPARE_URL', { "x01": l_url }, {
        "dataType": "text",
        async: false,
        "success": function(pData) {
            console.log(pData);            
            if (pData === 'INVALID') {
                console.log('The data you have entered is invalid');
            };
            l_url = pData;

        }
    });
    //get the link and unescape unicode chars
    var  link = l_url.replace(/\\u(\d\d\d\d)/g, function(m,d) {
          return String.fromCharCode(parseInt(d, 16));
        });
  
  apex.navigation.dialog(link,
                         {title: 'Modal Page', 
                          resizable: true, draggable: true, height:500,width:720,maxWidth:960,modal:true,dialog:null}, 
                          't-Dialog--standard',
                          this);

}