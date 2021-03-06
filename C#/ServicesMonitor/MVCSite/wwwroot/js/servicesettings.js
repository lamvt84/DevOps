﻿var dataTable;

$(document).ready(function () {
    loadDataTable();
    loadGroup(0);
});

$('#DDL_Load').on('change', function () {
    loadDataTable();
});

function loadDataTable() {
    var selectedId = $("#DDL_Load").val();
    var url = "/api_service/GetList?id=" + selectedId;
    if ($.fn.dataTable.isDataTable('#DT_load')) {
        dataTable = $('#DT_load').DataTable();
        dataTable.destroy();
    }
    dataTable = $('#DT_load').DataTable({
        "ajax": {
            "url": url,
            "type": "GET",
            "datatype": "json"
        },
        "columns": [
            { "data": "name" },
            { "data": "url" },
            {
                "data": "createdTime",
                "render": function (data) {
                    return convertDatetimeOffset(data);
                }
            },
            { "data": "status", "className": "text-center" },
            { "data": "enable", "className": "text-center" },
            { "data": "specialCase", "className": "text-center" },
            {
                "data": "id",
                "render": function (data) {
                    return `<div class="text-center">
                        <a href="/Config/ServiceInsertOrUpdate?id=${data}" class='btn btn-success text-white' style='cursor:pointer; width:70px;'>
                            Edit
                        </a>
                        &nbsp;
                        <a class='btn btn-danger text-white' style='cursor:pointer; width:70px;'
                            onclick=Delete('/api_service/Delete?id='+${data})>
                            Delete
                        </a>
                        </div>`;
                }
            }
        ],
        "language": {
            "emptyTable": "no data found"
        },
        "width": "100%",
        "pageLength": 50
    });
}