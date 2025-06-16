#!/bin/sh

watchexec -r -e cr "crystal run --error-trace src/urlaub_app.cr -- -p 3008"
