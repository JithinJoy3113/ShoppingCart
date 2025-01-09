function logoutValidate(){
    $("#logoutConfirm").css({"display":"flex"});
    $("#displayContent").addClass("disabled");
    $("#addCategory").addClass("disabled");
}

function logoutAlert(value){

    let valid = true;
    if(value == 'yes'){
        $.ajax({
            url:'./Components/shoppingCart.cfc?method=userLogout',
            type: "post",
            success: function (response) {
                if(response){
                    $("#logoutConfirm").css({"display":"none"});
                    $("#displayContent").removeClass("disabled");
                    $("#addCategory").removeClass("disabled");
                }
                else{
                    valid = false
                }
            }
         });
    }
    else{
        valid = false;
        $("#logoutConfirm").css({"display":"none"});
        $("#displayContent").removeClass("disabled");
        $("#addCategory").removeClass("disabled");
    }
    return valid;
}

function categoryAdd(ID){
    let editId=ID.value;
    if(editId.length){
        $.ajax({
            url:'./Components/shoppingCart.cfc?method=editCategory',
            type: "post",
            data:{
                editId:editId
            },
            success: function (response) {
                let data = JSON.parse(response);
                $("#addCategoryDiv").css({"display":"flex"});
                $("#displayContent").css({"display":"none"});
                $("#editingID").val(data.FLDCATEGORY_ID);
                $("#categoryInput").val(data.FLDCATEGORYNAME);
                return true
            }
        });
    }
    else{
        $("#addCategoryDiv").css({"display":"flex"});
        $("#displayContent").css({"display":"none"});
    }
}

function addCategoryClose(){
    $("#addCategoryDiv").css({"display":"none"});
    $("#displayContent").css({"display":"flex"});
}