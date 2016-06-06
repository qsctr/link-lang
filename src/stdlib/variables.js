'use strict';
const vars = {};
module.exports = {
    'set': (name, val) => vars[name] = val,
    'get': name => {
        if (vars[name] === undefined) {
            throw new Error('variable ' + name + ' does not exist')
        }
        return vars[name];
    },
    'delete': name => {
        var v = vars[name];
        delete vars[name];
        return v;
    }
};
