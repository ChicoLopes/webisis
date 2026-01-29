#!/usr/bin/perl -w

use strict;
print "Content-type: text/html\n\n";
print <<END_OF_HTML;
<html>
<head>
<title>Página Web em Perl</title>
<meta charset="utf-8">
</head>
<body>
<h1>Olá, Mundo!</h1>
<p>Esta é uma página web gerada por um script Perl.</p>
</body>
</html>
END_OF_HTML

