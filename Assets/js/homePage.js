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

$(document).ready(function () {
    $('.sideImage').on('mouseover', function () {
        var img=$(this).attr('src');
        $('#mainImg').attr('src', img);
    })
    $('.sideImage').on('mouseout', function () {
        var mainImg = $('#mainImg').attr('data-value');
        $('#mainImg').attr('src', mainImg);
    })
    $('.sideImage').on('click', function () {
        var img=$(this).attr('src');
        $('#mainImg').attr('src', img);
        $('#mainImg').attr('data-value', img);
    })
    let divId;
    $('.addressEditBtnDiv').on('click', function () {
        divId = $(this).attr('data-value');
        $('#'+divId).css('display', "flex");
    })
    $('.addressEditDiv').on('mouseout', function () {
        $('#'+divId).css('display', "none");
    })
})

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


const searchInput = document.getElementById('searchInput');
    searchInput.addEventListener('keydown', (e) => {
    if (e.key === 'Enter') {
        e.preventDefault();
        const searchValue = searchInput.value.trim();
        if (searchInput) {
            const button = document.getElementById('myButton');
            button.click();
        } 
    }
});

function viewMoreSubmit(string){
    let str = string.value
    let div = $('#viewHeight')
    let btn = $('#viewMoreSubmit')
    let input = $('#viewHidden').val();
    if(str == "More" && input > 5){
        div.removeClass('viewHeight');
        btn.text('View Less');
        btn.val('Less')
        return true
    }
    else{
        div.addClass('viewHeight');
        btn.text('View More');
        btn.val('More')
        return true
    }
 }

 function updateQuantity(ID){
    let btnData = ID.value.split(",")
    let operation = btnData[0];
    let cartId = btnData[1];
    $.ajax({
        url : './Components/shoppingCart.cfc?method=updateCart',
        type : 'post',
        data : {
            cartId : cartId,
            operation : operation
        },
        success : function(response){
            let data = JSON.parse(response)
            if(data.status == "error"){
                location.href = `./error.cfm?Exception=${data.status}&EventName=${data.message}`
            }
            else{
                let dataLen = data.length
                let totalAmount = 0
                let totalTax = 0
                for(let struct of data){
                    if(struct.cartId == cartId){
                        $("#price"+cartId).text((struct.totalPrice).toFixed(2))
                        $("#tax"+cartId).text((struct.totalTax).toFixed(2))
                        $("#quantity"+cartId).text(struct.quantity).attr('data-value',struct.quantity)
                    }
                    totalAmount = totalAmount + struct.totalPrice
                    totalTax = totalTax + struct.totalTax
                }
                let quantitySpan = $('#quantity'+cartId)
                let count = parseFloat(quantitySpan.attr('data-value'))
                if(count == 1){
                    $('#minus'+cartId).prop("disabled", true);
                }
                else{
                    $('#minus'+cartId).prop("disabled", false);
                }
                let cartAmount = totalAmount + totalTax
                $("#cartOrderAmount").text("₹"+cartAmount)
                $('#cartTotalAmount').text(totalAmount)
                $("#cartTotalTax").text(totalTax)
                $("#cartNumber").text(dataLen)
            }
        }
    })
 }
 function removeCartItem(ID){
    let cartId = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=deleteCartItem',
        type : 'post',
        data : {
            cartId : cartId
        },
        success : function(response){
            let data = JSON.parse(response)
            let dataLen = data.length
            let totalAmount = 0
            let totalTax = 0
            for(let struct of data){
                if(struct.cartId == cartId){
                    $("#price"+cartId).text(struct.totalPrice)
                    $("#tax"+cartId).text(struct.totalTax)
                    $("#quantity"+cartId).text(struct.quantity)
                }
                totalAmount = totalAmount + struct.totalPrice
                totalTax = totalTax + struct.totalTax
            }
            let cartAmount = totalAmount + totalTax
            $("#cartOrderAmount").text("₹"+cartAmount)
            $('#cartTotalAmount').text(totalAmount)
            $("#cartTotalTax").text(totalTax)
            $('#totalItems').text(data.length)
            $("#"+cartId).remove()
            $("#cartNumber").text(dataLen)
            $('#bodyContents').removeClass('disabled')
            $('#deleteConfirm').css({"display":"none"})
            $('#topDiv').removeClass('disabled')
        }
    })
 }
 function editProfile(button){

    if(button.value == 'Cancel'){
        $(button).text('Edit')
        $(button).val('')
        $("#profileSave").addClass('d-none');
        $('.profileInput').attr('disabled','disabled');
    }
    else{
        $(button).text('Cancel')
        $(button).val('Cancel')
        $("#profileSave").removeClass('d-none');
        $('.profileInput').removeAttr('disabled');
    }
}

