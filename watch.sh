#!/bin/sh

watchexec -r -e cr "crystal run --error-trace src/resteknueppeln.cr -- -p 3008"
