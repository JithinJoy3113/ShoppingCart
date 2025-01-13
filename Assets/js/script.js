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
                childDiv.setAttribute('id', data.DATA[i][1]);
                let innerNameDiv = document.createElement("div");
                innerNameDiv.innerHTML = data.DATA[i][0]; 
                let innerButtonDiv = document.createElement("div");

                let editImg=document.createElement("img");
                let editButton=document.createElement("button");
                editButton.classList.add('subCategoryeditButton');
                editButton.setAttribute('type', 'button');
                editButton.setAttribute('value', data.DATA[i][1]);
                editButton.setAttribute('onClick','editSubcategory(this)')
                editImg.setAttribute('src', "./Assets/Images/editBtn.png");
                editButton.append(editImg);
                innerButtonDiv.append(editButton);

                let dltImg=document.createElement("img");
                let dltButton=document.createElement("button");
                dltButton.classList.add('subCategoryeditButton');
                dltButton.setAttribute('type', 'button');
                dltButton.setAttribute('value', 'tblSubcategory'+','+ data.DATA[i][1])
                dltButton.setAttribute('onClick','categoryDeleteButton(this)')
                dltImg.setAttribute('src', "./Assets/Images/deleteBtn.png");
                dltButton.append(dltImg);
                innerButtonDiv.append(dltButton);

                let viewImg=document.createElement("img");
                let viewButton=document.createElement("button");
                viewButton.classList.add('subCategoryeditButton');
                viewButton.setAttribute('type', 'button');
                viewButton.setAttribute('value', data.DATA[i][1])
                viewButton.setAttribute('onClick','subcategoryViewButton(this)')
                viewImg.setAttribute('src', "./Assets/Images/goArrow.png");
                viewImg.setAttribute('width', '18');
                viewImg.setAttribute('height', '18');
                viewButton.append(viewImg);
                innerButtonDiv.append(viewButton);

                childDiv.append(innerNameDiv);
                childDiv.append(innerButtonDiv);
                div.append(childDiv); 
            }
        }
    });
}

function editSubcategory(ID){
    let editID = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewSubcategoryEdit',
        type : 'post',
        data : {
            subCategoryId : editID
        },
        success : function(response){
            let data=JSON.parse(response);
            $('#addSubcategoryHeading').text("Edit Subcategory");
            $("#addCategory").addClass("disabled");
            $("#addSubcategoryDiv").css({"display":"flex"});
            $("#viewSubcategory").css({"display":"none"});
            $("#displayContent").css({"display":"none"});
            $('#categoryDropdown').val(data.DATA[0][2]);
            $('#subCategoryInput').val(data.DATA[0][0]);
            $('#subCategorySubmit').val('edit' +','+ data.DATA[0][1]);
        }
    })
}

function addSubCategory(ID){
    let viewId = ID.value;
    $('#addSubcategoryHeading').text("Add Subcategory");
    $("#addCategory").addClass("disabled");
    $("#addSubcategoryDiv").css({"display":"flex"});
    $("#viewSubcategory").css({"display":"none"});
    $("#displayContent").css({"display":"none"});
    $("#subCategorySubmit").val(viewId);
    $("#addCategoryCloseValue").val(viewId);
}

function addSubcategorySubmit(ID){
    let categoryId = ID.value;
    let categoryName =  $("#categoryDropdown").val();
    let subcategoryName =  $("#subCategoryInput").val();
    $.ajax({
        url : './Components/shoppingCart.cfc?method=insertSubcategory',
        type : 'post',
        data : {
            subCategoryName : subcategoryName,
            categoryName : categoryName,
            categoryID : categoryId
        },
        success : function(response){
            let data = JSON.parse(response);
            if (data){
                console.log(data)
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

function addSubCategoryClose(){
    let parentDiv = document.getElementById("categoryFieldDiv");
    parentDiv.innerHTML = ''
    $("#addSubcategoryDiv").css({"display":"none"});
    $("#addCategory").addClass("disabled");
    $("#displayContent").css({"display":"none"});
    $("#viewSubcategory").css({"display":"flex"});
    $("#subcategoryError").text('');
    let categoryId = $("#addCategoryCloseValue").val();
    viewSubButton(document.getElementById('addCategoryCloseValue'));
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


function categoryDeleteButton(ID){
    let selectedValue = ID.value;
    let splitValue = selectedValue.split(",");
    let tableName = splitValue[0];
    let deleteId = splitValue[1];
    $.ajax({
        url : './Components/shoppingCart.cfc?method=deleteRow',
        type : 'post',
        data : {
            tableName : tableName,
            deleteId : deleteId
        },
        success : function(response){
            if (response){
                $('#'+deleteId).remove();
            }
        }
    })
}

function subcategoryViewButton(ID){
    let viewID = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewSubcategoryEdit',
        type : 'post',
        data : {
            subCategoryId : viewID
        },
        success : function(response){
            let data = JSON.parse(response)
            $("#subCategoryHead").text(data.DATA[0][0]);
            $("#addProductButton").val(data.DATA[0][2]+','+data.DATA[0][3]+','+data.DATA[0][0]);
            $('#productViewMainDiv').css({'display':'flex'})
            $("#addCategory").css({"display":"none"});
            $("#viewSubcategory").css({"display":"none"});
        }
    })
}

function addProduct(ID){
    let categoryId=ID.value;
    let splitData=categoryId.split(',');
    let select = $("#addProductCategorySelect");
    let selectSub = $("#addProductSubcategorySelect");
    var selectOption=document.createElement("option");
    var selectSubOption=document.createElement("option");
    selectOption.text=splitData[0];
    selectSubOption.text=splitData[2];
    select.append(selectOption)
    selectSub.append(selectSubOption)
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewCategory',
        type : 'post',
        success : function(response){
            let data=JSON.parse(response);
            for (let i = 0; i < data.DATA.length; i++) {
                if(data.DATA[i][1] != splitData[0]){
                var selectOption=document.createElement("option");
                selectOption.text=data.DATA[i][1];
                select.append(selectOption);
                }
            }
        }
    }),
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewSubcategories',
        type : 'post',
        data :{
            categoryId : splitData[1]
        },
        success : function(response){
            let subData=JSON.parse(response);
            for (let i = 0; i < subData.DATA.length; i++) {
                if(subData.DATA[i][1] != splitData[1]){
                var selectSubOption=document.createElement("option");
                selectSubOption.text=subData.DATA[i][0];
                selectSub.append(selectSubOption);
                }
            }
        }
    })
    $('#productViewMainDiv').css({'display':'none'});
    $('#addProductModal').css({'display':'flex'});
    $.ajax({
        url : './Components/shoppingCart.cfc?method='
    })
}

