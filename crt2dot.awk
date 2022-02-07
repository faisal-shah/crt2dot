#!/usr/bin/awk -f

# Usage: crt2dot.awk -v readelf=<path/to/readelfoutput> \
#           -v filt=<comma separated symbol types to use>
#
# If filt is empty, defaults to just FUNC symbol type

function basename(file) {
    sub(".*/", "", file)
    return file
}
BEGIN {
    err = 0;
    if (readelf == "")
    {
        err = 1;
        exit err;
    }
    if (filt == "")
    {
        filt = "FUNC";
    }
    split(filt, filtarr, ",");
    numtok = 0;
    for (i in filtarr)
    {
        if (filtarr[i] != "")
        {
            numtok++;
        }
    }
    state = "SEARCH_CRF";
    printf "digraph {\n"
}
END {
    if (err == 0)
    {
        printf "}\n"
    }
}
{
    if (state == "SEARCH_CRF")
    {
        if ($0 == "Cross Reference Table")
        {
            state = "SEARCH_HDR";
        }
    }
    else if (state == "SEARCH_HDR")
    {
        if (($1 == "Symbol") && ($2 == "File"))
        {
            state = "PROCESS_CRT";
            gotsym = 0;
        }
    }
    else if (state == "PROCESS_CRT")
    {
        if (NF == 2)
        {
            cmd = "awk '$8 == \""$1"\" {print $4}' "readelf;
            cmd | getline symtype;
            close(cmd);
            gotsym = 0;
            for (i in filtarr)
            {
                if (symtype == filtarr[i])
                {
                    gotsym = 1;
                    sym = $1;
                    symdef = $2;
                    break;
                }
            }
        }
        if (NF == 1)
        {
            if (gotsym == 1)
            {
                printf "\"%s\" -> \"%s\" [label=\"%s\"];\n",basename($1),basename(symdef),sym;
            }
        }
    }
}
