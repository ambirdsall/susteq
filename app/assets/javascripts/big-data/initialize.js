$(document).ready(function(){
  if (BigData.viz_data){
    var dataController = new BigData.DataController();
    dataController.getChartData(BigData.viz_data);

    setTimeout(function(){
      $('#page-wrapper').height($('html').height())
    }, 100);
  }

  if ($('.dataTables-example').length){
    $('.dataTables-example').dataTable();
  }

  if ($('.check-for-new-hubs').length){
    $('#new-hub-alert').hide()
    $('.check-for-new-hubs').on('click',function(){
      $('#new-hub-alert').show();
    })
  }
})
