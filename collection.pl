#!/usr/bin/perl -wT

# goes in /usr/lib/cgi-bin

print "Content-type: text/html\n\n";

my $bg;
my $title;
my $stylesheet;
my ($file,$mode) = split /=/, $ENV{QUERY_STRING};
if ($file =~ 'comic') {
    $stylesheet = $file;
    $mode =~ s/%20/ /g;
    $title = "$mode $file";
    $file = lc $title;
    $file =~ s/ //g;
    $bg = ' class="dark"';
}
else {
    $title = $mode;
    if ($mode eq 'all') {
        $mode = '';
    }
    else {
        $mode = "_$mode" if $mode;
    }
    $stylesheet = "$file$mode";
}

print qq~<!DOCTYPE html>
<html>
    <head>
        <title>Collection: $title</title>
        <link rel="stylesheet" href="/style.css" type="text/css"/>
        <link rel="icon" type="image/png" href="/images/home.png"/>
		<link href="https://fonts.googleapis.com/css?family=Work+Sans:400,700" rel="stylesheet"/>
        <script src="/jquery-2.2.0.min.js" language="JavaScript" type="text/javascript"></script>
        <script src="/jquery.animate-colors-min.js" language="JavaScript" type="text/javascript"></script>
        <script src="/jquery.lazyloadxt.min.js" language="JavaScript" type="text/javascript"></script>
        <script src="/imagepopup.js" language="JavaScript" type="text/javascript"></script>
        <script type="text/javascript" language="JavaScript">
            jQuery(document).ready(function() {
                comicsInit("/$file.xml", "/$stylesheet.xsl");
            });
        </script>
    </head>
    <body$bg>
    </body>
</html>
~;

# open FL, '<', "../Documents/$file.xml";
# my $line = <FL>;
# print $line if $line;

# #make my own xsl handler line
# $line = <FL>;
# print qq{<?xml-stylesheet type="text/xsl" href="/$stylesheet.xsl"?>\n};

# while (<FL>) {print $_;}

1;
