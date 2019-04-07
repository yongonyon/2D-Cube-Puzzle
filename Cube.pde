// Introduction Text (How-To)
fill(0, 0, 0);
textSize(15);
text("Pressing the key corresponding to a face will", 100, 30);
text("rotate that face Clockwise. Hold Shift or use", 100, 45);
text("Caps Lock to rotate", 200, 60);
text("Counter-Clockwise.", 200, 75);
text("Press q or Q to reset.", 200, 110);

// Swap up your color scheme
var _RED = color(230, 83, 83);
var _BLUE = color(111, 111, 217);
var _GREEN = color(32, 196, 32);
var _WHITE = color(255, 255, 255);
var _YELLOW = color(247, 247, 64);
var _ORANGE = color(255, 130, 20);

// Text for the Center Tiles
var _CENTERS = {
    "5": "uU",
    "14": "lL",  
    "23": "fF", 
    "32": "rR", 
    "41": "bB", 
    "50": "dD" 
};

// Turn Number Labels on or off
var show_number_labels = false;

// Iterate to Generate IDs for building each Tile object
var _ID_ITERATOR = 0;

// The Tile Constructor
var Tile = function(x, y, color) {
    // Constants
    this.id = ++_ID_ITERATOR;
    this.width = 30;
    this.fillColor = color;
    this._x = x;
    this._y = y;
    this.position = _ID_ITERATOR;
    this.is_center = _CENTERS[_ID_ITERATOR] !== undefined;
    // Malleable Values
    this.x = x;
    this.y = y;
};

// Draw a Tile on the Canvas
Tile.prototype.draw = function() {
    fill(this.fillColor);
    rect(this.x, this.y, this.width, this.width, 5);

    if (this.is_center) {
        fill(0, 0, 0);
        textSize(20);
        text(_CENTERS[this.id], this.x + 3, this.y + 23);
    }
};

// Our array of Tiles
var tiles = [];

// Getters
var get_tile_by_id = function(_id) {
    for (var i = 0; i < tiles.length; i++) {
        if (tiles[i].id === _id) {
            return tiles[i];   
        }
    }
};
var get_tile_by_position = function(_position) {
    for (var i = 0; i < tiles.length; i++) {
        if (tiles[i].position === _position) {
            return tiles[i];
        }
    }
};

// Setup a face of Nine Tiles
var build_puzzle_face = function(_root_x, _root_y, _color) {
    var root_x = _root_x;
    var root_y = _root_y;
    for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
            tiles.push(new Tile(root_x + (30 * i), root_y + (30 * j), _color));
        }
    }
};
var build_puzzle = function() {
    build_puzzle_face(100, 50, _YELLOW); // U
    build_puzzle_face(10, 140, _BLUE); // L
    build_puzzle_face(100, 140, _RED); // F
    build_puzzle_face(190, 140, _GREEN); // R
    build_puzzle_face(280, 140, _ORANGE); // B
    build_puzzle_face(100, 230, _WHITE); // D
};
build_puzzle();

// Transform Puzzle according to inputted Move
var applyTranslations = function(_translations) {
    for (var i = 0; i < tiles.length; i++) {
        if (_translations[tiles[i].position] !== undefined) {
            var new_position_tile = get_tile_by_id(_translations[tiles[i].position]);
            tiles[i].x = new_position_tile._x;
            tiles[i].y = new_position_tile._y;
            tiles[i].position = _translations[tiles[i].position];
            draw();
        }
    }
};

