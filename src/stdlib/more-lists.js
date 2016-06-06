'use strict';
module.exports = {
    'map': (x, f) => x.map(f),
    'filter': (x, f) => x.filter(f),
    'any': (x, f) => x.some(f),
    'all': (x, f) => x.every(f),
    'foldl': (x, f) => x.reduce(f),
    'foldr': (x, f) => x.reduceRight(f),
    'sort': (x, f) => {
        let y = x.slice();
        y.sort(f);
        return y;
    }
};
