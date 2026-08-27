#!/usr/bin/env bash
set -euo pipefail
FILE="tests/anchor.test.ts"
if [ ! -f "$FILE" ]; then
echo "Error: 
F
I
L
E
n
o
t
f
o
u
n
d
i
n
FILEnotfoundin(pwd)" >&2
exit 2
fi
cp -p "
F
I
L
E
"
"
FILE""{FILE}.bak"
awk '
/surfpool/ || /spawn("surfpool"/ || /exec("surfpool"/ || /run("surfpool"/ || /command\s*=\s*".surfpool."/ || /runner\s*=\s*".surfpool."/ {
if ($0 ~ /^\s*/// || $0 ~ /^\s*#/) { print $0; next }
print "// " $0; next
}
{ print $0 }
' "
F
I
L
E
"
>
"
FILE">"{FILE}.new"
mv "${FILE}.new" "$FILE"
echo "Patched 
F
I
L
E
(
b
a
c
k
u
p
a
t
FILE(backupat{FILE}.bak)"
