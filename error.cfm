<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <link rel = "stylesheet" href = "Assets/css/cart.css">
    <link rel = "stylesheet" href = "Assets/css/bootstrap.min.css">
</head>
<body>
    <cfoutput>
        <div class = "d-flex w-100 justify-content-center">
            <div class="d-flex flex-column align-items-center errorPageDiv">
                <h2>An unexpected error occurred.</h2>
                <p>Please provide the following information to technical support:</p>
                <cfif structKeyExists(URL, "page")>
                    <p>Template Missing : #URL.page#</p>
                    <a href="homePage.cfm?" class = "d-flex cartLoginBtn justify-content-center">Home</a>
                <cfelse>
                    <p>Error Event: #URL.EventName#</p>
                    <p>Error details:<br>
                    <p>#URL.Exception#</p>
                </cfif>
            </div> 
        </div>
    </cfoutput>
</body>
</html>