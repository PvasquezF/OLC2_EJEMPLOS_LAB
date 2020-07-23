function ejemplo1() {
    document.getElementById("salida").value = '';
    treeData = [];
    var content = document.getElementById("entrada").value;
    if (document.getElementById("grafo")) {
        document.getElementById("grafo").remove();
    }
    var result = ejemplo1.parse(content);
    document.getElementById("salida").value = result.val;
    const a = generateTree([result.node]);
}

function newNode(yy, state, ...nodes) {
    const parent = getNonTerminal(yy, state);
    const children = [];
    for (let node of nodes) {
        node.parent = node.parent ? node.parent : parent;
        if (node.parent == parent) {
            children.push(node);
        } else if (typeof node == 'string') {
            children.push({
                name: node,
                parent,
                children: []
            });
        } else {
            children.push({
                name: node.parent,
                parent,
                children: [node]
            });
        }
    }

    return {
        name: parent,
        parent: null,
        children
    }
}

function getNonTerminal(yy, state) {
    const simbolos = yy.parser.symbols_;
    const produccion = yy.parser.productions_[state];
    let nonTerminal = '';
    for (let sim in simbolos) {
        if (simbolos[sim] === produccion[0]) {
            nonTerminal = sim;
            break;
        }
    }
    return nonTerminal;
}