#!/bin/bash
SCRIPT_DIR=$(dirname "$(realpath "$0")")

CACHE_FILE="$SCRIPT_DIR/.cache.cfg"
# Si un fichier est passé en argument → on le compile et le stocke
if [ -n "$1" ]; then
    echo "$1" > "$CACHE_FILE"
    echo "󰚰  Nom du fichier LaTeX mis à jour 󰚰 :"
    echo "   $(realpath --relative-to="$SCRIPT_DIR" "$1")"
fi

# Lit le fichier à compiler depuis le cache
if [ ! -f "$CACHE_FILE" ]; then
    echo "  Aucun fichier LaTeX défini. Passez-en un en argument."
    exit 1
fi

FULLPATH=$(cat "$CACHE_FILE")
FILE_DIR=$(dirname "$(realpath "$FULLPATH")")

# Récupère le nom de fichier et le dossier
FILE=$(basename "$FULLPATH")
BASENAME="${FILE%.*}"
DIR=$(dirname "$FULLPATH")

# Répertoire de travail


# Horodatage
DATE=$(date "+%Y-%m-%d")
HEURE=$(date "+%H-%M-%S")

# Répertoires
PDF_DIR="$SCRIPT_DIR/build"
DEBUG_DIR="$SCRIPT_DIR/debug/build-${DATE}_${HEURE}"

# Création des dossiers
mkdir -p "$PDF_DIR" "$DEBUG_DIR"
echo "  Compilation de  :"
echo "   $(realpath --relative-to="$SCRIPT_DIR" "$FULLPATH")"

# Suppression du PDF existant
rm -f "$FILE_DIR/$BASENAME.pdf"

# Compilation
if ! pdflatex -interaction=nonstopmode "$FULLPATH" > "$DEBUG_DIR/${BASENAME}.out" 2>&1; then
    echo "  Erreur de compilation  :"
    echo "   $(realpath --relative-to="$SCRIPT_DIR" "$DEBUG_DIR/${BASENAME}.out")"
    exit 1
fi

# Déplacement des fichiers de trace
mv "$FILE_DIR/$BASENAME.aux" "$DEBUG_DIR/${BASENAME}.aux"
mv "$FILE_DIR/$BASENAME.log" "$DEBUG_DIR/${BASENAME}.log"

# Déplacement du PDF
PDF_NAME="${BASENAME}-${DATE}_${HEURE}.pdf"
mv "$FILE_DIR/$BASENAME.pdf" "$PDF_DIR/$PDF_NAME"

# Liens symboliques
ln -sfn "$PDF_DIR/$PDF_NAME" "$SCRIPT_DIR/$BASENAME.pdf"
ln -sfn "$DEBUG_DIR" "$SCRIPT_DIR/temp"

echo ""
echo "  Compilation réussie  :"
echo "   $(realpath --relative-to="$SCRIPT_DIR" "$PDF_DIR/$PDF_NAME")"
echo ""
echo "󰎔  Logs disponibles dans 󰎔 :"
echo "   $(realpath --relative-to="$SCRIPT_DIR" "$DEBUG_DIR")"

# Nettoyage des anciens PDFs
cd "$PDF_DIR" 2>/dev/null
if [ "$(ls -A . 2>/dev/null )" ]; then
    PDF_FILES=$(ls -t *.pdf | tail -n +6)
    if [ -n "$PDF_FILES" ]; then
        rm -f $PDF_FILES
    fi
fi

# Nettoyage des anciens logs
cd "$DEBUG_DIR" 2>/dev/null
if [ "$(ls -A . 2>/dev/null )" ]; then
    LOG_FILES=$(ls -t *.log | tail -n +6)
    if [ -n "$LOG_FILES" ]; then
        rm -f $LOG_FILES
    fi
fi

# Nettoyage des anciens dossiers de logs
cd "$SCRIPT_DIR/debug" 2>/dev/null
if [ "$(ls -A . 2>/dev/null)" ]; then
    DEBUG_DIRS=$(ls -d build-* | sort -r | tail -n +6)
    if [ -n "$DEBUG_DIRS" ]; then
        rm -rf $DEBUG_DIRS
    fi
fi

echo ""
echo "  Nombre de PDF conservés  : $(ls -1 "$PDF_DIR"/*.pdf 2>/dev/null | wc -l)"
echo "󱂅  Nombre de logs conservés 󱂅 : $(find "$SCRIPT_DIR/debug" -type f -path "$SCRIPT_DIR/debug/build-*" -name "*.log" | wc -l)"