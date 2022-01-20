/*
 * Copyright (c) 2020 Broadcom.
 * The term "Broadcom" refers to Broadcom Inc. and/or its subsidiaries.
 *
 * This program and the accompanying materials are made
 * available under the terms of the Eclipse Public License 2.0
 * which is available at https://www.eclipse.org/legal/epl-2.0/
 *
 * SPDX-License-Identifier: EPL-2.0
 *
 * Contributors:
 *   Broadcom, Inc. - initial API and implementation
 */

lexer grammar CobolLexer;

channels{COMMENTS, TECHNICAL}
import IdmsLexer;

EJECT: E J E C T DOT_FS? -> channel(HIDDEN);
SKIP1 : S K I P '1' DOT_FS? -> channel(HIDDEN);
SKIP2 : S K I P '2' DOT_FS? -> channel(HIDDEN);
SKIP3 : S K I P '3' DOT_FS? -> channel(HIDDEN);

// keywords
ABD: A B D;
ACCEPT : A C C E P T;
ACCESS : A C C E S S;
ADATA : A D A T A;
ADD : A D D;
ADDRESS : A D D R E S S;
ADEXIT : A D E X I T;
ADV : A D V;
ADVANCING : A D V A N C I N G;
ADX : A D X;
AFP : A F P;
AFTER : A F T E R;
ALIAS : A L I A S;
ALL : A L L;
ALPHABET : A L P H A B E T;
ALPHABETIC : A L P H A B E T I C;
ALPHABETIC_LOWER : A L P H A B E T I C MINUSCHAR L O W E R;
ALPHABETIC_UPPER : A L P H A B E T I C MINUSCHAR U P P E R;
ALPHANUMERIC : A L P H A N U M E R I C;
ALPHANUMERIC_EDITED : A L P H A N U M E R I C MINUSCHAR E D I T E D;
ALPHNUM : A L P H N U M;
ALSO : A L S O;
ALTER : A L T E R;
ALTERNATE : A L T E R N A T E;
ANA: A N A;
ANALIST: A N A L I S T;
AND : A N D;
ANSI : A N S I;
ANY : A N Y;
APOST : A P O S T;
APPLY : A P P L Y;
AR : A R;
ARCH : A R C H;
ARE : A R E;
AREA : A R E A;
AREAS : A R E A S;
ARITH : A R I T H;
ASCENDING : A S C E N D I N G;
ASCII : A S C I I;
ASSIGN : A S S I G N;
ASSOCIATED_DATA : A S S O C I A T E D UNDERSCORECHAR D A T A;
ASSOCIATED_DATA_LENGTH : A S S O C I A T E D UNDERSCORECHAR D A T A UNDERSCORECHAR L E N G T H;
AT : A T;
ATTACH : A T T A C H;
ATTRIBUTES : A T T R I B U T E S;
AUTHOR : A U T H O R;
AUTO : A U T O;
AVG: A V G;
AWO : A W O;
BEFORE : B E F O R E;
BELOW : B E L O W;
BIN : B I N;
BINARY : B I N A R Y;
BLANK : B L A N K;
BLOCK : B L O C K;
BLOCK0 : B L O C K '0';
BOTTOM : B O T T O M;
BUF : B U F;
BUFFER : B U F F E R;
BUFSIZE : B U F S I Z E;
BY : B Y;
BYFUNCTION : B Y F U N C T I O N;
BYTITLE : B Y T I T L E;
CALL : C A L L;
CANCEL : C A N C E L;
CAPABLE : C A P A B L E;
CBL : C B L;
CCSVERSION : C C S V E R S I O N;
CHAINING : C H A I N I N G;
CHANGE : C H A N G E;
CHANGED : C H A N G E D;
CHANNEL : C H A N N E L;
CHARACTER : C H A R A C T E R;
CHARACTERS : C H A R A C T E R S;
CHECK : C H E C K;
CICS : C I C S;
CLASS : C L A S S;
CLEANSIGN : C L E A N S I G N;
CLEAR : C L E A R;
CLOCK_UNITS : C L O C K MINUSCHAR U N I T S;
CLOSE : C L O S E;
CLOSE_DISPOSITION : C L O S E MINUSCHAR D I S P O S I T I O N;
CO : C O;
CODE : C O D E;
CODEPAGE : C O D E P A G E;
CODE_SET : C O D E MINUSCHAR S E T;
COLLATING : C O L L A T I N G;
COMMA : C O M M A;
COMMIT : C O M M I T;
COMMITMENT : C O M M I T M E N T;
COMMON : C O M M O N;
COMP : C O M P;
COMPAT : C O M P A T;
COMPILE : C O M P I L E;
COMPUTATIONAL : C O M P U T A T I O N A L;
COMPUTATIONAL_1 : C O M P U T A T I O N A L MINUSCHAR '1';
COMPUTATIONAL_2 : C O M P U T A T I O N A L MINUSCHAR '2';
COMPUTATIONAL_3 : C O M P U T A T I O N A L MINUSCHAR '3';
COMPUTATIONAL_4 : C O M P U T A T I O N A L MINUSCHAR '4';
COMPUTATIONAL_5 : C O M P U T A T I O N A L MINUSCHAR '5';
COMPUTE : C O M P U T E;
COMP_1 : C O M P MINUSCHAR '1';
COMP_2 : C O M P MINUSCHAR '2';
COMP_3 : C O M P MINUSCHAR '3';
COMP_4 : C O M P MINUSCHAR '4';
COMP_5 : C O M P MINUSCHAR '5';
CONFIGURATION : C O N F I G U R A T I O N;
CONNECT : C O N N E C T;
CONTAINS : C O N T A I N S;
CONTENT : C O N T E N T;
CONTINUE : C O N T I N U E;
CONTROL : C O N T R O L;
CONVERTING : C O N V E R T I N G;
COPYENTRY : (' *>CPYENTER<URI>' .*? '</URI>') -> channel(TECHNICAL);
COPYEXIT : '*>CPYEXIT' + NEWLINE -> channel(TECHNICAL);
COPYLOC : C O P Y L O C;
COPYRIGHT : C O P Y R I G H T;
CORR : C O R R;
CORRESPONDING : C O R R E S P O N D I N G;
COUNT : C O U N T;
CP : C P;
CPLC : C P L C;
CPYR : C P Y R;
CR : C R;
CRUNCH : C R U N C H;
CS : C S;
CURR : C U R R;
CURRENCY : C U R R E N C Y;
CURRENT : C U R R E N T;
CURSOR : C U R S O R;
C_CHAR : C;
DATA : D A T A;
DATE : D A T E;
DATE_COMPILED : D A T E MINUSCHAR C O M P I L E D;
DATE_WRITTEN : D A T E MINUSCHAR W R I T T E N;
DAY : D A Y;
DAY_OF_WEEK : D A Y MINUSCHAR O F MINUSCHAR W E E K;
DB : D B;
DBCS : D B C S;
DEBUG : D E B U G;
DEBUGGING : D E B U G G I N G;
DEBUG_CONTENTS : D E B U G MINUSCHAR C O N T E N T S;
DEBUG_ITEM : D E B U G MINUSCHAR I T E M;
DEBUG_LINE : D E B U G MINUSCHAR L I N E;
DEBUG_NAME : D E B U G MINUSCHAR N A M E;
DEBUG_SUB_1 : D E B U G MINUSCHAR S U B MINUSCHAR '1';
DEBUG_SUB_2 : D E B U G MINUSCHAR S U B MINUSCHAR '2';
DEBUG_SUB_3 : D E B U G MINUSCHAR S U B MINUSCHAR '3';
DEC : D E C;
DECIMAL_POINT : D E C I M A L MINUSCHAR P O I N T;
DECK : D E C K;
DECLARATIVES : D E C L A R A T I V E S;
DEF : D E F;
DEFAULT : D E F A U L T;
DEFAULT_DISPLAY : D E F A U L T MINUSCHAR D I S P L A Y;
DEFINE : D E F I N E;
DEFINITION : D E F I N I T I O N;
DELETE : D E L E T E;
DELIMITED : D E L I M I T E D;
DELIMITER : D E L I M I T E R;
DEPENDING : D E P E N D I N G;
DESCENDING : D E S C E N D I N G;
DESCRIPTION: D E S C R I P T I O N;
DESIGNER: D E S I G N E R;
DESTINATION : D E S T I N A T I O N;
DETAIL : D E T A I L;
DFHRESP : D F H R E S P;
DFHVALUE : D F H V A L U E;
DIAGTRUNC : D I A G T R U N C;
DISABLE : D I S A B L E;
DISCONNECT : D I S C O N N E C T;
DISK : D I S K;
DISPLAY : D I S P L A Y;
DISPLAY_1 : D I S P L A Y MINUSCHAR '1';
DISPSIGN : D I S P S I G N;
DIVIDE : D I V I D E;
DIVISION : D I V I S I O N;
DLL : D L L;
DN : D N;
DOM: D O M;
DOWN : D O W N;
DS : D S;
DSN : D S N;
DSNAME : D S N A M E;
DTR : D T R;
DU : D U;
DUMP : D U M P;
DUPLICATES : D U P L I C A T E S;
DWARF : D W A R F;
DYN : D Y N;
DYNAM : D Y N A M;
DYNAMIC : D Y N A M I C;
D_CHAR : D;
EBCDIC : E B C D I C;
EGCS : E G C S;
EGI : E G I;
EJPD : E J P D;
ELSE : E L S E;
EMI : E M I;
EMPTY : E M P T Y;
EN : E N;
ENABLE : E N A B L E;
ENCODING: E N C O D I N G;
END : E N D;
ENDP : E N D P;
ENDPERIOD : E N D P E R I O D;
END_ACCEPT : E N D MINUSCHAR A C C E P T;
END_ADD : E N D MINUSCHAR A D D;
END_CALL : E N D MINUSCHAR C A L L;
END_COMPUTE : E N D MINUSCHAR C O M P U T E;
END_DELETE : E N D MINUSCHAR D E L E T E;
END_DIVIDE : E N D MINUSCHAR D I V I D E;
END_EVALUATE : E N D MINUSCHAR E V A L U A T E;
END_EXEC : E N D MINUSCHAR E X E C;
END_IF : E N D MINUSCHAR I F;
END_MULTIPLY : E N D MINUSCHAR M U L T I P L Y;
END_OF_PAGE : E N D MINUSCHAR O F MINUSCHAR P A G E;
END_PERFORM : E N D MINUSCHAR P E R F O R M;
END_READ : E N D MINUSCHAR R E A D;
END_RECEIVE : E N D MINUSCHAR R E C E I V E;
END_RETURN : E N D MINUSCHAR R E T U R N;
END_REWRITE : E N D MINUSCHAR R E W R I T E;
END_SEARCH : E N D MINUSCHAR S E A R C H;
END_START : E N D MINUSCHAR S T A R T;
END_STRING : E N D MINUSCHAR S T R I N G;
END_SUBTRACT : E N D MINUSCHAR S U B T R A C T;
END_UNSTRING : E N D MINUSCHAR U N S T R I N G;
END_WRITE : E N D MINUSCHAR W R I T E;
END_XML : E N D MINUSCHAR X M L;
ENGLISH : E N G L I S H;
ENTER : E N T E R;
ENTITY : E N T I T Y;
ENTRY : E N T R Y;
ENVIRONMENT : E N V I R O N M E N T;
EOC : E O C;
EODS : E O D S;
EOP : E O P;
EQUAL : E Q U A L;
ERASE : E R A S E;
ERROR : E R R O R;
ESCAPE : E S C A P E;
ESI : E S I;
EVALUATE : E V A L U A T E;
EVENP : E V E N P;
EVENPACK : E V E N P A C K;
EVENT : E V E N T;
EVERY : E V E R Y;
EX : E X;
EXCEPT : E X C E P T;
EXCEPTION : E X C E P T I O N;
EXCLUSIVE : E X C L U S I V E;
EXEC : E X E C;
EXHIBIT : E X H I B I T;
EXIT : E X I T;
EXP : E X P;
EXPORTALL : E X P O R T A L L;
EXTEND : E X T E N D;
EXTENDED : E X T E N D E D;
EXTERNAL : E X T E R N A L;
E_CHAR : E;
FALSE : F A L S E;
FASTSRT : F A S T S R T;
FD : F D;
FILE : F I L E;
FILE_CONTROL : F I L E MINUSCHAR C O N T R O L;
FILLER : F I L L E R;
FINISH : F I N I S H;
FIRST : F I R S T;
FLAG : F L A G;
FLAGSTD : F L A G S T D;
FNC : F N C;
FOOTING : F O O T I N G;
FOR : F O R;
FORCENUMCMP : F O R C E N U M C M P;
FREE : F R E E;
FROM : F R O M;
FSRT : F S R T;
FULL : F U L L;
FUNCTION : F U N C T I O N;
FUNCTION_POINTER : F U N C T I O N MINUSCHAR P O I N T E R;
F_CHAR : F;
GENERATE : G E N E R A T E;
GIVING : G I V I N G;
GLOBAL : G L O B A L;
GO : G O;
GOBACK : G O B A C K;
GREATER : G R E A T E R;
GROUP_USAGE : G R O U P MINUSCHAR U S A G E;
GRS: G R S;
G_CHAR: G;
HEADER : H E A D E R;
HEX : H E X;
HGPR : H G P R;
HIGH_VALUE : H I G H MINUSCHAR V A L U E;
HIGH_VALUES : H I G H MINUSCHAR V A L U E S;
HOLD : H O L D;
H_CHAR : H;
IC : I C;
ID : I D;
IDENTIFICATION : I D E N T I F I C A T I O N;
IF : I F;
IGNORED : I G N O R E D;
IMMEDIATE : I M M E D I A T E;
IMPLICIT : I M P L I C I T;
IN : I N;
INDEX : I N D E X;
INDEXED : I N D E X E D;
INEXIT : I N E X I T;
INFO : I N F O;
INITCHECK : I N I T C H E C K;
INITIAL : I N I T I A L;
INITIALIZE : I N I T I A L I Z E;
INITIATE : I N I T I A T E;
INL : I N L;
INLINE : I N L I N E;
INPUT : I N P U T;
INPUT_OUTPUT : I N P U T MINUSCHAR O U T P U T;
INSPECT : I N S P E C T;
INSTALLATION : I N S T A L L A T I O N;
INTDATE : I N T D A T E;
INTEGER : I N T E G E R;
INTERVAL : I N T E R V A L;
INTO : I N T O;
INVALID : I N V A L I D;
INVD : I N V D;
INVDATA : I N V D A T A;
INVMPSZ : I N V M P S Z;
INVOKED : I N V O K E D;
INVPARTN : I N V P A R T N;
INVREQ : I N V R E Q;
INX : I N X;
IO : I O;
IS : I S;
ITEM: I T E M;
I_CHAR : I;
I_O : I MINUSCHAR O;
I_O_CONTROL : I MINUSCHAR O MINUSCHAR C O N T R O L;
JA : J A;
JAPANESE : J A P A N E S E;
JNIENVPTR: J N I E N V P T R;
JOB: J O B;
JP : J P;
JUST : J U S T;
JUSTIFIED : J U S T I F I E D;
JUSTIFY : J U S T I F Y;
KANJI : K A N J I;
KEEP : K E E P;
KEPT : K E P T;
KEY : K E Y;
KEYBOARD : K E Y B O A R D;
K_CHAR : K;
LABEL : L A B E L;
LANG : L A N G;
LANGUAGE : L A N G U A G E;
LAST : L A S T;
LAX : L A X;
LAXPERF : L A X P E R F;
LAXREDEF : L A X R E D E F;
LC : L C;
LEADING : L E A D I N G;
LEFT : L E F T;
LENGTH : L E N G T H;
LESS : L E S S;
LIBEXIT : L I B E X I T;
LIBRARY : L I B R A R Y;
LIBX : L I B X;
LILIAN : L I L I A N;
LIMIT : L I M I T;
LINAGE : L I N A G E;
LINAGE_COUNTER : L I N A G E MINUSCHAR C O U N T E R;
LINE : L I N E;
LINECOUNT : L I N E C O U N T;
LINES : L I N E S;
LINE_COUNTER : L I N E MINUSCHAR C O U N T E R;
LINK : L I N K;
LINKAGE : L I N K A G E;
LIST : L I S T;
LITERALS : L I T E R A L S;
LM : L M;
LOAD : L O A D;
LOCAL : L O C A L;
LOCAL_STORAGE : L O C A L MINUSCHAR S T O R A G E;
LOCK : L O C K;
LONG : L O N G;
LONGMIXED : L O N G M I X E D;
LONGUPPER : L O N G U P P E R;
LOW_VALUE : L O W MINUSCHAR V A L U E;
LOW_VALUES : L O W MINUSCHAR V A L U E S;
LP : L P;
LTERM : L T E R M;
LU : L U;
LXPRF : L X P R F;
LXRDF : L X R D F;
MANUAL : M A N U A L;
MAPFAIL : M A P F A I L;
MATCH : M A T C H;
MAX : M A X;
MAXPCF : M A X P C F;
MD : M D;
MDECK : M D E C K;
MEMBER : M E M B E R;
MEMORY : M E M O R Y;
MERGE : M E R G E;
MESSAGE : M E S S A G E;
MIG : M I G;
MIXED : M I X E D;
MMDDYYYY : M M D D Y Y Y Y;
MODE : M O D E;
MODULES : M O D U L E S;
MOVE : M O V E;
MSG : M S G;
MSGEXIT : M S G E X I T;
MSGX : M S G X;
MULTIPLE : M U L T I P L E;
MULTIPLY : M U L T I P L Y;
M_CHAR : M;
NAME : N A M E;
NAMED : N A M E D;
NAT : N A T;
NATIONAL : N A T I O N A L;
NATIONAL_EDITED : N A T I O N A L MINUSCHAR E D I T E D;
NATIVE : N A T I V E;
NC : N C;
ND : N D;
NEGATIVE : N E G A T I V E;
NETWORK : N E T W O R K;
NEW : N E W;
NEXT : N E X T;
NLCR : N L C R;
NO : N O;
NOADATA : N O A D A T A;
NOADEXIT : N O A D E X I T;
NOADV : N O A D V;
NOADX : N O A D X;
NOALIAS : N O A L I A S;
NOALPHNUM : N O A L P H N U M;
NOAWO : N O A W O;
NOBIN : N O B I N;
NOBLOCK0 : N O B L O C K '0';
NOC : N O C;
NOCICS : N O C I C S;
NOCLEANSIGN : N O C L E A N S I G N;
NOCOMPILE : N O C O M P I L E;
NOCOPYLOC : N O C O P Y L O C;
NOCOPYRIGHT : N O C O P Y R I G H T;
NOCPLC : N O C P L C;
NOCPYR : N O C P Y R;
NOCS : N O C S;
NOCURR : N O C U R R;
NOCURRENCY : N O C U R R E N C Y;
NOD : N O D;
NODBCS : N O D B C S;
NODECK : N O D E C K;
NODEF : N O D E F;
NODEFINE : N O D E F I N E;
NODIAGTRUNC : N O D I A G T R U N C;
NODLL : N O D L L;
NODSNAME : N O D S N A M E;
NODTR : N O D T R;
NODU : N O D U;
NODUMP : N O D U M P;
NODWARF : N O D W A R F;
NODYN : N O D Y N;
NODYNAM : N O D Y N A M;
NOEJPD : N O E J P D;
NOENDPERIOD : N O E N D P E R I O D;
NOEVENPACK : N O E V E N P A C K;
NOEX : N O E X;
NOEXIT : N O E X I T;
NOEXP : N O E X P;
NOEXPORTALL : N O E X P O R T A L L;
NOF : N O F;
NOFASTSRT : N O F A S T S R T;
NOFLAG : N O F L A G;
NOFLAGSTD : N O F L A G S T D;
NOFNC : N O F N C;
NOFORCENUMCMP : N O F O R C E N U M C M P;
NOFSRT : N O F S R T;
NOIC : N O I C;
NOINEXIT : N O I N E X I T;
NOINITCHECK : N O I N I T C H E C K;
NOINITIAL : N O I N I T I A L;
NOINL : N O I N L;
NOINLINE : N O I N L I N E;
NOINVD : N O I N V D;
NOINVDATA : N O I N V D A T A;
NOINX : N O I N X;
NOLAXPERF : N O L A X P E R F;
NOLAXREDEF : N O L A X R E D E F;
NOLIBEXIT : N O L I B E X I T;
NOLIBX : N O L I B X;
NOLIST : N O L I S T;
NOMAP : N O M A P;
NOMD : N O M D;
NOMDECK : N O M D E C K;
NOMSGEXIT : N O M S G E X I T;
NOMSGX : N O M S G X;
NONAME : N O N A M E;
NONC : N O N C;
NONE : N O N E;
NONUM : N O N U M;
NONUMBER : N O N U M B E R;
NONUMCHECK : N O N U M C H E C K;
NOOBJ : N O O B J;
NOOBJECT : N O O B J E C T;
NOOFF : N O O F F;
NOOFFSET : N O O F F S E T;
NOOMITODOMIN : N O O M I T O D O M I N;
NOPAC : N O P A C;
NOPARMCHECK : N O P A R M C H E C K;
NOPC : N O P C;
NOPFD : N O P F D;
NOPRESERVE : N O P R E S E R V E;
NOPRTEXIT : N O P R T E X I T;
NOPRTX : N O P R T X;
NORENT : N O R E N T;
NORULES : N O R U L E S;
NOS : N O S;
NOSEP : N O S E P;
NOSEPARATE : N O S E P A R A T E;
NOSEQ : N O S E Q;
NOSEQUENCE : N O S E Q U E N C E;
NOSERV : N O S E R V;
NOSERVICE : N O S E R V I C E;
NOSLACKBYTES : N O S L A C K B Y T E S;
NOSO : N O S O;
NOSOURCE : N O S O U R C E;
NOSQL : N O S Q L;
NOSQLC : N O S Q L C;
NOSQLCCSID : N O S Q L C C S I D;
NOSQLIMS : N O S Q L I M S;
NOSSR : N O S S R;
NOSSRANGE : N O S S R A N G E;
NOSTGOPT : N O S T G O P T;
NOSUPP : N O S U P P;
NOSUPPRESS : N O S U P P R E S S;
NOT : N O T;
NOTERM : N O T E R M;
NOTERMINAL : N O T E R M I N A L;
NOTEST : N O T E S T;
NOTHREAD : N O T H R E A D;
NOTRUNCBIN : N O T R U N C B I N;
NOUNRA : N O U N R A;
NOUNREFALL : N O U N R E F A L L;
NOUNREFSOURCE : N O U N R E F S O U R C E;
NOUNRS : N O U N R S;
NOVBREF : N O V B R E F;
NOVOLATILE : N O V O L A T I L E;
NOWAIT : N O W A I T;
NOWD : N O W D;
NOWORD : N O W O R D;
NOWRITE : N O W R I T E;
NOX : N O X;
NOXREF : N O X R E F;
NOZC : N O Z C;
NOZLEN : N O Z L E N;
NOZON : N O Z O N;
NOZONECHECK : N O Z O N E C H E C K;
NOZWB : N O Z W B;
NS : N S;
NSYMBOL : N S Y M B O L;
NULL : N U L L;
NULLS : N U L L S;
NUM : N U M;
NUMBER : N U M B E R;
NUMCHECK : N U M C H E C K;
NUMERIC : N U M E R I C;
NUMERIC_EDITED : N U M E R I C MINUSCHAR E D I T E D;
NUMPROC : N U M P R O C;
N_CHAR : N;
OBJ : O B J;
OBJECT : O B J E C T;
OBJECT_COMPUTER : O B J E C T MINUSCHAR C O M P U T E R;
OCCURS : O C C U R S;
ODT : O D T;
ODETTE: O D E T T E;
OF : O F;
OFF : O F F;
OFFSET : O F F S E T;
OMITODOMIN : O M I T O D O M I N;
OMITTED : O M I T T E D;
ON : O N;
ONLY : O N L Y;
OOM : O O M;
OPEN : O P E N;
OPT : O P T;
OPTFILE : O P T F I L E;
OPTIMIZE : O P T I M I Z E;
OPTIONAL : O P T I O N A L;
OR : O R;
ORDER : O R D E R;
ORDERLY : O R D E R L Y;
ORGANIZATION : O R G A N I Z A T I O N;
OTHER : O T H E R;
OUT : O U T;
OUTDD : O U T D D;
OUTPUT : O U T P U T;
OVERFLOW : O V E R F L O W;
OWN: O W N;
O_CHAR : O;
PAC : P A C;
PACKED_DECIMAL : P A C K E D MINUSCHAR D E C I M A L;
PACKET: P A C K E T;
PAD : P A D;
PADDING : P A D D I N G;
PAGE : P A G E;
PAGE_COUNTER : P A G E MINUSCHAR C O U N T E R;
PAGING : P A G I N G;
PARMCHECK : P A R M C H E C K;
PARSE: P A R S E;
PARTNFAIL : P A R T N F A I L;
PASSWORD : P A S S W O R D;
PATH : P A T H;
PC : P C;
PERFORM : P E R F O R M;
PFD : P F D;
PGMN : P G M N;
PGMNAME : P G M N A M E;
PIC : P I C  -> pushMode(PICTURECLAUSE);
PICTURE : P I C T U R E -> pushMode(PICTURECLAUSE);
POINTER : P O I N T E R;
POINTER_32 : P O I N T E R MINUSCHAR '3' '2';
PORT : P O R T;
POSITION : P O S I T I O N;
POSITIVE : P O S I T I V E;
POST : P O S T;
PREFIX : P R E F I X;
PRESERVE : P R E S E R V E;
PRINTER : P R I N T E R;
PRIOR : P R I O R;
PRIORITY : P R I O R I T Y;
PROCEDURE : P R O C E D U R E;
PROCEDURES : P R O C E D U R E S;
PROCEDURE_POINTER : P R O C E D U R E MINUSCHAR P O I N T E R;
PROCEED : P R O C E E D;
PROCESS : P R O C E S S;
PROCESSING: P R O C E S S I N G;
PROGRAM : P R O G R A M;
PROGRAM_ID : P R O G R A M MINUSCHAR I D;
PRTEXIT : P R T E X I T;
PRTX : P R T X;
PTERM : P T E R M;
PURGE : P U R G E;
PUT : P U T;
QUA : Q U A;
QUALIFY : Q U A L I F Y;
QUEUE : Q U E U E;
QUOTE : Q U O T E;
QUOTES : Q U O T E S;
Q_CHAR : Q;
RANDOM : R A N D O M;
RDATT : R D A T T;
READ : R E A D;
READER : R E A D E R;
READY : R E A D Y;
RECEIVE : R E C E I V E;
RECORD : R E C O R D;
RECORDING : R E C O R D I N G;
RECORDS : R E C O R D S;
RECURSIVE : R E C U R S I V E;
REDEFINES : R E D E F I N E S;
REEL : R E E L;
REFERENCE : R E F E R E N C E;
REFERENCES : R E F E R E N C E S;
RELATIVE : R E L A T I V E;
RELEASE : R E L E A S E;
RELOAD: R E L O A D;
REMAINDER : R E M A I N D E R;
REMARKS : R E M A R K S;
REMOTE : R E M O T E;
REMOVAL : R E M O V A L;
REMOVE : R E M O V E;
RENAMES : R E N A M E S;
RENT : R E N T;
REPLACE : R E P L A C E;
REPLACING : R E P L A C I N G;
REPORT : R E P O R T;
REPORTS : R E P O R T S;
REQUIRED : R E Q U I R E D;
RERUN : R E R U N;
RESERVE : R E S E R V E;
RESET : R E S E T;
RESTORE : R E S T O R E;
RESUME : R E S U M E;
RESULT: R E S U L T;
RETURN : R E T U R N;
RETURNING: R E T U R N I N G;
RETURN_CODE : R E T U R N MINUSCHAR C O D E;
REVERSED : R E V E R S E D;
REWIND : R E W I N D;
REWRITE : R E W R I T E;
RIGHT : R I G H T;
RMODE : R M O D E;
ROLLBACK : R O L L B A C K;
ROUNDED : R O U N D E D;
ROW : R O W;
RULES : R U L E S;
RUN : R U N;
SAME : S A M E;
SAVE : S A V E;
SCREENSIZE : S C R E E N S I Z E;
SD : S D;
SEARCH : S E A R C H;
SECONDS : S E C O N D S;
SECTION : S E C T I O N;
SECURITY : S E C U R I T Y;
SEGMENT : S E G M E N T;
SEGMENT_LIMIT : S E G M E N T MINUSCHAR L I M I T;
SELECT : S E L E C T;
SEND : S E N D;
SENTENCE : S E N T E N C E;
SEP : S E P;
SEPARATE : S E P A R A T E;
SEQ : S E Q;
SEQUENCE : S E Q U E N C E;
SEQUENTIAL : S E Q U E N T I A L;
SERV : S E R V;
SERVICE : S E R V I C E;
SESSION : S E S S I O N;
SET : S E T;
SHARE : S H A R E;
SHARED : S H A R E D;
SHOW : S H O W;
SHIFT_IN : S H I F T MINUSCHAR I N;
SHIFT_OUT : S H I F T MINUSCHAR O U T;
SIGN : S I G N;
SIZE : S I Z E;
SKIPCHAR : S K I P;
SLACKBYTES : S L A C K B Y T E S;
SLCKB : S L C K B;
SN : S N;
SNAP : S N A P;
SO : S O;
SOME : S O M E;
SORT : S O R T;
SORT_CONTROL : S O R T MINUSCHAR C O N T R O L;
SORT_CORE_SIZE : S O R T MINUSCHAR C O R E MINUSCHAR S I Z E;
SORT_FILE_SIZE : S O R T MINUSCHAR F I L E MINUSCHAR S I Z E;
SORT_MERGE : S O R T MINUSCHAR M E R G E;
SORT_MESSAGE : S O R T MINUSCHAR M E S S A G E;
SORT_MODE_SIZE : S O R T MINUSCHAR M O D E MINUSCHAR S I Z E;
SORT_RETURN : S O R T MINUSCHAR R E T U R N;
SOURCE : S O U R C E;
SOURCE_COMPUTER : S O U R C E MINUSCHAR C O M P U T E R;
SPACE : S P A C E;
SPACES : S P A C E S;
SPECIAL_NAMES : S P E C I A L MINUSCHAR N A M E S;
SQL : S Q L;
SQLC : S Q L C;
SQLCCSID : S Q L C C S I D;
SQLIMS : S Q L I M S;
SSR : S S R;
SSRANGE : S S R A N G E;
STANDARD : S T A N D A R D;
STANDARD_1 : S T A N D A R D MINUSCHAR '1';
STANDARD_2 : S T A N D A R D MINUSCHAR '2';
START : S T A R T;
STATISTICS : S T A T I S T I C S;
STATUS : S T A T U S;
STD : S T D;
STGOPT : S T G O P T;
STOP : S T O P;
STORAGE : S T O R A G E;
STRICT : S T R I C T;
STRING : S T R I N G;
SUBTRACT : S U B T R A C T;
SUCC : S U C C;
SUM : S U M;
SUPP : S U P P;
SUPPRESS : S U P P R E S S;
SYMBOL : S Y M B O L;
SYMBOLIC : S Y M B O L I C;
SYNC : S Y N C;
SYNCHRONIZED : S Y N C H R O N I Z E D;
SYSLIB : S Y S L I B;
SYSTEM : S Y S T E M;
SYSVERSION : S Y S V E R S I O N;
S_CHAR : S;
TABLE : T A B L E;
TALLY : T A L L Y;
TALLYING : T A L L Y I N G;
TAPE : T A P E;
TASK : T A S K;
TEMPORARY : T E M P O R A R Y;
TERM : T E R M;
TERMINAL : T E R M I N A L;
TERMINATE : T E R M I N A T E;
TEST : T E S T;
TEXT : T E X T;
THAN : T H A N;
THEN : T H E N;
THREAD : T H R E A D;
THROUGH : T H R O U G H;
THRU : T H R U;
TIME : T I M E;
TIMEOUT : T I M E O U T;
TIMES : T I M E S;
TITLE : T I T L E;
TO : T O;
TODAYS_DATE : T O D A Y S MINUSCHAR D A T E;
TODAYS_NAME : T O D A Y S MINUSCHAR N A M E;
TOP : T O P;
TRACE : T R A C E;
TRAILING : T R A I L I N G;
TRANSACTION : T R A N S A C T I O N;
TRANSFER : T R A N S F E R;
TRUE : T R U E;
TRUNC : T R U N C;
TRUNCATED : T R U N C A T E D;
TRUNCBIN : T R U N C B I N;
TUNE : T U N E;
TYPE : T Y P E;
UE : U E;
UENGLISH : U E N G L I S H;
UNEXPIN : U N E X P I N;
UNIT : U N I T;
UNREF : U N R E F;
UNSTRING : U N S T R I N G;
UNTIL : U N T I L;
UP : U P;
UPDATE : U P D A T E;
UPON : U P O N;
UPPER : U P P E R;
USAGE : U S A G E;
USE : U S E;
USER : U S E R;
USING : U S I N G;
UTF_8 : U T F MINUSCHAR '8';
U_CHAR : U;
VALIDATING: V A L I D A T I N G;
VALUE : V A L U E;
VALUES : V A L U E S;
VARYING : V A R Y I N G;
VBREF : V B R E F;
VIRTUAL : V I R T U A L;
VLR : V L R;
VOLATILE : V O L A T I L E;
VS : V S;
VSAMOPENFS : V S A M O P E N F S;
WAIT : W A I T;
WARNING : W A R N I N G;
WD : W D;
WHEN : W H E N;
WHEN_COMPILED : W H E N MINUSCHAR C O M P I L E D;
WITH : W I T H;
WORD : W O R D;
WORDS : W O R D S;
WORKING_STORAGE : W O R K I N G MINUSCHAR S T O R A G E;
WRITE : W R I T E;
WRITE_ONLY : W R I T E MINUSCHAR O N L Y;
W_CHAR : W;
XCTL : X C T L;
XML : X M L;
XMLPARSE : X M L P A R S E;
XMLSS : X M L S S;
XP : X P;
XREF : X R E F;
X_CHAR : X;
YEAR : Y E A R;
YES : Y E S;
YYYYDDD : Y Y Y Y D D D;
YYYYMMDD : Y Y Y Y M M D D;
ZC : Z C;
ZD : Z D;
ZERO : Z E R O;
ZEROES : Z E R O E S;
ZEROS : Z E R O S;
ZLEN : Z L E N;
ZON : Z O N;
ZONECHECK : Z O N E C H E C K;
ZONEDATA : Z O N E D A T A;
ZWB : Z W B;

