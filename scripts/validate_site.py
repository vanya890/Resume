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

    html_files = sorted(site_dir.glob("*.html"))
    if site_dir / "games.html" not in html_files:
        fail("Missing games.html")

    page_ids: dict[Path, set[str]] = {}
    parsed_pages: list[tuple[Path, SiteParser]] = []
    for html_file in html_files:
        parser = SiteParser()
        parser.feed(html_file.read_text(encoding="utf-8"))
        duplicates = sorted({item for item in parser.ids if parser.ids.count(item) > 1})
        if duplicates:
            fail(f"Duplicate HTML ids in {html_file.name}: {', '.join(duplicates)}")
        page_ids[html_file.resolve()] = set(parser.ids)
        parsed_pages.append((html_file, parser))

    missing_anchors: list[str] = []
    missing_files: list[str] = []
    total_links = 0

    for html_file, parser in parsed_pages:
        for href in parser.hrefs:
            total_links += 1
            parsed = urlsplit(href)
            if parsed.scheme or parsed.netloc:
                continue
            if href.startswith(("mailto:", "tel:", "javascript:")):
                continue

            target = html_file.parent / parsed.path if parsed.path else html_file
            if parsed.path.startswith("/"):
                target = site_dir / parsed.path.lstrip("/")
            target = target.resolve()
            try:
                target.relative_to(site_dir)
            except ValueError:
                fail(f"Local link escapes site directory: {html_file.name}: {href}")

            if parsed.path and not target.exists():
                missing_files.append(f"{html_file.name}: {href}")
            if parsed.fragment and target.suffix == ".html":
                target_ids = page_ids.get(target, set())
                if parsed.fragment not in target_ids:
                    missing_anchors.append(f"{html_file.name}: {href}")

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

    # Validate the canonical data model and cross-file references.
    data_dir = Path(__file__).resolve().parents[1] / "data"
    try:
        profile_data = json.loads((data_dir / "profile.json").read_text(encoding="utf-8"))
        skills_data = json.loads((data_dir / "skills.json").read_text(encoding="utf-8"))
        resume_data = json.loads((data_dir / "resume-profiles.json").read_text(encoding="utf-8"))
        project_ids = [item.get("id") for item in projects]
        if any(not item for item in project_ids) or len(project_ids) != len(set(project_ids)):
            fail("Project IDs must be present and unique")
        project_id_set = set(project_ids)
        for skill in skills_data.get("skills", []):
            for evidence in skill.get("evidence", []):
                if evidence.get("project_id") not in project_id_set:
                    fail(f"Unknown project evidence for skill {skill.get('id')}: {evidence.get('project_id')}")
            if skill.get("assessment") not in {"pending", "confirmed"}:
                fail(f"Invalid assessment state for skill {skill.get('id')}")
        for resume in resume_data.get("profiles", []):
            for project_id in resume.get("project_ids", []):
                if project_id not in project_id_set:
                    fail(f"Unknown project {project_id} in resume profile {resume.get('id')}")
        if profile_data.get("privacy", {}).get("publish_original_documents") is not False:
            fail("Original education documents must remain unpublished")
        if len(resume_data.get("profiles", [])) != 6:
            fail("Expected exactly six resume profiles")
    except (OSError, json.JSONDecodeError, KeyError, TypeError) as error:
        fail(f"Canonical data validation failed: {error}")

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
        f"{len(expected_pdfs)} PDF resumes, {total_links} local/external links across {len(html_files)} pages."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
