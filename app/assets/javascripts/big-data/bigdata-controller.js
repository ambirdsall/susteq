BigData.DataController = function(){
  this.kiosks = [];
  this.pumps = [];
};

BigData.DataController.prototype = {

  allHubs: function(){
    return this.kiosks.concat(this.pumps)
  },

  getAdminData: function(func){
    var pumpAjax = $.ajax({
      url:"/admin/pumps.json",
      method:"get",
      success:this.parseJsonPumpData.bind(this)
    });
    var kioskAjax = $.ajax({
      url:"/admin/kiosks.json",
      method:"get",
      success:this.parseJsonKioskData.bind(this)
    });
    $.when(pumpAjax, kioskAjax).done(func)
  },

  adminGetKioskData: function(){
    var kioskAjax = $.ajax({
      url:"/admin/kiosks.json",
      method:"get",
      success: this.parseJsonKioskData.bind(this)
    })
  },

  parseJsonKioskData: function(kioskData){
    for(var i= 0; i<kioskData.length; i++){
      var kiosk = new Kiosk(kioskData[i].hub);
      kiosk.parseTransactions(kioskData[i].transactions)
      this.kiosks.push(kiosk);
    }
  },

  adminGetPumpData: function(){
    var pumpAjax = $.ajax({
      url:"/admin/pumps.json",
      method:"get",
      success: this.parseJsonPumpData.bind(this)
    })
  },

  parseJsonPumpData: function(pumpData){
    for(var i= 0; i<pumpData.length; i++){
      var pump = new Pump(pumpData[i].hub);
      pump.parseTransactions(pumpData[i].transactions)
      this.pumps.push(pump);
    }
  },

  getProviderKioskData: function(){
  },

  getProviderPumpData: function(){
  },
}