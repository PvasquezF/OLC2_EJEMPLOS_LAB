function ejemplo1() {
    document.getElementById("salida").value = '';
    var content = document.getElementById("entrada").value;
    var result = grammar.parse(content);
    document.getElementById("salida").value = result;
}