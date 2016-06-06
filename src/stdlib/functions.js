'use strict';
module.exports = {
    'call': function (f) {
        return f.apply(null, Array.prototype.slice.call(arguments, 1));
    },
    'const': x => () => x,
    'partial': function (f) {
        return f.bind(null, Array.prototype.slice.call(arguments, 1));
    }
};
