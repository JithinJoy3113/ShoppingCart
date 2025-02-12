DELIMITER $$
CREATE PROCEDURE `sp_CreateOrder`(
    IN p_userId INT,
    IN p_addressId INT,
    IN p_totalOrderPrice DECIMAL(10,2),
    IN p_totalOrderTax DECIMAL(10,2),
    IN p_detailsStruct JSON,
    IN p_generatedOrderId VARCHAR(64)
)
BEGIN
    DECLARE orderId VARCHAR(64);
    DECLARE productId INT;
    DECLARE totalQuantity INT;
    DECLARE unitPrice DECIMAL(10,2);
    DECLARE unitTax DECIMAL(10,2);
    DECLARE i INT DEFAULT 0;
    DECLARE numItems INT;
	SET orderId = p_generatedOrderId;
    INSERT INTO tblOrders (
        fldOrder_ID,
        fldUserId,
        fldAddressId,
        fldTotalPrice,
        fldTotalTax
    )
    VALUES (
        orderId,
        p_userId,
        p_addressId,
        p_totalOrderPrice,
        p_totalOrderTax
    );
    
    SET numItems = JSON_LENGTH(p_detailsStruct);
    WHILE i < numItems DO
        SET productId = JSON_UNQUOTE(JSON_EXTRACT(p_detailsStruct, CONCAT('$[', i, '].productId')));
        SET totalQuantity = JSON_UNQUOTE(JSON_EXTRACT(p_detailsStruct, CONCAT('$[', i, '].totalQuantity')));
        SET unitPrice = JSON_UNQUOTE(JSON_EXTRACT(p_detailsStruct, CONCAT('$[', i, '].unitPrice')));
        SET unitTax = JSON_UNQUOTE(JSON_EXTRACT(p_detailsStruct, CONCAT('$[', i, '].unitTax')));
        INSERT INTO tblOrderItems (
            fldOrderId,
            fldProductId,
            fldQuantity,
            fldUnitPrice,
            fldUnitTax
        )
        VALUES (
            orderId,
            productId,
            totalQuantity,
            unitPrice,
            unitTax
        );
        DELETE FROM tblCart WHERE fldProductId = productId AND fldUserId = p_userId;
        SET i = i + 1;
    END WHILE;
END$$
DELIMITER ;
