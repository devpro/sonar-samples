'use strict';

const { greet, add } = require('../src/utils');
const { describeRole, classify, hashPassword } = require('../src/showcase');

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

describe('showcase', () => {
  test('describeRole returns the role label', () => {
    expect(describeRole('administrator')).toBe('administrator');
  });

  test('classify handles the all-positive branch', () => {
    expect(classify(1, 1, 1, 1)).toBe('all-positive');
  });

  test('classify falls through to unclassified', () => {
    expect(classify(0, 0, 0, 0)).toBe('unclassified');
  });

  test('hashPassword returns a hex digest', () => {
    expect(hashPassword('x')).toMatch(/^[0-9a-f]{32}$/);
  });
});
