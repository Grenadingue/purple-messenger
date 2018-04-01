#!/usr/bin/env node

const fileinput = require('fileinput');

var sentencePortions = [];
var lastLevel = 0;

function getNodeCharacter(line) {
  for (var i = 0; i !== line.length && line[i] === ' '; ++i);
  return line[i];
}

console.log('# Plain text use cases');
console.log();

fileinput.input('use_cases_tree.txt').on('line', (rawLine) => {
  const line = rawLine.toString('utf8').slice(0, rawLine.toString('utf8').length - 1);
  const nodeCharacter = getNodeCharacter(line);
  const level = line.indexOf(nodeCharacter) / 2;

  if (level < 0) { // eof
    return;
  }

  const sentencePortion = line.slice(line.indexOf(nodeCharacter) + 2, line.length);

  if (level < lastLevel) {
    const levelDiff = lastLevel - level;
    sentencePortions = sentencePortions.slice(0, sentencePortions.length - levelDiff - 1);
  } else if (level == lastLevel) {
    sentencePortions = sentencePortions.slice(0, sentencePortions.length - 1);
  }

  sentencePortions.push(sentencePortion);
  lastLevel = level;

  let sentence = '';
  let firstPortion = true;
  sentencePortions.forEach((portion) => {
    sentence += !firstPortion ? ' ' : '';
    sentence += portion;
    firstPortion = false;
  });

  if (nodeCharacter === '-') {
    console.log('-', sentence);
  }
});
