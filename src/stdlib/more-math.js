'use strict';
module.exports = {
    'parse-num': parseFloat,
    'pow': Math.pow,
    'cast-int': Math.trunc,
    'floor': Math.floor,
    'ceil': Math.ceil,
    'random-range': (min, max) =>
        Math.floor(Math.random() * (max - min + 1) + min),
    'random-0-1': Math.random,
    'abs': Math.abs,
    'isDivBy': (x, y) => x % y === 0,
    '+1': x => x + 1
};
