#!/usr/bin/env bash
set -Eeuo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SITE_DIR="$ROOT/site"

declare -A RESUMES=(
  [AI_ML]="Resume_AI_ML"
  [Data]="Resume_Data"
  [Engineer]="Resume_Engineer"
  [Robotics]="Resume_Robotics"
  [Universal]="Resume_Universal"
  [Web]="Resume_Web"
)

mkdir -p "$SITE_DIR"
cp "$ROOT/index.html" "$SITE_DIR/index.html"
cp "$ROOT/games.html" "$SITE_DIR/games.html"
cp "$ROOT/favicon.svg" "$SITE_DIR/favicon.svg"
cp "$ROOT/robots.txt" "$SITE_DIR/robots.txt"
cp "$ROOT/sitemap.xml" "$SITE_DIR/sitemap.xml"
mkdir -p "$SITE_DIR/data"
cp -R "$ROOT/data/." "$SITE_DIR/data/"

for variant in AI_ML Data Engineer Robotics Universal Web; do
  source_name="${RESUMES[$variant]}"
  source_dir="$ROOT/Resumes/$variant"
  source_file="$source_dir/$source_name.tex"
  output_dir="$SITE_DIR/Resumes/$variant"

  if [[ ! -f "$source_file" ]]; then
    echo "::error::Missing LaTeX source: $source_file"
    exit 1
  fi

  mkdir -p "$output_dir"
  echo "Building $variant resume..."
  (
    cd "$source_dir"
    xelatex -interaction=nonstopmode -halt-on-error -file-line-error "$source_name.tex"
    xelatex -interaction=nonstopmode -halt-on-error -file-line-error "$source_name.tex"
  )

  pdf_file="$source_dir/$source_name.pdf"
  if [[ ! -s "$pdf_file" ]]; then
    echo "::error::PDF was not generated: $pdf_file"
    exit 1
  fi
  cp "$pdf_file" "$output_dir/$source_name.pdf"

  rm -f "$source_dir"/*.aux "$source_dir"/*.log "$source_dir"/*.out \
    "$source_dir"/*.xdv "$source_dir"/*.fls "$source_dir"/*.fdb_latexmk \
    "$source_dir"/*.synctex.gz
done

echo "All six PDF resumes were built into $SITE_DIR."
