#!/usr/bin/env

process.stdin.resume();

process.on('SIGINT', function () {
	  console.log('Got a SIGINT. Goodbye cruel world');
	    process.exit(0);
});
