<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
</head>
<body>
    <cfoutput>
    <div class = "d-flex justify-content-center">
        <div class="d-flex">

                <h2>An unexpected error occurred.</h2>
                <p>Please provide the following information to technical support:</p>
                <p>Error Event: #URL.EventName#</p>
                <p>Error details:<br>
                <p>
                   #URL.Exception#
                </p>
            </div>
        </div>
    </cfoutput>
</body>
</html>