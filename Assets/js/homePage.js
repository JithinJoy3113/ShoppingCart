$(document).ready(function () {
    let subcategoryList; ;
    $('.categoryHeadDiv').on('mouseover', function () {
        const categoryId=$(this).attr('data-value');
        subcategoryList=$('#'+categoryId);
        subcategoryList.css({"display":"flex"});
    })

    $('.categoryHeadDiv').on('mouseout', function () {
        subcategoryList.css({"display":"none"}); 
    });

    $('.subCategoryListDiv').on('mouseout', function () {
        subcategoryList.css({"display":"none"}); 
    });

    $('.subCategoryListDiv').on('mouseover', function () {
        if (subcategoryList) {
            subcategoryList.css({"display": "flex"});
        }
    });
    let btn;
    $('.subcategoryBtn').on('mouseover', function () {
        const btnId=$(this).attr('id');
        btn=$('#'+btnId);
        btn.css({"background-color":"#0d9191","color":"white"});

    })
    $('.subcategoryBtn').on('mouseout', function () {
        btn.css({"background-color":"white","color":"black"});
    })
});

function filterButton(){
    $('#filterDiv').css({"display":"flex"})
}

function filterValidate(){
    let min = $('#filterMax').val();
    let max = $('#filterMin').val();
    if (min == '' || max == ''){
        $('#filterError').text('Enter Min and Max')
        return false
    }
    else{
        $('#filterError').text('')
        return true
    }
}