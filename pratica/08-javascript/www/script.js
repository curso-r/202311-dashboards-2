mudarDeCor = function(id) {
  var paragrafo = document.getElementById(id);
  if (paragrafo.style.color == "red") {
    paragrafo.style = "color: blue;";
  } else {
    paragrafo.style = "color: red;";
  }
}