// Objects used as Look-up Tables for Tile <-> Tile Relationships
var UP_TRANSLATIONS = {"1": 7, "2": 4, "3": 1, "4": 8, "5": 5, "6": 2, "7": 9, "8": 6, "9": 3, "10": 37, "13": 40, "16": 43, "19": 10, "22": 13, "25": 16, "28": 19, "31": 22, "34": 25, "37": 28, "40": 31, "43": 34};
var DOWN_TRANSLATIONS = {"46": 52,"47": 49,"48": 46,"49": 53,"50": 50,"51": 47,"52": 54,"53": 51,"54": 48,"21": 30,"24": 33,"27": 36,"30": 39,"33": 42,"36": 45,"39": 12,"42": 15,"45": 18,"12": 21,"15": 24,"18": 27};
var RIGHT_TRANSLATIONS = {"28": 34,"29": 31,"30": 28,"31": 35,"32": 32,"33": 29,"34": 36,"35": 33,"36": 30,"25": 7,"26": 8,"27": 9,"9": 37,"8": 38,"7": 39,"37": 54,"38": 53,"39": 52,"52": 25,"53": 26,"54": 27};
var LEFT_TRANSLATIONS = {"10": 16,"12": 10,"16": 18,"18": 12,"14": 14,"11": 13,"13": 17,"15": 11,"17": 15,"19": 46,"20": 47,"21": 48,"43": 3,"44": 2,"45": 1,"46": 45,"47": 44,"48": 43,"1": 19,"2": 20,"3": 21};
var BACK_TRANSLATIONS = {"37": 43,"38": 40,"39": 37,"40": 44,"41": 41,"42": 38,"43": 45,"44": 42,"45": 39,"34": 1,"35": 4,"36": 7,"10": 48,"11": 51,"12": 54,"1": 12,"4": 11,"7": 10,"48": 36,"51": 35,"54": 34};
var FRONT_TRANSLATIONS = {"19": 25,"20": 22,"21": 19,"22": 26,"23": 23,"24": 20,"25": 27,"26": 24,"27": 21,"3": 28,"6": 29,"9": 30,"28": 52,"29": 49,"30": 46,"46": 16,"49": 17,"52": 18,"16": 9,"17": 6,"18": 3};

// Reset the Puzzle to its initial state
var resetPuzzle = function() {
    for (var i = 0; i < tiles.length; i++){
        tiles[i].x = tiles[i]._x;
        tiles[i].y = tiles[i]._y;
        tiles[i].position = tiles[i].id;
        draw();
    }
};

keyTyped = function() {
    // u
    if (key.toString() === "u") {
        applyTranslations(UP_TRANSLATIONS);
    } 
    // U
    if (key.toString() === "U") {
        applyTranslations(UP_TRANSLATIONS);
        applyTranslations(UP_TRANSLATIONS);
        applyTranslations(UP_TRANSLATIONS);
    }

    // d
    if (key.toString() === "d") {
        applyTranslations(DOWN_TRANSLATIONS);
    }
    // D
    if (key.toString() === "D") {
        applyTranslations(DOWN_TRANSLATIONS);
        applyTranslations(DOWN_TRANSLATIONS);
        applyTranslations(DOWN_TRANSLATIONS);
    }
    
    // r
    if (key.toString() === "r") {
        applyTranslations(RIGHT_TRANSLATIONS);
    }
    // R
    if (key.toString() === "R") {
        applyTranslations(RIGHT_TRANSLATIONS);
        applyTranslations(RIGHT_TRANSLATIONS);
        applyTranslations(RIGHT_TRANSLATIONS);
    }

    // l
    if (key.toString() === "l") {
        applyTranslations(LEFT_TRANSLATIONS);
    }   
    // L
    if (key.toString() === "L") {
        applyTranslations(LEFT_TRANSLATIONS);
        applyTranslations(LEFT_TRANSLATIONS);
        applyTranslations(LEFT_TRANSLATIONS);
    }

    // f
    if (key.toString() === "f") {
        applyTranslations(FRONT_TRANSLATIONS);
    }
    // F
    if (key.toString() === "F") {
        applyTranslations(FRONT_TRANSLATIONS);
        applyTranslations(FRONT_TRANSLATIONS);
        applyTranslations(FRONT_TRANSLATIONS);   
    }

    // b
    if (key.toString() === "b") {
        applyTranslations(BACK_TRANSLATIONS);
    }
    // B
    if (key.toString() === "B") {
        applyTranslations(BACK_TRANSLATIONS);
        applyTranslations(BACK_TRANSLATIONS);
        applyTranslations(BACK_TRANSLATIONS);
    }

    // Reset 
    if (key.toString() === "Q" || key.toString() === "q") {
        resetPuzzle();
    }
};

draw = function() {
    for (var i = 0; i < tiles.length; i++) {
        tiles[i].draw();
    }
    noLoop();
};