UNDERSCORECHAR : '_';

INTEGERLITERAL_WITH_K: INTEGERLITERAL ('K' | 'k');
CURRENCY_SYMBOL : [\p{Sc}];

mode PICTURECLAUSE;
FINALCHARSTRING: CHARSTRING+ ->popMode;
CHARSTRING: PICTURECHARSGROUP1+ PICTURECHARSGROUP2? LParIntegralRPar? '.'? (PICTURECHARSGROUP1|PICTURECHARSGROUP2)
			PICTURECHARSGROUP1+ PICTURECHARSGROUP2? LParIntegralRPar?|
			PICTURECHARSGROUP1* '.' PICTUREPeriodAcceptables+ LParIntegralRPar?|
			PICTURECHARSGROUP1* PICTURECHARSGROUP2? PICTURECHARSGROUP1+ LParIntegralRPar? '.'? (PICTURECHARSGROUP1|PICTURECHARSGROUP2)|
			PICTURECHARSGROUP1* PICTURECHARSGROUP2? PICTURECHARSGROUP1+ LParIntegralRPar?|
			PICTURECHARSGROUP2 PICTURECHARSGROUP1* LParIntegralRPar? '.'? (PICTURECHARSGROUP1|PICTURECHARSGROUP2)|
			PICTURECHARSGROUP2 PICTURECHARSGROUP1* LParIntegralRPar?
;

PICTURECHARSGROUP1: PICTURECharAcceptedMultipleTime+;
PICTURECHARSGROUP2: PICTURECharAcceptedOneTime+;
WS2 : [ \t\f]+ -> channel(HIDDEN);
LParIntegralRPar: LPARENCHAR INTEGERLITERAL RPARENCHAR;
fragment PICTUREPeriodAcceptables: ('0'|'9'|B|Z|CR|DB|ASTERISKCHAR|COMMACHAR|MINUSCHAR|PLUSCHAR|SLASHCHAR);
fragment PICTURECharAcceptedMultipleTime: (A|G|N|P|X|DOLLARCHAR|PICTUREPeriodAcceptables);
fragment PICTURECharAcceptedOneTime: (V|E|S|CR|DB);
