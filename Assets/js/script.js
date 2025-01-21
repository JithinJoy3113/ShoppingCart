$(document).on("click", function () {
    $(".removeSpan").empty()
});

function logoutValidate(){
    $("#logoutConfirm").css({"display":"flex"});
    $("#addCategory").addClass("disabled");
    $("#displayContent").addClass("disabled");
    $("#addSubcategoryDiv").addClass("disabled");
    $("#viewSubcategory").addClass("disabled");
    $("#productViewMainDiv").addClass("disabled");
    $("#userBodyMainDiv").addClass("disabled");
    $("#headerNav").addClass("disabled");
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
                    $("#addSubcategoryDiv").removeClass("disabled");
                    $("#viewSubcategory").removeClass("disabled");
                    $("#productViewMainDiv").removeClass("disabled");
                    $("#userBodyMainDiv").removeClass("disabled");
                    $("#headerNav").removeClass("disabled");
                    location.href = "./login.cfm"
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
        $("#addCategory").removeClass("disabled");
        $("#addSubcategoryDiv").removeClass("disabled");
        $("#viewSubcategory").removeClass("disabled");
        $("#productViewMainDiv").removeClass("disabled");
        $("#userBodyMainDiv").removeClass("disabled");
        $("#headerNav").removeClass("disabled");
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
            for (let struct of data) {
                let childDiv = document.createElement("div");
                childDiv.classList.add('subCategoryShowDiv')
                childDiv.setAttribute('id', struct.subcategoryId);
                let innerNameDiv = document.createElement("div");
                innerNameDiv.innerHTML = struct.subcategoryName; 
                let innerButtonDiv = document.createElement("div");

                let editImg=document.createElement("img");
                let editButton=document.createElement("button");
                editButton.classList.add('subCategoryeditButton');
                editButton.setAttribute('type', 'button');
                editButton.setAttribute('value',struct.subcategoryId);
                editButton.setAttribute('onClick','editSubcategory(this)')
                editImg.setAttribute('src', "./Assets/Images/editBtn.png");
                editButton.append(editImg);
                innerButtonDiv.append(editButton);

                let dltImg=document.createElement("img");
                let dltButton=document.createElement("button");
                dltButton.classList.add('subCategoryeditButton');
                dltButton.setAttribute('type', 'button');
                dltButton.setAttribute('value', 'tblSubcategory'+','+ struct.subcategoryId)
                dltButton.setAttribute('onClick','categoryDeleteButton(this)')
                dltImg.setAttribute('src', "./Assets/Images/deleteBtn.png");
                dltButton.append(dltImg);
                innerButtonDiv.append(dltButton);

                let viewImg=document.createElement("img");
                let viewButton=document.createElement("button");
                viewButton.classList.add('subCategoryeditButton');
                viewButton.setAttribute('type', 'button');
                viewButton.setAttribute('value', struct.subcategoryId)
                viewButton.setAttribute('id', struct.subcategoryId)
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

function viewCategoryCommon(categoryName){
    alert(categoryName)
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewCategory',
        type : 'post',
        success : function(response){
            let categorySelect = $('#categoryDropdown');
            let select = $("#addProductCategorySelect");
            let data=JSON.parse(response);
            for (let struct of data) {
                if(struct.categoryName !=  categoryName){
                    option = $('<option>', {value : struct.categoryId, text : struct.categoryName});
                    categorySelect.append(option);
                    select.append(option)
                }
            }
        }
    })
    return true;
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
            $('#subCategoryInput').val(data[0].subcategoryName);
            $('#subCategoryUpdate').val(data[0].subcategoryId);
            let categorySelect = $('#categoryDropdown');
            categorySelect.empty() 
            let option = $('<option>', {value : data[0].categoryId, text : data[0].categoryName});
            let categoryName = data[0].categoryName;
            categorySelect.append(option)
            let valid = viewCategoryCommon(categoryName);
            $('#subCategoryUpdate').css({"display":"flex"});
            $('#subCategorySubmit').css({"display":"none"})
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
    let subCategoryID = ID.value;
    let categoryId =  $("#categoryDropdown").val();
    let subcategoryName =  $("#subCategoryInput").val();
    alert(categoryId)
    $.ajax({
        url : './Components/shoppingCart.cfc?method=insertSubcategory',
        type : 'post',
        data : {
            subCategoryName : subcategoryName,
            categoryId : categoryId,
        },
        success : function(response){
            let data = JSON.parse(response);
            for(const key in data){
                $('#'+key).text(data[key]);
                if(data[key].includes("Success")){
                    $('#'+key).css({'color':'green'});
                }
                else{
                    $('#'+key).css({'color':'red'});
                }
            }
            $("#subCategoryInput").val('');
        }
    })
}

