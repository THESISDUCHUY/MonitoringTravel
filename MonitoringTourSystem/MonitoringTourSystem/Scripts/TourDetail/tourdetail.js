


function GetTourDetail(id) {
    $.ajax({
        url: "/TourDetail/GetDetailTour/" + id,
        type: "GET",
    })
    .done(function (partialViewResult) {
        $("#tour-details").html(partialViewResult);
    });
}

function searchTour() {
    var id = $('#nametour').val();
    $.ajax({
        url: "/TourDetail/SearchTourGuide/" + id,
        type: "GET",
    })
    .done(function (partialViewResult) {
        $("#list-tour").html(partialViewResult);
    });
}

function searchWithDateAndTown()
{
    var dayValue = $("#daysearch").val();
    var region = $("#region").val();
    $.ajax({
        url: "/TourDetail/SearchByDateAndTown",
        type: "POST",
        data: 
            {
                regionSearch: region,
                dateSearch: dayValue,
            },
    })
    .done(function (partialViewResult) {
        $("#list-tour").html(partialViewResult);
    });
}

$(document).ready(function () {
    $('.datepicker_init').datetimepicker({
        locale: 'es',
        format: 'YYYY-MM-DD',
        useCurrent: false
    });
    $('.datepicker_end').datetimepicker({
        locale: 'vi',
        format: 'YYYY-MM-DD',
        useCurrent: false
    });
    var listRegion = ["Miền Bắc", "Miền Trung", "Miền Nam"];
    $("#region").select2({
        data: listRegion
    });
});
