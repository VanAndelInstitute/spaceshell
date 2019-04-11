#!/bin/bash

git checkout gh-pages
git merge master -m "autosync"
git commit -am "autosync"
git push origin gh-pages
git checkout master