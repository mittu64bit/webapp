#!/usr/bin/env bash

# githubのWebAppにローカルのWebAppを上書きするためのスクリプト
cp -r ~/Setup\ Guide\ In-Editor\ Tutorial/webapp/* ./
git status                                           
git add -A
git commit -m "update webapp"
git push origin
