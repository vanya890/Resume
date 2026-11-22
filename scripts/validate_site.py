#!/usr/bin/env python3
"""Validate the generated static portfolio and its local links."""

from __future__ import annotations

import json
import sys
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import urlsplit


class SiteParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.ids: list[str] = []
        self.hrefs: list[str] = []

    def handle_starttag(self, tag: str, attrs: list[tuple[str, str | None]]) -> None:
        attributes = dict(attrs)
        element_id = attributes.get("id")
        href = attributes.get("href")
        if element_id:
            self.ids.append(element_id)
        if href:
            self.hrefs.append(href)


def fail(message: str) -> None:
    print(f"ERROR: {message}", file=sys.stderr)
    raise SystemExit(1)


def main() -> int:
    if len(sys.argv) != 2:
        fail("Usage: validate_site.py <generated-site-directory>")

    site_dir = Path(sys.argv[1]).resolve()
    index_file = site_dir / "index.html"
    projects_file = site_dir / "data" / "projects.json"

    if not index_file.is_file():
        fail(f"Missing {index_file}")
    if not projects_file.is_file():
        fail(f"Missing {projects_file}")

    html = index_file.read_text(encoding="utf-8")
    parser = SiteParser()
    parser.feed(html)

    duplicates = sorted({item for item in parser.ids if parser.ids.count(item) > 1})
    if duplicates:
        fail(f"Duplicate HTML ids: {', '.join(duplicates)}")

    ids = set(parser.ids)
    missing_anchors: list[str] = []
    missing_files: list[str] = []

    for href in parser.hrefs:
        parsed = urlsplit(href)
        if parsed.scheme or parsed.netloc:
            continue
        if href.startswith("mailto:") or href.startswith("tel:") or href.startswith("javascript:"):
            continue
        if parsed.path:
            target = (site_dir / parsed.path.lstrip("/")).resolve()
            try:
                target.relative_to(site_dir)
            except ValueError:
                fail(f"Local link escapes site directory: {href}")
            if not target.exists():
                missing_files.append(href)
        if parsed.fragment and parsed.fragment not in ids:
            missing_anchors.append(href)

    if missing_files:
        fail(f"Broken local links: {', '.join(missing_files)}")
    if missing_anchors:
        fail(f"Broken anchor links: {', '.join(missing_anchors)}")

    try:
        data = json.loads(projects_file.read_text(encoding="utf-8"))
    except json.JSONDecodeError as error:
        fail(f"Invalid project registry JSON: {error}")

    projects = data.get("projects")
    if not isinstance(projects, list) or not projects:
        fail("Project registry must contain a non-empty 'projects' array")

    seen_titles: set[str] = set()
    for project in projects:
        title = project.get("title")
        if not title or title in seen_titles:
            fail(f"Missing or duplicate project title: {title!r}")
        seen_titles.add(title)
        if not project.get("category") or not project.get("description"):
            fail(f"Project {title!r} is missing category or description")
        for link in project.get("links", []):
            url = urlsplit(link.get("url", ""))
            if url.scheme != "https" or not url.netloc:
                fail(f"Project {title!r} has a non-HTTPS link: {link.get('url')!r}")

    expected_pdfs = [
        "Resumes/AI_ML/Resume_AI_ML.pdf",
        "Resumes/Data/Resume_Data.pdf",
        "Resumes/Engineer/Resume_Engineer.pdf",
        "Resumes/Robotics/Resume_Robotics.pdf",
        "Resumes/Universal/Resume_Universal.pdf",
        "Resumes/Web/Resume_Web.pdf",
    ]
    for relative_path in expected_pdfs:
        pdf_path = site_dir / relative_path
        if not pdf_path.is_file() or pdf_path.stat().st_size < 1000:
            fail(f"Missing or suspiciously small PDF: {relative_path}")
        if pdf_path.read_bytes()[:5] != b"%PDF-":
            fail(f"Not a PDF file: {relative_path}")

    print(
        f"Site validation passed: {len(projects)} projects, "
        f"{len(expected_pdfs)} PDF resumes, {len(parser.hrefs)} local/external links."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
