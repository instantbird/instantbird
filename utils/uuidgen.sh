#!/bin/bash

uuidgen-c++()
{
    max=`echo $1 |tr a-z A-Z`

    local UUID=$(uuidgen)
    echo "// $UUID"
    echo "#define PURPLE_"$max"_CID \\"
    echo "{ 0x${UUID:0:8}, 0x${UUID:9:4}, 0x${UUID:14:4}, \\"
    echo -n "  { 0x${UUID:19:2}, 0x${UUID:21:2}, 0x${UUID:24:2}, "
    echo -n "0x${UUID:26:2}, 0x${UUID:28:2}, 0x${UUID:30:2}, "
    echo "0x${UUID:32:2}, 0x${UUID:34:2} } \\"
    echo " }" 

    echo

    min=`echo $1 |tr A-Z a-z`

    echo "#define PURPLE_"$max"_CONTRACTID \\"
    echo "    \"@instantbird.org/purple/$min;1\""


}


uuidgen-c++ $1
