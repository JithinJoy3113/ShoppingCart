function accordianHead(ID) {
    let id=ID.value
    $('.topBtn').css({"background-color":"white","color":"black"})
    $('.titleDiv').css({"background-color":"white","color":"black"})
    $('#'+id).css({"background-color":"#0d9191","color":"white"})
}

function buyNow(Id){
    let productId = Id.value
    var buyDetails = {}
    let orderTotalAmountSpan = $('#orderTotalAmount')
    let orderTotalAmount = parseFloat(orderTotalAmountSpan.attr('data-value'))
    let orderTotalTaxSpan = $('#orderTotalTax')
    let orderTotalTax = parseFloat(orderTotalTaxSpan.attr('data-value'))
    buyDetails.orderAmount = orderTotalAmount
    buyDetails.orderTax = orderTotalTax
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewProducts',
        type : 'post',
        data : {
            productId : Id
        },
        success : function(response){
            let data = JSON.parse(response)
            let orderAmount = 0
            let orderTax = 0
            for(var struct of data){
                orderAmount += struct.price
                orderTax += struct.tax
                buyDetails[struct.productId] = {}
                buyDetails[struct.productId]['totalPrice'] = struct.price
                buyDetails[struct.productId]['totalTax'] = struct.tax
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
            localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
            return true;
        }
    })
}

function buyNowCart(Id){
    let productId = Id.value
    var buyDetails = {}
    let orderTotalAmountSpan = $('#orderTotalAmount')
    let orderTotalAmount = parseFloat(orderTotalAmountSpan.attr('data-value'))
    let orderTotalTaxSpan = $('#orderTotalTax')
    let orderTotalTax = parseFloat(orderTotalTaxSpan.attr('data-value'))
    buyDetails.orderAmount = orderTotalAmount
    buyDetails.orderTax = orderTotalTax
    $.ajax({
        url : './Components/shoppingCart.cfc?method=cartItems',
        type : 'post',
        success : function(response){
            let data = JSON.parse(response)
            let orderAmount = 0
            let orderTax = 0
            for(var struct of data){
                orderAmount += struct.totalPrice
                orderTax += struct.totalTax
                buyDetails[struct.productId] = {}
                buyDetails[struct.productId]['totalPrice'] = struct.totalPrice
                buyDetails[struct.productId]['totalTax'] = struct.totalTax
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
            localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
            location.href = "./order.cfm?cartId="+productId
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
    localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
}

function buyProductBtn(ID){
    let buyDetails = JSON.parse(localStorage.getItem("buyDetails"))
    let productId = ID.value
    let address = $('input[name="addressRadio"]:checked').val();
    let cardNumber = $('#cardNumberInput').val() 
    let cardCvv = $('#cardCVVInput').val() 
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