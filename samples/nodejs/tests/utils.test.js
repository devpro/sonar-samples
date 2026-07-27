'use strict';

const { greet, add } = require('../src/utils');

describe('greet', () => {
  test('returns greeting with provided name', () => {
    expect(greet('Bertrand')).toBe('Hello, Bertrand!');
  });

  test('falls back to world when name is empty', () => {
    expect(greet('')).toBe('Hello, world!');
  });
});

describe('add', () => {
  test('adds two positive numbers', () => {
    expect(add(2, 3)).toBe(5);
  });

  test('handles negative numbers', () => {
    expect(add(-1, 1)).toBe(0);
  });
});
