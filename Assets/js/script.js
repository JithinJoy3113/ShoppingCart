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
                viewButton.setAttribute('id', data.DATA[i][1])
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
            $("#addProductButton").val(data.DATA[0][2]+','+data.DATA[0][3]+','+data.DATA[0][0]+','+data.DATA[0][1]);
            var subCategoryId=data.DATA[0][1];
            $('#productViewMainDiv').css({'display':'flex'})
            $("#addCategory").css({"display":"none"});
            $("#viewSubcategory").css({"display":"none"});
            let div = $("#subcategoryProductDiv")
            $.ajax({
                
                url : './Components/shoppingCart.cfc?method=viewProducts',
                type : 'post',
                data : {
                    columnName : 'fldSubcategoryId',
                    productSubId : subCategoryId
                },
                success : function(response) {
                    let data=JSON.parse(response);
                    for (let i = 0; i < data.DATA.length; i++) {
                        var childDiv=`<div class="similarProductcol d-flex flex-column ms-2" id=${data.DATA[i][4]}>
                                        <img src="Assets/uploadImages/#local.result.fldImageFileName#" class="similarImage mx-auto" height="186" alt="">
                                        <div class="productDiscriptionsdiv d-flex align-items-center mt-3">
                                            <img src="Assets/uploadImages/${data.DATA[i][3]}" class="" alt="" width="50" height="50">
                                            <div class="d-flex flex-column">
                                                <span class="productsNamespan">${data.DATA[i][0]}</span>
                                                <span class="productsNamespan">${data.DATA[i][1]}</span>
                                                <span class="similarPrice">RS.${data.DATA[i][2]}</span>
                                            </div>
                                            <div class="d-flex">
                                                <button type="button" class="border-0" name="editBtn" value=${data.DATA[i][4]}  onClick="return editProductsButton(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                                <button type="button" class="border-0" name="deleteBtn" value=${data.DATA[i][4]} onClick="productDeleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
                                            </div>
                                        </div>
                                    </div>`;
                        div.append(childDiv)
                    }
                  }
                })
        }
    })
}

function productDeleteButton(ID){
    let selectedValue = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=deleteRow',
        type : 'post',
        data : {
            tableName : 'tblProducts',
            deleteId : selectedValue
        },
        success : function(response){
            if (response){
                $('#'+selectedValue).remove();
            }
        }
    })
}


function editProductsButton(ID){
    let productId = ID.value;
    alert(productId)
    $('#productViewMainDiv').css({'display':'none'});
    $('#addProductModal').css({'display':'flex'});
    $('#addProductImage').css({'display':'none'});
    $('#addProductLabel').css({'display':'none'});
    $('#addProductSubmit').css({'display':'none'});
    $('#updateProductSubmit').css({'display':'flex'});
    $('#updateProductSubmit').val(productId);
    $.ajax({
        url:'./Components/shoppingCart.cfc?method=viewProducts',
        type : 'post',
        data :{
            columnName : 'fldProduct_ID',
            productSubId : productId
        },
        success : function(response){
            let data = JSON.parse(response)
            console.log(data)
            $('#addProductNameInput').val(data.DATA[0][1]);
            $('#addProductPrice').val(data.DATA[0][2]);
            $('#addProductDescription').val(data.DATA[0][5]);
            $('#addProductTax').val(data.DATA[0][6]);
            let categorySelect=$('#addProductCategorySelect');
            let option = $('<option>', {value : data.DATA[0][9], text : data.DATA[0][8]});
            categorySelect.append(option)
            let subCategorySelect=$('#addProductSubcategorySelect');
            let subOption = $('<option>', {value : data.DATA[0][10], text : data.DATA[0][7]});
            subCategorySelect.append(subOption)
            let brandSelect=$('#brandSelect');
            brandSelect.empty();
            let brandOption = $('<option>', {value : data.DATA[0][11], text : data.DATA[0][0]});
            brandSelect.append(brandOption)

            $.ajax({
                url : './Components/shoppingCart.cfc?method=viewCategory',
                type : 'post',
                success : function(response){
                    let data=JSON.parse(response);
                    let categorySelect=$('#addProductCategorySelect');
                    for (let i = 0; i < data.DATA.length; i++) {
                        if(data.DATA[i][1] !=  data.DATA[0][8]){
                            var selectOption=document.createElement("option");
                            selectOption.setAttribute('value', data.DATA[i][0])
                            selectOption.text=data.DATA[i][1];
                            categorySelect.append(selectOption);
                        }
                    }
                }
            }),
            $.ajax({
                url : './Components/shoppingCart.cfc?method=viewSubcategories',
                type : 'post',
                data :{
                    categoryId : data.DATA[0][9]
                },
                success : function(response){
                    let subData=JSON.parse(response);
                    let subCategorySelect=$('#addProductSubcategorySelect');
                    for (let i = 0; i < subData.DATA.length; i++) {
                        if(subData.DATA[i][0] != data.DATA[0][7]){
                        var selectSubOption=document.createElement("option");
                        selectSubOption.setAttribute('value',  subData.DATA[i][1])
                        selectSubOption.text=subData.DATA[i][0];
                        subCategorySelect.append(selectSubOption);
                    }
                }
            }
            })
            $.ajax({
                url : './Components/shoppingCart.cfc?method=viewBrand',
                type : 'post',
                success : function(response){
                    let subData=JSON.parse(response);
                    let brandSelect=$('#brandSelect');
                    for (let i = 0; i < subData.DATA.length; i++) {
                        if(subData.DATA[i][0] != data.DATA[0][0]){
                        var selectSubOption=document.createElement("option");
                        selectSubOption.setAttribute('value',  subData.DATA[i][1])
                        selectSubOption.text=subData.DATA[i][0];
                        brandSelect.append(selectSubOption);
                        }
                    }
                }
            })

        }
    })
}

