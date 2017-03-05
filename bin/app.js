'use strict';

const Blinkt = require('node-blinkt');

/* eslint-disable no-console */

const leds = new Blinkt();
const NUM_LEDS = 8;
const brightness = 0.1;

const shutdown = function () {
  console.log('Turning off lights.');

  leds.setAllPixels(0, 0, 0, 0);

  // Workaround: https://github.com/Irrelon/node-blinkt/issues/1
  leds.sendUpdate();
  leds.sendUpdate();

  /* eslint-disable no-process-exit */
  process.nextTick(() => {
    console.log('Terminating process.');
    process.exit(0);
  });
  /* eslint-enable no-process-exit */
};

const init = function () {
  leds.setup();
  leds.clearAll();

  process.on('SIGINT', shutdown);
  process.on('SIGTERM', shutdown);

  console.log('Initialized.');
};

// generate rainbow colors accross 0-255 positions.
const wheel = function (pos) {
  /* eslint-disable brace-style */
  /* eslint-disable max-statements-per-line */
  /* eslint-disable no-else-return */
  pos = 255 - pos;
  if (pos < 85) { return [255 - pos * 3, 0, pos * 3]; }
  else if (pos < 170) { pos -= 85; return [0, pos * 3, 255 - pos * 3]; }
  else { pos -= 170; return [pos * 3, 255 - pos * 3, 0]; }
};

init();

const offset = 0;

setInterval(() => {
  /* eslint-disable one-var-declaration-per-line */
  /* eslint-disable sort-vars */
  let red, green, blue;

  for (let i = 0; i < NUM_LEDS; i++) {
    [red, green, blue] = wheel(((i * 256 / NUM_LEDS) + offset) % 256);
    leds.setPixel(i, red, green, blue, brightness);
  }

  leds.sendUpdate();
}, 1000 / 30);

console.log('Rainbow started. Press <ctrl>+C to exit.');
