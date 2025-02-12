function accordianHead(ID) {
    let id=ID.value
    $('.topBtn').css({"background-color":"white","color":"black"})
    $('.titleDiv').css({"background-color":"white","color":"black"})
    $('#'+id).css({"background-color":"#0d9191","color":"white"})
}

function addCart(ID){
    var productId;
    if(typeof ID === 'string' && ID.includes('buy')){
        var id = ID.split(',');
        productId = id[1]
    }   
    else{
        productId = ID.value;
    }
    $.ajax({
        url : './Components/shoppingCart.cfc?method=addToCart',
        type : 'post',
        data : {
            productId : productId
        },
        success : function(response){
            var data = JSON.parse(response);
            if(!data){
                if(typeof ID === 'string' && ID.includes('buy')){
                    location.href = `./login.cfm?productId=${productId}&page=buy`
                }
                else{
                    location.href = `./login.cfm?productId=${productId}`
                }
            }
            else if(typeof ID === 'string' && ID.includes('buy')){
                $('#cartNumber').text(Number($('#cartNumber').text())+1)
                return true
            }
            else{
                location.href = './cart.cfm'
            }
        
        }
    })
 }

function buyNow(Id){
    var url;
    var productId;
    var cartId;
    if(window.location.href.includes("product.cfm")){
        url = './Components/shoppingCart.cfc?method=viewProducts'
        productId = Id
        var cartId = addCart("buy,"+productId)
    }
    else{
        url = './Components/shoppingCart.cfc?method=cartItems'
        productId = 0
        cartId = Id.value
    }
    var buyDetails = {}
    let orderTotalAmountSpan = $('#orderTotalAmount')
    let orderTotalAmount = parseFloat(orderTotalAmountSpan.attr('data-value'))
    let orderTotalTaxSpan = $('#orderTotalTax')
    let orderTotalTax = parseFloat(orderTotalTaxSpan.attr('data-value'))
    buyDetails.orderAmount = orderTotalAmount
    buyDetails.orderTax = orderTotalTax
    $.ajax({
        url : url,
        type : 'post',
        data : {
            productId : productId
        },
        success : function(response){
            let data = JSON.parse(response)
            let orderAmount = 0
            let orderTax = 0
            for(var struct of data){
                buyDetails[struct.productId] = {}
                if(window.location.href.includes("product.cfm")){
                    orderAmount += struct.price
                    orderTax += struct.tax
                    buyDetails[struct.productId]['totalPrice'] = struct.price
                    buyDetails[struct.productId]['totalTax'] = struct.tax
                }
                else{
                    orderAmount += struct.totalPrice
                    orderTax += struct.totalTax
                    buyDetails[struct.productId]['totalPrice'] = struct.totalPrice
                    buyDetails[struct.productId]['totalTax'] = struct.totalTax
                }
                buyDetails[struct.productId]['productName'] = struct.productName
                buyDetails[struct.productId]['unitTax'] = struct.tax
                buyDetails[struct.productId]['unitPrice'] = struct.price
                buyDetails[struct.productId]['productId'] = struct.productId
                if('quantity' in struct){
                    buyDetails[struct.productId]['totalQuantity'] = struct.quantity
                }
                else{
                    buyDetails[struct.productId]['totalQuantity'] = 1
                }
            }
            buyDetails.orderAmount = orderAmount
            buyDetails.orderTax = orderTax
            console.log(buyDetails)
            localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
            if(window.location.href.includes("product.cfm")){
                return true;
            }
            else{
                location.href = "./order.cfm?cartId="+cartId
            }
        }
    })
}

