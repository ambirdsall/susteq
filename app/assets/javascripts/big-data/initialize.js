$(document).ready(function(){
  if (BigData.viz_data){
    var dataController = new BigData.DataController();
    dataController.getChartData(BigData.viz_data)
  }
  if ($('.dataTables-example').length){
    $('.dataTables-example').dataTable();
  }
})
