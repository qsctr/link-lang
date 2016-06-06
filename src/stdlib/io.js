'use strict';
const rls = require('readline-sync');
module.exports = {
    'print': m => {
        console.log(m);
        return m;
    },
    'printnoln': m => {
        let s = m;
        if (typeof m !== 'string') {
            s = m.toString();
        }
        process.stdout.write(s);
        return m;
    },
    'question': rls.question
};