function updateQuantityOrder(ID){
    let buyDetails = JSON.parse(localStorage.getItem("buyDetails"))
    let btnData = ID.value.split(",")
    let operation = btnData[0];
    let productId = btnData[1];
    let priceSpan = $('#price'+productId);
    let taxSpan = $('#tax'+productId);
    let quantitySpan = $('#quantity'+productId)
    let priceInput = parseFloat($('#orderPriceInput'+productId).val())
    let taxInput = parseFloat($('#orderTaxInput'+productId).val())
    let price = parseFloat(priceSpan.attr('data-value'))
    let tax = parseFloat(taxSpan.attr('data-value'))
    let quantity = parseFloat(quantitySpan.attr('data-value'))
    let totalAmountSpan = parseFloat($('#orderAmount').attr('data-value'))
    let orderTotalAmountSpan = $('#orderTotalAmount')
    let orderTotalAmount = parseFloat(orderTotalAmountSpan.attr('data-value'))
    let orderTotalTaxSpan = $('#orderTotalTax')
    let orderTotalTax = parseFloat(orderTotalTaxSpan.attr('data-value'))

    if(operation == "Minus"){
        priceSpan.text(price-priceInput).attr('data-value',price-priceInput)
        taxSpan.text(tax-taxInput).attr('data-value',tax-taxInput)
        quantitySpan.text(quantity-1).attr('data-value',quantity-1)
        orderTotalAmountSpan.text(orderTotalAmount-priceInput).attr('data-value', orderTotalAmount-priceInput)
        orderTotalTaxSpan.text(orderTotalTax-taxInput).attr('data-value', orderTotalTax-taxInput)
        $('#orderAmount').text(totalAmountSpan -(priceInput+taxInput)).attr("data-value",totalAmountSpan -(priceInput+taxInput))
        $('#btnPrice').text((price-priceInput)+(tax-taxInput))
        buyDetails[productId].totalPrice = parseFloat(buyDetails[productId].totalPrice)-priceInput
        buyDetails[productId].totalTax = parseFloat(buyDetails[productId].totalTax) - taxInput
        buyDetails[productId].totalQuantity = parseFloat(buyDetails[productId].totalQuantity) - 1
        buyDetails.orderAmount = buyDetails.orderAmount-(priceInput)
        buyDetails.orderTax = buyDetails.orderTax-(taxInput)
        let count = parseFloat(quantitySpan.attr('data-value'))
        if(count == 1){
            $('#minus'+productId).prop("disabled", true);
        }
    }
    else{
        priceSpan.text(price+priceInput).attr('data-value',price+priceInput)
        taxSpan.text(tax+taxInput).attr('data-value',tax+taxInput)
        quantitySpan.text(quantity+1).attr('data-value',quantity+1)
        orderTotalAmountSpan.text(orderTotalAmount+priceInput).attr('data-value', orderTotalAmount+priceInput)
        orderTotalTaxSpan.text(orderTotalTax+taxInput).attr('data-value', orderTotalTax+taxInput)
        $('#orderAmount').text(totalAmountSpan +(priceInput+taxInput)).attr("data-value",totalAmountSpan +(priceInput+taxInput))
        $('#btnPrice').text(totalAmountSpan +(priceInput+taxInput))
        buyDetails[productId].totalPrice = parseFloat(buyDetails[productId].totalPrice)+priceInput
        buyDetails[productId].totalTax = parseFloat(buyDetails[productId].totalTax) + taxInput
        buyDetails[productId].totalQuantity = parseFloat(buyDetails[productId].totalQuantity) + 1
        buyDetails.orderAmount = buyDetails.orderAmount+priceInput
        buyDetails.orderTax = buyDetails.orderTax+taxInput
        $('#minus'+productId).prop("disabled", false);
    }
    localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
}

