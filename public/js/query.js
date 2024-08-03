document.addEventListener("htmx:configRequest", function (event) {
  var connection = localStorage.getItem("connection");
  var database = document.getElementById("databases").value;

  if (connection) {
    var url = new URL(event.detail.path, window.location.origin);

    url.searchParams.append("uid", connection);
    url.searchParams.append("database", database);

    event.detail.path = url.toString();
  }
});

document.addEventListener("htmx:afterRequest", function (event) {
  console.log(parseInt(event.detail.xhr.status.toString()));
  if (parseInt(event.detail.xhr.status.toString()) == "422") {
    console.log(event.detail.xhr);
    localStorage.removeItem("connection");
    alert("ERROR: " + event.detail.xhr.statusTex);
    window.location.replace("/");
  }

  if (parseInt(event.detail.xhr.status.toString()) == "400") {
    console.log(event.detail.xhr);
    alert("ERROR: " + event.detail.xhr.response);
  }

  const responseJson = event.detail.xhr.responseText;
  console.log(responseJson);
  const jsonData = JSON.parse(responseJson);

  function createTableFromJson(data) {
    const table = document.createElement("table");
    table.border = "1";

    const thead = table.createTHead();
    const headerRow = thead.insertRow();

    const headers = Object.keys(data[0]);
    headers.forEach((header) => {
      const th = document.createElement("th");
      th.textContent = header.replace(/_/g, " ").toUpperCase();
      headerRow.appendChild(th);
    });

    const tbody = table.createTBody();

    data.forEach((item) => {
      const row = tbody.insertRow();
      headers.forEach((header) => {
        const cell = row.insertCell();
        cell.textContent = item[header];
      });
    });

    return table;
  }
  const contentDiv = document.getElementById("content");
  contentDiv.innerHTML = "";

  if (jsonData.length != 0) {
    console.log(jsonData);
    contentDiv.appendChild(createTableFromJson(jsonData));
  } else {
    contentDiv.appendChild(createTableFromJson([{ value: "[]" }]));
  }
});
