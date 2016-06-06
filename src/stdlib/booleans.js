'use strict';
module.exports = {
    'true': () => true,
    'false': () => false,
    '!': x => !x,
    '&': (x, y) => x && y,
    '|': (x, y) => x || y
};
