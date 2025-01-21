<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Search Bar with Enter Key</title>
  <style>
    input[type="search"] {
      padding: 8px;
      font-size: 16px;
      width: 250px;
      border: 1px solid #ccc;
      border-radius: 4px;
    }
  </style>
</head>
<body>
  <form id="searchForm" action="profile.cfm" method="post">
    <button type="submit" id="myButton" name="myButton" style="display: none;"></button>
    <input type="search" id="searchInput" placeholder="Search here..." aria-label="Search">
    <button type="submit">Search</button>
  </form>
  <cfif structKeyExists(form, "myButton")>
    <cfset local.randomProducts = application.obj.viewBrand()>
                <cfdump  var="#local.randomProducts#">
  </cfif>
  <script>
    const searchInput = document.getElementById('searchInput');

    // Listen for the Enter key
    searchInput.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') {
        e.preventDefault(); // Prevent form submission
        const searchValue = searchInput.value.trim(); // Get the value
        if (searchValue) {
          const button = document.getElementById('myButton');
          button.click(); // Programmatically trigger the hidden button
        } else {
          alert('Please enter a search term!');
        }
      }
    });
  </script>
</body>
</html>
