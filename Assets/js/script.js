$(document).on("click", function () {
    $(".removeSpan").hide();
});


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

function categoryValidate(){
    let category=$('#categoryInput').val();
    if(category == ""){
        $('#categoryError').text("Category Name Required");
        return false;
    }
    else{
        return true;
    }
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
                $("#updateCategoryButton").css({"display":"flex"});
                $("#addCategoryButton").css({"display":"none"});
                $("#addCategoryHeading").text("Edit Category");
                $("#displayContent").css({"display":"none"});
                $("#editingID").val(data.FLDCATEGORY_ID);
                $("#categoryInput").val(data.FLDCATEGORYNAME);
                return true
            }
        });
    }
    else{
        $("#updateCategoryButton").css({"display":"none"});
        $("#addCategoryButton").css({"display":"flex"});
        $("#addCategoryHeading").text("Add New Category");
        $("#addCategoryDiv").css({"display":"flex"});
        $("#displayContent").css({"display":"none"});
    }
}

function viewSubButton(ID){
    let viewId = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewSubcategory',
        type : 'post',
        data : {
            categoryId : viewId
        },
        success : function(response){
            let data = JSON.parse(response);
            $("#addCategory").addClass("disabled");
            $("#displayContent").css({"display":"none"});
            $("#viewSubcategory").css({"display":"flex"});
            $("#subAddButton").val(viewId);
            $("#subCategoryHidden").val(viewId);
            $("#addCategoryCloseValue").val(viewId);
            
            let div = $("#categoryFieldDiv"); 
            for (let i = 0; i < data.DATA.length; i++) {
                let childDiv = document.createElement("div");
                childDiv.classList.add('subCategoryShowDiv')
                let innerNameDiv = document.createElement("div");
                innerNameDiv.innerHTML = data.DATA[i][0]; 
                let innerButtonDiv = document.createElement("div");

                let editImg=document.createElement("img");
                let editButton=document.createElement("button");
                editButton.classList.add('subCategoryeditButton');
                editButton.setAttribute('value', data.DATA[i][1]);
                editButton.setAttribute('onClick','editSubcategory(this)')
                editImg.setAttribute('src', "./Assets/Images/editBtn.png");
                editButton.append(editImg);
                innerButtonDiv.append(editButton);

                let dltImg=document.createElement("img");
                let dltButton=document.createElement("button");
                dltButton.classList.add('subCategoryeditButton')
                dltButton.setAttribute('value', data.DATA[i][1])
                dltButton.setAttribute('onClick','dltSubcategory(this)')
                dltImg.setAttribute('src', "./Assets/Images/deleteBtn.png");
                dltButton.append(dltImg);
                innerButtonDiv.append(dltButton);

                childDiv.append(innerNameDiv);
                childDiv.append(innerButtonDiv);
                div.append(childDiv); 
            }
        }
    });
}

function addSubCategory(ID){
    let viewId = ID.value;
    $("#addCategory").addClass("disabled");
    $("#addSubcategoryDiv").css({"display":"flex"});
    $("#viewSubcategory").css({"display":"none"});
    $("#displayContent").css({"display":"none"});
    $("#subCategorySubmit").val(viewId);
}

function addSubcategorySubmit(ID){
    let categoryId = ID.value;
    let subcategoryName =  $("#subCategoryInput").val();
    $.ajax({
        url : './Components/shoppingCart.cfc?method=insertSubcategory',
        type : 'post',
        data : {
            subCategoryName : subcategoryName,
            categoryID : categoryId
        },
        success : function(response){
            let data = JSON.parse(response);
            if (data){
                $("#subcategoryError").attr("class","text-success");
                $("#subcategoryError").text('Subcategory Added');
                $("#subCategoryInput").val('');

                return true;
            }
            else{
                $("#subcategoryError").attr("class","text-danger");
                $("#subcategoryError").text('Subcategory already exist');
                $("#subCategoryInput").val('');
            }
        }
    })
    
}

function addCategoryClose(){
    $("#addCategoryDiv").css({"display":"none"});
    $("#displayContent").css({"display":"flex"});
    $("#viewSubcategory").css({"display":"none"});
    $("#addCategory").removeClass("disabled");
    $("#categoryInput").val('')
    let parentDiv = document.getElementById("categoryFieldDiv");
    parentDiv.innerHTML = ''
}

function addSubCategoryClose(ID){
    let categoryId=ID.value;
    $("#addSubcategoryDiv").css({"display":"none"});
    $("#addCategory").addClass("disabled");
    $("#displayContent").css({"display":"none"});
    $("#viewSubcategory").css({"display":"flex"});
    $("#subcategoryError").text('');
    viewSubButton(categoryId);
}

function loginValidation(){
    let email = $('#userName').val();
    let password = $('#password').val();

    let valid = true;

    if (email == ''){  
        $('#mailError').text("Please enter your user name");
        valid = false;
    }
    else if(!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email) && !/^\d{10}$/.test(email)){
        $('#mailError').text("Invalid UserName");
        valid = false;
    }
    else{
        $('#mailError').text("");
    }
    if (password == ''){  
        $('#passwordError').text("Please enter your password");
        valid = false;
    }
    else{
        $('#passwordError').text("");
    } 
    return valid;
}