function updateProductsubmit(ID){
    let productID = ID.value;
    let formData = new FormData($('#productForm')[0]);
    formData.append("productId",productID)
    $.ajax({
        url : './Components/shoppingCart.cfc?method=updateProduct',
        type : 'post',
        data : formData,
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        success : function(response){
            
        }
    })
}

function addProductClose(){
    $('#productViewMainDiv').css({'display':'flex'});
    $('#addProductModal').css({'display':'none'});
}
function addProductsubmit(){
    let formData = new FormData($('#productForm')[0]);
    $.ajax({
        url : './Components/shoppingCart.cfc?method=insertProduct',
        type : 'post',
        data : formData,
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        success : function(response){
            
        }
    })
}

function addProduct(ID){
    let categoryId=ID.value;
    let splitData=categoryId.split(',');
    let select = $("#addProductCategorySelect");
    let selectSub = $("#addProductSubcategorySelect");
    var selectOption=document.createElement("option");
    selectOption.setAttribute('value',splitData[1]);
    selectOption.text=splitData[0];
    var selectSubOption=document.createElement("option");
    selectSubOption.setAttribute('value', splitData[3]);
    selectSubOption.text=splitData[2];
    select.append(selectOption);
    selectSub.append(selectSubOption);
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewCategory',
        type : 'post',
        success : function(response){
            let data=JSON.parse(response);
            for (let i = 0; i < data.DATA.length; i++) {
                if(data.DATA[i][1] != splitData[0]){
                    var selectOption=document.createElement("option");
                    selectOption.setAttribute('value', data.DATA[i][0])
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
                if(subData.DATA[i][0] != splitData[2]){
                var selectSubOption=document.createElement("option");
                selectSubOption.setAttribute('value',  subData.DATA[i][1])
                selectSubOption.text=subData.DATA[i][0];
                selectSub.append(selectSubOption);
                }
            }
        }
    })
    $('#productViewMainDiv').css({'display':'none'});
    $('#addProductModal').css({'display':'flex'});
}

$(document).ready(function() {
	$("#addProductCategorySelect").change(function() {
		let categoryId = this.value;
        $.ajax({
            type: "POST",
            url: "./Components/shoppingCart.cfc?method=viewSubcategory",
            data: {
                categoryId: categoryId
            },
            success: function(response) {
                const data = JSON.parse(response);
                $("#addProductSubcategorySelect").empty();
                for(let i=0; i<data.DATA.length; i++) {
                    let subCategoryName = data.DATA[i][0];
                    let  subCategoryId= data.DATA[i][1];
                    let optionTag = `<option value="${subCategoryId}">${subCategoryName}</option>`;
                    $("#addProductSubcategorySelect").append(optionTag);
                }
            }
        });	
	});
});

