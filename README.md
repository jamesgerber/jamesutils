These are a bunch of utilities written mostly by
me, although a few were written by others.

ConnectPaths will add all of the paths in this directory
to the matlab path

You'll have to make your own function iddstring.m
which returns the location of some data you'll have to get from me

similarly you'll have to get your own version of DataProductsDir.m
will need to point to other data you'll have to get from me


DirectoryOfShame and DirectoryOfShame2 were a temporary workaround
when mathworks introduced capitalization-sensitive
function names ... everything broke, so I wrote 
a passthrough function and made no-caps versions of things.
In theory I'll fix this some day ... but it works 
so I haven't bothered yet.


Here are some functions I find particularly useful:

nsg ... calls nicesurfgeneral, zillions of options

megagrep - this runs a unix command (default command is grep)
in every non-mathworks directory on the path.  it's surprisingly useful
at least for me who can never remember where things are

