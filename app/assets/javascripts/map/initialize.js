$(document).ready(function() {
  if ($("#map")){
    var mapView = new HubMap.View(-1.283285, 36.821657, 13);
    mapView.setOSMTileLayer();
    var mapController = new HubMap.Controller(mapView);
    // mapController.parseJsonHubData([testData, testData1]);
    // mapController.view.renderMarkers(mapController.hubs);
    mapController.getAdminKioskData()
  }
});