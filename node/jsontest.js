#!/usr/bin/env node

console.log('hello world');
var args = process.argv.slice(2);

var test = '{"zones": [{"name": "wearablezone.com","id": "6f389622fe64fccdcf636956be422b5c"}, {"name": "wearableshowdown.com","id": "8674213d6ba84b7921047991443d2b40"}]}'
var json = JSON.parse(test);

console.log(args);
console.log(json.zones[0].name + " - " + json.zones[0].id);
