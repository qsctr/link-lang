'use strict';
module.exports = {
    'while': (cond, f) => {
        let res = false;
        for (let i = 1; cond; i++) {
            res = f(i);
        }
        return res;
    },
    'until': (cond, f) => {
        let res = false;
        for (let i = 1; !cond; i++) {
            res = f(i);
        }
        return res;
    },
    'repeat': (n, f) => {
        let res = false;
        for (let i = 1; i <= n; i++) {
            res = f(i);
        }
        return res;
    },
    'repeat-range': (a, b, f) => {
        let res = false;
        for (let i = a; i <= b; i++) {
            res = f(i);
        }
        return res;
    },
    'repeat-range-every': (a, b, c, f) => {
        let res = false;
        for (let i = a; i <= b; i += c) {
            res = f(i);
        }
        return res;
    }
};
