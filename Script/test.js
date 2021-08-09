let name_list = new Array()


function preload() {
    name_list = loadStrings('assets/name.txt')
}

function setup() {
    background(200);
    console.log(name_list[0]);
}

