fs   = require "fs"
path = require "path"
gulp = require "gulp"

log         = require "../../lib/log"
diskWatcher = require "../../lib/disk-watcher"
tests       = require "../../lib/tests"

options       = coffeeProjectOptions.tests
enabled       = options.enabled
directoryPath = path.resolve options.directoryPath
watchEnabled  = coffeeProjectOptions.watch.enabled

runTests = ->
	tests directoryPath, false, "spec", ->

changeHandler = (options) ->
	return unless options.path.match /\.coffee/

	# Run tests all cases (changed, added, deleted).
	runTests()

gulp.task "tests:watch", [ "compile" ], (cb) ->
	unless enabled and watchEnabled
		log.info "Skipping tests:watch: Disabled."
		return cb()

	log.debug "[tests:watch] Directory path: `#{directoryPath}`."

	diskWatcher.src().on  "change", changeHandler
	diskWatcher.test().on "change", changeHandler

	runTests()

	return