function saveProfile(ID){
    let userId = ID.value;
    let formData = new FormData($('#profileForm')[0]);
    $.ajax({
        url : './Components/shoppingCart.cfc?method=updateProfile',
        type : 'post',
        data : formData,
        processData: false,
        contentType: false,
        success : function(response){
            let data = JSON.parse(response)
            if (data == false){
                $('#profileError').text('Email/Phone Already exist').addClass("text-danger").removeClass('text-success')
                $('#profileEmail').val($('#profileEmail').attr('data-value'));
                $('#profilePhone').val($('#profilePhone').attr('data-value'));
            }
            else{
                $("#profileFirstName").val(data.firstName);
                $('#profileLastName').val(data.lastName);
                $('#profilePhone').val(data.phone).attr('data-value', data.phone);
                $('#profileEmail').val(data.email).attr('data-value', data.email);
                $("#profileSave").addClass('d-none');
                $('.profileInput').attr('disabled','disabled');
                $('#profileEditBtn').val('').text('Edit')
                $('#profileFullNameSpan').text(data.firstName+' '+data.lastName)
                $('#profileError').text('').addClass('text-success').removeClass('text-danger')
            }
        }
    })
}
function openManageAddress(){
    $('#personalInformationDiv').removeClass('d-flex')
    $('#personalInformationDiv').addClass('d-none')
    $('#manageAddressDiv').removeClass('d-none')
    $('#manageAddressDiv').addClass('d-flex')
    $('#addressModal').css({"display":"none"})
}
function openPersonalInformation(){
    $('#addressModal').css({"display":"none"})
    $('#personalInformationDiv').removeClass('d-none')
    $('#personalInformationDiv').addClass('d-flex')
    $('#manageAddressDiv').removeClass('d-flex')
    $('#manageAddressDiv').addClass('d-none')
}
function addAddressCloseBtn(){
    $('#addressModal').css({"display":"none"})
    $('#manageAddressDiv').removeClass('d-none')
    $('#manageAddressDiv').addClass('d-flex')
    $('#accordianBody').removeClass('disabled')
    $('#addressForm')[0].reset();
}
function openAddressModal(){
    $('#addressModal').css({"display":"flex"})
    $('#manageAddressDiv').removeClass('d-flex')
    $('#manageAddressDiv').addClass('d-none')
    $('#accordianBody').addClass('disabled')
}
function addAddressBtn(){
    let formData = new FormData($('#addressForm')[0]);
    $.ajax({
        url : './Components/shoppingCart.cfc?method=addAddress',
        type : 'post',
        data : formData,
        processData: false,
        contentType: false,
        success : function(response){
            let data = JSON.parse(response)
            let id = formData.get('firstName')
            if (data.Result == 'Success'){
                let profileAddressDiv = `<div class="addressMainDiv d-flex justify-content-between" id="address${data.addressId}">
                    <div class = "addressEditBtnDiv d-flex align-items-center" data-value = "${data.addressId}">
                        <img src="Assets/Images/dots.png" alt="" class = "addressEditImg" data-value = "${data.addressId}" width="20" height="20">
                    </div>
                    <div class="addressEditDiv py-3" id="${data.addressId}" data-value = "${data.addressId}">
                        <button type="button bt-2" value = "${data.addressId}" class="addressDltbtn" onClick = "deleteProfileAddress(this)">Delete</button>
                    </div>
                </div>`
                let div = $('#addressListDiv')
                let prodileAddressParent = $('#address'+data.addressId)
                let accordianDiv = $('#accordianAddressDiv')
                let childDiv = `<div class = "addressDiv d-flex flex-column" id="">
                                    <span class="addressNameSpan fw-bold">${formData.get('firstName')} ${formData.get('lastName')}
                                        <span class="ms-2 addressPhoneSpan">${formData.get('phone')}</span>
                                    </span>
                                    <span class="addressSpan">
                                    ${formData.get('addressOne')}, ${formData.get('addressTwo')}, ${formData.get('city')}, ${formData.get('state')}, ${formData.get('pincode')}
                                    </span>
                                </div>`
                prodileAddressParent.insertBefore(childDiv, prodileAddressParent.firstChild);
                let accordianSelectDiv = `<div class="d-flex align-items-center">
                                            <input type="radio" name="addressRadio" value="${data.addressId}">
                                            `
                let selectDiv = accordianSelectDiv + childDiv + '</div>'
                accordianDiv.append(selectDiv)
                div.append(prodileAddressParent)
                $("#addAddressErrorSpan").css({"display":"none"})
                $('#orderAddressBtn').removeClass('disabled')
                $('#addressModal').css({"display":"none"})
                $('#manageAddressDiv').removeClass('d-none')
                $('#manageAddressDiv').addClass('d-flex')
                $('#accordianBody').removeClass('disabled')
                $('#addressForm')[0].reset();
            }
            else{
                for(let key in data){
                    $('#'+key).text(data[key])
                }
            }
        }
    })
}

$(document).ready(function() {
    var dataValue = [$(".quantityBtn").data('value')]; 
});

