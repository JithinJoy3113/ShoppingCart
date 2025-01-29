function accordianHead(ID) {
    let id=ID.value
    $('.topBtn').css({"background-color":"white","color":"black"})
    $('.titleDiv').css({"background-color":"white","color":"black"})
    $('#'+id).css({"background-color":"#0d9191","color":"white"})
}

function updateQuantityOrder(ID){
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

    if(operation == "Minus"){
        priceSpan.text(price-priceInput).attr('data-value',price-priceInput)
        taxSpan.text(tax-taxInput).attr('data-value',tax-taxInput)
        quantitySpan.text(quantity-1).attr('data-value',quantity-1)
        $('#orderTotalAmount').text(price-priceInput)
        $('#orderTotalTax').text(tax-taxInput)
        $('#orderAmount').text(totalAmountSpan -(priceInput+taxInput)).attr("data-value",totalAmountSpan -(priceInput+taxInput))
        $('#btnPrice').text((price-priceInput)+(tax-taxInput))
    }
    else{
        priceSpan.text(price+priceInput).attr('data-value',price+priceInput)
        taxSpan.text(tax+taxInput).attr('data-value',tax+taxInput)
        quantitySpan.text(quantity+1).attr('data-value',quantity+1)
        $('#orderTotalAmount').text(price+priceInput)
        $('#orderTotalTax').text(tax+taxInput)
        $('#orderAmount').text(totalAmountSpan +(priceInput+taxInput)).attr("data-value",totalAmountSpan +(priceInput+taxInput))
        $('#btnPrice').text((price+priceInput)+(tax+taxInput))
    }
}

function buyProductBtn(ID){
    let productId = ID.value
    let priceSpan = parseFloat($('#price'+productId).attr('data-value'));
    let taxSpan = parseFloat($('#tax'+productId).attr('data-value'));
    let quantity = parseFloat($('#quantity'+productId).attr('data-value'))
    let address = $('input[name="addressRadio"]:checked').val();
    let cardNumber = $('#cardNumberInput').val() 
    let cardCvv = $('#cardCVVInput').val() 
    alert(address)
    $.ajax({
        url : './Components/shoppingCart.cfc?method=buyProduct',
        type : 'post',
        data : {
            productId : productId,
            addressId : address,
            totalPrice : priceSpan,
            totalTax : taxSpan,
            quantity : quantity,
            cardNumber : cardNumber,
            cvv : cardCvv
        },
        success : function(response){
            let data = JSON.parse(response)
            alert(data)
        }
    }) 
}