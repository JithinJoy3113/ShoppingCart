function accordianHead(ID) {
    let id=ID.value
    $('.topBtn').css({"background-color":"white","color":"black"})
    $('.titleDiv').css({"background-color":"white","color":"black"})
    $('#'+id).css({"background-color":"#0d9191","color":"white"})
}

function buyNow(Id){
    var buyDetails = {}
    $.ajax({
        url : './Components/shoppingCart.cfc?method=viewProducts',
        type : 'post',
        data : {
            productId : Id
        },
        success : function(response){
            let data = JSON.parse(response)
            for(var struct of data){
                buyDetails[struct.productId] = {}
                buyDetails[struct.productId]['totalPrice'] = struct.price
                buyDetails[struct.productId]['totalTax'] = struct.tax
                if('quantity' in struct){
                    buyDetails[struct.productId]['totalQuantity'] = struct.quantity
                }
                else{
                    buyDetails[struct.productId]['totalQuantity'] = 1
                }
            }
            localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
            return true;
        }
    })
}
function buyNowCart(Id){
    let ID = Id.value
    var buyDetails = {}
    $.ajax({
        url : './Components/shoppingCart.cfc?method=cartItems',
        type : 'post',
        success : function(response){
            let data = JSON.parse(response)
            console.log(data)
            for(var struct of data){
                buyDetails[struct.productId] = {}
                buyDetails[struct.productId]['totalPrice'] = struct.price
                buyDetails[struct.productId]['totalTax'] = struct.tax
                if('quantity' in struct){
                    buyDetails[struct.productId]['totalQuantity'] = struct.quantity
                }
                else{
                    buyDetails[struct.productId]['totalQuantity'] = 1
                }
            }
            localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
            location.href = "./order.cfm?cartId="+ID
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
    }
    else{
        priceSpan.text(price+priceInput).attr('data-value',price+priceInput)
        taxSpan.text(tax+taxInput).attr('data-value',tax+taxInput)
        quantitySpan.text(quantity+1).attr('data-value',quantity+1)
        orderTotalAmountSpan.text(orderTotalAmount+priceInput).attr('data-value', orderTotalAmount+priceInput)
        orderTotalTaxSpan.text(orderTotalTax+taxInput).attr('data-value', orderTotalTax+taxInput)
        $('#orderAmount').text(totalAmountSpan +(priceInput+taxInput)).attr("data-value",totalAmountSpan +(priceInput+taxInput))
        $('#btnPrice').text((price+priceInput)+(tax+taxInput))
        buyDetails[productId].totalPrice = parseFloat(buyDetails[productId].totalPrice)+priceInput
        buyDetails[productId].totalTax = parseFloat(buyDetails[productId].totalTax) + taxInput
        buyDetails[productId].totalQuantity = parseFloat(buyDetails[productId].totalQuantity) + 1
    }
    localStorage.setItem("buyDetails",JSON.stringify(buyDetails))
}

function buyProductBtn(ID){
    let buyDetails = JSON.parse(localStorage.getItem("buyDetails"))
    // let productId = ID.value
    // let priceSpan = parseFloat($('#price'+productId).attr('data-value'));
    // let taxSpan = parseFloat($('#tax'+productId).attr('data-value'));
    // let quantity = parseFloat($('#quantity'+productId).attr('data-value'))
    let address = $('input[name="addressRadio"]:checked').val();
    let cardNumber = $('#cardNumberInput').val() 
    let cardCvv = $('#cardCVVInput').val() 
    for(let product in buyDetails){
        $.ajax({
            url : './Components/shoppingCart.cfc?method=buyProduct',
            type : 'post',
            data : {
                productId : product,
                addressId : address,
                totalPrice : buyDetails[product].totalPrice,
                totalTax : buyDetails[product].totalTax,
                quantity : buyDetails[product].totalQuantity,
                cardNumber : cardNumber,
                cvv : cardCvv
            },
            success : function(response){
                let data = JSON.parse(response)

                localStorage.clear();
            }
        }) 
    }
    }