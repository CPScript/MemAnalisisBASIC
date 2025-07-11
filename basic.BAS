10 CLS
20 PRINT "MEMORY ANALYZER"
30 PRINT "==================="
40 PRINT
50 STARTADDR = 0: ENDADDR = 65535: CURRENTADDR = 0
60 BYTESPERLINE = 16: SEARCHSTRING$ = ""
70 MODE$ = "HEX": HIGHLIGHT = 0
80 GOSUB 2000
90 INPUT "Command: ", CMD$
100 CMD$ = UCASE$(LEFT$(CMD$, 1))
110 IF CMD$ = "D" THEN GOSUB 500: GOTO 80
120 IF CMD$ = "S" THEN GOSUB 800: GOTO 80
130 IF CMD$ = "G" THEN GOSUB 1000: GOTO 80
140 IF CMD$ = "F" THEN GOSUB 1200: GOTO 80
150 IF CMD$ = "M" THEN GOSUB 1400: GOTO 80
160 IF CMD$ = "R" THEN GOSUB 1600: GOTO 80
170 IF CMD$ = "H" THEN GOSUB 1800: GOTO 80
180 IF CMD$ = "Q" THEN GOSUB 2200: END
190 PRINT "Invalid command. Type H for help."
200 GOTO 80
210
500 CLS
510 PRINT "MEMORY DUMP - Address: "; HEX$(CURRENTADDR)
520 PRINT "======================================="
530 FOR ROW = 0 TO 15
540   ADDR = CURRENTADDR + (ROW * BYTESPERLINE)
550   IF ADDR > ENDADDR THEN GOTO 680
560   PRINT HEX$(ADDR); ": ";
570   FOR COL = 0 TO BYTESPERLINE - 1
580     IF ADDR + COL <= ENDADDR THEN
590       BYTEVAL = PEEK(ADDR + COL)
600       IF BYTEVAL < 16 THEN PRINT "0";
610       PRINT HEX$(BYTEVAL); " ";
620     ELSE
630       PRINT "   ";
640     ENDIF
650   NEXT COL
660   PRINT " |";
670   FOR COL = 0 TO BYTESPERLINE - 1
680     IF ADDR + COL <= ENDADDR THEN
690       BYTEVAL = PEEK(ADDR + COL)
700       IF BYTEVAL >= 32 AND BYTEVAL <= 126 THEN
710         PRINT CHR$(BYTEVAL);
720       ELSE
730         PRINT ".";
740       ENDIF
750     ELSE
760       PRINT " ";
770     ENDIF
780   NEXT COL
790   PRINT "|"
800 NEXT ROW
810 PRINT
820 PRINT "N)ext page, P)revious page, M)ain menu"
830 INPUT "Action: ", ACTION$
840 ACTION$ = UCASE$(LEFT$(ACTION$, 1))
850 IF ACTION$ = "N" THEN CURRENTADDR = CURRENTADDR + 256: GOTO 500
860 IF ACTION$ = "P" THEN CURRENTADDR = CURRENTADDR - 256: IF CURRENTADDR < 0 THEN CURRENTADDR = 0
870 IF ACTION$ = "P" THEN GOTO 500
880 RETURN
890
900 INPUT "Enter search string (hex or ASCII): ", SEARCHSTRING$
910 INPUT "Search type (H)ex or (A)SCII: ", SEARCHTYPE$
920 SEARCHTYPE$ = UCASE$(LEFT$(SEARCHTYPE$, 1))
930 PRINT "Searching from address "; HEX$(CURRENTADDR); "..."
940 SEARCHLEN = LEN(SEARCHSTRING$)
950 IF SEARCHTYPE$ = "H" THEN GOSUB 3000
960 FOUND = 0
970 FOR ADDR = CURRENTADDR TO ENDADDR - SEARCHLEN + 1
980   MATCH = 1
990   FOR I = 0 TO SEARCHLEN - 1
1000     IF SEARCHTYPE$ = "A" THEN
1010       IF PEEK(ADDR + I) <> ASC(MID$(SEARCHSTRING$, I + 1, 1)) THEN MATCH = 0: I = SEARCHLEN
1020     ELSE
1030       IF PEEK(ADDR + I) <> HEXBYTES(I) THEN MATCH = 0: I = SEARCHLEN
1040     ENDIF
1050   NEXT I
1060   IF MATCH = 1 THEN
1070     PRINT "Found at address: "; HEX$(ADDR)
1080     CURRENTADDR = ADDR
1090     HIGHLIGHT = ADDR
1100     FOUND = 1
1110     INPUT "Continue searching (Y/N)? ", CONTINUE$
1120     IF UCASE$(LEFT$(CONTINUE$, 1)) = "N" THEN RETURN
1130   ENDIF
1140 NEXT ADDR
1150 IF FOUND = 0 THEN PRINT "Pattern not found."
1160 RETURN
1170
1200 INPUT "Enter address (hex): ", ADDR$
1210 NEWADDR = VAL("&H" + ADDR$)
1220 IF NEWADDR >= 0 AND NEWADDR <= ENDADDR THEN
1230   CURRENTADDR = NEWADDR
1240   PRINT "Current address set to: "; HEX$(CURRENTADDR)
1250 ELSE
1260   PRINT "Invalid address range."
1270 ENDIF
1280 RETURN
1290
1300 INPUT "Start address (hex): ", START$
1310 INPUT "End address (hex): ", END$
1320 INPUT "Fill byte (hex): ", FILLBYTE$
1330 STARTFILL = VAL("&H" + START$)
1340 ENDFILL = VAL("&H" + END$)
1350 FILLVAL = VAL("&H" + FILLBYTE$)
1360 IF STARTFILL <= ENDFILL AND STARTFILL >= 0 AND ENDFILL <= ENDADDR THEN
1370   FOR ADDR = STARTFILL TO ENDFILL
1380     POKE ADDR, FILLVAL
1390   NEXT ADDR
1400   PRINT "Memory filled from "; HEX$(STARTFILL); " to "; HEX$(ENDFILL)
1410 ELSE
1420   PRINT "Invalid address range."
1430 ENDIF
1440 RETURN
1450
1460 PRINT "MEMORY STATISTICS"
1470 PRINT "=================="
1480 PRINT "Address range: "; HEX$(STARTADDR); " - "; HEX$(ENDADDR)
1490 PRINT "Current position: "; HEX$(CURRENTADDR)
1500 PRINT "Total memory size: "; (ENDADDR - STARTADDR + 1); " bytes"
1510 DIM FREQ(255)
1520 FOR I = 0 TO 255: FREQ(I) = 0: NEXT I
1530 PRINT "Analyzing byte frequency..."
1540 FOR ADDR = STARTADDR TO ENDADDR
1550   BYTEVAL = PEEK(ADDR)
1560   FREQ(BYTEVAL) = FREQ(BYTEVAL) + 1
1570 NEXT ADDR
1580 PRINT "Most common bytes:"
1590 FOR I = 0 TO 255
1600   IF FREQ(I) > (ENDADDR - STARTADDR + 1) / 100 THEN
1610     PRINT "  "; HEX$(I); ": "; FREQ(I); " occurrences"
1620   ENDIF
1630 NEXT I
1640 INPUT "Press ENTER to continue...", DUMMY$
1650 RETURN
1660
1670 PRINT "Current range: "; HEX$(STARTADDR); " - "; HEX$(ENDADDR)
1680 INPUT "New start address (hex, ENTER to keep): ", START$
1690 INPUT "New end address (hex, ENTER to keep): ", END$
1700 IF START$ <> "" THEN
1710   NEWSTART = VAL("&H" + START$)
1720   IF NEWSTART >= 0 THEN STARTADDR = NEWSTART
1730 ENDIF
1740 IF END$ <> "" THEN
1750   NEWEND = VAL("&H" + END$)
1760   IF NEWEND >= STARTADDR THEN ENDADDR = NEWEND
1770 ENDIF
1780 CURRENTADDR = STARTADDR
1790 PRINT "New range: "; HEX$(STARTADDR); " - "; HEX$(ENDADDR)
1800 RETURN
1810
1820 CLS
1830 PRINT "MEMORY ANALYZER HELP"
1840 PRINT "===================="
1850 PRINT "D - Dump memory (hex/ASCII display)"
1860 PRINT "S - Search for pattern in memory"
1870 PRINT "G - Goto specific address"
1880 PRINT "F - Fill memory range with byte"
1890 PRINT "M - Memory statistics and analysis"
1900 PRINT "R - Set memory range"
1910 PRINT "H - Show this help"
1920 PRINT "Q - Quit analyzer"
1930 PRINT
1940 PRINT "Navigation in dump mode:"
1950 PRINT "  N - Next page (+256 bytes)"
1960 PRINT "  P - Previous page (-256 bytes)"
1970 PRINT
1980 INPUT "Press ENTER to continue...", DUMMY$
1990 RETURN
2000
2010 CLS
2020 PRINT "MEMORY ANALYZER v1.0"
2030 PRINT "===================="
2040 PRINT "Range: "; HEX$(STARTADDR); " - "; HEX$(ENDADDR)
2050 PRINT "Current: "; HEX$(CURRENTADDR)
2060 PRINT
2070 PRINT "Commands:"
2080 PRINT "D)ump  S)earch  G)oto  F)ill  M)emstat  R)ange  H)elp  Q)uit"
2090 PRINT
2100 RETURN
2110
2120 PRINT "Memory Analyzer terminated."
2130 RETURN
2140
2150 DIM HEXBYTES(255)
2160 HEXLEN = LEN(SEARCHSTRING$) / 2
2170 FOR I = 0 TO HEXLEN - 1
2180   HEXCHAR$ = MID$(SEARCHSTRING$, I * 2 + 1, 2)
2190   HEXBYTES(I) = VAL("&H" + HEXCHAR$)
2200 NEXT I
2210 SEARCHLEN = HEXLEN
2220 RETURN
2230 REM *** AHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH ***
2240 REM *** Blehhh!!! :P ***
