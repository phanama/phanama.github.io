#!/usr/bin/env bash

set -e

hugo

cd public
git add .
git commit --signoff -e
git push origin master
