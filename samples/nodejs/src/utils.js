'use strict';

/**
 * Returns a greeting string.
 * @param {string} name
 * @returns {string}
 */
function greet(name) {
  if (!name) {
    name = 'world';
  }
  return `Hello, ${name}!`;
}

/**
 * Adds two numbers.
 * @param {number} a
 * @param {number} b
 * @returns {number}
 */
function add(a, b) {
  return a + b;
}

// Intentional code smell: unused variable (Sonar will flag this)
const unusedConstant = 42;

module.exports = { greet, add };
