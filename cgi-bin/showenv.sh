#!/bin/bash

echo "Content-type: text/html"
echo ""

echo "<h1>Ambiente CGI - $SERVER_NAME</h1>"
echo "<pre>"
env | sort
echo "</pre>"

