'use strict';
module.exports = {
    list: function () {
        return Array.prototype.slice.call(arguments);
    },
    'range': (a, b) => {
        let arr = [];
        for (let i = a; i <= b; i++) {
            arr.push(i);
        }
        return arr;
    },
    'range-by': (a, b, c) => {
        let arr = [];
        for (let i = a; i <= b; i += c) {
            arr.push(i);
        }
        return arr;
    },
    'index': (x, i) => x[i],
    'index-of': (x, a) => x.indexOf(a),
    'copy': (x, a, b) => x.slice(a, b),
    'add': (x, a) => {
        let y = x.slice();
        y.push(a);
        return y;
    },
    'add-at': (x, i, a) => {
        let y = x.slice();
        y.splice(i, 0, a);
        return y;
    },
    'remove': (x, i) => {
        let y = x.slice();
        y.splice(i, 1);
        return y;
    },
    'length': x => x.length,
    'is-empty': x => x.length === 0
};