function removeOrderItem(removeId){
    let buyDetails = JSON.parse(localStorage.getItem("buyDetails"))
    let productId = removeId.value
    let priceSpan = $('#price'+productId);
    let taxSpan = $('#tax'+productId);
    let orderTotalAmountSpan = $('#orderTotalAmount')
    let orderTotalTaxSpan = $('#orderTotalTax')
    let price = parseFloat(priceSpan.attr('data-value'))
    let tax = parseFloat(taxSpan.attr('data-value'))

    buyDetails.orderAmount = buyDetails.orderAmount - price
    buyDetails.orderTax = buyDetails.orderTax - tax
    orderTotalAmountSpan.attr('data-value', buyDetails.orderAmount).text(buyDetails.orderAmount)
    orderTotalTaxSpan.attr('data-value', buyDetails.orderTax).text(buyDetails.orderTax)
    delete buyDetails[productId]
    $('#div'+productId).remove()
    $('#accordianBody').removeClass('disabled')
    $('#deleteConfirm').css({"display":"none"})
    $('#topDiv').removeClass('disabled')
    localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
}

function buyProductBtn(ID){
    let buyDetails = JSON.parse(localStorage.getItem("buyDetails"))
    let productId = ID.value
    let address = $('input[name="addressRadio"]:checked').val();
    let cardNumber = $('#cardNumberInput').val() 
    let cardCvv = $('#cardCVVInput').val()
    cardNumber = cardNumber.replace(/\s+/g, '')
    $.ajax({
        url : './Components/shoppingCart.cfc?method=buyProduct',
        type : 'post',
        data : {
            detailsStruct : localStorage.getItem("buyDetails"),
            addressId : address,
            totalOrderPrice : buyDetails.orderAmount,
            totalOrderTax : buyDetails.orderTax,
            cardNumber : cardNumber,
            cvv : cardCvv
        },
        success : function(response){
            console.log(response)
            let data = JSON.parse(response)
            if(data.Result == true){
                $('#orderSuccessDiv').css({"display":"flex"})
                $('#accordianBody').addClass("disabled")

            }
            else{
                $('#cardError').text('Invalid Card')
            }
        }
    }) 
}

function pdfDownload(ID){
    $.ajax({
        url:'./Components/shoppingCart.cfc?method=getPdf',
        type: "post",
        data:{
            orderId:ID
        },
        success:function(response){
            let path=JSON.parse(response)
            let tag=document.createElement('a');
            tag.href=`Assets/Pdfs/${path}`;
            tag.download=path;
            tag.click();
            tag.remove();
        }
    })
}

function deleteProfileAddressButton(ID){
    let id = ID.value;
    $('#topDiv').addClass('disabled')
    $('#profileBodyDiv').addClass('disabled')
    $("#deleteConfirm").css({"display":"flex"})
    $('#bodyContents').addClass('disabled')
    $('#alertAddressDeleteBtn').val(id)
    $('#alertCartDeleteBtn').val(id)
    $('#accordianBody').addClass('disabled')
}

function deleteProfileAddress(ID){
    let addressId = ID.value;
    $.ajax({
        url:'./Components/shoppingCart.cfc?method=addressDelete',
        type: "post",
        data:{
            addressId : addressId
        },
        success:function(response){
            let data=JSON.parse(response)
            $('#address'+addressId).remove()
            $('#topDiv').removeClass('disabled')
            $('#profileBodyDiv').removeClass('disabled')
            $("#deleteConfirm").css({"display":"none"})
        }
    })
}

document.getElementById("cardNumberInput").addEventListener("input", function(e) {
    let value = e.target.value.replace(/\D/g, "");
    if (value.length > 4) {
        value = value.replace(/(\d{4})(?=\d)/g, "$1 ");
    }
    e.target.value = value;
});
document.getElementById("cardCVVInput").addEventListener("input", function(e) {
    let value = e.target.value.replace(/\D/g, "");
    e.target.value = value;
});

function checkCard(){
    let cardNumber = $('#cardNumberInput').val()
    let cardCvv = $('#cardCVVInput').val()
    cardNumber = cardNumber.replace(/\s+/g, '')
    if((cardNumber != '' && cardNumber.length == 12) && (cardCvv != '' && cardCvv.length == 3)){
        $('#paymentButon').removeClass('disabled')
    }
    else{
        $('#paymentButon').addClass('disabled')
    }
}
