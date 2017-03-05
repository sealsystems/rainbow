'use strict';

const roboter = require('roboter');

// dummy require to avoid an unused dependencies error
require('eslint-config-seal');

roboter.
  workOn('server').
  equipWith((task) => {
    task('universal/analyze', {
      src: ['**/*.js', '!node_modules/**/*.js', '!examples/**', '!coverage/**', '!tmp/**', '!output/**'],
      rules: '.eslintrc'
    });
    task('universal/license', {
      disable: true
    });
    task('universal/test-units', {
      src: 'test/**/*Test.js'
    });
  }).
  start();
