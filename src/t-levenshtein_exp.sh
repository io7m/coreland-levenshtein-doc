#!/bin/sh

cat <<EOF
(subsection
  (title "standard use cases")
  (para-verbatim example "
EOF

echo "# compile Ada source using the library"
echo "$ levenshtein-conf compile cflags incdir"
levenshtein-conf compile incdir cflags
echo
echo

echo "# link object files against the static library"
echo "$ levenshtein-conf compile ldflags slibdir"
levenshtein-conf compile slibdir ldflags
echo
echo

echo "# link object files against the dynamic library"
echo "$ levenshtein-conf compile ldflags dlibdir"
levenshtein-conf compile dlibdir ldflags
echo
echo

cat <<EOF
"))

(subsection
  (title "other use cases")
  (para-verbatim example "
EOF

echo "$ levenshtein-conf version"
levenshtein-conf version
echo
echo

echo "$ levenshtein-conf incdir"
levenshtein-conf incdir
echo
echo

echo "$ levenshtein-conf dlibdir"
levenshtein-conf dlibdir
echo
echo

echo "$ levenshtein-conf slibdir"
levenshtein-conf slibdir
echo
echo

echo "$ levenshtein-conf cflags"
levenshtein-conf cflags
echo
echo

echo "$ levenshtein-conf ldflags"
levenshtein-conf ldflags
echo
echo

echo "$ levenshtein-conf compile incdir"
levenshtein-conf compile incdir
echo
echo

echo "$ levenshtein-conf compile dlibdir"
levenshtein-conf compile dlibdir
echo
echo

echo "$ levenshtein-conf compile slibdir"
levenshtein-conf compile slibdir
echo
echo

cat <<EOF
"))
EOF

