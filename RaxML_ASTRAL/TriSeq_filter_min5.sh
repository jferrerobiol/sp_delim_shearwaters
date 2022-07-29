#!/bin/bash
#$-V
#$-cwd
#TriSeq 1.0.2
TriSeq -in PPuf_clust89_percent65_min5.phy -of phylip -c --missing-filter 75 75 --min-taxa 5 --suffix PBoBa -grep XPLL2 XPLB1 XPB1 PLBa1 XPLB4 XPLB3 PLBa2 XPLB5 PLBa4 PLBa3 XPB2 XPLB2 PLBo1 PLBo2 XPLL1
TriSeq -in PPuf_clust89_percent65_min5.phy -of phylip -c --missing-filter 75 75 --min-taxa 5 --suffix PPuf -grep PPuf2 PPuf1 XPPP2 XPP3 XPP9 XPP6 XPP8 XPP5 XPP4 XPP7 XPP10 XPM2 XPY1
TriSeq -in PPuf_clust89_percent65_min5.phy -of phylip -c --missing-filter 75 75 --min-taxa 5 --suffix PMY -grep  XPP7 XPP10 XPM2 XPY1 XPY3 XPY4 XPM1 XPM6 PMau1 XPM5 XPY2 PYel1 PMau2 PYel2

