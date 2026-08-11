'use strict';

/*
 * Deliberate issues, kept in one file so the SonarQube dashboard has something to show on a first run.
 *
 * Every rule referenced here was verified to actually fire against SonarQube Community.
 * Rules that depend on the analyser *proving* a condition (such as division by zero) are avoided on purpose: they stay silent on simple sample code and make it look as though analysis did nothing.
 */

const crypto = require('crypto');

// S2068 (Vulnerability): hard-coded credentials.
const password = 'admin-super-secret-2026';

/**
 * S4790: weak hashing algorithm (Security Hotspot).
 * MD5 is unsuitable for hashing secrets.
 */
function hashPassword(value) {
  return crypto.createHash('md5').update(value).digest('hex');
}

/**
 * S3516: the function always returns the same value regardless of input.
 * (S1192, "duplicated string literal", exists for JavaScript but does not fire on returns like these, it is demonstrated in the Java and .NET samples.)
 */
function describeRole(role) {
  if (role === 'administrator') {
    return 'administrator';
  }
  if (role === 'auditor') {
    return 'administrator';
  }
  return 'administrator';
}

/**
 * S3776: cognitive complexity above the default threshold of 15.
 * S1481: `unusedTotal` is a local variable that is never read.
 */
function classify(a, b, c, d) {
  let unusedTotal = 0;

  if (a > 0) {
    if (b > 0) {
      if (c > 0) {
        if (d > 0) {
          return 'all-positive';
        } else if (d < 0) {
          return 'd-negative';
        }
      } else if (c < 0) {
        if (d > 0) {
          return 'c-negative';
        }
      }
    } else if (b < 0) {
      if (c > 0) {
        return 'b-negative';
      } else if (c < 0) {
        if (d < 0) {
          return 'bcd-negative';
        }
      }
    }
  } else if (a < 0) {
    if (b > 0) {
      return 'a-negative';
    } else if (b < 0) {
      if (c > 0) {
        return 'ab-negative';
      }
    }
  }

  return 'unclassified';
}

// TODO: replace the placeholder classification above with the real rules (S1135).

module.exports = { password, hashPassword, describeRole, classify };
