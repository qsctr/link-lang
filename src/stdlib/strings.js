'use strict';
module.exports = {
    '+': (a, b) => a + b,
    'substring': (s, a, b) => s.substring(a, b),
    'length': x => x.length,
    'is-empty': x => x.length === 0,
    'index': (x, i) => x[i],
    'index-of': (a, b) => a.indexOf(b),
    'to-string': x => x.toString()
};
