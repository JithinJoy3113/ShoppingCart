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

 function addCart(ID){
    let productId = ID.value;
    $.ajax({
        url : './Components/shoppingCart.cfc?method=addToCart',
        type : 'post',
        data : {
            productId : productId
        },
        success : function(response){
            let data = JSON.parse(response);
            if(!data){
                location.href = `./login.cfm?productId=${productId}`
            }
            else{
                location.href = './cart.cfm'
            }
        }
    })
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
            $("#cartNumber").text(dataLen)
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
            $("#"+cartId).remove()
            $("#cartNumber").text(dataLen)
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
            if (data = "false"){
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
}
function openAddressModal(){
    $('#addressModal').css({"display":"flex"})
    $('#manageAddressDiv').removeClass('d-flex')
    $('#manageAddressDiv').addClass('d-none')
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
            if (data = "true"){
                let div = $('#addressListDiv')
                let childDiv = `<div class = "addressDiv d-flex flex-column" id="">
                                <span class="addressNameSpan fw-bold">${formData.get('firstName')} ${formData.get('lastName')}
                                    <span class="ms-2 addressPhoneSpan">${formData.get('phone')}</span>
                                </span>
                                <span class="addressSpan">
                                   ${formData.get('addressOne')}, ${formData.get('addressTwo')}, ${formData.get('city')}, ${formData.get('state')}, ${formData.get('pincode')}
                                </span>
                            </div>`
                div.append(childDiv)
                $('#addressModal').css({"display":"none"})
                $('#manageAddressDiv').removeClass('d-none')
                $('#manageAddressDiv').addClass('d-flex')
            }
        }
    })
}

$(document).ready(function() {
    var dataValue = [$(".quantityBtn").data('value')]; 
    console.log(dataValue);
});