function updateSubcategorySubmit(ID){
    let subCategoryID = ID.value;
    let categoryId =  $("#categoryDropdown").val();
    let subcategoryName =  $("#subCategoryInput").val();
    $.ajax({
        url : './Components/shoppingCart.cfc?method=updateSubcategory',
        type : 'post',
        data : {
            subCategoryName : subcategoryName,
            categoryId : categoryId,
            subCategoryID : subCategoryID
        },
        success : function(response){
            let data = JSON.parse(response);
            for(const key in data){
                $('#'+key).text(data[key]);
                if(data[key].includes("Success")){
                    $('#'+key).css({'color':'green'});
                }
                else{
                    $('#'+key).css({'color':'red'});
                }
            }
            $("#subCategoryInput").val('');
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
    $('#subCategoryUpdate').css({"display":"none"});
    $('#subCategorySubmit').css({"display":"flex"})
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

function categoryDeleteButton(ID){
    alert(ID.value)
    let selectedValue = ID.value;
    $("#alertDeleteBtn").val(selectedValue);
    $("#deleteConfirm").css({"display":"flex"})
    $("#displayContent").addClass("disabled");
    $("#addCategory").addClass("disabled");
    $("#addSubcategoryDiv").addClass("disabled");
    $("#viewSubcategory").addClass("disabled");
    $("#productViewMainDiv").addClass("disabled");
    $("#imagesUpdateDiv").addClass("disabled");
}

function deleteAlert(ID){
    let selectedValue = ID.value;
    if(selectedValue=='cancel'){
        $("#deleteConfirm").css({"display":"none"})
        $("#displayContent").removeClass("disabled");
        $("#addCategory").removeClass("disabled");
        $("#addSubcategoryDiv").removeClass("disabled");
        $("#viewSubcategory").removeClass("disabled");
        $("#productViewMainDiv").removeClass("disabled");
        $("#imagesUpdateDiv").removeClass("disabled");
    }
    else{
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
                    $("#deleteConfirm").css({"display":"none"})
                    $("#displayContent").removeClass("disabled");
                    $("#addCategory").removeClass("disabled");
                    $("#addSubcategoryDiv").removeClass("disabled");
                    $("#viewSubcategory").removeClass("disabled");
                    $("#productViewMainDiv").removeClass("disabled");
                    $("#imagesUpdateDiv").removeClass("disabled");
                }
            }
        })
    }
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
            $("#subCategoryHead").text(data[0].subcategoryName);
            $("#addProductButton").val(data[0].categoryName+','+data[0].categoryId+','+data[0].subcategoryName+','+data[0].subcategoryId);
            var subCategoryId=data[0].subcategoryId;
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
                    for (let struct of data) {
                        var childDiv=`<div class="similarProductcol d-flex flex-column ms-2 mt-2" id=${struct.productId}>
                                        <div class="productDiscriptionsdiv d-flex align-items-center mt-3 justify-content-between">
                                            <div class="d-flex">
                                                <button class="border-0 imageEditButton" value=${struct.productId} type="button" onClick="editImages(this)">
                                                    <img src="Assets/uploadImages/${struct.file}" class="" alt="" width="50" height="50">
                                                </button>
                                            </div>
                                            <div class="d-flex flex-column px-2">
                                                <span class="productsNamespan px-2">${struct.productName}</span>
                                                <span class="productsBrandspan fw-bold px-2">${struct.brandName}</span>
                                                <span class="productsPricespan px-2">RS.${struct.price}</span>
                                            </div>
                                            <div class="d-flex">
                                                <button type="button" class="border-0" name="editBtn" value=${struct.productId}  onClick="return editProductsButton(this)"><img width="23" height="23" src="Assets/Images/editBtn.png" alt="create-new"/></button>
                                                <button type="button" class="border-0" name="deleteBtn" value="tblProducts,${struct.productId}" onClick="categoryDeleteButton(this)"><img width="26" height="26" src="Assets/Images/deleteBtn.png" alt="filled-trash"/></button>
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

function editImages(ID){
    let productId = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewImages',
        type : 'post',
        data : {productId:productId},
        success : function(response){
            let data = JSON.parse(response)
            let div= $("#imagesUpdateSubDiv");
            $("#imagesUpdateDiv").css({"display":"flex"});
            $('#productViewMainDiv').css({'display':'none'})
            for (const struct of data) {
                let childDiv = `<div class="viewIamgesDiv d-flex flex-column" id="${struct.imageId}">
                                    <div class="productImageDiv d-flex justify-content-center align-items-center px-3 py-3">
                                        <img src="Assets/uploadImages/${struct.imageFileName}" class="" width="80" height="80">
                                    </div>
                                    <div class="imageButtonDiv d-flex flex-column px-3">
                                        <button type="button" id="" class="imageThumbBtn" value=${struct.imageId},${struct.imageFileName} onClick="setThumbnail(this)">Set Thumbnail</button>
                                        <button type="button" id="" class="imageDltBtn mt-2" value="tblProductImages,${struct.imageId}" onClick="categoryDeleteButton(this)">Delete</button>
                                    </div>
                                </div>`
                div.append(childDiv)
            }
        }
    })
}

function viewProductsClose(){
    $('#productViewMainDiv').css({'display':'none'})
    $("#viewSubcategory").css({"display":"flex"});
    $("#subcategoryProductDiv").empty()
}

function imageEditClose(){
    $("#imagesUpdateDiv").css({"display":"none"})
    $('#productViewMainDiv').css({'display':'flex'})
    $("#imagesUpdateSubDiv").empty()
}

function setThumbnail(ID){
    let selectedValue=ID.value;
    let splitData=selectedValue.split(',');
    let ImageId=splitData[0];
    let productId=splitData[1]
    alert(ImageId)
    $.ajax({
        url : './Components/shoppingCart.cfc?method=setThumbnail',
        type : 'post',
        data : {
            ImageId : ImageId,
            productId :productId
        },
        success : function(response){
            if (response){

            }
        }
    })
}

function editProductsButton(ID){
    let productId = ID.value;
    $('#productViewMainDiv').css({'display':'none'});
    $('#addProductModal').css({'display':'flex'});
    $('#addProductImage').css({'display':'none'});
    $('#addProductLabel').css({'display':'none'});
    $('#addProductSubmit').css({'display':'none'});
    $('#updateProductSubmit').css({'display':'flex'});
    $('#addProductHeading').text("Edit Product");
    $('#updateProductSubmit').val(productId);
    $.ajax({
        url:'./Components/shoppingCart.cfc?method=displayProduct',
        type : 'post',
        data :{
            productId : productId
        },
        success : function(response){
            let data = JSON.parse(response)
            $('#addProductNameInput').val(data.productName);
            $('#addProductPrice').val(data.price);
            $('#addProductDescription').val(data.description);
            $('#addProductTax').val(data.tax);
            let categorySelect=$('#addProductCategorySelect');
            let option = $('<option>', {value : data.categoryId, text : data.categoryName});
            categorySelect.append(option)
            let subCategorySelect=$('#addProductSubcategorySelect');
            let subOption = $('<option>', {value : data.subCategoryId, text : data.subCategoryName});
            subCategorySelect.append(subOption)
            let brandSelect=$('#brandSelect');
            brandSelect.empty();
            let brandOption = $('<option>', {value : data.brandId, text : data.brand});
            brandSelect.append(brandOption)
            var categoryName = data.categoryName
            let subcategoryName = data.subCategoryName
            var categoryId = data.categoryId
            let brand = data.brand
            $("#addProductClose").val(data.subCategoryId);

            let valid = viewCategoryCommon(categoryName);

            let subValid = viewSubcategoryCommon(categoryId, subcategoryName)

            let brandValid = viewBrandCommon()
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
            let data=JSON.parse(response)
            for(const key in data){
                $('#'+key).text(data[key]);
                if(data[key].includes("Success")){
                    $('#'+key).css({'color':'green'});
                }
                else{
                    $('#'+key).css({'color':'red'});
                }
            }
        }
    })
}

function addProductCloseBtn(ID){
    $('#productViewMainDiv').css({'display':'flex'});
    $('#addProductModal').css({'display':'none'});
    $("#subcategoryProductDiv").empty()
    $("#createSpan").text('')
    $('#addProductCategorySelect').empty()
    $('#addProductSubcategorySelect').empty()
    $('#brandSelect').empty()
    $('#insertError').text('')
    subcategoryViewButton(ID)
    $('#productForm')[0].reset()
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
            let data=JSON.parse(response)
            for(const key in data){
                $('#'+key).text(data[key]);
                if(data[key].includes("Success")){
                    $('#'+key).css({'color':'green'});
                }
                else{
                    $('#'+key).css({'color':'red'});
                }
            }
        }
    })
}

function viewSubcategoryCommon(categoryId,subCategoryName){
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewSubcategory',
        type : 'post',
        data :{
            categoryId : categoryId
        },
        success : function(response){
            let subData=JSON.parse(response);
            let selectSub = $("#addProductSubcategorySelect");
            for (let struct of subData) {
                if(struct.subcategoryName != subCategoryName){
                    let option = $('<option>', {value : struct.subcategoryId, text : struct.subcategoryName});
                    selectSub.append(option);
                }
            }
        }
    })
    return true;
}

function addProduct(ID){
    let Id = ID.value;
    let splitData = Id.split(',');
    let categoryName = splitData[0];
    let categoryId = splitData[1];
    let subCategoryName = splitData[2];
    let subCategoryId = splitData[3]
    let select = $("#addProductCategorySelect");
    let selectSub = $("#addProductSubcategorySelect");
    $("#addProductSubmit").css({"display":"flex"});
    $("#addProductImage").css({"display":"flex"});
    $("#updateProductSubmit").css({"display":"none"});
    var selectOption=document.createElement("option");
    $('#addProductHeading').text("Add Product");
    selectOption.setAttribute('value',categoryId);
    selectOption.text = categoryName;
    var selectSubOption = document.createElement("option");
    selectSubOption.setAttribute('value', subCategoryId);
    selectSubOption.text = subCategoryName;
    select.append(selectOption);
    selectSub.append(selectSubOption);
    $("#addProductClose").val(subCategoryId);
    let valid = viewCategoryCommon(categoryName);

    let subValid = viewSubcategory(categoryId, subCategoryName)

    let brandValid = viewBrandCommon()
    $('#productViewMainDiv').css({'display':'none'});
    $('#addProductModal').css({'display':'flex'});
}

function viewBrandCommon(){
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewBrand',
        type : 'post',
        success : function(response){
            let brandData=JSON.parse(response);
            let brandSelect=$('#brandSelect');
            for (let struct of brandData) {
                let option = $('<option>', {value : struct.brandId, text : struct.brandName});
                brandSelect.append(option);
            }
        }
    })
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
                for(let struct of data) {
                    let subCategoryName = struct.subcategoryName;
                    let  subCategoryId= struct.subcategoryId;
                    let optionTag = `<option value="${subCategoryId}">${subCategoryName}</option>`;
                    $("#addProductSubcategorySelect").append(optionTag);
                }
            }
        });	
	});
});